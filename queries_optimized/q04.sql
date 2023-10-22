WITH STORE_YEAR_TOTAL AS (
    SELECT
        C_CUSTOMER_ID CUSTOMER_ID,
        C_FIRST_NAME CUSTOMER_FIRST_NAME,
        C_LAST_NAME CUSTOMER_LAST_NAME,
        C_PREFERRED_CUST_FLAG CUSTOMER_PREFERRED_CUST_FLAG,
        C_BIRTH_COUNTRY CUSTOMER_BIRTH_COUNTRY,
        C_LOGIN CUSTOMER_LOGIN,
        C_EMAIL_ADDRESS CUSTOMER_EMAIL_ADDRESS,
        D_YEAR DYEAR,
        SUM((SS_EXT_LIST_PRICE - SS_EXT_WHOLESALE_COST - SS_EXT_DISCOUNT_AMT + SS_EXT_SALES_PRICE) / 2) YEAR_TOTAL
    FROM CUSTOMER
    JOIN STORE_SALES ON C_CUSTOMER_SK = SS_CUSTOMER_SK
    JOIN DATE_DIM ON SS_SOLD_DATE_SK = D_DATE_SK AND D_YEAR IN (1999, 2000)
    GROUP BY C_CUSTOMER_ID, C_FIRST_NAME, C_LAST_NAME, C_PREFERRED_CUST_FLAG, C_BIRTH_COUNTRY, C_LOGIN, C_EMAIL_ADDRESS, D_YEAR
),

CATALOG_YEAR_TOTAL AS (
    SELECT
        C_CUSTOMER_ID CUSTOMER_ID,
        C_FIRST_NAME CUSTOMER_FIRST_NAME,
        C_LAST_NAME CUSTOMER_LAST_NAME,
        C_PREFERRED_CUST_FLAG CUSTOMER_PREFERRED_CUST_FLAG,
        C_BIRTH_COUNTRY CUSTOMER_BIRTH_COUNTRY,
        C_LOGIN CUSTOMER_LOGIN,
        C_EMAIL_ADDRESS CUSTOMER_EMAIL_ADDRESS,
        D_YEAR DYEAR,
        SUM((CS_EXT_LIST_PRICE - CS_EXT_WHOLESALE_COST - CS_EXT_DISCOUNT_AMT + CS_EXT_SALES_PRICE) / 2) YEAR_TOTAL
    FROM CUSTOMER
    JOIN CATALOG_SALES ON C_CUSTOMER_SK = CS_BILL_CUSTOMER_SK
    JOIN DATE_DIM ON CS_SOLD_DATE_SK = D_DATE_SK AND D_YEAR IN (1999, 2000)
    GROUP BY C_CUSTOMER_ID, C_FIRST_NAME, C_LAST_NAME, C_PREFERRED_CUST_FLAG, C_BIRTH_COUNTRY, C_LOGIN, C_EMAIL_ADDRESS, D_YEAR
),

WEB_YEAR_TOTAL AS (
    SELECT
        C_CUSTOMER_ID CUSTOMER_ID,
        C_FIRST_NAME CUSTOMER_FIRST_NAME,
        C_LAST_NAME CUSTOMER_LAST_NAME,
        C_PREFERRED_CUST_FLAG CUSTOMER_PREFERRED_CUST_FLAG,
        C_BIRTH_COUNTRY CUSTOMER_BIRTH_COUNTRY,
        C_LOGIN CUSTOMER_LOGIN,
        C_EMAIL_ADDRESS CUSTOMER_EMAIL_ADDRESS,
        D_YEAR DYEAR,
        SUM((WS_EXT_LIST_PRICE - WS_EXT_WHOLESALE_COST - WS_EXT_DISCOUNT_AMT + WS_EXT_SALES_PRICE) / 2) YEAR_TOTAL
    FROM CUSTOMER
    JOIN WEB_SALES ON C_CUSTOMER_SK = WS_BILL_CUSTOMER_SK
    JOIN DATE_DIM ON WS_SOLD_DATE_SK = D_DATE_SK AND D_YEAR IN (1999, 2000)
    GROUP BY C_CUSTOMER_ID, C_FIRST_NAME, C_LAST_NAME, C_PREFERRED_CUST_FLAG, C_BIRTH_COUNTRY, C_LOGIN, C_EMAIL_ADDRESS, D_YEAR
)

SELECT
    S.CUSTOMER_ID,
    S.CUSTOMER_FIRST_NAME,
    S.CUSTOMER_LAST_NAME,
    S.CUSTOMER_BIRTH_COUNTRY
FROM STORE_YEAR_TOTAL S
JOIN CATALOG_YEAR_TOTAL C ON S.CUSTOMER_ID = C.CUSTOMER_ID
JOIN WEB_YEAR_TOTAL W ON S.CUSTOMER_ID = W.CUSTOMER_ID
WHERE
    S.DYEAR = 1999 AND C.DYEAR = 1999 AND W.DYEAR = 1999
    AND S.YEAR_TOTAL > 0 AND C.YEAR_TOTAL > 0 AND W.YEAR_TOTAL > 0
    AND CASE WHEN C.YEAR_TOTAL > 0 THEN C.YEAR_TOTAL ELSE NULL END > CASE WHEN S.YEAR_TOTAL > 0 THEN S.YEAR_TOTAL ELSE NULL END
    AND CASE WHEN C.YEAR_TOTAL > 0 THEN C.YEAR_TOTAL ELSE NULL END > CASE WHEN W.YEAR_TOTAL > 0 THEN W.YEAR_TOTAL ELSE NULL END
ORDER BY
    S.CUSTOMER_ID,
    S.CUSTOMER_FIRST_NAME,
    S.CUSTOMER_LAST_NAME,
    S.CUSTOMER_BIRTH_COUNTRY
LIMIT 100;
