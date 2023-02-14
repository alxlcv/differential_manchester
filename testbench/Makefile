
SIMCOMPILER = iverilog
SIMULATOR = vvp
VIEWER = gtkwave


#SIMCOMPFLAGS = -v -o
SIMCOMPFLAGS = -o
#SIMFLAGS = -v
SIMFLAGS =

COMMON_DIR = ../common/
RTL_DIR = ../rtl/

SRCS = $(wildcard *.v)
SRCS += $(wildcard $(COMMON_DIR)*.v)
SRCS += $(wildcard $(RTL_DIR)*.v)

TBSRCS = $(filter %_tb.v, $(SRCS))
MODSRCS = $(filter-out %_tb.v %_incl.v, $(SRCS))
VVPS = $(patsubst %.v,%.vvp,$(TBSRCS))
VCDS = $(patsubst %_tb.v,%_tb.vcd,$(TBSRCS))

GTKCONF = $(patsubst %_tb.v,%_tb.gtkw,$(TBSRCS))

all: disp

sim: $(VCDS)

$(VVPS): %.vvp: %.v $(MODSRCS)
	$(SIMCOMPILER) $(SIMCOMPFLAGS) $(VVPS) $^ 

$(VCDS): %_tb.vcd: %_tb.vvp
	$(SIMULATOR) $(SIMFLAGS) $<
        
disp: $(VCDS)
	$(VIEWER) -O /dev/null $(VCDS) $(GTKCONF) &

clean:
	rm -f $(wildcard *.vvp) $(wildcard *.vcd)
#	del $(wildcard *.vvp) $(wildcard *.vcd)
