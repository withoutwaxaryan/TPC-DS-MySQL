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

SELECT I_ITEM_ID
       , I_ITEM_DESC
       , I_CURRENT_PRICE 
FROM INVENTORY 
     JOIN DATE_DIM 
     JOIN ITEM 
     JOIN CATALOG_SALES 
WHERE I_CURRENT_PRICE BETWEEN 39 AND 39 + 30 
      AND INV_ITEM_SK = I_ITEM_SK 
      AND D_DATE_SK = INV_DATE_SK 
      AND D_DATE BETWEEN CAST('2001-01-16' AS DATE) AND  DATE_ADD('2001-01-16', INTERVAL 60 DAY ) 
      AND I_MANUFACT_ID IN ( 765, 886, 889, 728 ) 
      AND INV_QUANTITY_ON_HAND BETWEEN 100 AND 500 
      AND CS_ITEM_SK = I_ITEM_SK 
GROUP BY I_ITEM_ID
         , I_ITEM_DESC
         , I_CURRENT_PRICE 
ORDER BY I_ITEM_ID 
LIMIT 100;