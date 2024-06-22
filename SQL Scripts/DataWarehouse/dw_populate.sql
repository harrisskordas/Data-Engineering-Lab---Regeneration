-- Populate the Dimension Tables

-- DimLocation
INSERT INTO dbo.DimLocation (LocationID, LocationName)
SELECT locationID, location_name
FROM [STAGINGv1].[dbo].[STAGING_LOCATIONS];

-- DimCategory
INSERT INTO dbo.DimCategory (CategoryID, CategoryName, EffectiveDate, ExpiryDate, IsCurrent)
SELECT categoryID, categoryName, GETDATE(), NULL, 1
FROM [STAGINGv1].[dbo].[STAGING_CATEGORIES];

-- DimProduct
INSERT INTO dbo.DimProduct (ProductID, ProductName, SurrogateCategoryID, Price, Length, Weight, Thickness, EffectiveDate, ExpiryDate, IsCurrent)
SELECT 
    p.productID, 
    p.name, 
    c.SurrogateCategoryID, 
    p.price, 
    p.length, 
    p.weight, 
    p.thickness, 
    GETDATE(), 
    NULL, 
    1
FROM 
    [STAGINGv1].[dbo].[STAGING_PRODUCTS] p
    JOIN dbo.DimCategory c ON p.categoryID = c.CategoryID;

-- DimCustomer
INSERT INTO dbo.DimCustomer (CustomerID, CompanyName, Email, SurrogateLocationID, EffectiveDate, ExpiryDate, IsCurrent)
SELECT 
    c.custID, 
    c.company_name, 
    c.email, 
    l.SurrogateLocationID, 
    GETDATE(), 
    NULL, 
    1
FROM 
    [STAGINGv1].[dbo].[STAGING_CUSTOMERS] c
    JOIN dbo.DimLocation l ON c.locationID = l.LocationID;






-- Populate DimDate with all dates in the range
DECLARE @StartDate DATE = '2019-01-01';
DECLARE @EndDate DATE = '2024-12-31';

WHILE @StartDate <= @EndDate
BEGIN
    INSERT INTO dbo.DimDate (DateID, Date, Year, Quarter, Month, Day, WeekDay, EffectiveDate, ExpiryDate, IsCurrent, IsHoliday)
    SELECT 
        CONVERT(INT, FORMAT(@StartDate, 'yyyyMMdd')) AS DateID,
        @StartDate AS Date,
        YEAR(@StartDate) AS Year,
        DATEPART(QUARTER, @StartDate) AS Quarter,
        MONTH(@StartDate) AS Month,
        DAY(@StartDate) AS Day,
        DATENAME(WEEKDAY, @StartDate) AS WeekDay,
        GETDATE() AS EffectiveDate,
        NULL AS ExpiryDate,
        1 AS IsCurrent,
        CASE 
            WHEN MONTH(@StartDate) = 1 AND DAY(@StartDate) = 1 THEN 1 -- Πρωτοχρονιά
            WHEN MONTH(@StartDate) = 3 AND DAY(@StartDate) = 25 THEN 1 -- Εισαγωγή της 25ης Μαρτίου ως αργίας
            WHEN MONTH(@StartDate) = 5 AND DAY(@StartDate) = 1 THEN 1 -- Πρωτομαγιά
            WHEN MONTH(@StartDate) = 8 AND DAY(@StartDate) = 15 THEN 1 -- Εισαγωγή της 15ης Αυγούστου ως αργίας
            WHEN MONTH(@StartDate) = 10 AND DAY(@StartDate) = 28 THEN 1 -- Ημέρα του Όχι
            WHEN MONTH(@StartDate) = 12 AND DAY(@StartDate) IN (25, 26) THEN 1 -- Χριστούγεννα & Συναντήσεις
            ELSE 0 -- Όλες οι άλλες μέρες δεν είναι αργίες
        END AS IsHoliday;

    SET @StartDate = DATEADD(DAY, 1, @StartDate);
END;










-- DimOrder
INSERT INTO dbo.DimOrder (OrderID, SurrogateCustomerID, PartnerID, OrderDate, EffectiveDate, ExpiryDate, IsCurrent)
SELECT 
    o.orderID,
    c.SurrogateCustomerID,
    o.partnerID,
    MIN(s.date_ordersales_status_changed) AS OrderDate,
    GETDATE(),
    NULL,
    1
FROM 
    [STAGINGv1].[dbo].[STAGING_ORDERS] o
    JOIN [STAGINGv1].[dbo].[STAGING_OUTORDERSTATUS] s ON o.orderID = s.orderID
    JOIN dbo.DimCustomer c ON o.custID = c.CustomerID
GROUP BY 
    o.orderID, c.SurrogateCustomerID, o.partnerID;

-- Populate FactSales

INSERT INTO dbo.FactSales (SurrogateOrderID, SurrogateProductID, SurrogateCustomerID, DateID, Quantity, TotalCost)
SELECT 
    do.SurrogateOrderID,
    dp.SurrogateProductID,
    dc.SurrogateCustomerID,
    dd.DateID,
    po.units,
    po.units * p.price AS TotalCost
FROM 
    [STAGINGv1].[dbo].[STAGING_PRODUCTS_ORDERS] po
    JOIN [STAGINGv1].[dbo].[STAGING_PRODUCTS] p ON po.productID = p.productID
    JOIN [STAGINGv1].[dbo].[STAGING_ORDERS] o ON po.orderID = o.orderID
    JOIN [STAGINGv1].[dbo].[STAGING_OUTORDERSTATUS] os ON o.orderID = os.orderID
    JOIN dbo.DimOrder do ON o.orderID = do.OrderID
    JOIN dbo.DimProduct dp ON p.productID = dp.ProductID
    JOIN dbo.DimCustomer dc ON o.custID = dc.CustomerID
    JOIN dbo.DimDate dd ON 
        DATEPART(YEAR, os.date_ordersales_status_changed) * 10000 +
        DATEPART(MONTH, os.date_ordersales_status_changed) * 100 +
        DATEPART(DAY, os.date_ordersales_status_changed) = dd.DateID
WHERE 
    os.status_id = (SELECT status_id FROM [STAGINGv1].[dbo].[STAGING_STATUSES] WHERE status_name = 'Completed');



-- DIM GIA 2o STAR SCHEMA

INSERT INTO dbo.DimSupplier (SupplierID, CompanyName, Email, SurrogateLocationID, EffectiveDate, ExpiryDate, IsCurrent)
SELECT 
    supplier_ID,
    company_name,
    email,
    (SELECT SurrogateLocationID FROM dbo.DimLocation WHERE LocationID = s.locationID),
    GETDATE() AS EffectiveDate,
    '9999-12-31' AS ExpiryDate,
    1 AS IsCurrent
FROM 
    [STAGINGv1].[dbo].[STAGING_SUPPLIERS] s;


INSERT INTO dbo.DimRawMaterial (RawMaterialID, RawMaterialName, RawMaterialDescription, EffectiveDate, ExpiryDate, IsCurrent)
SELECT 
    rawMatID,
    raw_material_name,
    raw_material_description,
    GETDATE() AS EffectiveDate,
    '9999-12-31' AS ExpiryDate,
    1 AS IsCurrent
FROM 
    [STAGINGv1].[dbo].[STAGING_RAW_MATERIALS];


INSERT INTO dbo.DimStatus (StatusID, StatusName, EffectiveDate, ExpiryDate, IsCurrent)
SELECT 
    status_id,
    status_name,
    GETDATE() AS EffectiveDate,
    '9999-12-31' AS ExpiryDate,
    1 AS IsCurrent
FROM 
    [STAGINGv1].[dbo].[STAGING_STATUSES];




--populate fact for orders raw material

INSERT INTO dbo.FactRawMaterialOrders (OrderID, SurrogateSupplierID, SurrogateRawMaterialID, DateID, SurrogateStatusID, Quantity, TotalCost)
SELECT 
    rm.rmorderID AS OrderID,
    ds.SurrogateSupplierID,
    dr.SurrogateRawMaterialID,
    dd.DateID,
    dstat.SurrogateStatusID,
    rmo.units AS Quantity,
    rmo.units * rms.CostPerUnit AS TotalCost
FROM 
    [STAGINGv1].[dbo].[STAGING_RAW_MATERIALS_ORDERS_RAW_MATERIALS] rmo
    left JOIN [STAGINGv1].[dbo].[STAGING_ORDERS_FOR_RAW_MATERIALS] rm ON rmo.rmorderID = rm.rmorderID
    left JOIN [STAGINGv1].[dbo].[STAGING_RAW_MATERIALS_SUPPLIERS] rms ON rm.supplier_ID = rms.supplier_ID AND rmo.rawMatID = rms.rawMatID
    left JOIN dbo.DimSupplier ds ON rm.supplier_ID = ds.SupplierID
    left JOIN dbo.DimRawMaterial dr ON rmo.rawMatID = dr.RawMaterialID
    left JOIN [STAGINGv1].[dbo].[STAGING_RAW_MATERIALS_ORDER_STATUS] rmos ON rm.rmorderID = rmos.rmorderID
    left JOIN dbo.DimStatus dstat ON rmos.status_id = dstat.StatusID
    left JOIN dbo.DimDate dd ON 
        DATEPART(YEAR, rmos.date_of_status_change) * 10000 +
        DATEPART(MONTH, rmos.date_of_status_change) * 100 +
        DATEPART(DAY, rmos.date_of_status_change) = dd.DateID
WHERE 
    dstat.IsCurrent = 1;





-----


INSERT INTO dbo.DimQualityControl (RepID, Result, EffectiveDate, ExpiryDate, IsCurrent)
SELECT
    qc.repID,
    qr.result,
    GETDATE(), 
    NULL, 
    1 
FROM
    [STAGINGv1].[dbo].[STAGING_QUALITY_CONTROL] qc
    JOIN [STAGINGv1].[dbo].[STAGING_QC_REPORTS] qr ON qc.test_reportID = qr.resultID;



INSERT INTO dbo.DimShift (ShiftID, StartTime, EndTime, EffectiveDate, ExpiryDate, IsCurrent)
SELECT
    shiftID,
    start_time,
    end_time,
    GETDATE(), 
    NULL, 
    1 
FROM
    [STAGINGv1].[dbo].[STAGING_SHIFTS];


INSERT INTO dbo.DimMemberr (MemberID, FirstName, LastName, RoleID, ShiftID, StartTime, EndTime, EffectiveDate, ExpiryDate, IsCurrent)
SELECT
    sm.memberID,
    sm.firstname,
    sm.lastname,
    sr.roleID,
    ss.shiftID,
    ss.start_time,
    ss.end_time,
    GETDATE(), 
	NULL, 
    1 -- 
FROM
    [STAGINGv1].[dbo].[STAGING_MEMBERS] sm
    JOIN [STAGINGv1].[dbo].[STAGING_MEMBERS_SHIFT] sms ON sm.memberID = sms.memberID
    JOIN [STAGINGv1].[dbo].[STAGING_SHIFTS] ss ON sms.shiftID = ss.shiftID
    JOIN [STAGINGv1].[dbo].[STAGING_ROLES] sr ON sm.roleID = sr.roleID;





INSERT INTO dbo.DimProduction (ProductionID, OrderID, ShiftID, repID,   EffectiveDate, ExpiryDate, IsCurrent)
SELECT
    productionID,
    orderID,
    shiftID,
    repID,
    
    GETDATE(), 
    NULL, 
    1 -- 
FROM
    [STAGINGv1].[dbo].[STAGING_PRODUCTION];




-- Εισαγωγή δεδομένων στον πίνακα DimStatus_pending
INSERT INTO DimStatus_pending (date_ordersales_status_changed, orderID)
SELECT date_ordersales_status_changed, orderID
FROM [STAGINGv1].[dbo].[STAGING_OUTORDERSTATUS]
WHERE status_id = 2; 

-- Εισαγωγή δεδομένων στον πίνακα DimStatus_processing
INSERT INTO DimStatus_processing (date_ordersales_status_changed, orderID)
SELECT date_ordersales_status_changed, orderID
FROM [STAGINGv1].[dbo].[STAGING_OUTORDERSTATUS]
WHERE status_id = 3; 


INSERT INTO dbo.FactProduction (SurrogateOrderID, SurrogateShiftID, SurrogateQCID, StartDate, EndDate)
SELECT
    do.SurrogateOrderID,
    ds.SurrogateShiftID,
    dq.SurrogateQCID,
    dsp.date_ordersales_status_changed AS StartDate,
    dspr.date_ordersales_status_changed AS EndDate
FROM
    [STAGINGv1].[dbo].[STAGING_PRODUCTION] sp
INNER JOIN
    dbo.DimOrder do ON sp.orderID = do.OrderID
INNER JOIN
    dbo.DimShift ds ON sp.shiftID = ds.ShiftID
INNER JOIN
    dbo.DimQualityControl dq ON sp.repID = dq.RepID
LEFT JOIN
    dbo.DimStatus_pending dsp ON sp.orderID = dsp.orderID
LEFT JOIN
    dbo.DimStatus_processing dspr ON sp.orderID = dspr.orderID;



--populate factinventory and the dims


INSERT INTO dbo.DimWarehouse (WarehouseID, LocationID, Capacity, EffectiveDate, ExpiryDate, IsCurrent)
SELECT 
    warehouseID,
    locationID,
    capacity,
    GETDATE(), -- Ή μια σταθερή τιμή για την ημερομηνία έναρξης της εγγραφής
    NULL, -- Εάν δεν υπάρχει πληροφορία για λήξη, αφήστε το ως NULL
    1 -- Υποθέτουμε ότι η εγγραφή είναι τρέχουσα
FROM 
    [STAGINGv1].[dbo].[STAGING_WAREHOUSES_OF_RAW_MATERIALS];



INSERT INTO dbo.DimRawMaterialWarehouse (WarehouseID, RawMaterialID, StockedQuantity)
SELECT 
    warehouseID,
    rawMatID,
    stocked_quantity
FROM 
    [STAGINGv1].[dbo].[STAGING_RAW_MATERIALS_WAREHOUSE_RAW_MATERIALS];











INSERT INTO dbo.FactInventory (SurrogateWarehouseID, SurrogateRawMaterialID, StockedQuantity, AvailableCapacity)
SELECT 
    dw.SurrogateWarehouseID,
    drm.SurrogateRawMaterialID,
    drw.StockedQuantity,
    dw.Capacity - SUM(drw.StockedQuantity) OVER (PARTITION BY dw.SurrogateWarehouseID) AS AvailableCapacity
FROM 
    dbo.DimRawMaterialWarehouse drw
INNER JOIN 
    dbo.DimWarehouse dw ON drw.WarehouseID = dw.WarehouseID
INNER JOIN 
    dbo.DimRawMaterial drm ON drw.RawMaterialID = drm.RawMaterialID;
