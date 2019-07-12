PROJECT_NAME := $(notdir $(CURDIR))
setup:
	sed -i 's/#project#/${PROJECT_NAME}/' shell.nix
