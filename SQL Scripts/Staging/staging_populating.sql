-- Insertion for Staging Table for Quality Control Reports
INSERT INTO STAGING_QC_REPORTS (resultID, result)
SELECT resultID, result FROM [OLTPv2].[dbo].[QC_REPORTS];

INSERT INTO STAGING_CATEGORIES (categoryID, categoryName)
SELECT categoryID, categoryName FROM [OLTPv2].[dbo].[CATEGORIES];

INSERT INTO STAGING_RAW_MATERIALS (rawMatID, raw_material_name, raw_material_description)
SELECT rawMatID, raw_material_name, raw_material_description FROM [OLTPv2].[dbo].[RAW_MATERIALS];

INSERT INTO STAGING_LOCATIONS (locationID, location_name)
SELECT locationID, location_name FROM [OLTPv2].[dbo].[LOCATIONS];

INSERT INTO STAGING_WAREHOUSES_OF_RAW_MATERIALS (warehouseID, locationID, capacity)
SELECT warehouseID, locationID, capacity FROM [OLTPv2].[dbo].[WAREHOUSES_OF_RAW_MATERIALS];

INSERT INTO STAGING_CUSTOMERS (custID, company_name, email, locationID)
SELECT custID, company_name, email, locationID FROM [OLTPv2].[dbo].[CUSTOMERS];

INSERT INTO STAGING_SHIFTS (shiftID, start_time, end_time)
SELECT shiftID, start_time, end_time FROM [OLTPv2].[dbo].[SHIFTS];

INSERT INTO STAGING_SUPPLIERS (supplier_ID, company_name, email, locationID)
SELECT supplier_ID, company_name, email, locationID FROM [OLTPv2].[dbo].[SUPPLIERS];

INSERT INTO STAGING_QUALITY_CONTROL (repID, test_reportID, report_date)
SELECT repID, resultID, report_date FROM [OLTPv2].[dbo].[QUALITY_CONTROL];

INSERT INTO STAGING_ORDERS_FOR_RAW_MATERIALS (rmorderID, supplier_ID)
SELECT rmorderID, supplier_ID FROM [OLTPv2].[dbo].[ORDERS_FOR_RAW_MATERIALS];

INSERT INTO STAGING_COMPLIANCES (compliance_id, compliance_name, cost)
SELECT compliance_id, compliance_name, cost FROM [OLTPv2].[dbo].[COMPLIANCES];

INSERT INTO STAGING_STATUSES (status_id, status_name)
SELECT status_id, status_name FROM [OLTPv2].[dbo].[STATUSES];

INSERT INTO STAGING_ROLES (roleID, role)
SELECT roleID, role FROM [OLTPv2].[dbo].[ROLES];

INSERT INTO STAGING_PARTNERS (partnerID, Company_Name, email, locationID)
SELECT partnerID, Company_Name, email, locationID FROM [OLTPv2].[dbo].[PARTNERS];

INSERT INTO STAGING_RAW_MATERIALS_WAREHOUSE_RAW_MATERIALS (stocked_quantity, batchid, rawMatID, warehouseID)
SELECT stocked_quantity, batchid, rawMatID, warehouseID FROM [OLTPv2].[dbo].[RAW_MATERIALS_WAREHOUSE_RAW_MATERIALS];

INSERT INTO STAGING_RAW_MATERIALS_ORDERS_RAW_MATERIALS (units, rmorderID, rawMatID)
SELECT units, rmorderID, rawMatID FROM [OLTPv2].[dbo].[RAW_MATERIALS_ORDERS_RAW_MATERIALS];

INSERT INTO STAGING_RAW_MATERIALS_SUPPLIERS (CostPerUnit, rawMatID, supplier_ID)
SELECT CostPerUnit, rawMatID, supplier_ID FROM [OLTPv2].[dbo].[RAW_MATERIALS_SUPPLIERS];

INSERT INTO STAGING_RAW_MATERIALS_ORDER_STATUS (date_of_status_change, status_id, rmorderID)
SELECT date_of_status_change, status_id, rmorderID FROM [OLTPv2].[dbo].[RAW_MATERIALS_ORDER_STATUS];

INSERT INTO STAGING_PRODUCTS (productID, name, price, construction_time, length, weight, thickness, categoryID)
SELECT productID, name, price, construction_time, length, weight, thickness, categoryID FROM [OLTPv2].[dbo].[PRODUCTS];

INSERT INTO STAGING_ORDERS (orderID, custID, partnerID)
SELECT orderID, custID, partnerID FROM [OLTPv2].[dbo].[ORDERS];

INSERT INTO STAGING_PRODUCTION (productionID, orderID, shiftID, repID)
SELECT productionID, orderID, shiftID, repID FROM [OLTPv2].[dbo].[PRODUCTION];

INSERT INTO STAGING_MEMBERS (memberID, firstname, lastname, roleID)
SELECT memberID, firstname, lastname, roleID FROM [OLTPv2].[dbo].[MEMBERS];

INSERT INTO STAGING_PRODUCTS_RAW_MATERIALS (quantity_per_product, productID, rawMatID)
SELECT quantity_per_product, productID, rawMatID FROM [OLTPv2].[dbo].[PRODUCTS_RAW_MATERIALS];

INSERT INTO STAGING_MEMBERS_SHIFT (shiftID, memberID)
SELECT shiftID, memberID FROM [OLTPv2].[dbo].[MEMBERS_SHIFT];

INSERT INTO STAGING_COMPLIANCE_PRODUCTS (expire_date, compliance_id, productID)
SELECT expire_date, compliance_id, productID FROM [OLTPv2].[dbo].[COMPLIANCE_PRODUCTS];

INSERT INTO STAGING_OUTORDERSTATUS (date_ordersales_status_changed, orderID, status_id)
SELECT date_ordersales_status_changed, orderID, status_id FROM [OLTPv2].[dbo].[OUTORDERSTATUS];

INSERT INTO STAGING_PRODUCTS_ORDERS (units, productID, orderID)
SELECT units, productID, orderID FROM [OLTPv2].[dbo].[PRODUCTS_ORDERS];
