CREATE OR REPLACE EDITIONABLE PACKAGE BODY HANDLE_PKG AS

 
  FUNCTION OK_MESSAGE  return CALL_RESULT
  is
    v_out CALL_RESULT := CALL_RESULT(const_pkg.c_result_ok);
  begin
    return v_out;
  end OK_MESSAGE;

  FUNCTION OK_MESSAGE (p_message in varchar2) return CALL_RESULT
  is
    v_out CALL_RESULT := CALL_RESULT(const_pkg.c_result_ok, p_message);
  begin
    logger.log_information(v_out.status||' - '||v_out.message);
    return v_out;
  end OK_MESSAGE;

  FUNCTION OK_MESSAGE (p_message in varchar2, pi_count_ok NUMBER, pi_count_err NUMBER) return CALL_RESULT
  is
    v_out CALL_RESULT := CALL_RESULT(const_pkg.c_result_ok, p_message, pi_count_ok, pi_count_err);
  begin
    logger.log_information(v_out.status||' - '||v_out.message);
    return v_out;
  end OK_MESSAGE;

  FUNCTION OK_MESSAGE (p_message in varchar2, p_return_id in number) return CALL_RESULT
  is
    v_out CALL_RESULT := CALL_RESULT(const_pkg.c_result_ok, p_message, p_return_id);
  begin
    logger.log_information(v_out.status||' - '||v_out.message||' - inserted id: '||v_out.NEW_OBJECT_ID);
    return v_out;
  end OK_MESSAGE;

  FUNCTION ERR_MESSAGE (p_message in varchar2) return CALL_RESULT
  IS
    v_out CALL_RESULT := CALL_RESULT(const_pkg.c_result_err, p_message);
  begin
    logger.log_error(v_out.status||' - '||v_out.message);
    return v_out;
  end ERR_MESSAGE;

  FUNCTION ERR_MESSAGE (p_message in varchar2, pi_count_ok NUMBER, pi_count_err NUMBER ) return CALL_RESULT
  IS
    v_out CALL_RESULT := CALL_RESULT(const_pkg.c_result_err, p_message, pi_count_ok, pi_count_err);
  begin
    logger.log_error(v_out.status||' - '||v_out.message);
    return v_out;
  end ERR_MESSAGE;

  FUNCTION WAR_MESSAGE (p_message in varchar2) return CALL_RESULT
  IS
    v_out CALL_RESULT := CALL_RESULT(const_pkg.c_result_war, p_message);
  begin
    logger.log_warning(v_out.status||' - '||v_out.message);
    return v_out;
  end WAR_MESSAGE;

  FUNCTION WAR_MESSAGE (p_message in varchar2, pi_count_ok NUMBER, pi_count_err NUMBER) return CALL_RESULT
  IS
    v_out CALL_RESULT := CALL_RESULT(const_pkg.c_result_war, p_message, pi_count_ok, pi_count_err);
  begin
    logger.log_warning(v_out.status||' - '||v_out.message);
    return v_out;
  end WAR_MESSAGE;

  FUNCTION OK_MESSAGE (p_message in varchar2, p_scope in logger_logs.scope%type) return CALL_RESULT
  is
    v_out CALL_RESULT := CALL_RESULT(const_pkg.c_result_ok, p_message);
  begin
    logger.log_information(v_out.status||' - '||v_out.message, p_scope);
    return v_out;
  end OK_MESSAGE;

  FUNCTION OK_MESSAGE (p_message in varchar2, p_return_id in number, p_scope in logger_logs.scope%type) return CALL_RESULT
  is
    v_out CALL_RESULT := CALL_RESULT(const_pkg.c_result_ok, p_message, p_return_id);
  begin
    logger.log_information(v_out.status||' - '||v_out.message||' - inserted id: '||v_out.NEW_OBJECT_ID, p_scope);
    return v_out;
  end OK_MESSAGE;

  FUNCTION ERR_MESSAGE (p_message in varchar2, p_scope in logger_logs.scope%type) return CALL_RESULT
  IS
    v_out CALL_RESULT := CALL_RESULT(const_pkg.c_result_err, p_message);
  begin
    logger.log_error(v_out.status||' - '||v_out.message, p_scope);
    return v_out;
  end ERR_MESSAGE;

  FUNCTION WAR_MESSAGE (p_message in varchar2, p_scope in logger_logs.scope%type) return CALL_RESULT
  IS
    v_out CALL_RESULT := CALL_RESULT(const_pkg.c_result_war, p_message);
  begin
    logger.log_warning(v_out.status||' - '||v_out.message, p_scope);
    return v_out;
  end WAR_MESSAGE;

END HANDLE_PKG;
/
