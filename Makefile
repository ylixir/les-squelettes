PROJECT_NAME := $(notdir $(CURDIR))
SOURCES := hello.cpp

CT_BINUTILS_PATH = $(shell nix-build '<nixpkgs>' -A binutils --no-out-link)
CT_CLANG_PATH = $(shell nix-build '<nixpkgs>' -A clang_8 --no-out-link)
CT_CXXFLAGS = $(shell bash -c ' \
	source $(CT_CLANG_PATH)/nix-support/utils.bash; \
	source $(CT_BINUTILS_PATH)/nix-support/add-flags.sh; \
	source $(CT_CLANG_PATH)/nix-support/add-flags.sh; \
	echo $$NIX_x86_64_unknown_linux_gnu_CFLAGS_COMPILE $$NIX_x86_64_unknown_linux_gnu_CXXSTDLIB_COMPILE \
	')
CXX := clang++
BIN_FOLDER := bin
OBJ_FOLDER := obj
SRC_FOLDER := src
BINARY := $(BIN_FOLDER)/$(PROJECT_NAME)
OBJECTS = $(patsubst %.cpp, $(OBJ_FOLDER)/%.o, $(SOURCES)) 

#this just changes the name of the project in nix
#it can be safely deleted after make is run for the first time
setup:
	sed -i 's/#project#/${PROJECT_NAME}/' shell.nix

run: $(BINARY)
	./$(BINARY)

$(BINARY): $(OBJECTS) | $(BIN_FOLDER)
	$(CXX) -o $@ $^

clean:
	rm $(OBJECTS) $(BINARY)

$(OBJ_FOLDER)/%.o: $(SRC_FOLDER)/%.cpp | $(OBJ_FOLDER)
	@echo linting $<
	@clang-tidy $< -- $(CT_CXXFLAGS)
	@echo compiling $<
	$(CXX) -c $< -o $@

$(OBJ_FOLDER):
	mkdir -p $(OBJ_FOLDER)
$(BIN_FOLDER):
	mkdir -p $(BIN_FOLDER)

