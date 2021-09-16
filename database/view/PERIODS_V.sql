--liquibase formatted sql
--changeset RGRZEGORCZYK:PERIODS_V runOnChange:true stripComments:false
--rollback DROP VIEW PERIODS_V
  CREATE OR REPLACE FORCE EDITIONABLE VIEW PERIODS_V
  as
  SELECT   MTH.CODE       AS MONTH_PERIOD
         , MTH.DATE_FROM  AS MONTH_PERIOD_FROM
         , MTH.DATE_TO    AS MONTH_PERIOD_TO
         , QT.CODE        AS QUARTER_PERIOD
         , QT.DATE_FROM   AS QUARTER_PERIOD_FROM
         , QT.DATE_TO     AS QUARTER_PERIOD_TO
         , Y.CODE         AS YEAR_PERIOD
         , Y.DATE_FROM    AS YEAR_PERIOD_FROM
         , Y.DATE_TO      AS YEAR_PERIOD_TO 
         , D.CODE         AS DAY_PERIOD
         , D.DATE_FROM    AS DAY_PERIOD_FROM
         , D.DATE_TO      AS DAY_PERIOD_TO                     

      FROM PERIODS_CONF MTH
 LEFT JOIN PERIODS_CONF QT
        ON QT.DATE_FROM <= MTH.DATE_FROM
       AND QT.DATE_TO   >= MTH.DATE_TO
       AND QT.TYPE       = 'QUARTER'
LEFT JOIN PERIODS_CONF Y
       ON mth.date_from >= y.date_from
      AND mth.date_to   <= y.date_to  
      AND y.type='YEAR'     
LEFT JOIN PERIODS_CONF D
       ON d.date_from   >= mth.date_from
      AND d.date_to     <= mth.date_to  
      AND d.type='DAY'          
;
