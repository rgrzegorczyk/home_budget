--liquibase formatted sql
--changeset RGRZEGORCZYK:PERIODS_CONF_TRG runOnChange:true stripComments:false splitStatements:false
--rollback DROP TRIGGER PERIODS_CONF_TRG;
CREATE OR REPLACE EDITIONABLE TRIGGER PERIODS_CONF_TRG 
BEFORE INSERT OR UPDATE ON PERIODS_CONF 
REFERENCING NEW AS NEW OLD AS OLD
FOR EACH ROW
BEGIN
  :new.code := upper(:new.code);
END;
/