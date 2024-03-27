-- add new directory containing the database dump files
create or replace directory dump_data as '/opt/oracle/scripts/setup';
grant read, write on directory dump_data to system;
-- create needed tablespaces
create tablespace MY_TABLESPACE datafile 'FIRST_DB.dat' size 10M autoextend on;
create tablespace MY_SECOND_TABLESPACE datafile 'SECOND_DB.dat' size 10M autoextend on;
-- create needed profiles
create profile MY_PROFILE limit sessions_per_user 100 failed_login_attempts default;
-- create roles
create role ROLE_1;
create role ROLE_2;
create role ROLE_3;
-- create users
create user USER_1 identified by pass1234;
create user USER_2 identified by pass1234;
create user USER_3 identified by pass1234;
-- exit script
EXIT SQL.SQLCODE
