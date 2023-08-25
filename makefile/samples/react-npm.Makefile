CURRENT_UID         	= $(shell id -u)
CURRENT_GID         	= $(shell id -g)
CURRENT_PATH        	= $(shell pwd)

NODE_IMG            	= node:lts-alpine
NODE_PORTS          	= 3000:3000
NODE_WORKSPACE			= /usr/src 

DOCKER_OPT_USER     	= -u $(CURRENT_UID):$(CURRENT_GID)
DOCKER_OPT_VOLUMES  	= -v $(CURRENT_PATH):$(NODE_WORKSPACE) 
DOCKER_OPT_WORKSPACE	= -w $(NODE_WORKSPACE) 
DOCKER_OPT_PORTS		= -p $(NODE_PORTS)

DOCKER_RUN 				= docker run -it --rm $(DOCKER_OPT_USER)
DOCKER_RUN_NODE     	= $(DOCKER_RUN) $(DOCKER_OPT_WORKSPACE) $(DOCKER_OPT_VOLUMES) $(DOCKER_OPT_PORTS) $(NODE_IMG)

.DEFAULT_GOAL :=    	help
.PHONY:   

help:
	@grep -Eh '(^[a-zA-Z_-]+:.*?##.*$$)|(^##)' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[32m%-30s\033[0m %s\n", $$1, $$2}' | sed -e 's/\[32m##/[33m/'


## 
##Create
##-----------------------------------------------------------------------------
.PHONY: create-react-pwa create-react-app

create-react-pwa: ## Create a react pwa
	@make -s create-react-app template=cra-template-pwa

create-react-app: ## args: t="[template]" - Create a react app
ifneq ($(wildcard $(CURRENT_PATH)/src/.),)
    @echo "src folder exist remove it to create an app"
else
ifndef template
	@make -s npx c="create-react-app app"
else
	@make -s npx c="create-react-app app --template $(template)"
endif
	@chown -R $(CURRENT_UID):$(CURRENT_GID) app/
	@mv app/* ./ 
	@rm -rf app/
endif


##
##Commands 
##-----------------------------------------------------------------------------
.PHONY: node npm npx

node: ## args: c="[command]" - Execute a node command
	@$(DOCKER_RUN_NODE) $(c)
 
npm: ## args: c="[command]" - Execute a npm command 
	@$(DOCKER_RUN_NODE) npm $(c)

npx: ## args: c="[command]" - Execute a npx command
	@$(DOCKER_RUN_NODE) npx $(c)


## 
##Dependencies
##-----------------------------------------------------------------------------
.PHONY: installReq install update

installReq: package-lock.json 

package-lock.json: package.json
	@make -s npm c=install

install: | package.json ## Install dependencies
	@make -s npm c=install

update: | package.json ## Update dependencies
	@make -s npm c=update


## 
##Project 
##-----------------------------------------------------------------------------
.PHONY: buildReq build start serve

buildReq: build/

build/: public/ src/ node_modules/
	@make -s npm c="run build"

build: installReq | src/ ## Build project
	@make -s npm c="run build"

start: installReq | src/ ## Start project
	@@make -s npm c=start

serve: installReq buildReq ## Serve project
	@$(DOCKER_RUN_NODE) sh -c "npm install -g serve && serve -s build"

##
