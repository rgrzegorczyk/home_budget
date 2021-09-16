CREATE OR REPLACE EDITIONABLE PACKAGE APEX_UTIL_PKG 
as

 

  procedure p_show_message(
    pi_message IN CALL_RESULT
  );

  /** Procedura która wyswietla komunikat jako success message na gui
   * @param pi_message zmienna typu VARCHAR2 zawierajaca komunikat success message wyswietlanej na GUI
  */

  procedure p_show_success_message(
    pi_message IN VARCHAR2
  );

  /** Procedura która wyswietla komunikat bledu na gui
   * @param pi_message zmienna typu VARCHAR2 zawierajaca komunikat bledu wyswietlanej na GUI
  */

  procedure p_show_error_message(
    pi_message IN VARCHAR2
  );

  /** Procedura która wyswietla komunikat bledu na gui jednoczesnie globalnie na stronie i przy itemie ktorego dotyczy
   * @param pi_message zmienna typu VARCHAR2 zawierajaca komunikat bledu wyswietlanej na GUI
   * @param pi_item_name zmienna typu VARCHAR2 do ktorego komunikat bledu zostanie przypisany
  */

  procedure p_show_error_message(
    pi_message IN VARCHAR2,
    pi_item_name IN VARCHAR2
  );



  function f_lang (
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
  ) return varchar2;




end APEX_UTIL_PKG;
/
