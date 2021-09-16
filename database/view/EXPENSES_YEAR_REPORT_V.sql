--liquibase formatted sql
--changeset RGRZEGORCZYK:EXPENSES_YEAR_REPORT_V runOnChange:true stripComments:false
--rollback DROP VIEW EXPENSES_YEAR_REPORT_V;
CREATE OR REPLACE VIEW EXPENSES_YEAR_REPORT_V
AS
  SELECT x.*
    FROM (
                    WITH rws AS
                         (
                                  SELECT *
                                    FROM (
                                                  SELECT TO_NUMBER(TO_CHAR (TO_DATE(e.expense_date), 'MM')) MONTH,
                                                         e.expense_value,
                                                         e.group_name,
                                                         e.type_name,
                                                         e.year_code,
                                                         e.group_id,
                                                         (SUM (expense_value) over (PARTITION BY group_name, type_name, year_code)) SUMA
                                                    FROM EXPENSES_MONTH_DETAILS_V e
                                                   WHERE 1 = 1
                                                GROUP BY
                                                         e.group_name,
                                                         e.type_name,
                                                         expense_value,
                                                         year_code,
                                                         e.group_id,
                                                         TO_NUMBER(TO_CHAR (TO_DATE(e.expense_date), 'MM'))
                                         )
                         )
                  SELECT p.*
                    FROM rws pivot (SUM (expense_value) FOR MONTH IN (01 as STYCZEŃ,
                                                                      02 as LUTY,
                                                                      03 as MARZEC,
                                                                      04 as KWIECEŃ,
                                                                      05 as MAJ,
                                                                      06 as CZERWIEC,
                                                                      07 as LIPIEC,
                                                                      08 as SIERPIEŃ,
                                                                      09 as WRZESIEŃ,
                                                                      10 as PAŹDZIERNIK,
                                                                      11 as LISTOPAD,
                                                                      12 as GRUDZIEŃ
                    )) p
         ) x;