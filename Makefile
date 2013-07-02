# Makefile for building Tate Application
# Requires: underscore-cli (npm install -g underscore-cli)

SRC-DIR= ./src/*
CONFIG= ./src/config.json

# Loads the name from config.json
APP-NAME= $(shell cat $(CONFIG) | underscore extract name --outfmt text)
NODE-WEBKIT= /Applications/node-webkit.app/
PLIST-BUDDY= /usr/libexec/PlistBuddy

all: clean build

build: $(SRC-DIR)
	@# Build the nw, for shits and giggles
	@echo building: $(APP-NAME).nw
	@cp -rf src temp
	@cp $(CONFIG) temp/package.json
	@cd temp; zip -r app.nw *; cd ..
	@mkdir build
	@mv temp/app.nw build/app.nw
	@mv build/app.nw "build/$(APP-NAME).nw"
	@# Build the mac app
	@echo building: $(APP-NAME).app
	@cp -r $(NODE-WEBKIT) "build/$(APP-NAME).app"
	@cp -r temp "build/$(APP-NAME).app/Contents/Resources/app.nw"
	@# Set the app name
	@$(PLIST-BUDDY) -c "Set CFBundleName $(APP-NAME)" "build/$(APP-NAME).app/Contents/Info.plist"
	@# Clean up
	@echo "Cleaning up"
	@rm -rf temp
	@echo "Done."

clean: 
	@rm -rf build
	@rm -rf temp

.PHONY: build clean run