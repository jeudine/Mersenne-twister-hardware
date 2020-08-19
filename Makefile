SRC_DIR		:= src
TB_SRC_DIR	:= tb_src
OBJ_DIR		:= obj

SRCS_SV		= $(wildcard $(SRC_DIR)/*.sv)
SRCS_CPP	= $(wildcard $(TB_SRC_DIR)/*.cpp)
EXE		= simulation.x

CXX		= gcc
CXXFLAGS	= -Wall -Werror -g -O3
LDFLAGS		= -g
VFLAGS		= --sc --pins-uint8 --exe -Wall -O3 --trace\
		  --Mdir $(OBJ_DIR) --compiler $(CXX)\
		  $(patsubst %, -CFLAGS %, $(CXXFLAGS))\
		  $(patsubst %, -LDFLAGS %, $(LDFLAGS))\
		  --MP --top-module MTwister -o ../$(EXE)

all: $(EXE)

$(OBJ_DIR)/VMTwister.mk: $(SRCS_SV) $(SRCS_CPP)
	verilator $(VFLAGS) $^

$(EXE): $(OBJ_DIR)/VMTwister.mk
	make -C $(OBJ_DIR) -f VMTwister.mk

lint:
	verilator --lint-only -Wall $(SRCS_SV)

clean:
	$(RM) $(EXE)
	$(RM) -r $(OBJ_DIR)
	$(RM) *.vcd

.PHONY: lint clean all $(EXE)
