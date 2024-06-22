-- view for the consumption of raw materials during productions according to the order demands
CREATE VIEW dbo.ProductionViewWithRawMaterialNameAndConsumption
AS
SELECT
    p.productionID,
    p.orderID,
    po.productID,
    po.units AS quantity_produced,
    prm.quantity_per_product AS raw_material_consumed,
    prm.quantity_per_product * po.units AS total_raw_material_consumed,
    rm.raw_material_name AS raw_material_name
FROM
    [stagingtest].[dbo].[STAGING_PRODUCTION] p
INNER JOIN
    [stagingtest].[dbo].[STAGING_PRODUCTS_ORDERS] po ON p.orderID = po.orderID
INNER JOIN
    [stagingtest].[dbo].[STAGING_PRODUCTS_RAW_MATERIALS] prm ON po.productID = prm.productID
INNER JOIN
    [stagingtest].[dbo].[STAGING_RAW_MATERIALS] rm ON prm.rawMatID = rm.rawMatID;





--view about clients orders products and amount of products
CREATE VIEW dbo.SalesViewWithClientDetails
AS
SELECT
    sum(spo.units) as total_products_ordered,
    orders.custID,
    cust.company_name,
    cust.email
FROM
    [stagingtest].[dbo].[STAGING_PRODUCTS_ORDERS] spo
INNER JOIN
    [stagingtest].[dbo].[STAGING_ORDERS] orders ON spo.orderID = orders.orderID
INNER JOIN
    [stagingtest].[dbo].[STAGING_CUSTOMERS] cust ON orders.custID = cust.custID
GROUP BY
    orders.custID, cust.company_name, cust.email

