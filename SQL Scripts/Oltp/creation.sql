-- Table for quality control reports

CREATE TABLE QC_REPORTS
(
resultID INT NOT NULL IDENTITY,
result NVARCHAR(100) NOT NULL,
PRIMARY KEy (resultID)
)


-- Table for Categories
CREATE TABLE CATEGORIES
(
  categoryID INT NOT NULL IDENTITY,  -- Unique identifier for each category
  categoryName NVARCHAR(255) NOT NULL,  -- Name of the category
  PRIMARY KEY (categoryID)  -- Primary key on categoryID
);

-- Table for Raw Materials
CREATE TABLE RAW_MATERIALS
(
  rawMatID INT NOT NULL IDENTITY,  -- Unique identifier for each raw material
  raw_material_name NVARCHAR(255) NOT NULL,  -- Name of the raw material
  raw_material_description NVARCHAR(255) NOT NULL --Description of raw material
  PRIMARY KEY (rawMatID)  -- Primary key on rawMatID
);

-- Table for Locations
CREATE TABLE LOCATIONS
(
  locationID INT NOT NULL IDENTITY, -- Unique identifier for each location
  location_name NVARCHAR(100) -- Location's name
  PRIMARY KEY (locationID) -- Primary key on locationID
);

-- Table for Warehouses
CREATE TABLE WAREHOUSES_OF_RAW_MATERIALS
(
  warehouseID INT NOT NULL IDENTITY,  -- Unique identifier for each warehouse
  locationID INT NOT NULL,  -- Foreign key referencing locationID from LOCATIONS table
  capacity DECIMAL(10, 2) NOT NULL,  -- Total capacity of the warehouse
  PRIMARY KEY (warehouseID),  -- Primary key on warehouseID
  FOREIGN KEY (locationID) REFERENCES LOCATIONS(locationID)  -- Foreign key constraint
);

-- Table for Customers
CREATE TABLE CUSTOMERS
(
  custID INT NOT NULL IDENTITY,  -- Unique identifier for each customer
  company_name NVARCHAR(255) NOT NULL,  -- Company name of the customer
  email NVARCHAR(255) NOT NULL,  -- Email address of the customer
  locationID INT NOT NULL,  -- Foreign key referencing locationID from LOCATIONS table
  PRIMARY KEY (custID), -- Primary key on custID
  FOREIGN KEY (locationID) REFERENCES LOCATIONS(locationID)  -- Foreign key constraint
);

-- Table for Shifts
CREATE TABLE SHIFTS
(
  shiftID INT NOT NULL IDENTITY,  -- Unique identifier for each shift
  start_time TIME NOT NULL,  -- Start time of the shift
  end_time TIME NOT NULL,  -- End time of the shift
  PRIMARY KEY (shiftID)  -- Primary key on shiftID
);


-- Table for Suppliers
CREATE TABLE SUPPLIERS
(
  supplier_ID INT NOT NULL IDENTITY,  -- Unique identifier for each supplier
  company_name NVARCHAR(255) NOT NULL,  -- Company name of the supplier
  email NVARCHAR(255) NOT NULL,  -- Email address of the supplier
  locationID INT NOT NULL,  -- Foreign key referencing locationID from LOCATIONS table
  PRIMARY KEY (supplier_ID),  -- Primary key on supplier_ID
  FOREIGN KEY (locationID) REFERENCES LOCATIONS(locationID)  -- Foreign key constraint
);

-- Table for Quality Control
CREATE TABLE QUALITY_CONTROL
(
  repID INT NOT NULL IDENTITY,  -- Quality control report ID
  resultID INT NOT NULL ,  
  report_date DATETIME NOT NULL,  -- Date and time of the test report
  PRIMARY KEY (repID),  -- Primary key on test_reportID
  FOREIGN KEY (resultID) REFERENCES QC_REPORTS(resultID)

);

-- Table for Orders for Raw Materials
CREATE TABLE ORDERS_FOR_RAW_MATERIALS
(
  rmorderID INT NOT NULL IDENTITY,  -- Unique identifier for each raw material order
  supplier_ID INT NOT NULL,  -- Foreign key referencing supplier_ID from SUPPLIERS table
  PRIMARY KEY (rmorderID),  -- Primary key on rmorderID
  FOREIGN KEY (supplier_ID) REFERENCES SUPPLIERS(supplier_ID)  -- Foreign key constraint
);

-- Table for Compliance
CREATE TABLE COMPLIANCES
(
  compliance_id INT NOT NULL IDENTITY,  -- Unique identifier for each compliance record
  compliance_name NVARCHAR(255) NOT NULL,  -- Name of the compliance
  cost DECIMAL(10, 2) NOT NULL,  -- Cost associated with the compliance
  PRIMARY KEY (compliance_id)  -- Primary key on compliance_id
);

-- Table for Status
CREATE TABLE STATUSES
(
  status_id INT NOT NULL IDENTITY,  -- Unique identifier for each status
  status_name NVARCHAR(255) NOT NULL,  -- Name of the status
  PRIMARY KEY (status_id)  -- Primary key on status_id
);

-- Table for Roles
CREATE TABLE ROLES
(
  roleID INT NOT NULL IDENTITY,  -- Unique identifier for each role
  role NVARCHAR(255) NOT NULL,  -- Name of the role
  PRIMARY KEY (roleID)  -- Primary key on roleID
);

-- Table for Partners
CREATE TABLE PARTNERS
(
  partnerID INT NOT NULL IDENTITY,  -- Unique identifier for each partner
  Company_Name NVARCHAR(255) NOT NULL,  -- Company name of the partner
  email NVARCHAR(255) NOT NULL,  -- Email address of the partner
  locationID INT NOT NULL, -- Unique identifier for each location
  PRIMARY KEY (partnerID) , -- Primary key on partnerID
  FOREIGN KEY (locationID) REFERENCES LOCATIONS(locationID)  -- Foreign key constraint
);


-- Table for Stored Raw Materials in Warehouses
CREATE TABLE RAW_MATERIALS_WAREHOUSE_RAW_MATERIALS
(
  stocked_quantity INT NOT NULL,  -- Quantity of raw materials stocked
  batchid INT NOT NULL IDENTITY,  -- Unique identifier for each batch
  rawMatID INT NOT NULL,  -- Foreign key referencing rawMatID from RAW_MATERIALS table
  warehouseID INT NOT NULL,  -- Foreign key referencing warehouseID from WAREHOUSES table
  PRIMARY KEY (batchid),  -- Primary key on batchid
  FOREIGN KEY (rawMatID) REFERENCES RAW_MATERIALS(rawMatID),  -- Foreign key constraint
  FOREIGN KEY (warehouseID) REFERENCES WAREHOUSES_OF_RAW_MATERIALS(warehouseID),  -- Foreign key constraint
  
);

-- Table for Relationship between Orders_of_raw_materials and Raw Materials
CREATE TABLE RAW_MATERIALS_ORDERS_RAW_MATERIALS
(
  units INT NOT NULL,  -- Units of raw materials in the relationship
  rmorderID INT NOT NULL,  -- Foreign key referencing rmorderID from ORDERS_FOR_RAW_MATERIALS table
  rawMatID INT NOT NULL,  -- Foreign key referencing rawMatID from RAW_MATERIALS table
  
  PRIMARY KEY (rmorderID, rawMatID),  -- Composite primary key on rmorderID and rawMatID
  FOREIGN KEY (rmorderID) REFERENCES ORDERS_FOR_RAW_MATERIALS(rmorderID),  -- Foreign key constraint
  FOREIGN KEY (rawMatID) REFERENCES RAW_MATERIALS(rawMatID)  -- Foreign key constraint
);

-- Table for Cost Per Unit of Raw Materials from Suppliers
CREATE TABLE RAW_MATERIALS_SUPPLIERS
(
  CostPerUnit DECIMAL(10, 2) NOT NULL,  -- Cost per unit of raw material
  rawMatID INT NOT NULL,  -- Foreign key referencing rawMatID from RAW_MATERIALS table
  supplier_ID INT NOT NULL,  -- Foreign key referencing supplier_ID from SUPPLIERS table
  PRIMARY KEY (rawMatID, supplier_ID),  -- Composite primary key on rawMatID and supplier_ID
  FOREIGN KEY (rawMatID) REFERENCES RAW_MATERIALS(rawMatID),  -- Foreign key constraint
  FOREIGN KEY (supplier_ID) REFERENCES SUPPLIERS(supplier_ID)  -- Foreign key constraint
);

-- Table for Order Supply Status
CREATE TABLE RAW_MATERIALS_ORDER_STATUS
(
  date_of_status_change DATETIME NOT NULL,  -- Date and time of order supply
  status_id INT NOT NULL,  -- Foreign key referencing status_id from STATUSES table
  rmorderID INT NOT NULL,  -- Foreign key referencing rmorderID from ORDERS_FOR_RAW_MATERIALS table
  PRIMARY KEY (status_id, rmorderID),  -- Composite primary key on status_id and rmorderID
  FOREIGN KEY (status_id) REFERENCES STATUSES(status_id),  -- Foreign key constraint
  FOREIGN KEY (rmorderID) REFERENCES ORDERS_FOR_RAW_MATERIALS(rmorderID)  -- Foreign key constraint
);

-- Table for Products
CREATE TABLE PRODUCTS
(
  productID INT NOT NULL IDENTITY,  -- Unique identifier for each product
  name NVARCHAR(255) NOT NULL,  -- Name of the product
  price DECIMAL(10, 2) NOT NULL,  -- Price of the product
  construction_time INT NOT NULL,  -- Construction time of the product
  length DECIMAL(10, 2) NOT NULL,  -- Length of the product
  weight DECIMAL(10, 2) NOT NULL,  -- Weight of the product
  thickness DECIMAL(10, 2) NOT NULL,  -- Thickness of the product
  categoryID INT NOT NULL,  -- Foreign key referencing categoryID from CATEGORIES table
  PRIMARY KEY (productID),  -- Primary key on productID
  FOREIGN KEY (categoryID) REFERENCES CATEGORIES(categoryID)  -- Foreign key constraint
);

-- Table for Orders
CREATE TABLE ORDERS
(
  orderID INT NOT NULL IDENTITY,  -- Unique identifier for each order
  custID INT NOT NULL,  -- Foreign key referencing custID from CUSTOMERS table
  partnerID INT NOT NULL,  -- Foreign key referencing partnerID from PARTNERS table
  PRIMARY KEY (orderID),  -- Primary key on orderID
  FOREIGN KEY (custID) REFERENCES CUSTOMERS(custID),  -- Foreign key constraint
  FOREIGN KEY (partnerID) REFERENCES PARTNERS(partnerID)  -- Foreign key constraint
);

-- Table for Production
CREATE TABLE PRODUCTION
(
  productionID INT NOT NULL IDENTITY,  -- Unique identifier for each production record
  orderID INT NOT NULL,  -- Foreign key referencing orderID from ORDERS table
  shiftID INT NOT NULL,  -- Foreign key referencing shiftID from SHIFTS table
  repID INT NOT NULL,  --  test report id of each production
  PRIMARY KEY (productionID),  -- Primary key on productionID
  FOREIGN KEY (orderID) REFERENCES ORDERS(orderID),  -- Foreign key constraint
  FOREIGN KEY (shiftID) REFERENCES SHIFTS(shiftID),  -- Foreign key constraint
  FOREIGN KEY (repID) REFERENCES QUALITY_CONTROL(repID)  -- Foreign key constraint
);

-- Table for Members
CREATE TABLE MEMBERS
(
  memberID INT NOT NULL IDENTITY,  -- Unique identifier for each member
  firstname NVARCHAR(255) NOT NULL,  -- First name of the member
  lastname NVARCHAR(255) NOT NULL,  -- Last name of the member
  roleID INT NOT NULL,  -- Foreign key referencing roleID from ROLES table
  PRIMARY KEY (memberID),  -- Primary key on memberID
  FOREIGN KEY (roleID) REFERENCES ROLES(roleID)  -- Foreign key constraint
);

-- Table for Relationship between Products and Raw Materials
CREATE TABLE PRODUCTS_RAW_MATERIALS
(
  quantity_per_product INT NOT NULL,  -- Quantity of raw material per batch
  productID INT NOT NULL,  -- Foreign key referencing productID from PRODUCTS table
  rawMatID INT NOT NULL,  -- Foreign key referencing rawMatID from RAW_MATERIALS table
  PRIMARY KEY (productID, rawMatID),  -- Composite primary key on productID and rawMatID
  FOREIGN KEY (productID) REFERENCES PRODUCTS(productID),  -- Foreign key constraint
  FOREIGN KEY (rawMatID) REFERENCES RAW_MATERIALS(rawMatID)  -- Foreign key constraint
);

-- Table for Members Shift Assignments
CREATE TABLE MEMBERS_SHIFT
(
  shiftID INT NOT NULL,  -- Foreign key referencing shiftID from SHIFTS table
  memberID INT NOT NULL,  -- Foreign key referencing memberID from MEMBERS table
  PRIMARY KEY (shiftID, memberID),  -- Composite primary key on shiftID and memberID
  FOREIGN KEY (shiftID) REFERENCES SHIFTS(shiftID),  -- Foreign key constraint
  FOREIGN KEY (memberID) REFERENCES MEMBERS(memberID)  -- Foreign key constraint
);


-- Table for Compliance and Product Relationship
CREATE TABLE COMPLIANCE_PRODUCTS
(
  expire_date DATETIME NOT NULL,  -- Expiration date of the compliance
  compliance_id INT NOT NULL,  -- Foreign key referencing compliance_id from COMPLIANCES table
  productID INT NOT NULL,  -- Foreign key referencing productID from PRODUCTS table
  PRIMARY KEY (compliance_id, productID),  -- Composite primary key on compliance_id and productID
  FOREIGN KEY (compliance_id) REFERENCES COMPLIANCES(compliance_id),  -- Foreign key constraint
  FOREIGN KEY (productID) REFERENCES PRODUCTS(productID)  -- Foreign key constraint
);

-- Table for Order Sales Status
CREATE TABLE OUTORDERSTATUS
(
  date_ordersales_status_changed DATETIME NOT NULL,  -- Date and time of order sales
  orderID INT NOT NULL,  -- Foreign key referencing orderID from ORDERS table
  status_id INT NOT NULL,  -- Foreign key referencing status_id from STATUSES table
  PRIMARY KEY (orderID, status_id),  -- Composite primary key on orderID and status_id
  FOREIGN KEY (orderID) REFERENCES ORDERS(orderID),  -- Foreign key constraint
  FOREIGN KEY (status_id) REFERENCES STATUSES(status_id)  -- Foreign key constraint
);


CREATE TABLE products_orders
(
  units INT NOT NULL, -- Units
  productID INT NOT NULL, -- Stock Keeping Unit (SKU)
  orderID INT NOT NULL, -- Order ID
  PRIMARY KEY (productID, orderID), -- Primary key constraint
  FOREIGN KEY (productID) REFERENCES PRODUCTS(productID) ON DELETE CASCADE, -- Foreign key constraint for SKU
  FOREIGN KEY (orderID) REFERENCES ORDERS(orderID) ON DELETE CASCADE -- Foreign key constraint for Order ID
);