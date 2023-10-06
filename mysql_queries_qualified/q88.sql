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

SELECT *
FROM (
        SELECT
            COUNT(*) H8_30_TO_9
        FROM
            STORE_SALES,
            HOUSEHOLD_DEMOGRAPHICS,
            TIME_DIM,
            STORE
        WHERE
            SS_SOLD_TIME_SK = TIME_DIM.T_TIME_SK
            AND SS_HDEMO_SK = HOUSEHOLD_DEMOGRAPHICS.HD_DEMO_SK
            AND SS_STORE_SK = S_STORE_SK
            AND TIME_DIM.T_HOUR = 8
            AND TIME_DIM.T_MINUTE >= 30
            AND ( (
                    HOUSEHOLD_DEMOGRAPHICS.HD_DEP_COUNT = 2
                    AND HOUSEHOLD_DEMOGRAPHICS.HD_VEHICLE_COUNT <= 2 + 2
                )
                OR (
                    HOUSEHOLD_DEMOGRAPHICS.HD_DEP_COUNT = 4
                    AND HOUSEHOLD_DEMOGRAPHICS.HD_VEHICLE_COUNT <= 4 + 2
                )
                OR (
                    HOUSEHOLD_DEMOGRAPHICS.HD_DEP_COUNT = 3
                    AND HOUSEHOLD_DEMOGRAPHICS.HD_VEHICLE_COUNT <= 3 + 2
                )
            )
            AND STORE.S_STORE_NAME = 'ese'
    ) S1, (
        SELECT
            COUNT(*) H9_TO_9_30
        FROM
            STORE_SALES,
            HOUSEHOLD_DEMOGRAPHICS,
            TIME_DIM,
            STORE
        WHERE
            SS_SOLD_TIME_SK = TIME_DIM.T_TIME_SK
            AND SS_HDEMO_SK = HOUSEHOLD_DEMOGRAPHICS.HD_DEMO_SK
            AND SS_STORE_SK = S_STORE_SK
            AND TIME_DIM.T_HOUR = 9
            AND TIME_DIM.T_MINUTE < 30
            AND ( (
                    HOUSEHOLD_DEMOGRAPHICS.HD_DEP_COUNT = 2
                    AND HOUSEHOLD_DEMOGRAPHICS.HD_VEHICLE_COUNT <= 2 + 2
                )
                OR (
                    HOUSEHOLD_DEMOGRAPHICS.HD_DEP_COUNT = 4
                    AND HOUSEHOLD_DEMOGRAPHICS.HD_VEHICLE_COUNT <= 4 + 2
                )
                OR (
                    HOUSEHOLD_DEMOGRAPHICS.HD_DEP_COUNT = 3
                    AND HOUSEHOLD_DEMOGRAPHICS.HD_VEHICLE_COUNT <= 3 + 2
                )
            )
            AND STORE.S_STORE_NAME = 'ese'
    ) S2, (
        SELECT
            COUNT(*) H9_30_TO_10
        FROM
            STORE_SALES,
            HOUSEHOLD_DEMOGRAPHICS,
            TIME_DIM,
            STORE
        WHERE
            SS_SOLD_TIME_SK = TIME_DIM.T_TIME_SK
            AND SS_HDEMO_SK = HOUSEHOLD_DEMOGRAPHICS.HD_DEMO_SK
            AND SS_STORE_SK = S_STORE_SK
            AND TIME_DIM.T_HOUR = 9
            AND TIME_DIM.T_MINUTE >= 30
            AND ( (
                    HOUSEHOLD_DEMOGRAPHICS.HD_DEP_COUNT = 2
                    AND HOUSEHOLD_DEMOGRAPHICS.HD_VEHICLE_COUNT <= 2 + 2
                )
                OR (
                    HOUSEHOLD_DEMOGRAPHICS.HD_DEP_COUNT = 4
                    AND HOUSEHOLD_DEMOGRAPHICS.HD_VEHICLE_COUNT <= 4 + 2
                )
                OR (
                    HOUSEHOLD_DEMOGRAPHICS.HD_DEP_COUNT = 3
                    AND HOUSEHOLD_DEMOGRAPHICS.HD_VEHICLE_COUNT <= 3 + 2
                )
            )
            AND STORE.S_STORE_NAME = 'ese'
    ) S3, (
        SELECT
            COUNT(*) H10_TO_10_30
        FROM
            STORE_SALES,
            HOUSEHOLD_DEMOGRAPHICS,
            TIME_DIM,
            STORE
        WHERE
            SS_SOLD_TIME_SK = TIME_DIM.T_TIME_SK
            AND SS_HDEMO_SK = HOUSEHOLD_DEMOGRAPHICS.HD_DEMO_SK
            AND SS_STORE_SK = S_STORE_SK
            AND TIME_DIM.T_HOUR = 10
            AND TIME_DIM.T_MINUTE < 30
            AND ( (
                    HOUSEHOLD_DEMOGRAPHICS.HD_DEP_COUNT = 2
                    AND HOUSEHOLD_DEMOGRAPHICS.HD_VEHICLE_COUNT <= 2 + 2
                )
                OR (
                    HOUSEHOLD_DEMOGRAPHICS.HD_DEP_COUNT = 4
                    AND HOUSEHOLD_DEMOGRAPHICS.HD_VEHICLE_COUNT <= 4 + 2
                )
                OR (
                    HOUSEHOLD_DEMOGRAPHICS.HD_DEP_COUNT = 3
                    AND HOUSEHOLD_DEMOGRAPHICS.HD_VEHICLE_COUNT <= 3 + 2
                )
            )
            AND STORE.S_STORE_NAME = 'ese'
    ) S4, (
        SELECT
            COUNT(*) H10_30_TO_11
        FROM
            STORE_SALES,
            HOUSEHOLD_DEMOGRAPHICS,
            TIME_DIM,
            STORE
        WHERE
            SS_SOLD_TIME_SK = TIME_DIM.T_TIME_SK
            AND SS_HDEMO_SK = HOUSEHOLD_DEMOGRAPHICS.HD_DEMO_SK
            AND SS_STORE_SK = S_STORE_SK
            AND TIME_DIM.T_HOUR = 10
            AND TIME_DIM.T_MINUTE >= 30
            AND ( (
                    HOUSEHOLD_DEMOGRAPHICS.HD_DEP_COUNT = 2
                    AND HOUSEHOLD_DEMOGRAPHICS.HD_VEHICLE_COUNT <= 2 + 2
                )
                OR (
                    HOUSEHOLD_DEMOGRAPHICS.HD_DEP_COUNT = 4
                    AND HOUSEHOLD_DEMOGRAPHICS.HD_VEHICLE_COUNT <= 4 + 2
                )
                OR (
                    HOUSEHOLD_DEMOGRAPHICS.HD_DEP_COUNT = 3
                    AND HOUSEHOLD_DEMOGRAPHICS.HD_VEHICLE_COUNT <= 3 + 2
                )
            )
            AND STORE.S_STORE_NAME = 'ese'
    ) S5, (
        SELECT
            COUNT(*) H11_TO_11_30
        FROM
            STORE_SALES,
            HOUSEHOLD_DEMOGRAPHICS,
            TIME_DIM,
            STORE
        WHERE
            SS_SOLD_TIME_SK = TIME_DIM.T_TIME_SK
            AND SS_HDEMO_SK = HOUSEHOLD_DEMOGRAPHICS.HD_DEMO_SK
            AND SS_STORE_SK = S_STORE_SK
            AND TIME_DIM.T_HOUR = 11
            AND TIME_DIM.T_MINUTE < 30
            AND ( (
                    HOUSEHOLD_DEMOGRAPHICS.HD_DEP_COUNT = 2
                    AND HOUSEHOLD_DEMOGRAPHICS.HD_VEHICLE_COUNT <= 2 + 2
                )
                OR (
                    HOUSEHOLD_DEMOGRAPHICS.HD_DEP_COUNT = 4
                    AND HOUSEHOLD_DEMOGRAPHICS.HD_VEHICLE_COUNT <= 4 + 2
                )
                OR (
                    HOUSEHOLD_DEMOGRAPHICS.HD_DEP_COUNT = 3
                    AND HOUSEHOLD_DEMOGRAPHICS.HD_VEHICLE_COUNT <= 3 + 2
                )
            )
            AND STORE.S_STORE_NAME = 'ese'
    ) S6, (
        SELECT
            COUNT(*) H11_30_TO_12
        FROM
            STORE_SALES,
            HOUSEHOLD_DEMOGRAPHICS,
            TIME_DIM,
            STORE
        WHERE
            SS_SOLD_TIME_SK = TIME_DIM.T_TIME_SK
            AND SS_HDEMO_SK = HOUSEHOLD_DEMOGRAPHICS.HD_DEMO_SK
            AND SS_STORE_SK = S_STORE_SK
            AND TIME_DIM.T_HOUR = 11
            AND TIME_DIM.T_MINUTE >= 30
            AND ( (
                    HOUSEHOLD_DEMOGRAPHICS.HD_DEP_COUNT = 2
                    AND HOUSEHOLD_DEMOGRAPHICS.HD_VEHICLE_COUNT <= 2 + 2
                )
                OR (
                    HOUSEHOLD_DEMOGRAPHICS.HD_DEP_COUNT = 4
                    AND HOUSEHOLD_DEMOGRAPHICS.HD_VEHICLE_COUNT <= 4 + 2
                )
                OR (
                    HOUSEHOLD_DEMOGRAPHICS.HD_DEP_COUNT = 3
                    AND HOUSEHOLD_DEMOGRAPHICS.HD_VEHICLE_COUNT <= 3 + 2
                )
            )
            AND STORE.S_STORE_NAME = 'ese'
    ) S7, (
        SELECT
            COUNT(*) H12_TO_12_30
        FROM
            STORE_SALES,
            HOUSEHOLD_DEMOGRAPHICS,
            TIME_DIM,
            STORE
        WHERE
            SS_SOLD_TIME_SK = TIME_DIM.T_TIME_SK
            AND SS_HDEMO_SK = HOUSEHOLD_DEMOGRAPHICS.HD_DEMO_SK
            AND SS_STORE_SK = S_STORE_SK
            AND TIME_DIM.T_HOUR = 12
            AND TIME_DIM.T_MINUTE < 30
            AND ( (
                    HOUSEHOLD_DEMOGRAPHICS.HD_DEP_COUNT = 2
                    AND HOUSEHOLD_DEMOGRAPHICS.HD_VEHICLE_COUNT <= 2 + 2
                )
                OR (
                    HOUSEHOLD_DEMOGRAPHICS.HD_DEP_COUNT = 4
                    AND HOUSEHOLD_DEMOGRAPHICS.HD_VEHICLE_COUNT <= 4 + 2
                )
                OR (
                    HOUSEHOLD_DEMOGRAPHICS.HD_DEP_COUNT = 3
                    AND HOUSEHOLD_DEMOGRAPHICS.HD_VEHICLE_COUNT <= 3 + 2
                )
            )
            AND STORE.S_STORE_NAME = 'ese'
    ) S8;