-- Copyright (c) 2022, Oracle and/or its affiliates.

-- Licensed under the Apache License, Version 2.0 (the "License");

--  you may not use this file except in compliance with the License.

--  You may obtain a copy of the License at

--

--     https://www.apache.org/licenses/LICENSE-2.0

--

--  Unless required by applicable law or agreed to in writing, software

--  distributed under the License is distributed on an "AS IS" BASIS,

--  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.

--  See the License for the specific language governing permissions and

--  limitations under the License.

-- Copyright (c) 2022, Transaction Processing Performance Council

WITH FREQUENT_SS_ITEMS AS (
        SELECT
            SUBSTR(I_ITEM_DESC, 1, 30) ITEMDESC,
            I_ITEM_SK ITEM_SK,
            D_DATE SOLDDATE,
            COUNT(*) CNT
        FROM STORE_SALES
            STRAIGHT_JOIN DATE_DIM
            STRAIGHT_JOIN ITEM
        WHERE
            SS_SOLD_DATE_SK = D_DATE_SK
            AND SS_ITEM_SK = I_ITEM_SK
            AND D_YEAR IN (2000, 2000 + 1, 2000 + 2, 2000 + 3)
        GROUP BY
            SUBSTR(I_ITEM_DESC, 1, 30),
            I_ITEM_SK,
            D_DATE
        HAVING
            COUNT(*) > 4
    ),
    MAX_STORE_SALES AS (
        SELECT
            MAX(temp1.CSALES) TPCDS_CMAX
        FROM (
                SELECT
                    C_CUSTOMER_SK,
                    SUM(SS_QUANTITY * SS_SALES_PRICE) CSALES
                FROM
                    STORE_SALES
                    STRAIGHT_JOIN DATE_DIM
                    STRAIGHT_JOIN CUSTOMER
                WHERE
                    SS_CUSTOMER_SK = C_CUSTOMER_SK
                    AND SS_SOLD_DATE_SK = D_DATE_SK
                    AND D_YEAR IN (2000, 2000 + 1, 2000 + 2, 2000 + 3)
                GROUP BY
                    C_CUSTOMER_SK
            ) as temp1
    ),
    BEST_SS_CUSTOMER AS (
        SELECT
            C_CUSTOMER_SK,
            SUM(SS_QUANTITY * SS_SALES_PRICE) SSALES
        FROM
            STORE_SALES,
            CUSTOMER
        WHERE
            SS_CUSTOMER_SK = C_CUSTOMER_SK
        GROUP BY
            C_CUSTOMER_SK
        HAVING
            SUM(SS_QUANTITY * SS_SALES_PRICE) > (95 / 100.0) * (
                SELECT *
                FROM
                    MAX_STORE_SALES
            )
    )
SELECT
    /*+SET_VAR(use_secondary_engine=forced)*/
    SUM(main.SALES)
FROM (
        SELECT
            CS_QUANTITY * CS_LIST_PRICE SALES
        FROM
            CATALOG_SALES,
            DATE_DIM
        WHERE
            D_YEAR = 2000
            AND D_MOY = 3
            AND CS_SOLD_DATE_SK = D_DATE_SK
            AND CS_ITEM_SK IN (
                SELECT
                    ITEM_SK
                FROM
                    FREQUENT_SS_ITEMS
            )
            AND CS_BILL_CUSTOMER_SK IN (
                SELECT
                    C_CUSTOMER_SK
                FROM
                    BEST_SS_CUSTOMER
            )
        UNION ALL
        SELECT
            WS_QUANTITY * WS_LIST_PRICE SALES
        FROM
            WEB_SALES,
            DATE_DIM
        WHERE
            D_YEAR = 2000
            AND D_MOY = 3
            AND WS_SOLD_DATE_SK = D_DATE_SK
            AND WS_ITEM_SK IN (
                SELECT
                    ITEM_SK
                FROM
                    FREQUENT_SS_ITEMS
            )
            AND WS_BILL_CUSTOMER_SK IN (
                SELECT
                    C_CUSTOMER_SK
                FROM
                    BEST_SS_CUSTOMER
            )
    ) as main
LIMIT 100;

WITH FREQUENT_SS_ITEMS AS (
        SELECT
            SUBSTR(I_ITEM_DESC, 1, 30) ITEMDESC,
            I_ITEM_SK ITEM_SK,
            D_DATE SOLDDATE,
            COUNT(*) CNT
        FROM DATE_DIM
            STRAIGHT_JOIN ITEM
            STRAIGHT_JOIN STORE_SALES
        WHERE
            SS_SOLD_DATE_SK = D_DATE_SK
            AND SS_ITEM_SK = I_ITEM_SK
            AND D_YEAR IN (2000, 2000 + 1, 2000 + 2, 2000 + 3)
        GROUP BY
            SUBSTR(I_ITEM_DESC, 1, 30),
            I_ITEM_SK,
            D_DATE
        HAVING
            COUNT(*) > 4
    ),
    MAX_STORE_SALES AS (
        SELECT
            MAX(temp1.CSALES) TPCDS_CMAX
        FROM (
                SELECT
                    C_CUSTOMER_SK,
                    SUM(SS_QUANTITY * SS_SALES_PRICE) CSALES
                FROM DATE_DIM
                    STRAIGHT_JOIN STORE_SALES
                    STRAIGHT_JOIN CUSTOMER
                WHERE
                    SS_CUSTOMER_SK = C_CUSTOMER_SK
                    AND SS_SOLD_DATE_SK = D_DATE_SK
                    AND D_YEAR IN (2000, 2000 + 1, 2000 + 2, 2000 + 3)
                GROUP BY
                    C_CUSTOMER_SK
            ) as temp1
    ),
    BEST_SS_CUSTOMER AS (
        SELECT
            C_CUSTOMER_SK,
            SUM(SS_QUANTITY * SS_SALES_PRICE) SSALES
        FROM
            STORE_SALES,
            CUSTOMER
        WHERE
            SS_CUSTOMER_SK = C_CUSTOMER_SK
        GROUP BY
            C_CUSTOMER_SK
        HAVING
            SUM(SS_QUANTITY * SS_SALES_PRICE) > (95 / 100.0) * (
                SELECT *
                FROM
                    MAX_STORE_SALES
            )
    )
SELECT
    /*+SET_VAR(use_secondary_engine=forced)*/
    C_LAST_NAME,
    C_FIRST_NAME,
    main.SALES
FROM (
        SELECT
            C_LAST_NAME,
            C_FIRST_NAME,
            SUM(CS_QUANTITY * CS_LIST_PRICE) SALES
        FROM DATE_DIM
            STRAIGHT_JOIN CATALOG_SALES
            STRAIGHT_JOIN CUSTOMER
        WHERE
            D_YEAR = 2000
            AND D_MOY = 3
            AND CS_SOLD_DATE_SK = D_DATE_SK
            AND CS_ITEM_SK IN (
                SELECT
                    ITEM_SK
                FROM
                    FREQUENT_SS_ITEMS
            )
            AND CS_BILL_CUSTOMER_SK IN (
                SELECT
                    C_CUSTOMER_SK
                FROM
                    BEST_SS_CUSTOMER
            )
            AND CS_BILL_CUSTOMER_SK = C_CUSTOMER_SK
        GROUP BY
            C_LAST_NAME,
            C_FIRST_NAME
        UNION ALL
        SELECT
            C_LAST_NAME,
            C_FIRST_NAME,
            SUM(WS_QUANTITY * WS_LIST_PRICE) SALES
        FROM DATE_DIM
            STRAIGHT_JOIN WEB_SALES
            STRAIGHT_JOIN CUSTOMER
        WHERE
            D_YEAR = 2000
            AND D_MOY = 3
            AND WS_SOLD_DATE_SK = D_DATE_SK
            AND WS_ITEM_SK IN (
                SELECT
                    ITEM_SK
                FROM
                    FREQUENT_SS_ITEMS
            )
            AND WS_BILL_CUSTOMER_SK IN (
                SELECT
                    C_CUSTOMER_SK
                FROM
                    BEST_SS_CUSTOMER
            )
            AND WS_BILL_CUSTOMER_SK = C_CUSTOMER_SK
        GROUP BY
            C_LAST_NAME,
            C_FIRST_NAME
    ) as main
ORDER BY
    C_LAST_NAME,
    C_FIRST_NAME,
    SALES
LIMIT 100;