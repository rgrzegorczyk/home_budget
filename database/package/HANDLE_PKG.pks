CREATE OR REPLACE EDITIONABLE PACKAGE "HANDLE_PKG" AS 

  FUNCTION OK_MESSAGE return CALL_RESULT;
  FUNCTION OK_MESSAGE (p_message in varchar2) return CALL_RESULT;


  FUNCTION OK_MESSAGE (p_message in varchar2, p_return_id in number) return CALL_RESULT;

  FUNCTION ERR_MESSAGE (p_message in varchar2) return CALL_RESULT;


  FUNCTION WAR_MESSAGE (p_message in varchar2) return CALL_RESULT;

  FUNCTION OK_MESSAGE (p_message in varchar2, p_scope in logger_logs.scope%type) return CALL_RESULT;
  FUNCTION OK_MESSAGE (p_message in varchar2, p_return_id in number, p_scope in logger_logs.scope%type) return CALL_RESULT;
  FUNCTION ERR_MESSAGE (p_message in varchar2, p_scope in logger_logs.scope%type) return CALL_RESULT;
  FUNCTION WAR_MESSAGE (p_message in varchar2, p_scope in logger_logs.scope%type) return CALL_RESULT;

  -- na potrzeby business logow dodalem oblusge ok i err countow.
  FUNCTION OK_MESSAGE (p_message in varchar2, pi_count_ok NUMBER, pi_count_err NUMBER) return CALL_RESULT;
  FUNCTION ERR_MESSAGE (p_message in varchar2, pi_count_ok NUMBER, pi_count_err NUMBER) return CALL_RESULT;
  FUNCTION WAR_MESSAGE (p_message in varchar2, pi_count_ok NUMBER, pi_count_err NUMBER) return CALL_RESULT;

END HANDLE_PKG;
/
