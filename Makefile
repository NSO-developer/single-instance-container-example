VER="6.3"
ENABLED_SERVICES=BUILD PROD
ARCH=x86_64
NID_DIR=$(pwd)/NSO-Vol
#Change below variable to "build" for newer versions 
BUILD_CONT=dev


build:
	-docker cp nid-prod:/etc/ncs/ncs.conf NSO-Vol/nso-config/
	-docker container stop nid-prod
	docker load -i ./images/nso-${VER}.container-image-${BUILD_CONT}.linux.${ARCH}.tar.gz
	docker load -i ./images/nso-${VER}.container-image-prod.linux.${ARCH}.tar.gz
	docker build -t mod-nso-prod:${VER}  --no-cache --network=host --build-arg type="prod"  --build-arg ver=${VER} --file Dockerfile .
	docker build -t mod-nso-dev:${VER}  --no-cache --network=host --build-arg type=${BUILD_CONT}  --build-arg ver=${VER} --file Dockerfile .
	cp util/Makefile NSO-vol/nso/run/packages/

deep_clean: clean_log clean_run clean

clean_images: 
	-docker image rm -f cisco-nso-${BUILD_CONT}:${VER}
	-docker image rm -f cisco-nso-prod:${VER}
	-docker image rm -f mod-nso-prod:${VER}  
	-docker image rm -f mod-nso-dev:${VER} 

clean_run:
	rm -rf ./NSO-vol/* 

clean_log:
	rm -rf ./NSO-log-vol/*	


stop:
	-docker stop nso-build && docker rm nso-build
	-docker stop nso-prod && docker rm nso-prod

start:
	docker run -d --name nso-prod -e ADMIN_USERNAME=admin -e ADMIN_PASSWORD=admin -e EXTRA_ARGS=--with-package-reload-force  -v ./NSO-vol/nso:/nso -v ./NSO-log-vol:/log mod-nso-prod:${VER} 
	docker run -d --name nso-build -v ./NSO-vol/nso/packages/:/nso/packages -v ./NSO-log-vol:/log mod-nso-dev:${VER}

start_compose:
	VER=${VER} docker-compose up ${ENABLED_SERVICES} -d


stop_compose:
	 export VER=${VER} ;docker-compose down  ${ENABLED_SERVICES}


compile_packages:
	docker exec -it nso-build make all -C /nso/run/packages

cli-c:
	docker exec -it nso-prod ncs_cli -C -u admin

cli-j:
	docker exec -it nso-prod ncs_cli -J -u admin
