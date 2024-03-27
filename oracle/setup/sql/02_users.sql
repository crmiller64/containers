-- modify users
alter user USER_1 identified by pass1234;
grant create session to USER_1;
grant ALL PRIVILEGES to USER_1;
alter user USER_2 identified by pass1234;
grant create session to USER_2;
grant ALL PRIVILEGES to USER_2;
-- exit script
EXIT SQL.SQLCODE
