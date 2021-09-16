CREATE OR REPLACE EDITIONABLE PACKAGE BODY "DB_UTIL_PKG" AS

--==== Scope loggera ====--
  gc_scope_prefix constant VARCHAR2(1000) := lower($$PLSQL_UNIT) || '.';
--==== Typy ====--

--==== Zmienne Globalne ====--
  gv_TAPI           VARCHAR2(32767);
  gv_table_name     VARCHAR2(200);
  gv_table_schema   VARCHAR2(200);


--==== Funkcje glowne pakietu DB_UTIL_PKG  ====--
-- Funkcja zwracajaca po separatorze tabelice PIPELINED deterministyczna
  FUNCTION in_list (
                    pi_string     IN VARCHAR2,
                    pi_separator  IN VARCHAR2
  ) RETURN t_varchar2 PIPELINED DETERMINISTIC
  AS
    l_text  VARCHAR2(32767) := pi_string || pi_separator;
    l_idx   NUMBER;
  BEGIN
    LOOP
      l_idx := INSTR(l_text, pi_separator);
      EXIT WHEN NVL(l_idx, 0) = 0;
      PIPE ROW (TRIM(SUBSTR(l_text, 1, l_idx - 1)));
      l_text := SUBSTR(l_text, l_idx + 1);
    END LOOP;

    RETURN;
  END in_list;

END DB_UTIL_PKG;


/
