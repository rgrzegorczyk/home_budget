CREATE OR REPLACE EDITIONABLE PACKAGE "CONST_PKG" 
AS
/**
* Projekt:          SC<br/>
* Opis:             Pakiet zawierajacy defnicje stalych<br/>
* DB impact:        NO<br/>
* Commit inside:    NO<br/>
* Rollback inside:  NO<br/>
* @headcom
*/

  SUBTYPE t_code IS VARCHAR2(50);    

  c_sc_apex_aplication_id            NUMBER := 200; -- zakladam ze na takim ID jest nasza aplikacja (w razie zmiany trzeba to zmienic bo komunikaty przestana dzialac )

  -- kody bledow
  c_result_err                       VARCHAR2(20) := 'ERR';
  c_result_ok                        VARCHAR2(20) := 'OK';
  c_result_war                       VARCHAR2(20) := 'WAR';

  -- kody funkcji GUI
  c_command_insert                  VARCHAR2(30) := 'INSERT';
  c_command_update                  VARCHAR2(30) := 'UPDATE';
  c_command_delete                  VARCHAR2(30) := 'DELETE';
  c_command_copy                    VARCHAR2(30) := 'COPY';
  
  --kody funkcji na GUI dla Interactive Grid (APEX$ROW_STATUS)
  c_command_ig_insert               VARCHAR2(50) := 'C';
  c_command_ig_update               VARCHAR2(50) := 'U';
  c_command_ig_delete               VARCHAR2(50) := 'D';
  
 
  -- komunikaty bedów
  c_when_others_message             VARCHAR2(100) := 'Nieoczekiwany problem';
  c_unsupported_message VARCHAR2(100) := 'Procedura/Funkcja jest w tym momencie zablokowana.' ;


  FUNCTION f_get_buffer_schema
    RETURN VARCHAR2;

  FUNCTION f_get_core_schema
    RETURN VARCHAR2;

  FUNCTION f_REPL_table_prefix
    RETURN VARCHAR2;

  FUNCTION f_EXT_table_prefix
    RETURN VARCHAR2;

END CONST_PKG;

/
