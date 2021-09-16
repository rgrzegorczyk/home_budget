--liquibase formatted sql
--changeset RGRZEGORCZYK:EXPENSES_MONTH_DETAILS_V_new_cols runOnChange:true stripComments:false
--rollback DROP VIEW EXPENSES_MONTH_DETAILS_V;
CREATE OR REPLACE VIEW EXPENSES_MONTH_DETAILS_V
AS
SELECT e.id,
       e.value expense_value,
       e.comments expense_comment,
       e.expense_date,
       et.name type_name,
       et.id type_id,
       eg.name group_name,
       eg.id group_id,
       pc_month.code month_code,
       pc_year.code year_code,
       e.IS_RETURNED,
       e.RETURN_WIRE_RECEIVED,
       e.RETURN_value,       
       e.comments,
       e.SHOP_NAME,
       e.order_number,
       e.return_details,
       SUM(NVL(e.value,0)) over (partition by et.id,pc_month.code ) sum_month,
       SUM(NVL(e.value,0)) over (partition by et.id,pc_year.code ) sum_year,
       SUM(NVL(e.value,0)) over (partition by eg.id,expense_date ) sum_day
  FROM expenses e
  JOIN expense_types et ON et.id=e.expense_types_id
  JOIN expense_groups eg ON et.expense_group_id=eg.id
  JOIN periods_conf pc_month ON (e.expense_date between pc_month.date_from and pc_month.date_to AND pc_month.type='MONTH')
  JOIN periods_conf pc_year ON (e.expense_date between pc_year.date_from and pc_year.date_to AND pc_year.type='YEAR');