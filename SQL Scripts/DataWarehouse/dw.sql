-- Dimension Tables with Surrogate Keys

CREATE TABLE dbo.DimLocation (
    SurrogateLocationID INT IDENTITY(1,1) PRIMARY KEY,
    LocationID INT,
    LocationName NVARCHAR(100)
);

CREATE TABLE dbo.DimCategory (
    SurrogateCategoryID INT IDENTITY(1,1) PRIMARY KEY,
    CategoryID INT,
    CategoryName NVARCHAR(255),
    EffectiveDate DATETIME,
    ExpiryDate DATETIME,
    IsCurrent BIT
);

CREATE TABLE dbo.DimProduct (
    SurrogateProductID INT IDENTITY(1,1) PRIMARY KEY,
    ProductID INT,
    ProductName NVARCHAR(255),
    SurrogateCategoryID INT,
    Price DECIMAL(10, 2),
    Length DECIMAL(10, 2),
    Weight DECIMAL(10, 2),
    Thickness DECIMAL(10, 2),
    EffectiveDate DATETIME,
    ExpiryDate DATETIME,
    IsCurrent BIT,
    FOREIGN KEY (SurrogateCategoryID) REFERENCES dbo.DimCategory(SurrogateCategoryID)
);

CREATE TABLE dbo.DimCustomer (
    SurrogateCustomerID INT IDENTITY(1,1) PRIMARY KEY,
    CustomerID INT,
    CompanyName NVARCHAR(255),
    Email NVARCHAR(255),
    SurrogateLocationID INT,
    EffectiveDate DATETIME,
    ExpiryDate DATETIME,
    IsCurrent BIT,
    FOREIGN KEY (SurrogateLocationID) REFERENCES dbo.DimLocation(SurrogateLocationID)
);

-- DimDate Table Creation
CREATE TABLE dbo.DimDate (
    DateID INT PRIMARY KEY,
    Date DATE,
    Year INT,
    Quarter INT,
    Month INT,
    Day INT,
    WeekDay NVARCHAR(20),
    EffectiveDate DATETIME,
    ExpiryDate DATETIME,
    IsCurrent BIT,
    IsHoliday BIT -- Νέα στήλη για το αν είναι αργία η ημερομηνία
);
CREATE TABLE dbo.DimOrder (
    SurrogateOrderID INT IDENTITY(1,1) PRIMARY KEY,
    OrderID INT,
    SurrogateCustomerID INT,
    PartnerID INT,
    OrderDate DATE,
    EffectiveDate DATETIME,
    ExpiryDate DATETIME,
    IsCurrent BIT,
    FOREIGN KEY (SurrogateCustomerID) REFERENCES dbo.DimCustomer(SurrogateCustomerID)
);

-- Fact Table

CREATE TABLE dbo.FactSales (
    SalesID INT IDENTITY(1,1) PRIMARY KEY,
    SurrogateOrderID INT,
    SurrogateProductID INT,
    SurrogateCustomerID INT,
	-- SurrogateStatusID INT  , kai na erthei to status panw
    DateID INT,
    Quantity INT,
    TotalCost DECIMAL(10, 2),
    FOREIGN KEY (SurrogateOrderID) REFERENCES dbo.DimOrder(SurrogateOrderID),
    FOREIGN KEY (SurrogateProductID) REFERENCES dbo.DimProduct(SurrogateProductID),
    FOREIGN KEY (SurrogateCustomerID) REFERENCES dbo.DimCustomer(SurrogateCustomerID),
	--FOREIGN KEY (SurrogateStatusID) REFERENCES dbo.DimStatus(SurrogateStatusID)
    FOREIGN KEY (DateID) REFERENCES dbo.DimDate(DateID)
);


--DES EDW!!!!!




--einai swsto  to population apla iparxei null sto dateid aytoy tou fact enw sto SALESFACT OXI. des tin ilopoiisi sto date toy fact sales
CREATE TABLE dbo.DimSupplier (
    SurrogateSupplierID INT IDENTITY(1,1) PRIMARY KEY,
    SupplierID INT,
    CompanyName NVARCHAR(255),
    Email NVARCHAR(255),
    SurrogateLocationID INT,
    EffectiveDate DATETIME,
    ExpiryDate DATETIME,
    IsCurrent BIT,
    FOREIGN KEY (SurrogateLocationID) REFERENCES dbo.DimLocation(SurrogateLocationID)
);





CREATE TABLE dbo.DimRawMaterial (
    SurrogateRawMaterialID INT IDENTITY(1,1) PRIMARY KEY,
    RawMaterialID INT,
    RawMaterialName NVARCHAR(255),
    RawMaterialDescription NVARCHAR(255),
    EffectiveDate DATETIME,
    ExpiryDate DATETIME,
    IsCurrent BIT
);





CREATE TABLE dbo.DimStatus (
    SurrogateStatusID INT IDENTITY(1,1) PRIMARY KEY,
    StatusID INT,
    StatusName NVARCHAR(255),

    EffectiveDate DATETIME,
    ExpiryDate DATETIME,
    IsCurrent BIT
);





-- Fact Table for Raw Materials Orders
CREATE TABLE dbo.FactRawMaterialOrders (
	fact INT IDENTITY(1,1) PRIMARY KEY, 
    OrderID INT,
    SurrogateSupplierID INT,
    SurrogateRawMaterialID INT,
    DateID INT,
    SurrogateStatusID INT,
    Quantity INT,
    TotalCost DECIMAL(10, 2),
    FOREIGN KEY (SurrogateSupplierID) REFERENCES dbo.DimSupplier(SurrogateSupplierID),
    FOREIGN KEY (SurrogateRawMaterialID) REFERENCES dbo.DimRawMaterial(SurrogateRawMaterialID),
    FOREIGN KEY (DateID) REFERENCES dbo.DimDate(DateID),
    FOREIGN KEY (SurrogateStatusID) REFERENCES dbo.DimStatus(SurrogateStatusID)
);


---------
------------
----------




--fact about production





CREATE TABLE dbo.DimQualityControl (
    SurrogateQCID INT IDENTITY(1,1) PRIMARY KEY,
    RepID INT,
    Result NVARCHAR(100),
    EffectiveDate DATETIME,
    ExpiryDate DATETIME,
    IsCurrent BIT
);



-- Dimension Table for Members (Staff)
CREATE TABLE dbo.DimMemberr (
    SurrogateMemberID INT IDENTITY(1,1) PRIMARY KEY,
    MemberID INT,
    FirstName NVARCHAR(255),
    LastName NVARCHAR(255),
    RoleID INT,
    ShiftID INT, 
    StartTime TIME, 
    EndTime TIME,
    EffectiveDate DATETIME,
    ExpiryDate DATETIME,
    IsCurrent BIT
);




-- Dimension Table for Shifts
CREATE TABLE dbo.DimShift (
    SurrogateShiftID INT IDENTITY(1,1) PRIMARY KEY,
    ShiftID INT,
    StartTime TIME,
    EndTime TIME,
    EffectiveDate DATETIME,
    ExpiryDate DATETIME,
    IsCurrent BIT
);



-- Dimension Table for Production σςστο
CREATE TABLE dbo.DimProduction (
    SurrogateProductionID INT IDENTITY(1,1) PRIMARY KEY,
    ProductionID INT,
    OrderID INT,
    ShiftID INT,
    repID INT,
    EffectiveDate DATETIME,
    ExpiryDate DATETIME,
    IsCurrent BIT,
    
);



-- dim table for status when the production started
CREATE TABLE DimStatus_pending (
    SurrogateStatusID INT IDENTITY(1,1) PRIMARY KEY,
    date_ordersales_status_changed DATETIME,
    orderID INT
);

-- dim table for status when the production finished
CREATE TABLE DimStatus_processing (
    SurrogateStatusID INT IDENTITY(1,1) PRIMARY KEY,
    date_ordersales_status_changed DATETIME,
    orderID INT
);





CREATE TABLE dbo.FactProduction (
    ProductionID INT IDENTITY(1,1) PRIMARY KEY,
    SurrogateOrderID INT,
    SurrogateShiftID INT,
    SurrogateQCID INT,
    StartDate DATETIME,
    EndDate DATETIME,
    FOREIGN KEY (SurrogateOrderID) REFERENCES dbo.DimOrder(SurrogateOrderID),
    FOREIGN KEY (SurrogateShiftID) REFERENCES dbo.DimShift(SurrogateShiftID),
    FOREIGN KEY (SurrogateQCID) REFERENCES dbo.DimQualityControl(SurrogateQCID)
);






--fact about inventory





--test

CREATE TABLE dbo.DimWarehouse (
    SurrogateWarehouseID INT IDENTITY(1,1) PRIMARY KEY,
    WarehouseID INT,
    LocationID INT,
    Capacity DECIMAL(10, 2),
    EffectiveDate DATETIME,
    ExpiryDate DATETIME,
    IsCurrent BIT,
);

CREATE TABLE dbo.DimRawMaterialWarehouse (
    SurrogateRawMaterialWarehouseID INT IDENTITY(1,1) PRIMARY KEY,
    WarehouseID INT,
    RawMaterialID INT,
    StockedQuantity INT

);

CREATE TABLE dbo.FactInventory (
    InventoryID INT IDENTITY(1,1) PRIMARY KEY,
    SurrogateWarehouseID INT,
    SurrogateRawMaterialID INT,
    StockedQuantity INT,
    AvailableCapacity DECIMAL(10, 2),
    FOREIGN KEY (SurrogateWarehouseID) REFERENCES dbo.DimWarehouse(SurrogateWarehouseID),
    FOREIGN KEY (SurrogateRawMaterialID) REFERENCES dbo.DimRawMaterial(SurrogateRawMaterialID),
);



