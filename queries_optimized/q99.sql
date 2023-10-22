WITH AggregatedSales AS (
    SELECT 
        CS_WAREHOUSE_SK,
        CS_SHIP_MODE_SK,
        CS_CALL_CENTER_SK,
        CS_SHIP_DATE_SK - CS_SOLD_DATE_SK AS DaysDifference,
        COUNT(*) AS Count
    FROM CATALOG_SALES
    WHERE CS_SHIP_DATE_SK IN (
        SELECT D_DATE_SK
        FROM DATE_DIM
        WHERE D_MONTH_SEQ BETWEEN 1178 AND 1178 + 11
    )
    GROUP BY 
        CS_WAREHOUSE_SK,
        CS_SHIP_MODE_SK,
        CS_CALL_CENTER_SK,
        CS_SHIP_DATE_SK - CS_SOLD_DATE_SK
)

SELECT 
    SUBSTR(W_WAREHOUSE_NAME, 1, 20) AS WarehouseName,
    SM_TYPE,
    CC_NAME,
    SUM(CASE WHEN DaysDifference <= 30 THEN Count ELSE 0 END) AS '30 DAYS',
    SUM(CASE WHEN DaysDifference <= 60 THEN Count ELSE 0 END) - SUM(CASE WHEN DaysDifference <= 30 THEN Count ELSE 0 END) AS '31 - 60 DAYS',
    SUM(CASE WHEN DaysDifference <= 90 THEN Count ELSE 0 END) - SUM(CASE WHEN DaysDifference <= 60 THEN Count ELSE 0 END) AS '61 - 90 DAYS',
    SUM(CASE WHEN DaysDifference <= 120 THEN Count ELSE 0 END) - SUM(CASE WHEN DaysDifference <= 90 THEN Count ELSE 0 END) AS '91 - 120 DAYS',
    SUM(CASE WHEN DaysDifference > 120 THEN Count ELSE 0 END) AS '> 120 DAYS'
FROM 
    AggregatedSales AS ASales
    JOIN WAREHOUSE ON ASales.CS_WAREHOUSE_SK = W_WAREHOUSE_SK
    JOIN SHIP_MODE ON ASales.CS_SHIP_MODE_SK = SM_SHIP_MODE_SK
    JOIN CALL_CENTER ON ASales.CS_CALL_CENTER_SK = CC_CALL_CENTER_SK
GROUP BY 
    SUBSTR(W_WAREHOUSE_NAME, 1, 20),
    SM_TYPE,
    CC_NAME
ORDER BY 
    SUBSTR(W_WAREHOUSE_NAME, 1, 20),
    SM_TYPE,
    CC_NAME
LIMIT 100;
