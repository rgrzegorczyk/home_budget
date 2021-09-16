--liquibase formatted sql
--changeset RGRZEGORCZYK:EXPENSES_MONTH_REPORT_V runOnChange:true stripComments:false
--rollback DROP VIEW EXPENSES_MONTH_REPORT_V
CREATE OR REPLACE VIEW EXPENSES_MONTH_REPORT_V
AS
  SELECT x.*
    FROM (
                    WITH rws AS
                         (
                                  SELECT *
                                    FROM (
                                                  SELECT TO_NUMBER (TO_CHAR (e.expense_date, 'DD')) DAY,
                                                         e.expense_value,
                                                         e.group_name,
                                                         e.type_name,
                                                         e.month_code,
                                                         e.group_id,
                                                         --NVL(e.type_name, 'SUMA') type_name,
                                                         (SUM (expense_value) over (PARTITION BY group_name, type_name, month_code)) SUMA
                                                    FROM EXPENSES_MONTH_DETAILS_V e
                                                   WHERE 1 = 1
                                                GROUP BY
                                                         (e.group_name,
                                                         e.type_name,
                                                         expense_value,
                                                         month_code,
                                                         e.group_id,
                                                         TO_NUMBER (TO_CHAR (e.expense_date, 'DD')))
                                         )
                         )
                  SELECT p.*
                    FROM rws pivot (SUM (expense_value) FOR DAY IN (1,
                                                                    2,
                                                                    3,
                                                                    4,
                                                                    5,
                                                                    6,
                                                                    7,
                                                                    8,
                                                                    9,
                                                                    10,
                                                                    11,
                                                                    12,
                                                                    13,
                                                                    14,
                                                                    15,
                                                                    16,
                                                                    17,
                                                                    18,
                                                                    19,
                                                                    20,
                                                                    21,
                                                                    22,
                                                                    23,
                                                                    24,
                                                                    25,
                                                                    26,
                                                                    27,
                                                                    28,
                                                                    29,
                                                                    30,
                                                                    31)) p
         ) x;