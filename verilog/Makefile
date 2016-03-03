VERILOG=iverilog
SIMENGINE=vvp
WAVEVIEWER=gtkwave

MODULES=alu.v proccesor.v
COMPILED=dsn
HEADERS=signals.v
TESTS=alu_tb.v
SIMS=alu_tb.vcd
COVMODS=$(MODULES:%=-v %) $(TESTS:%=-v %) 

all: $(SIMS)

$(COMPILED): $(MODULES) $(TESTS) $(HEADERS)
	$(VERILOG) -o $(COMPILED) $(MODULES) $(TESTS)

$(SIMS): $(COMPILED)
	$(SIMENGINE) $(COMPILED)

covrep: $(SIMS)
	covered score -t alu_tb $(COVMODS) -I . -vcd $(SIMS) -o top.cdd
	covered report -d v top.cdd | less

clean:
	rm $(COMPILED) $(SIMS)
