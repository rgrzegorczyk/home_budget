CREATE OR REPLACE EDITIONABLE PACKAGE BODY APEX_UTIL_PKG AS

--==== Logger scope ====--
  gc_scope_prefix constant VARCHAR2(31) := lower($$PLSQL_UNIT) || '.';

--==== TYPES ====----
  c_APP_CN_ITEM_NAME CONSTANT VARCHAR2(100) := 'APP_CN';

--==== GLOBALS ====----
  g_coll_name   APEX_COLLECTIONS.COLLECTION_NAME%TYPE := c_APP_CN_ITEM_NAME;  

--==== Functions and procedures  ====--

-- show success message on GUI
  procedure p_show_success_message(
    pi_message IN VARCHAR2
  ) AS
      v_scope logger_logs.scope%type := gc_scope_prefix || 'p_show_success_message' ;
      v_params logger.tab_param;
  BEGIN
  logger.append_param(v_params, 'pi_message', pi_message);
  logger.log('START', v_scope, null, v_params);

  APEX_UTIL.set_session_state(p_name => 'APP_SUCCESS_MESSAGE', p_value => pi_message);

  apex_application.g_print_success_message := pi_message;

  logger.log('END', v_scope);
  EXCEPTION 
  WHEN OTHERS THEN
    logger.log_error();
    raise;
  END p_show_success_message;

--------------------------------------------------------------------------------
-- translates codes using apex_lang
  function f_lang(
    pi_message in varchar2,
    pi_p0      in varchar2 default null,
    pi_p1      in varchar2 default null,
    pi_p2      in varchar2 default null,
    pi_p3      in varchar2 default null,
    pi_p4      in varchar2 default null,
    pi_p5      in varchar2 default null,
    pi_p6      in varchar2 default null,
    pi_p7      in varchar2 default null,
    pi_p8      in varchar2 default null,
    pi_p9      in varchar2 default null,
    pi_p_lang  in varchar2 default null
  ) return varchar2
  IS

    v_scope logger_logs.scope%type := gc_scope_prefix || 'f_lang' ;
    v_params logger.tab_param;

    v_return APEX_APPLICATION_TRANSLATIONS.message_text%TYPE;

  BEGIN

    logger.append_param(v_params, 'pi_message', pi_message);
    logger.log('START', v_scope, null, v_params);

    IF SYS_CONTEXT('APEX$SESSION','APP_SESSION') is not null then
      v_return := apex_lang.message(
                    p_name => pi_message,
                    p0 => pi_p0,
                    p1 => pi_p1,
                    p2 => pi_p2,
                    p3 => pi_p3,
                    p4 => pi_p4,
                    p5 => pi_p5,
                    p6 => pi_p6,
                    p7 => pi_p7,
                    p8 => pi_p8,
                    p9 => pi_p9,
                    p_lang => pi_p_lang
                  );

      IF v_return = pi_message then
        logger.log_error('No translation found for code'||pi_message||'in apex_lang');
      END IF;

    ELSE
      Select
        message_text 
      into 
        v_return
      from APEX_APPLICATION_TRANSLATIONS
      where 1 = 1
        and lower(language_code) = nvl(pi_p_lang,'pl') -- default language code PL
        and application_id = const_pkg.c_sc_apex_aplication_id
        and TRANSLATABLE_MESSAGE = pi_message;
    END IF;

    logger.log('END', v_scope);
    return v_return;

  EXCEPTION 
  WHEN OTHERS THEN
    logger.log_error();
    logger.log_error('No translation found for code'||pi_message||'in apex_lang');
    --raise;
    return pi_message;
  END f_lang;

--------------------------------------------------------------------------------
-- error message on GUI
  procedure p_show_error_message(
    pi_message IN VARCHAR2
  ) AS

    v_scope logger_logs.scope%type := gc_scope_prefix || 'p_show_error_message' ;
    v_params logger.tab_param;
  BEGIN
  logger.append_param(v_params, 'pi_message', pi_message);
  logger.log('START', v_scope, null, v_params);

  APEX_ERROR.ADD_ERROR (
        p_message  => pi_message,
        p_display_location => apex_error.c_inline_in_notification 
      );

  logger.log('END', v_scope);
  EXCEPTION 
  WHEN OTHERS THEN
    logger.log_error();
    raise;
  END p_show_error_message;

--------------------------------------------------------------------------------

-- error message with field and notification
  procedure p_show_error_message(
    pi_message IN VARCHAR2,
    pi_item_name IN VARCHAR2
  ) AS
      v_scope logger_logs.scope%type := gc_scope_prefix || 'p_show_error_message' ;
      v_params logger.tab_param;
  BEGIN

  logger.append_param(v_params, 'pi_message', pi_message);
  logger.append_param(v_params, 'pi_item_name', pi_item_name);
  logger.log('START', v_scope, null, v_params);

  APEX_ERROR.ADD_ERROR (
        p_message  => pi_message,
        p_page_item_name => pi_item_name,
        p_display_location => apex_error.c_inline_with_field_and_notif
      );

  logger.log('END', v_scope);

  EXCEPTION 
  WHEN OTHERS THEN
    logger.log_error();
    raise;
  END p_show_error_message;

--------------------------------------------------------------------------------

-- error message depending on CALL_RESULT value
  procedure p_show_message(
    pi_message IN CALL_RESULT
  ) AS
    v_scope logger_logs.scope%type := gc_scope_prefix || 'p_show_message' ;
    v_params logger.tab_param;

  BEGIN

  logger.append_param(v_params, 'pi_message', pi_message.message);
  logger.log('START', v_scope, null, v_params);

  CASE pi_message.status
    WHEN const_pkg.c_result_ok then p_show_success_message(pi_message => pi_message.message);
    WHEN const_pkg.c_result_err then p_show_error_message(pi_message => pi_message.message);
    ELSE logger.log_error('Unsupported message');
  END CASE;

  logger.log('END', v_scope);
  EXCEPTION 
  WHEN OTHERS THEN
    logger.log_error();
    raise;
  END p_show_message;


END APEX_UTIL_PKG;

/
