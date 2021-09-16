--liquibase formatted sql
--changeset RGRZEGORCZYK:EXPENSES_ID_H_AIUD_TRG runOnChange:true stripComments:false splitStatements:false
--rollback DROP TRIGGER EXPENSES_ID_H_AIUD_TRG;
create or replace trigger EXPENSES_ID_H_AIUD_TRG
after insert or update or delete on EXPENSES
for each row
begin
IF INSERTING THEN
  insert into EXPENSES_h(hist_op_type, hist_op_ts, hist_user, ID, EXPENSE_TYPES_ID, EXPENSE_DATE, VALUE, COMMENTS, CREATED, CREATED_BY, UPDATED, UPDATED_BY,  IS_RETURNED, RETURN_WIRE_RECEIVED, RETURN_VALUE)
  values ('I', systimestamp, NVL(SYS_CONTEXT('APEX$SESSION','APP_USER'), user), :new.ID, :new.EXPENSE_TYPES_ID, :new.EXPENSE_DATE, :new.VALUE, :new.COMMENTS, :new.CREATED, :new.CREATED_BY, :new.UPDATED, :new.UPDATED_BY, :new.IS_RETURNED, :new.RETURN_WIRE_RECEIVED, :new.RETURN_VALUE);
ELSIF UPDATING THEN
  insert into EXPENSES_h(hist_op_type, hist_op_ts, ID, EXPENSE_TYPES_ID, EXPENSE_DATE, VALUE, COMMENTS, CREATED, CREATED_BY, UPDATED, UPDATED_BY, hist_user, IS_RETURNED, RETURN_WIRE_RECEIVED, RETURN_VALUE)
  values ('U', systimestamp, :new.ID, :new.EXPENSE_TYPES_ID, :new.EXPENSE_DATE, :new.VALUE, :new.COMMENTS, :new.CREATED, :new.CREATED_BY, :new.UPDATED, :new.UPDATED_BY, NVL(SYS_CONTEXT('APEX$SESSION','APP_USER'), user),  :new.IS_RETURNED, :new.RETURN_WIRE_RECEIVED, :new.RETURN_VALUE);
ELSIF DELETING THEN
  insert into EXPENSES_h(hist_user, hist_op_type, hist_op_ts, ID)
  values (NVL(SYS_CONTEXT('APEX$SESSION','APP_USER'), user), 'D', systimestamp, :old.ID);
end if;
end;
/