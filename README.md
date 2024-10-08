# Migration to Containerized NSO

This example emphasizes on migrating from NID (NSO in Docker) setup to an official NSO docker image, Containerized NSO with enclosed steps, which themselves are sectioned into two parts:

**Steps to create prerequisite NID setup for demo:**
* Download NSO image from Cisco Download Software center.
* clone NID repository and cd into nso-docker
* Inside nso-docker, put your desired NSO version image in directory "nso-install-files"
* Run make which will build two docker images, cisco-nso-base and cisco-nso-dev.
* cd into single-instance-migration
* As it is demonstration, we will only use cisco-nso-base to build our container, use following comand to build:
    ```docker run -itd -v $(pwd)/NSO-vol/nso:/nso --name nid-prod cisco-nso-base:<tag>```
    You can get tag from docker images command corresponding to your image.
* You should be able to see now two folders (NSO-vol and NSO-log) in current directory
* Inside them you can see NSO file structure, and your NID setup is ready. You can also verify it by excecuting NSO CLI using container shell, next we will see how to migrate to Official image of Containerized NSO.

**Steps for Migration:**
* clone single-instance-container-example and checkout nid_migration branch:
```
    git clone
    cd single-instance-container-example
    git checkout nid_migration
```

* Download Containerized NSO images (production as well as development) from Cisco Download Center.
* Extract images and store tar files of images inside single-instance-container-example/images
* Run ```make build```

```
       ....
       .......
       Successfully built d1cc7a6f3185
       Successfully tagged mod-nso-dev:6.3
       cp util/Makefile NSO-vol/nso/run/packages/
```
This step includes:
* loading your contanerized NSO images
* building mod-nso-dev and mod-nso-prod images from the loaded images, with some customizations to help us update packages/libraries on images
* copy ncs.conf file from NID container using docker cp command (this can be skipped if parent of ncs.conf is mapped volume on host, then it can be mapped to Containerized NSO prod container in later step).
* stop NID container(s).
* It also copies Makefile from util which will help us build all packages when we spin up development container through docker compose.

* After the target completes the build process, you can see loaded images:
```
panndesa@PANNDESA-M-CX29 single-instance-container-example % docker images
REPOSITORY                                          TAG                    IMAGE ID       CREATED          SIZE
mod-nso-dev                                         6.3                    d1cc7a6f3185   9 minutes ago    2.69GB
mod-nso-prod                                        6.3                    4913ad823856   16 minutes ago   1.96GB
```
* We will proceed with bringing up compose service using the target ```make start_compose```
```
panndesa@PANNDESA-M-CX29 single-instance-container-example % make start_compose
VER="6.3" docker-compose up BUILD PROD -d
[+] Running 4/4
 ✔ Container nso_prod                                                                                                                                   Started                                        0.4s 
 ✔ Container nso-build                                                                                                                                  Started                                        0.4s
```
***Besides spinning up containers, the Compose file will direct following maps:***

       Host volume                             Containers
    * NSO-vol/nso/etc             -->      prod-container's /nso/etc
    * NSO-vol/nso/run             -->      prod-container's /nso/run
    * NSO-vol/nso-config/ncs.conf -->      prod-container's /etc/ncs.conf
    * NSO-vol/nso/run/packages    -->      dev-containere's /packages
    * NSO-log/                    -->      dev and prod container's /log
***Other loaded settings:***
    Startup development container with make all command to run ```util/make```
    Perform health checks on startup of production container with nso status.
    Refer docker-compose.yaml for more details.

## Makefile Overview
***The Makefile has the following targets:***

build:  
Copy essentials like ncs.conf and other files from NID volume system, load Contanerized NSO images (build and prod) and build the container enviorment having single instance.

deep_clean:   
deep_clean will call the following target 
clean_log clean_run clean  

clean_images:  
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

