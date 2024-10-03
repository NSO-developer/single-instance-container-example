# Containerized NSO Example
This is a example for running NSO in Official Container with recommended best practices


## Useage
The Makefile have the following target  
build:  
Build the container enviorment  

deep_clean:   
deep_clean will call the following target 
clean_log clean_run clean  

clean:  
clean will remove all the docker images  

clean_run:  
clean the NSO-vol directory

clean_log:  
clean the NSO-log-vol directory  

stop:
stop all container with docker stop  

start:  
start all container with docker start  

start_compose:  
start all container with docker-compose  

stop_compose:  
stop all container with docker-compose  

compile_packages:  
compile the packages inside the developer conainter  

cli-c:  
start Cisco style CLI

cli-j:  
START Juniper style CLI . 


## Use Case
1. Copy the development and production image in the images folder
2. Set Python dependency in requirements.txt
3. Set the dependency that need to be installed via yum and dnf in Dockerfile
4. "make build" to build the enviorment and import the images
5. Start the container with "make start" or with docker composer "make start_compose"
6. Build the packages in the development images "make compile_packages"
7. Test the packages inside the production images "make cli-c" or Juniper CLI "make cli-j"
