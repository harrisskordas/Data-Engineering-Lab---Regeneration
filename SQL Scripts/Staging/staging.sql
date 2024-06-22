-- Staging table for Quality Control Reports
CREATE TABLE STAGING_QC_REPORTS (
    resultID INT,
    result NVARCHAR(100)
);

-- Staging table for Categories
CREATE TABLE STAGING_CATEGORIES (
    categoryID INT,
    categoryName NVARCHAR(255)
);

-- Staging table for Raw Materials
CREATE TABLE STAGING_RAW_MATERIALS (
    rawMatID INT,
    raw_material_name NVARCHAR(255),
    raw_material_description NVARCHAR(255)
);

-- Staging table for Locations
CREATE TABLE STAGING_LOCATIONS (
    locationID INT,
    location_name NVARCHAR(100)
);

-- Staging table for Warehouses of Raw Materials
CREATE TABLE STAGING_WAREHOUSES_OF_RAW_MATERIALS (
    warehouseID INT,
    locationID INT,
    capacity DECIMAL(10, 2)
);

-- Staging table for Customers
CREATE TABLE STAGING_CUSTOMERS (
    custID INT,
    company_name NVARCHAR(255),
    email NVARCHAR(255),
    locationID INT
);

-- Staging table for Shifts
CREATE TABLE STAGING_SHIFTS (
    shiftID INT,
    start_time TIME,
    end_time TIME
);

-- Staging table for Suppliers
CREATE TABLE STAGING_SUPPLIERS (
    supplier_ID INT,
    company_name NVARCHAR(255),
    email NVARCHAR(255),
    locationID INT
);

-- Staging table for Quality Control
CREATE TABLE STAGING_QUALITY_CONTROL (
    repID INT, -- Προσθήκη της νέας στήλης repID
    test_reportID INT,
    report_date DATETIME
);

-- Staging table for Orders for Raw Materials
CREATE TABLE STAGING_ORDERS_FOR_RAW_MATERIALS (
    rmorderID INT,
    supplier_ID INT
);

-- Staging table for Compliance
CREATE TABLE STAGING_COMPLIANCES (
    compliance_id INT,
    compliance_name NVARCHAR(255),
    cost DECIMAL(10, 2)
);

-- Staging table for Status
CREATE TABLE STAGING_STATUSES (
    status_id INT,
    status_name NVARCHAR(255)
);

-- Staging table for Roles
CREATE TABLE STAGING_ROLES (
    roleID INT,
    role NVARCHAR(255)
);

-- Staging table for Partners
CREATE TABLE STAGING_PARTNERS (
    partnerID INT,
    Company_Name NVARCHAR(255),
    email NVARCHAR(255),
    locationID INT
);

-- Staging table for Stored Raw Materials in Warehouses
CREATE TABLE STAGING_RAW_MATERIALS_WAREHOUSE_RAW_MATERIALS (
    stocked_quantity INT,
    batchid INT,
    rawMatID INT,
    warehouseID INT
);

-- Staging table for Relationship between Orders_of_raw_materials and Raw Materials
CREATE TABLE STAGING_RAW_MATERIALS_ORDERS_RAW_MATERIALS (
    units INT,
    rmorderID INT,
    rawMatID INT
);

-- Staging table for Cost Per Unit of Raw Materials from Suppliers
CREATE TABLE STAGING_RAW_MATERIALS_SUPPLIERS (
    CostPerUnit DECIMAL(10, 2),
    rawMatID INT,
    supplier_ID INT
);

-- Staging table for Order Supply Status
CREATE TABLE STAGING_RAW_MATERIALS_ORDER_STATUS (
    date_of_status_change DATETIME,
    status_id INT,
    rmorderID INT
);

-- Staging table for Products
CREATE TABLE STAGING_PRODUCTS (
    productID INT,
    name NVARCHAR(255),
    price DECIMAL(10, 2),
    construction_time INT,
    length DECIMAL(10, 2),
    weight DECIMAL(10, 2),
    thickness DECIMAL(10, 2),
    categoryID INT
);

-- Staging table for Orders
CREATE TABLE STAGING_ORDERS (
    orderID INT,
    custID INT,
    partnerID INT
);

-- Staging table for Production
CREATE TABLE STAGING_PRODUCTION (
    productionID INT,
    orderID INT,
    shiftID INT,
    repID INT
);

-- Staging table for Members
CREATE TABLE STAGING_MEMBERS (
    memberID INT,
    firstname NVARCHAR(255),
    lastname NVARCHAR(255),
    roleID INT
);

-- Staging table for Relationship between Products and Raw Materials
CREATE TABLE STAGING_PRODUCTS_RAW_MATERIALS (
    quantity_per_product INT,
    productID INT,
    rawMatID INT
);

-- Staging table for Members Shift Assignments
CREATE TABLE STAGING_MEMBERS_SHIFT (
    shiftID INT,
    memberID INT
);

-- Staging table for Compliance and Product Relationship
CREATE TABLE STAGING_COMPLIANCE_PRODUCTS (
    expire_date DATETIME,
    compliance_id INT,
    productID INT
);

-- Staging table for Order Sales Status
CREATE TABLE STAGING_OUTORDERSTATUS (
    date_ordersales_status_changed DATETIME,
    orderID INT,
    status_id INT
);

-- Staging table for Products Orders
CREATE TABLE STAGING_PRODUCTS_ORDERS (
    units INT,
    productID INT,
    orderID INT
);





