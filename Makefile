CXX		= g++

SRC_DIR		:= src
TB_SRC_DIR	:= tb_src

vpath %.cpp $(TB_SRC_DIR)
vpath %.h $(TB_SRC_DIR)

SRCS_SV		= $(wildcard $(SRC_DIR)/*.sv)
SRCS_CPP	= $(wildcard $(TB_SRC_DIR)/*.cpp)
OBJS		= $(patsubst $(TB_SRC_DIR)/%.cpp,%.o,$(SRCS_CPP))
DEPS		= $(patsubst %.o,.%.d,$(OBJS))
EXE		= simulation.x

CXXFLAGS	= -Wall -g -O3
LDLIBS		= -lsystemc
LDFLAGS		= -g

all: $(EXE)

$(EXE): $(OBJS)
	$(CXX) $(LDFLAGS) $^ -o $@ $(LDLIBS)

.%.d: %.cpp
	$(CXX) $(CPPFLAGS) -MM -MF $@ $<

lint:
	verilator --lint-only -Wall $(SRCS_SV)

clean:
	$(RM) $(EXE)
	$(RM) $(OBJS)
	$(RM) $(DEPS)

.PHONY: lint clean all

ifneq ($(MAKECMDGOALS),clean)
ifneq ($(MAKECMDGOALS),lint)
-include $(DEPS)
endif
endif
