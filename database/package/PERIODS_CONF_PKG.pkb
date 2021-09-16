create or replace PACKAGE BODY PERIODS_CONF_PKG AS


--==== Logger scope ====--
  gc_scope_prefix constant VARCHAR2(1000) := lower($$PLSQL_UNIT) || '.';


  procedure p_set_apex_items(
    pi_app_page IN NUMBER,
    pi_row   IN PERIODS_CONF%ROWTYPE
  )
  as
    v_scope logger_logs.scope%type := gc_scope_prefix || 'p_set_apex_items';
    v_params logger.tab_param;
  
  begin
    logger.append_param(v_params, 'pi_app_page', pi_app_page);
    logger.log('START', v_scope, null, v_params);
  
    APEX_UTIL.set_session_state(p_name => 'P'||pi_app_page||'_'||'CODE', p_value => pi_row.CODE);
    APEX_UTIL.set_session_state(p_name => 'P'||pi_app_page||'_'||'NAME', p_value => pi_row.NAME);
    APEX_UTIL.set_session_state(p_name => 'P'||pi_app_page||'_'||'TYPE', p_value => pi_row.TYPE);
    APEX_UTIL.set_session_state(p_name => 'P'||pi_app_page||'_'||'DATE_FROM', p_value => pi_row.DATE_FROM);
    APEX_UTIL.set_session_state(p_name => 'P'||pi_app_page||'_'||'DATE_TO', p_value => pi_row.DATE_TO);
    
    logger.log('END', v_scope);
  exception
    when others then
      logger.log_error('Unknown error:'||SQLERRM, v_scope, null, v_params);
      raise;
  end p_set_apex_items;

  procedure p_get_apex_items (
    pi_app_page IN NUMBER,
    pio_row  IN OUT PERIODS_CONF%ROWTYPE
  )
  IS
    v_scope logger_logs.scope%type := gc_scope_prefix || 'p_get_apex_items';
    v_params logger.tab_param;
  begin
    logger.append_param(v_params, 'APP_PAGE', pi_app_page);
    logger.log('START', v_scope, null, v_params);
    
    pio_row.CODE   := v('P'||pi_app_page||'_'||'CODE');
    pio_row.NAME   := v('P'||pi_app_page||'_'||'NAME');
    pio_row.TYPE   := v('P'||pi_app_page||'_'||'TYPE');
    pio_row.DATE_FROM   := v('P'||pi_app_page||'_'||'DATE_FROM');
    pio_row.DATE_TO   := v('P'||pi_app_page||'_'||'DATE_TO');

    
    logger.log('END', v_scope);
  EXCEPTION
  WHEN OTHERS THEN
    logger.log_error();
    raise;
  END;

  function f_check_parameters (
    pi_function_name IN CONST_PKG.t_code,
    pi_command       IN CONST_PKG.t_code
  ) return boolean
  IS
    v_scope logger_logs.scope%type := gc_scope_prefix || 'f_check_parameters';
  BEGIN
    IF pi_command is null THEN
      logger.log('Wywolanie ''||pi_function_name||'' - Komenda nie moze byc NULLem!', v_scope);
      return false;
    END IF;
    
    IF upper(pi_command) not in (CONST_PKG.C_COMMAND_INSERT, CONST_PKG.C_COMMAND_UPDATE, CONST_PKG.C_COMMAND_COPY, CONST_PKG.C_COMMAND_DELETE) THEN
      logger.log('Wykryto nieprawidlowa komende ''||pi_command||'' przy wywolaniu funkcji '||pi_function_name, v_scope);
      return false;
    END IF;
    
    logger.log('Parametry wywolania funkcji '||pi_function_name||' prawidlowe.', v_scope);
    return true;
  EXCEPTION
  WHEN OTHERS THEN
    logger.log_error();
    raise;
    return false;
  END;


  function f_prepareString(
    pi_string IN varchar2
  ) return varchar2
  IS
    v_scope logger_logs.scope%type := gc_scope_prefix || 'f_prepareString';
  BEGIN
    logger.log('Przygotowuje stringa '||pi_string, v_scope);
    return trim(upper(pi_string));
  EXCEPTION 
  WHEN OTHERS THEN
    logger.log_error();
    raise;
  END;
  
  function f_prepareNumber(
    pi_number IN number
  ) return number
  IS
    v_scope logger_logs.scope%type := gc_scope_prefix || 'f_prepareNumber';
  BEGIN
    logger.log('Przygotowuje liczbe: '||pi_number, v_scope);
    return pi_number;
  EXCEPTION 
  WHEN OTHERS THEN
    logger.log_error();
    raise;
  END;
  
  function f_prepareDate(
    pi_date IN varchar2
  ) return varchar2
  IS
    v_scope logger_logs.scope%type := gc_scope_prefix || 'f_prepareDate';
  BEGIN
    logger.log('Przygotowuje date: '||pi_date, v_scope);
    return trunc(to_date(pi_date));
  EXCEPTION 
  WHEN OTHERS THEN
    logger.log_error();
    raise;
  END;
  

  procedure p_PERIODS_CONF_prepare(
    pio_row IN OUT PERIODS_CONF%ROWTYPE
  )
  IS
    v_scope logger_logs.scope%type := gc_scope_prefix || 'p_PERIODS_CONF_prepare' ;
    v_params logger.tab_param;
  BEGIN
    logger.log('START', v_scope, null, v_params);
    
    
    logger.log('STOP', v_scope);
  EXCEPTION 
  WHEN OTHERS THEN
    logger.log_error();
    raise;
  END p_PERIODS_CONF_prepare;
  
  
  function f_PERIODS_CONF_exists(
    pi_row IN PERIODS_CONF%ROWTYPE
  ) return BOOLEAN
  IS
    v_scope logger_logs.scope%type := gc_scope_prefix || 'f_PERIODS_CONF_exists' ;
    v_params logger.tab_param;
    
    v_count NUMBER := 0;
  BEGIN

    logger.append_param(v_params, 'PERIODS_CONF_CODE', pi_row.CODE);
    logger.log('START', v_scope, null, v_params);
    
    SELECT 
      count(1)
    INTO
      v_count
    FROM 
      PERIODS_CONF 
    WHERE 1 = 1
      and CODE = pi_row.CODE
      ;

    logger.log('STOP. Istnieje takich wpisów: '||v_count, v_scope);
    
    IF v_count is not null AND v_count > 0 THEN
      return false;
    END IF;
    
    return true;
  EXCEPTION 
  WHEN OTHERS THEN
    logger.log_error();
    raise;
  END f_PERIODS_CONF_exists;


  function f_PERIODS_CONF_insert(
    pi_row IN PERIODS_CONF%ROWTYPE
  ) return CALL_RESULT
  IS
    v_row PERIODS_CONF%ROWTYPE := pi_row;
    v_return_id NUMBER;
    
    v_scope logger_logs.scope%type := gc_scope_prefix || 'f_PERIODS_CONF_insert' ;
    v_params logger.tab_param;
  BEGIN
    p_PERIODS_CONF_prepare(v_row);
    logger.append_param(v_params, 'PERIODS_CONF_CODE', v_row.CODE);
    
    logger.log('START', v_scope, null, v_params);
    
    
    IF not f_PERIODS_CONF_exists(pi_row => v_row) THEN
      return HANDLE_PKG.ERR_MESSAGE( apex_util_pkg.f_lang('TAPI_EXISTS_ERROR') , v_scope);
    END IF;
    
    logger.log('Rozpoczynam dodawanie rekordu.', v_scope);
    
    INSERT
    INTO PERIODS_CONF
      VALUES v_row
    ; 
    
    logger.log('STOP. Success', v_scope);
    
    return HANDLE_PKG.OK_MESSAGE( apex_util_pkg.f_lang('TAPI_SUCCESS_INSERT') , v_return_id, v_scope);
  EXCEPTION
  WHEN OTHERS THEN
    logger.log_error(CONST_PKG.C_WHEN_OTHERS_MESSAGE, v_scope);
    raise;
  END f_PERIODS_CONF_insert;
  
  
  function f_PERIODS_CONF_update(
    pi_row IN PERIODS_CONF%ROWTYPE
  ) return CALL_RESULT
  IS
    v_row PERIODS_CONF%ROWTYPE := pi_row;
    
    v_scope logger_logs.scope%type := gc_scope_prefix || 'f_PERIODS_CONF_update' ;
    v_params logger.tab_param;
  BEGIN
  
    p_PERIODS_CONF_prepare(v_row);

    logger.append_param(v_params, 'PERIODS_CONF_CODE', v_row.CODE);

    
    logger.log('START', v_scope, null, v_params);
    
    IF v_row.CODE is null THEN
      return HANDLE_PKG.ERR_MESSAGE( apex_util_pkg.f_lang('TAPI_PK_ERROR_UPDATE') , v_scope);
    END IF;
    
    logger.log('Rozpoczynam aktualizacje rekordu', v_scope);
    
    UPDATE PERIODS_CONF
    SET ROW = v_row
    WHERE 1 = 1
      and CODE = v_row.CODE
    ;
    
    logger.log('STOP. Success', v_scope);
    
    return HANDLE_PKG.OK_MESSAGE( apex_util_pkg.f_lang('TAPI_SUCCESS_UPDATE') , null, v_scope);
    
  EXCEPTION
  WHEN OTHERS THEN
    logger.log_error(CONST_PKG.C_WHEN_OTHERS_MESSAGE, v_scope, null, v_params);
    raise;
  END f_PERIODS_CONF_update;

--------------------------------------------------------------------------------

   -- funkcja usuwająca dane
  function f_PERIODS_CONF_delete(
    pi_row IN PERIODS_CONF%ROWTYPE
  ) return CALL_RESULT
  IS
    v_row          PERIODS_CONF%ROWTYPE := pi_row;
    
    v_scope logger_logs.scope%type := gc_scope_prefix || 'f_PERIODS_CONF_delete' ;
    v_params logger.tab_param;
  BEGIN
    logger.append_param(v_params, 'PERIODS_CONF_CODE', v_row.CODE);
    
    logger.log('START', v_scope, null, v_params);
    
    IF v_row.CODE is null THEN
      return HANDLE_PKG.ERR_MESSAGE( apex_util_pkg.f_lang('TAPI_PK_ERROR_DELETE') , v_scope);
    END IF;
    
    logger.log('Rozpoczynam usuwanie rekordu', v_scope);
    
    DELETE 
      PERIODS_CONF
    WHERE 1 = 1
      and CODE = v_row.CODE
      ;
      
    logger.log('STOP. Success', v_scope);
    
    return HANDLE_PKG.OK_MESSAGE( apex_util_pkg.f_lang('TAPI_SUCCESS_DELETE') , null, v_scope);
    
  EXCEPTION
  WHEN OTHERS THEN
    logger.log_error(CONST_PKG.C_WHEN_OTHERS_MESSAGE, v_scope, null, v_params);
    raise;
  END f_PERIODS_CONF_delete;

--------------------------------------------------------------------------------

   -- funkcja usuwajaca dane
  function f_PERIODS_CONF_copy(
    pi_row IN PERIODS_CONF%ROWTYPE
  ) return CALL_RESULT
  IS
    v_row          PERIODS_CONF%ROWTYPE := pi_row;
    v_return_message CALL_RESULT;
    
    v_scope logger_logs.scope%type := gc_scope_prefix || 'f_PERIODS_CONF_copy' ;
    v_params logger.tab_param;
  BEGIN
    logger.append_param(v_params, 'PERIODS_CONF_CODE', v_row.CODE);
    
    logger.log('START', v_scope, null, v_params);
    
    IF v_row.CODE is null THEN
      return HANDLE_PKG.ERR_MESSAGE( apex_util_pkg.f_lang('TAPI_PK_ERROR_COPY') , v_scope);
    END IF;
    
    
    logger.log('Rozpoczynam kopiowanie rekordu', v_scope);
    
    v_return_message := f_PERIODS_CONF_insert(v_row);
      
    logger.log('STOP. Success', v_scope);
    
    return v_return_message;
    
  EXCEPTION
  WHEN OTHERS THEN
    logger.log_error(CONST_PKG.C_WHEN_OTHERS_MESSAGE, v_scope, null, v_params);
    raise;  
  END f_PERIODS_CONF_copy;
  
--------------------------------------------------------------------------------

  procedure p_PERIODS_CONF(
    pi_command IN CONST_PKG.t_code,
    pi_app_page IN NUMBER default v('APP_PAGE_ID')
  )
  IS
    v_command CONST_PKG.t_code := f_prepareString(pi_command);
    v_return_message CALL_RESULT;
    v_scope logger_logs.scope%type := gc_scope_prefix || 'p_PERIODS_CONF';
    v_params logger.tab_param;
    
    v_row  PERIODS_CONF%ROWTYPE;
  BEGIN    
    logger.append_param(v_params, 'COMMAND', pi_command);
    logger.append_param(v_params, 'APP_PAGE', pi_app_page);
    
    logger.log('START', v_scope, null, v_params);
    p_get_apex_items(pi_app_page, v_row);
                      
    v_return_message := f_PERIODS_CONF(
                                    pi_command => pi_command,
                                    pi_row => v_row
                                    );
    

    apex_util_pkg.p_show_message ( pi_message  => v_return_message );

    logger.log('STOP', v_scope);
    
  EXCEPTION
  WHEN OTHERS THEN
    logger.log_error(CONST_PKG.C_WHEN_OTHERS_MESSAGE, v_scope, null, v_params);
    raise;
  END p_PERIODS_CONF;
  
--------------------------------------------------------------------------------

  function f_PERIODS_CONF(
    pi_command IN CONST_PKG.t_code,
    pi_row IN PERIODS_CONF%ROWTYPE
  ) return CALL_RESULT 
  IS
    v_command CONST_PKG.t_code := f_prepareString(pi_command);
    v_return_message CALL_RESULT;
    v_scope logger_logs.scope%type := gc_scope_prefix || 'f_PERIODS_CONF';
    v_params logger.tab_param;
    
  BEGIN    
    logger.append_param(v_params, 'COMMAND', pi_command);
    logger.append_param(v_params, 'PERIODS_CONF_CODE', pi_row.CODE);
    
    logger.log('START', v_scope, null, v_params);
                      
    
    IF f_check_parameters('f_PERIODS_CONF', v_command) THEN
      CASE v_command
        WHEN CONST_PKG.C_COMMAND_INSERT THEN v_return_message := f_PERIODS_CONF_insert(pi_row);
        WHEN CONST_PKG.C_COMMAND_UPDATE THEN v_return_message := f_PERIODS_CONF_update(pi_row);
        WHEN CONST_PKG.C_COMMAND_DELETE THEN v_return_message := f_PERIODS_CONF_delete(pi_row);
        WHEN CONST_PKG.C_COMMAND_COPY THEN v_return_message := f_PERIODS_CONF_copy(pi_row);
      END CASE;
    else
      v_return_message := HANDLE_PKG.err_message( apex_util_pkg.f_lang('TAPI_WRONG_COMMAND_ERROR') , v_scope);
    end if;
    
    logger.log('STOP', v_scope);
    
    return v_return_message;
  EXCEPTION
  WHEN OTHERS THEN
    logger.log_error(CONST_PKG.C_WHEN_OTHERS_MESSAGE, v_scope, null, v_params);
    raise;    
  END f_PERIODS_CONF;

--------------------------------------------------------------------------------
  procedure p_get_PERIODS_CONF(
      pi_app_page IN NUMBER default v('APP_PAGE_ID')
    )
  as
    v_scope logger_logs.scope%type := gc_scope_prefix || 'p_get_PERIODS_CONF';
    v_params logger.tab_param;
    
    v_row  PERIODS_CONF%ROWTYPE;
  begin
    logger.append_param(v_params, 'pi_app_page', pi_app_page);
    logger.log('START', v_scope, null, v_params);

    p_get_apex_items (
      pi_app_page => pi_app_page,
      pio_row  => v_row
    );
    
    v_row := f_get_PERIODS_CONF(
                  pi_CODE => v_row.CODE
                );
    
    p_set_apex_items(
      pi_app_page => pi_app_page,
      pi_row   => v_row
    );
  
    logger.log('END', v_scope);
  exception
    when others then
      logger.log_error('Unknown error:'||SQLERRM, v_scope, null, v_params);
      raise;
  end p_get_PERIODS_CONF;

--------------------------------------------------------------------------------
  function f_get_PERIODS_CONF(
    pi_CODE IN PERIODS_CONF.CODE%TYPE
  ) return PERIODS_CONF%ROWTYPE
  IS
    v_row          PERIODS_CONF%ROWTYPE;
    
    v_scope logger_logs.scope%type := gc_scope_prefix || 'f_get_PERIODS_CONF' ;
    v_params logger.tab_param;
  BEGIN
    logger.append_param(v_params, 'CODE', pi_CODE);
    
    logger.log('START', v_scope, null, v_params);
    
    
    logger.log('Rozpoczynam pobieranie wiersza', v_scope);
    
    SELECT
      *
    INTO
      v_row
    FROM
      PERIODS_CONF
    WHERE 1 = 1
      and CODE = pi_CODE
      ;
    logger.log('STOP. Success', v_scope);
    
    return v_row;
    
  EXCEPTION
  WHEN OTHERS THEN
    logger.log_error(CONST_PKG.C_WHEN_OTHERS_MESSAGE, v_scope, null, v_params);
    raise;
  END f_get_PERIODS_CONF;

END PERIODS_CONF_PKG;
/
