CREATE OR REPLACE EDITIONABLE PACKAGE BODY "EXPENSES_PKG" AS


--==== Scope loggera ====--
  gc_scope_prefix constant VARCHAR2(1000) := lower($$PLSQL_UNIT) || '.';

--==== Typy ====--


--==== Funkcje i Procedury pomocnicze ====--
  procedure p_set_apex_items(
    pi_app_page IN NUMBER,
    pi_row   IN EXPENSES%ROWTYPE
  )
  as
    v_scope logger_logs.scope%type := gc_scope_prefix || 'p_set_apex_items';
    v_params logger.tab_param;

  begin
    logger.append_param(v_params, 'pi_app_page', pi_app_page);
    logger.log('START', v_scope, null, v_params);


    logger.log('EXPENSE_TYPES_ID ' || pi_row.EXPENSE_TYPES_ID, v_scope);
    APEX_UTIL.set_session_state(p_name => 'P'||pi_app_page||'_'||'ID', p_value => pi_row.ID);
    APEX_UTIL.set_session_state(p_name => 'P'||pi_app_page||'_'||'EXPENSE_TYPES_ID', p_value => pi_row.EXPENSE_TYPES_ID);
    APEX_UTIL.set_session_state(p_name => 'P'||pi_app_page||'_'||'EXPENSE_DATE', p_value => pi_row.EXPENSE_DATE);
    APEX_UTIL.set_session_state(p_name => 'P'||pi_app_page||'_'||'VALUE', p_value => pi_row.VALUE);
    APEX_UTIL.set_session_state(p_name => 'P'||pi_app_page||'_'||'COMMENTS', p_value => pi_row.COMMENTS);
    APEX_UTIL.set_session_state(p_name => 'P'||pi_app_page||'_'||'CREATED', p_value => pi_row.CREATED);
    APEX_UTIL.set_session_state(p_name => 'P'||pi_app_page||'_'||'CREATED_BY', p_value => pi_row.CREATED_BY);
    APEX_UTIL.set_session_state(p_name => 'P'||pi_app_page||'_'||'UPDATED', p_value => pi_row.UPDATED);
    APEX_UTIL.set_session_state(p_name => 'P'||pi_app_page||'_'||'UPDATED_BY', p_value => pi_row.UPDATED_BY);
    APEX_UTIL.set_session_state(p_name => 'P'||pi_app_page||'_'||'IS_RETURNED', p_value => pi_row.IS_RETURNED);
    APEX_UTIL.set_session_state(p_name => 'P'||pi_app_page||'_'||'RETURN_WIRE_RECEIVED', p_value => pi_row.RETURN_WIRE_RECEIVED);
    APEX_UTIL.set_session_state(p_name => 'P'||pi_app_page||'_'||'RETURN_VALUE', p_value => pi_row.RETURN_VALUE); 
    APEX_UTIL.set_session_state(p_name => 'P'||pi_app_page||'_'||'SHOP_NAME', p_value => pi_row.SHOP_NAME); 
    APEX_UTIL.set_session_state(p_name => 'P'||pi_app_page||'_'||'ORDER_NUMBER', p_value => pi_row.ORDER_NUMBER); 
    APEX_UTIL.set_session_state(p_name => 'P'||pi_app_page||'_'||'RETURN_DETAILS', p_value => pi_row.RETURN_DETAILS); 

    logger.log('END', v_scope);
  exception
    when others then
      logger.log_error('Nieznany błąd: '||SQLERRM, v_scope, null, v_params);
      raise;
  end p_set_apex_items;

-- procedura pobierająca stan sesji APEX i zwracająca rowtype
  procedure p_get_apex_items (
    pi_app_page IN NUMBER,
    pio_row  IN OUT EXPENSES%ROWTYPE
  )
  IS
    v_scope logger_logs.scope%type := gc_scope_prefix || 'p_get_apex_items';
    v_params logger.tab_param;
  begin
    logger.append_param(v_params, 'APP_PAGE', pi_app_page);
    logger.log('START', v_scope, null, v_params);

    pio_row.ID   := v('P'||pi_app_page||'_'||'ID');
    pio_row.EXPENSE_TYPES_ID   := v('P'||pi_app_page||'_'||'EXPENSE_TYPES_ID');
    pio_row.EXPENSE_DATE   := v('P'||pi_app_page||'_'||'EXPENSE_DATE');
    pio_row.VALUE   := v('P'||pi_app_page||'_'||'VALUE');
    pio_row.COMMENTS   := v('P'||pi_app_page||'_'||'COMMENTS');
    pio_row.CREATED   := v('P'||pi_app_page||'_'||'CREATED');
    pio_row.CREATED_BY   := v('P'||pi_app_page||'_'||'CREATED_BY');
    pio_row.UPDATED   := v('P'||pi_app_page||'_'||'UPDATED');
    pio_row.UPDATED_BY   := v('P'||pi_app_page||'_'||'UPDATED_BY');
    pio_row.IS_RETURNED   := v('P'||pi_app_page||'_'||'IS_RETURNED');
    pio_row.RETURN_WIRE_RECEIVED   := v('P'||pi_app_page||'_'||'RETURN_WIRE_RECEIVED');                
    pio_row.RETURN_VALUE   := v('P'||pi_app_page||'_'||'RETURN_VALUE');   
    pio_row.SHOP_NAME   := v('P'||pi_app_page||'_'||'SHOP_NAME');    
    pio_row.ORDER_NUMBER   := v('P'||pi_app_page||'_'||'ORDER_NUMBER');    
    pio_row.RETURN_DETAILS   := v('P'||pi_app_page||'_'||'RETURN_DETAILS');    



    logger.log('END', v_scope);
  EXCEPTION
  WHEN OTHERS THEN
    logger.log_error();
    raise;
  END;

-- Funkcja pomocnicza sprawdzajaca czy parametry wejsciowe nie sa nullem --
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


  -- funkcje przygotowujace dane
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

--==== Koniec funkcji pomocniczych ====--


--==== Funkcje wywolujace modyfikacje konkretnych danych ====--


  -- Procedura przygotowujaca dane
  procedure p_EXPENSES_prepare(
    pio_row IN OUT EXPENSES%ROWTYPE
  )
  IS
    v_scope logger_logs.scope%type := gc_scope_prefix || 'p_EXPENSES_prepare' ;
    v_params logger.tab_param;
  BEGIN
    logger.log('START', v_scope, null, v_params);

    -- tutaj modyfikujemy rekord (status, wartosci itp.) gdyby cos trzeba bylo zmienic przed wlasciwa akcja

    logger.log('STOP', v_scope);
  EXCEPTION 
  WHEN OTHERS THEN
    logger.log_error();
    raise;
  END p_EXPENSES_prepare;


  -- funkcja sprawdzajaca czy istnieje juz taki wpis
  function f_EXPENSES_exists(
    pi_row IN EXPENSES%ROWTYPE
  ) return BOOLEAN
  IS
    v_scope logger_logs.scope%type := gc_scope_prefix || 'f_EXPENSES_exists' ;
    v_params logger.tab_param;

    v_count NUMBER := 0;
  BEGIN

    logger.append_param(v_params, 'EXPENSES_ID', pi_row.ID);
    logger.log('START', v_scope, null, v_params);

    -- sprawdzam czy istnieje taki wpis w wynikach
    SELECT 
      count(1)
    INTO
      v_count
    FROM 
      EXPENSES 
    WHERE 1 = 1
      and ID = pi_row.ID
      ;

    logger.log('STOP. Istnieje takich wpisów: '||v_count, v_scope);

    -- jezeli tak, to zwracam true
    IF v_count is not null AND v_count > 0 THEN
      return false;
    END IF;

    return true;
  EXCEPTION 
  WHEN OTHERS THEN
    logger.log_error();
    raise;
  END f_EXPENSES_exists;


  -- funkcja dodajaca nowe dane
  function f_EXPENSES_insert(
    pi_row IN EXPENSES%ROWTYPE
  ) return CALL_RESULT
  IS
    v_row EXPENSES%ROWTYPE := pi_row;
    v_return_id NUMBER;

    v_scope logger_logs.scope%type := gc_scope_prefix || 'f_EXPENSES_insert' ;
    v_params logger.tab_param;
  BEGIN
    p_EXPENSES_prepare(v_row);
    logger.append_param(v_params, 'EXPENSES_ID', v_row.ID);

    logger.log('START', v_scope, null, v_params);
    logger.log('expense_types.id => '|| v_row.expense_types_id, v_scope);    

    /*
    Warunki biznesowe. Warunki techniczne i logiczne powinny byc obsluzone na tabelach.
    */
    IF not f_EXPENSES_exists(pi_row => v_row) THEN
      return HANDLE_PKG.ERR_MESSAGE( apex_util_pkg.f_lang('TAPI_EXISTS_ERROR') , v_scope);
    END IF;

    logger.log('Rozpoczynam dodawanie rekordu.', v_scope);

    -- robimy inserta
    INSERT
    INTO EXPENSES
      VALUES v_row
    ; 

    logger.log('STOP. Zakonczono sukcesem.', v_scope);

    return HANDLE_PKG.OK_MESSAGE( apex_util_pkg.f_lang('EXPENSES_TAPI_SUCCESS_INSERT') , v_return_id, v_scope);
  EXCEPTION
  WHEN OTHERS THEN
    logger.log_error(CONST_PKG.C_WHEN_OTHERS_MESSAGE, v_scope);
    raise;
  END f_EXPENSES_insert;
  ----


  -- funkcja aktualizujaca dane

  function f_EXPENSES_update(
    pi_row IN EXPENSES%ROWTYPE
  ) return CALL_RESULT
  IS
    v_row EXPENSES%ROWTYPE := pi_row;

    v_scope logger_logs.scope%type := gc_scope_prefix || 'f_EXPENSES_update' ;
    v_params logger.tab_param;
    v_old_row EXPENSES%ROWTYPE;
  BEGIN

    p_EXPENSES_prepare(v_row);

   --get row before UPDATE
    v_old_row := f_get_EXPENSES(pi_row.ID);
    logger.append_param(v_params, 'EXPENSES_ID', v_row.ID);

    logger.log('START', v_scope, null, v_params);

    IF v_row.ID is null THEN
      return HANDLE_PKG.ERR_MESSAGE( apex_util_pkg.f_lang('TAPI_PK_ERROR_UPDATE') , v_scope);
    END IF;

    logger.log('Rozpoczynam aktualizacje rekordu', v_scope);

    --set return value only it wasn't marked as returned before
    IF v_row.is_returned = 'Y' and v_old_row.is_returned ='N' THEN 
      v_row.value := NVL(v_row.value,0) - NVL(v_row.return_value,0);
    END IF; 
     
    IF v_row.is_returned = 'N' THEN 
      v_row.return_value := NULL;
    END IF;         

    UPDATE EXPENSES
    SET ROW = v_row
    WHERE 1 = 1
      and ID = v_row.ID
    ;

    logger.log('STOP. Zakonczono sukcesem.', v_scope);

    return HANDLE_PKG.OK_MESSAGE( apex_util_pkg.f_lang('EXPENSES_TAPI_SUCCESS_UPDATE') , null, v_scope);

  EXCEPTION
  WHEN OTHERS THEN
    logger.log_error(CONST_PKG.C_WHEN_OTHERS_MESSAGE, v_scope, null, v_params);
    raise;
  END f_EXPENSES_update;

--------------------------------------------------------------------------------

   -- funkcja usuwająca dane
  function f_EXPENSES_delete(
    pi_row IN EXPENSES%ROWTYPE
  ) return CALL_RESULT
  IS
    v_row          EXPENSES%ROWTYPE := pi_row;

    v_scope logger_logs.scope%type := gc_scope_prefix || 'f_EXPENSES_delete' ;
    v_params logger.tab_param;
  BEGIN
    logger.append_param(v_params, 'EXPENSES_ID', v_row.ID);

    logger.log('START', v_scope, null, v_params);

    IF v_row.ID is null THEN
      return HANDLE_PKG.ERR_MESSAGE( apex_util_pkg.f_lang('TAPI_PK_ERROR_DELETE') , v_scope);
    END IF;

    logger.log('Rozpoczynam usuwanie rekordu', v_scope);

    DELETE 
      EXPENSES
    WHERE 1 = 1
      and ID = v_row.ID
      ;

    logger.log('STOP. Zakonczono sukcesem.', v_scope);

    return HANDLE_PKG.OK_MESSAGE( apex_util_pkg.f_lang('EXPENSES_TAPI_SUCCESS_DELETE') , null, v_scope);

  EXCEPTION
  WHEN OTHERS THEN
    logger.log_error(CONST_PKG.C_WHEN_OTHERS_MESSAGE, v_scope, null, v_params);
    raise;
  END f_EXPENSES_delete;

--------------------------------------------------------------------------------

   -- funkcja usuwajaca dane
  function f_EXPENSES_copy(
    pi_row IN EXPENSES%ROWTYPE
  ) return CALL_RESULT
  IS
    v_row          EXPENSES%ROWTYPE := pi_row;
    v_return_message CALL_RESULT;

    v_scope logger_logs.scope%type := gc_scope_prefix || 'f_EXPENSES_copy' ;
    v_params logger.tab_param;
  BEGIN
    logger.append_param(v_params, 'EXPENSES_ID', v_row.ID);

    logger.log('START', v_scope, null, v_params);

    IF v_row.ID is null THEN
      return HANDLE_PKG.ERR_MESSAGE( apex_util_pkg.f_lang('TAPI_PK_ERROR_COPY') , v_scope);
    END IF;


    logger.log('Rozpoczynam kopiowanie rekordu', v_scope);

    v_return_message := f_EXPENSES_insert(v_row);

    logger.log('STOP. Zakonczono sukcesem.', v_scope);

    return v_return_message;

  EXCEPTION
  WHEN OTHERS THEN
    logger.log_error(CONST_PKG.C_WHEN_OTHERS_MESSAGE, v_scope, null, v_params);
    raise;  
  END f_EXPENSES_copy;

--------------------------------------------------------------------------------

  procedure p_EXPENSES(
    pi_command IN CONST_PKG.t_code,
    pi_app_page IN NUMBER default v('APP_PAGE_ID')
  )
  IS
    v_command CONST_PKG.t_code := f_prepareString(pi_command);
    v_return_message CALL_RESULT;
    v_scope logger_logs.scope%type := gc_scope_prefix || 'p_EXPENSES';
    v_params logger.tab_param;

    v_row  EXPENSES%ROWTYPE;
  BEGIN    
    logger.append_param(v_params, 'COMMAND', pi_command);
    logger.append_param(v_params, 'APP_PAGE', pi_app_page);
    logger.log('START', v_scope, null, v_params);
    p_get_apex_items(pi_app_page, v_row);
    v_return_message := f_EXPENSES(
                                    pi_command => pi_command,
                                    pi_row => v_row
                                    );


    APEX_UTIL_PKG.p_show_message ( pi_message  => v_return_message );

    logger.log('STOP', v_scope);

  EXCEPTION
  WHEN OTHERS THEN
    logger.log_error(CONST_PKG.C_WHEN_OTHERS_MESSAGE, v_scope, null, v_params);
    raise;
  END p_EXPENSES;

--------------------------------------------------------------------------------

  function f_EXPENSES(
    pi_command IN CONST_PKG.t_code,
    pi_row IN EXPENSES%ROWTYPE
  ) return CALL_RESULT 
  IS
    v_command CONST_PKG.t_code := f_prepareString(pi_command);
    v_return_message CALL_RESULT;
    v_scope logger_logs.scope%type := gc_scope_prefix || 'f_EXPENSES';
    v_params logger.tab_param;

  BEGIN    
    logger.append_param(v_params, 'COMMAND', pi_command);
    logger.append_param(v_params, 'EXPENSES_ID', pi_row.ID);

    logger.log('START', v_scope, null, v_params);


    IF f_check_parameters('f_EXPENSES', v_command) THEN
      CASE v_command
        WHEN CONST_PKG.C_COMMAND_INSERT THEN v_return_message := f_EXPENSES_insert(pi_row);
        WHEN CONST_PKG.C_COMMAND_UPDATE THEN v_return_message := f_EXPENSES_update(pi_row);
        WHEN CONST_PKG.C_COMMAND_DELETE THEN v_return_message := f_EXPENSES_delete(pi_row);
        WHEN CONST_PKG.C_COMMAND_COPY THEN v_return_message := f_EXPENSES_copy(pi_row);
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
  END f_EXPENSES;

--------------------------------------------------------------------------------
  procedure p_get_EXPENSES(
      pi_app_page IN NUMBER default v('APP_PAGE_ID')
    )
  as
    v_scope logger_logs.scope%type := gc_scope_prefix || 'p_get_EXPENSES';
    v_params logger.tab_param;

    v_row  EXPENSES%ROWTYPE;
  begin
    logger.append_param(v_params, 'pi_app_page', pi_app_page);
    logger.log('START', v_scope, null, v_params);

    p_get_apex_items (
      pi_app_page => pi_app_page,
      pio_row  => v_row
    );

    v_row := f_get_EXPENSES(
                  pi_ID => v_row.ID
                );

    p_set_apex_items(
      pi_app_page => pi_app_page,
      pi_row   => v_row
    );

    logger.log('END', v_scope);
  exception
    when others then
      logger.log_error('Nieznany błąd: '||SQLERRM, v_scope, null, v_params);
      raise;
  end p_get_EXPENSES;

--------------------------------------------------------------------------------
  -- pobranie wiersza EXPENSES na podstawie klucza glownego
  function f_get_EXPENSES(
    pi_ID IN EXPENSES.ID%TYPE
  ) return EXPENSES%ROWTYPE
  IS
    v_row          EXPENSES%ROWTYPE;

    v_scope logger_logs.scope%type := gc_scope_prefix || 'f_get_EXPENSES' ;
    v_params logger.tab_param;
  BEGIN
    logger.append_param(v_params, 'ID', pi_ID);

    logger.log('START', v_scope, null, v_params);


    logger.log('Rozpoczynam pobieranie wiersza', v_scope);

    SELECT
      *
    INTO
      v_row
    FROM
      EXPENSES
    WHERE 1 = 1
      and ID = pi_ID
      ;
    logger.log('STOP. Zakonczono sukcesem.', v_scope);

    return v_row;

  EXCEPTION
  WHEN OTHERS THEN
    logger.log_error(CONST_PKG.C_WHEN_OTHERS_MESSAGE, v_scope, null, v_params);
    raise;
  END f_get_EXPENSES;

END EXPENSES_PKG;
/
