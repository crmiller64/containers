# Deploy a project to Tomcat container

* Pull down the Tomcat 9 JDK11 Docker image
  * `podman image pull tomcat:9-jdk11`
* Copy `application.war` to this directory
* Build the custom Tomcat container image defined in `Containerfile` 
  * Run the following command from this directory:  
  `podman build --tag <username>/application ./`
* Run the newly built Tomcat image
  * ```shell
	podman run -it \
	  --name=tomcat-application \
    # set up remote JVM debug
	  -e JPDA_ADDRESS=0.0.0.0:8002 \
	  -e JPDA_TRANSPORT=dt_socket \
    # kc webapp port
	  -p 8081:8080 \
    # remote debug port
	  -p 8002:8002 \
    # SMTP
	  -p 2525:2525 \
    # JMX / Batch RMI
    -p 42000:42000 \
    # OPTIONAL: mount any needed directories
	  # -v /host/path/to/needed/directory/:/root/path/to/needed/directory/ \
	  <username>/application \
	  /usr/local/tomcat/bin/catalina.sh jpda run
    ```

## Useful commands
Tail `catalina.log` in Tomcat container:  
`podman exec -it tomcat-application tail -f /usr/local/tomcat/logs/catalina.log`

Tail logs from `stdout` from Tomcat container:  
`podman logs --follow --tail=100 tomcat-application`

Copy new `application.war` to Tomcat container:  
`podman cp my-app/target/application.war my-app:/usr/local/tomcat/webapps/`

## Set up communication between the Tomcat (web) and Oracle (database) containers

First - read the instructions under the **Communicate between two rootless containers** or **Communicate between two rootless containers in a pod** sections here:  
https://www.redhat.com/sysadmin/container-networking-podman

Then do one the following things to set up communications between the containers:

### Communicate between two rootless containers:
* Find the local IP address of your system
  * For macOS
    * https://apple.stackexchange.com/a/20553 
    * `ipconfig getifaddr en0`
  * Modify the JDBC connection strings in all config files to point to the IP address from the above `ipconfig` command

### Communicate between two rootless containers in a pod:
* Create a new pod
  * ```shell
    podman pod create --name=kuali \
      # port range for Tomcat
      -p 8000-8180:8000-8180 \
      -p 2525:2525 \
      -p 42000:42000 \
      # port for Oracle
      -p 1521:1521
    ```
* Create the Oracle and Tomcat containers with the same pod name by specifying the `--pod` arg *when first running the container*
  * **NOTE**: omit the `-p` args in the podman run command as the needed ports are already exposed by the pod itself
  * ```shell
    podman run -it \
      --pod=<pod name> \
      ...
      <Tomcat or Oracle image name> \
      ...
    ```
