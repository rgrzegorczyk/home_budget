--liquibase formatted sql
--changeset RGRZEGORCZYK:expenses_biu_trg runOnChange:true stripComments:false
--rollback DROP TRIGGER expenses_biu_trg;
create or replace trigger expenses_biu_trg
   before insert or update on expenses
   for each row
begin
   if inserting then
      :new.created        := sysdate;
      :new.created_by     := nvl(sys_context('APEX$SESSION', 'APP_USER'), user);
   end if;
   :new.updated        := sysdate;
   :new.updated_by     := nvl(sys_context('APEX$SESSION', 'APP_USER'), user);
end expenses_biu;
/