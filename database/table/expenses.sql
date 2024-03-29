--liquibase formatted sql
--changeset RGRZEGORCZYK:expenses 
--comment Expenses table
--rollback DROP TABLE EXPENSES;
create table expenses (
    id                             number generated by default on null as identity  start with 500
                                   constraint expenses_id_pk primary key,
    expense_types_id               number,      
    expense_date                   date,
    value                          number,
    quantity                       number (8,2),
    unit_price                     number (16,2),        
    is_returned                    char(1) default 'N',
    return_wire_received           char(1) default 'N',    
    return_value                   number(16,2),         
    comments                       varchar2(4000),
    created                        date not null,
    created_by                     varchar2(255) not null,
    updated                        date not null,
    updated_by                     varchar2(255) not null
);

COMMENT ON COLUMN EXPENSES.QUANTITY IS 'Quantity';

COMMENT ON COLUMN EXPENSES.UNIT_PRICE IS 'Unit price';

COMMENT ON COLUMN EXPENSES.IS_RETURNED IS 'Goods returned Y/N';

COMMENT ON COLUMN EXPENSES.RETURN_WIRE_RECEIVED IS 'Wire transfer received Y/N?';

COMMENT ON COLUMN EXPENSES.RETURN_VALUE IS 'Value of returned goods';

--changeset RGRZEGORCZYK:expenses_drop_cols
--comment I don't need this columns anymore
--rollback ALTER TABLE EXPENSES ADD (quantity number (8,2),unit_price number(16,2)) ;
ALTER TABLE EXPENSES DROP  (QUANTITY ,UNIT_PRICE );

--changeset RGRZEGORCZYK:expenses_add_cols
--comment I need a place for shop name, order number, return details
--rollback ALTER TABLE EXPENSES DROP (SHOP_NAME,ORDER_NUMBER,RETURN_DETAILS);
ALTER TABLE EXPENSES ADD (SHOP_NAME VARCHAR2(100 CHAR),
                         ORDER_NUMBER VARCHAR2(255 CHAR),
                         RETURN_DETAILS VARCHAR2(255 CHAR) );
                         
COMMENT ON COLUMN EXPENSES.SHOP_NAME IS 'Shop name, website or other preffered info';

COMMENT ON COLUMN EXPENSES.ORDER_NUMBER IS 'Order number';

COMMENT ON COLUMN EXPENSES.RETURN_DETAILS IS 'Return details if goods returned e.g return number, return parcel number etc.';                         
