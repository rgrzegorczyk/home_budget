--liquibase formatted sql
--changeset rgrzegorczyk:EXPENSES_FK1
--rollback  ALTER TABLE EXPENSES DROP CONSTRAINT EXPENSES_FK1;
ALTER TABLE EXPENSES ADD CONSTRAINT EXPENSES_FK1 FOREIGN KEY (EXPENSE_TYPES_ID)
	  REFERENCES EXPENSE_TYPES (ID) ENABLE;