## HOME BUDGET ##

   #### Track your expenses and plan your home budget ####

   # Quick intro #

   For many years my wife and I been using MS Excel to write down all the expenses we made during month.
   But for me, it was always hard to maintan, backup or do some analitycal grouping etc.
   That's why I decided to write an app and move it to APEX

  #### TO DO ######

   Here you can check a working DEMO of application pubslished at apex.oracle.com

  #### TO DO ######


   # Warning #
    App is published without any guarantees and still in development.

   ## However I'v been using it at "production" in my home for few months :) ##



### Installation ###

1. I assume that you have Oracle Database minimum 19.X, and APEX minimum 20.2
   Below examples are dedicated for using with Oracle Cloud - probably you will have to tune it a little, if you use sth else.

1. Using privileged user e.g ADMIN

create user HOME_BUDGET identified by [PASSWORD];

  grant connect to HOME_BUDGET;
  grant create view to HOME_BUDGET;
  grant create job to HOME_BUDGET;
  grant create table to HOME_BUDGET;
  grant create type to HOME_BUDGET;
  grant create sequence to HOME_BUDGET;
  grant create trigger to HOME_BUDGET;
  grant create procedure to HOME_BUDGET;
  grant create any context  to HOME_BUDGET;
  
  -- QUOTAS // it's "DATA" when you use Oracle Cloud Free ATP
ALTER USER "HOME_BUDGET" QUOTA UNLIMITED ON "DATA";

2. Log into your APEX internal and:
Create workspace for your HOME_BUDGET user.

3. Log into newly created HOME_BUDGET workspace.
Install APEX application (When installig choose "Install supporting objects").

Choose f200.sql file from the newest  ./build folder.

## Do not install "install_script.sql" - it's  just for archive purposes!

## Updated new app versions will have new install scripts included (conditions to run or not run scripts will be covered on checking existing changesets in DATABSECHANGELOGTABLE)



