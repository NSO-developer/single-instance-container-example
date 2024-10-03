# Containerized NSO Example
This is a example for running NSO in Official Container with recommended best practices. This example act as the base framwork for the HA, HARAFT and the LSA Containerized NSO example. At the same time, we will also use this as base framwork for NID migration to Containerized NSO. 


## Usage
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


### Example Usage
Startup NSO with "docker run"
```
make clean build start
```
Stop NSO with "docker stop"
```
make stop clean
```

Startup NSO with docker-compose
```
make clean build start_compose
```
Stop NSO with docker-compose
```
make stop_compose clean
```


## Use Case
1. Copy the development and production image in the images folder
2. Set Python dependency in requirements.txt
3. Set the dependency that need to be installed via yum and dnf in Dockerfile
4. "make build" to build the enviorment and import the images
5. Start the container with "make start" or with docker composer "make start_compose"
6. Build the packages in the development images "make compile_packages"
7. Test the packages inside the production images "make cli-c" or Juniper CLI "make cli-j"

## Copyright and License Notice
``` 
Copyright (c) 2024 Cisco and/or its affiliates.

This software is licensed to you under the terms of the Cisco Sample
Code License, Version 1.1 (the "License"). You may obtain a copy of the
License at

               https://developer.cisco.com/docs/licenses

All use of the material herein must be in accordance with the terms of
the License. All rights not expressly granted by the License are
reserved. Unless required by applicable law or agreed to separately in
writing, software distributed under the License is distributed on an "AS
IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express
or implied.
``` 

