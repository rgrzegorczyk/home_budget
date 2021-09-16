--liquibase formatted sql
--changeset RGRZEGORCZYK:EXPENSES_YEAR_V runOnChange:true stripComments:false
--rollback DROP VIEW EXPENSES_YEAR_V;
CREATE OR REPLACE VIEW EXPENSES_YEAR_V
AS
SELECT 
       et.name type_name,
       et.id type_id,
       eg.name group_name,
       eg.id group_id,
       pc_month.code month_code,
       pc_year.code year_code,
       SUM(e.value) sum
  FROM expenses e
  JOIN expense_types et ON et.id=e.expense_types_id
  JOIN expense_groups eg ON et.expense_group_id=eg.id
  JOIN periods_conf pc_month ON (e.expense_date between pc_month.date_from and pc_month.date_to AND pc_month.type='MONTH')
  JOIN periods_conf pc_year ON (e.expense_date between pc_year.date_from and pc_year.date_to AND pc_year.type='YEAR')
  GROUP BY        et.name,
       et.id ,
       eg.name ,
       eg.id ,
       pc_month.code ,
       pc_year.code;
