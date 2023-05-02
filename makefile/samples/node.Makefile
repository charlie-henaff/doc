-include .env .env.local

CURRENT_UID 		= $(shell id -u)
CURRENT_GID 		= $(shell id -g)
CURRENT_PATH 		= $(shell pwd)

NODE_IMG 			= node:lts-alpine
NODE_PORTS 			= 3000:3000

DOCKER_VOLUMES		= -v $(CURRENT_PATH):/usr/src
DOCKER_RUN			= docker run $(DOCKER_EXTRA_PARAMS) --rm -u $(CURRENT_UID):$(CURRENT_GID) 
DOCKER_RUN_NODE 	= $(DOCKER_RUN) -w /usr/src $(DOCKER_VOLUMES) -p $(NODE_PORTS) $(NODE_IMG)

.DEFAULT_GOAL := 	help
.PHONY: 			help

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
	@$(DOCKER_RUN_NODE) npx create-react-app app
else
	@$(DOCKER_RUN_NODE) npx create-react-app app --template $(template) 
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
##Project 
##-----------------------------------------------------------------------------
.PHONY: build start serve

package.json.lock.tmp: package.json.lock
	@$(DOCKER_RUN_NODE) npm install
	@touch package.json.lock.tmp

build: package.json.lock.tmp ## Build project
	@$(DOCKER_RUN_NODE) npm build

start: package.json.lock.tmp ## Start project
	@$(DOCKER_RUN_NODE) npm start

serve: package.json.lock.tmp build  ## Serve project
	@$(DOCKER_RUN_NODE) npm serve -s build

##