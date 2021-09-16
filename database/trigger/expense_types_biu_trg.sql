--liquibase formatted sql
--changeset RGRZEGORCZYK:expense_types_biu_trg runOnChange:true stripComments:false splitStatements:false
--rollback DROP TRIGGER expense_types_biu_trg;
create or replace trigger expense_types_biu_trg
    before insert or update 
    on expense_types
    for each row
begin
    if inserting then
        :new.created := sysdate;
        :new.created_by := nvl(sys_context('APEX$SESSION','APP_USER'),user);
    end if;
    :new.updated := sysdate;
    :new.updated_by := nvl(sys_context('APEX$SESSION','APP_USER'),user);
end expense_types_biu;
/