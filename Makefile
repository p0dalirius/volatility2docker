.PHONY: build img

BINNAME := /bin/volatility2docker
IMGNAME := volatility2docker

all : build

build:
	docker build -t $(IMGNAME):latest -f Dockerfile .

install: build
	@if [ -f $(BINNAME) ]; then sudo rm -rf $(BINNAME); fi
	@printf '#!/bin/bash\ndocker run -it -v "$$(pwd):/workspace" $(IMGNAME) $${@}\n' | sudo tee -a $(BINNAME) > /dev/null
	@sudo chmod +x $(BINNAME)
	@if [ -f $(BINNAME) ]; then \
		echo "[+] Installed successfully in $(BINNAME)"; \
	else \
		echo '[!] Installation of $(BINNAME) failed.'; \
	fi

start: build
	docker run --rm -it $(IMGNAME)

background:
	docker run --rm -d $(IMGNAME)

shell:
	docker exec -it $(shell docker ps | grep $(IMGNAME) | awk '{split($$0,a," "); print a[1]}') bash

stop:
	docker stop $(shell docker ps | grep $(IMGNAME) | awk '{split($$0,a," "); print a[1]}')
