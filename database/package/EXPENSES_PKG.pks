CREATE OR REPLACE EDITIONABLE PACKAGE "EXPENSES_PKG" 
as



  /** Procedura do obsługi tabeli EXPENSES z APEX
   * @param pi_command Komenda definiująca akcje (np.INSERT, UPDATE, DELETE) - słownik dostepnych komend zapisany w CONST_PKG
   * @param pi_app_page ID strony APEX z ktorej zostala funkcja uruchomiona
  */

  procedure p_EXPENSES(
    pi_command IN CONST_PKG.t_code,
    pi_app_page IN NUMBER default v('APP_PAGE_ID')
  );

  /** Funkcja do obsługi tabeli EXPENSES
  * @param pi_command Komenda definiująca akcje (np.INSERT, UPDATE, DELETE) - słownik dostepnych komend zapisany w CONST_PKG
  * @param pi_row Wiersz typu EXPENSES 
  */

  function f_EXPENSES(
    pi_command IN CONST_PKG.t_code,
    pi_row in EXPENSES%ROWTYPE
  ) return CALL_RESULT;

  /** Procedura do pobierania rekordu z tabeli EXPENSES i przypisywania wartosci w APEX na stronie
  * @param pi_app_page ID strony APEX z ktorej zostala funkcja uruchomiona
  */
  procedure p_get_EXPENSES(
    pi_app_page IN NUMBER default v('APP_PAGE_ID')
  );

  /** Funkcja do pobierania rekordu z tabeli EXPENSES
  * @param pi_ID klucz glowny tabeli 
  * @return Zwraca wiersz typu EXPENSES
  */
  function f_get_EXPENSES(
    pi_ID IN EXPENSES.ID%TYPE
  ) return EXPENSES%ROWTYPE;

end EXPENSES_PKG;
/