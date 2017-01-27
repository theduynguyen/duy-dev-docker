help:
	@cat Makefile

DATA?="${HOME}/data"
WORK?="${HOME}/work"
SRC="${HOME}/projects"
GPU?=0
DOCKER_FILE=Dockerfile
DOCKER=GPU=$(GPU) nvidia-docker

build:
	docker build -t dl-duy -f $(DOCKER_FILE) .

bash: build
	$(DOCKER) run -it -v $(SRC):/src -v $(DATA):/data -v $(WORK):/work -p 6006:6006 dl-duy bash

ipython: build
	$(DOCKER) run -it -v $(SRC):/src -v $(DATA):/data -v $(WORK):/work -p 6006:6006 dl-duy ipython

notebook: build
	$(DOCKER) run -it -v $(SRC):/src -v $(DATA):/data -v $(WORK):/work -p 8888:8888 dl-duy