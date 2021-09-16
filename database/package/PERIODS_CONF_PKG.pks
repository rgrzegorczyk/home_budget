create or replace package PERIODS_CONF_PKG
as

  procedure p_PERIODS_CONF(
    pi_command IN CONST_PKG.t_code,
    pi_app_page IN NUMBER default v('APP_PAGE_ID')
  );

  
  function f_PERIODS_CONF(
    pi_command IN CONST_PKG.t_code,
    pi_row in PERIODS_CONF%ROWTYPE
  ) return CALL_RESULT;
  

  procedure p_get_PERIODS_CONF(
    pi_app_page IN NUMBER default v('APP_PAGE_ID')
  );
  

  function f_get_PERIODS_CONF(
    pi_CODE IN PERIODS_CONF.CODE%TYPE
  ) return PERIODS_CONF%ROWTYPE;

end PERIODS_CONF_PKG;

/


