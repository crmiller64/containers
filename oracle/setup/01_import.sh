#!/bin/bash

# Run setup SQL to create needed objects for imports
sqlplus sys/Welcome1@//localhost:1521/ORCLPDB1 as sysdba @/opt/oracle/scripts/setup/sql/01_setup.sql

# Run the data imports
impdp SYSTEM/Welcome1@//localhost/ORCLPDB1 directory=DUMP_DATA dumpfile=dump_1.dmp logfile=first.log full=y
impdp SYSTEM/Welcome1@//localhost/ORCLPDB1 directory=DUMP_DATA dumpfile=dump_2.dmp logfile=second.log full=y

# Set user passwords and permissions
sqlplus sys/Welcome1@//localhost:1521/ORCLPDB1 as sysdba @/opt/oracle/scripts/setup/sql/02_users.sql

# Do post import clean up
sqlplus sys/Welcome1@//localhost:1521/ORCLPDB1 as sysdba @/opt/oracle/scripts/setup/sql/03_cleanup.sql
