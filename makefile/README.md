# Makefile

Makefile basic template inspired by [Kévin Dunglas](https://github.com/dunglas/symfony-docker/blob/main/docs/makefile.md).  

To use it, create a new `Makefile` file at the root of your project.  
Copy/paste the content in the template section.
To view all the available commands, run `make`.

You can find a more complete symfony based example in this [snippet](https://www.strangebuzz.com/en/snippets/the-perfect-makefile-for-symfony).  

**PS**: If using Windows, you have to install [chocolatey.org](https://chocolatey.org/)
or use [Cygwin](http://cygwin.com) to use the `make` command. Check out this
[StackOverflow question](https://stackoverflow.com/q/2532234/633864) for more explanations.

## The template

```Makefile
# Executables (local)
DOCKER_COMP = docker compose

# Misc
.DEFAULT_GOAL = help

## 
## —— 😎 My super Makefile 😎 ——————————————————————————————————————————————
help: ## Outputs this help screen
    @grep -E '(^[a-zA-Z0-9\./_-]+:.*?##.*$$)|(^##)' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}{printf "\033[32m%-30s\033[0m %s\n", $$1, $$2}' | sed -e 's/\[32m##/[33m/'

## 
## —— Project1 🚀 ———————————————————————————————————————————————————————————
start_project1: ## Start project1
    @$(DOCKER_COMP) up -d project1

.PHONY: start_project1

## 
```

## Samples

- [node-npm with only runnable docker containers](samples/node-npm.Makefile)