# Deploy a database to Oracle container
* OPTIONAL: If using podman, verify a podman machine has been created with your `$HOME` directory mounted
  * `podman machine init --cpus=5 --memory=10240 -v $HOME:$HOME --rootful`
* Log in to the Oracle Container Registry
  * `docker login container-registry.oracle.com`
* Pull down the Oracle 19 Enterprise Docker image
  * Use this image for **AMD64** systems (Intel x86)
    * `docker pull container-registry.oracle.com/database/enterprise:19.3.0.0`
  * Use this image 19 for **ARM64** systems (Mac M1)
    * `docker pull container-registry.oracle.com/database/enterprise:19.19.0.0`
* Copy the database dump `*.dmp` files to the `setup/` directory
  * `dump_1.dmp`
  * `dump_2.dmp`
* Grant read+write file permissions to the `setup` directory
  * `chmod -R 777 setup`
* Create an `oradata` volume to mount to the Oracle container
  * `docker volume create --label version=19 oradata`
* Build the Oracle container image
  * ```shell
    docker run --name oracle-db \
        -p 1521:1521 \
        -e ORACLE_PWD=Welcome1 \
        -e ORACLE_EDITION=enterprise \
        -v oradata:/opt/oracle/oradata \
        # mount scripts and database dumps to setup kc database 
        -v /Users/crmiller64/workspace/crmiller64/containers/oracle/setup:/opt/oracle/scripts/setup \
        container-registry.oracle.com/database/enterprise:19.19.0.0
    ```

## Username, Passwords, Database Names
* usernames / passwords
  * `sys` / `Welcome1`
  * `system` / `Welcome1`
  * `USER_1` / `pass1234`
  * `USER_2` / `pass1234`
  * `USER_3` / `pass1234`
* SID/CDB: `ORCLCDB`
* PDB: `ORCLPDB1`

### JDBC connection
* URL: `jdbc:oracle:thin:@localhost:1521/ORCLPDB1`
* username / password: `USER_1` / `pass1234`

# Misc Info

## Connect to Oracle DB hosted on a container via SQLcl
`sql <username>/<password>@//localhost:1521/<database name> as sysdba`

Database name can be the `CDB` or `PDB` of the Oracle DB, so:

`sql sys/Welcome1@//localhost:1521/ORCLPDB1 as sysdba`

## Changing the default password for Oracle SYS User
On the first startup of the container, a random password is generated for the database if a password is not provided by using the `-e ORACLE_PWD` option.

To change the password for the default accounts, use the `docker exec` command to run the `setPassword.sh` script that is found in the container. Note that the container must be running before you run the script.

For example:
`docker exec <oracle container name> ./setPassword.sh <new password>`
