--liquibase formatted sql
--changeset RGRZEGORCZYK:DB_UTIL_PKG_spec runOnChange:true stripComments:false  stripComments:false context:release_1.0 labels:release_1.0
--rollback SELECT 1 FROM DUAL;
--------------------------------------------------------
--  DDL for Package DB_UTIL_PKG
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE PACKAGE "DB_UTIL_PKG" AS 

--=============================SYBTYPES=======================================--
  SUBTYPE param_index_type IS VARCHAR2(32);
  SUBTYPE param_value_type IS VARCHAR2(4000);

--=============================TYPES==========================================--
/** Typ - tablica varchar2
*/
  TYPE t_varchar2 IS TABLE OF param_value_type;

  TYPE t_outer_args IS TABLE OF t_varchar2
    INDEX BY param_index_type;

--===========================FUNCTIONS========================================--

/** Funkcja rozdzielajaca ciag znakow po separatorach
* @param pi_string ciag znakow z ktorego chcemy utworzyc tablice pipelined
* @param pi_separator separator po ktorym rozpoznajemy kolejne elementy tablicy
*/

  FUNCTION in_list (
                    pi_string     IN  VARCHAR2,
                    pi_separator  IN  VARCHAR2
  ) RETURN t_varchar2 PIPELINED DETERMINISTIC;



END DB_UTIL_PKG;


/
