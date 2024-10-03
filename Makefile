VER="6.2.3"
ENABLED_SERVICES=NSO-1 BUILD-NSO-PKGS
ARCH=x86_64


build:
	docker load -i ./images/nso-${VER}.container-image-dev.linux.${ARCH}.tar.gz
	docker load -i ./images/nso-${VER}.container-image-prod.linux.${ARCH}.tar.gz
	docker build -t mod-nso-prod:${VER}  --no-cache --network=host --build-arg type="prod"  --build-arg ver=${VER}    --file Dockerfile .
	docker build -t mod-nso-dev:${VER}  --no-cache --network=host --build-arg type="dev"  --build-arg ver=${VER}   --file Dockerfile .
	docker run -d --name nso-prod -e ADMIN_USERNAME=admin -e ADMIN_PASSWORD=admin -e EXTRA_ARGS=--with-package-reload-force -v ./NSO-vol:/nso -v ./NSO-log-vol:/log mod-nso-prod:${VER}
	sleep 10
	docker stop nso-prod && docker rm nso-prod
	cp util/Makefile NSO-vol/run/packages/

deep_clean: clean_log clean_run clean

clean: 
	-docker image rm -f cisco-nso-dev:${VER}
	-docker image rm -f cisco-nso-prod:${VER}
	-docker image rm -f mod-nso-prod:${VER}  
	-docker image rm -f mod-nso-dev:${VER} 

clean_run:
	rm -rf ./NSO-vol/* 

clean_log:
	rm -rf ./NSO-log-vol/*	

stop:
	-docker stop nso-dev && docker rm nso-dev
	-docker stop nso-prod && docker rm nso-prod

start:
	docker run -d --name nso-prod -e ADMIN_USERNAME=admin -e ADMIN_PASSWORD=admin -e EXTRA_ARGS=--with-package-reload-force  -v ./NSO-vol:/nso -v ./NSO-log-vol:/log mod-nso-prod:${VER} 
	docker run -d --name nso-dev -v ./NSO-vol:/nso -v ./NSO-log-vol:/log mod-nso-dev:${VER}

start_compose:
	export VER=${VER} ; docker-compose up ${ENABLED_SERVICES} -d


stop_compose:
	 export VER=${VER} ;docker-compose down  ${ENABLED_SERVICES}


compile_packages:
	docker exec -it nso-dev make all -C /nso/run/packages

cli-c:
	docker exec -it nso-prod ncs_cli -C -u admin

cli-j:
	docker exec -it nso-prod ncs_cli -J -u admin
