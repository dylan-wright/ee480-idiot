VERILOG=iverilog
SIMENGINE=vvp
WAVEVIEWER=gtkwave

MODULES=alu.v register_file.v proccesor.v control.v memory.v
COMPILED=dsn
HEADERS=signals.v
TESTS=proccesor_tb.v
SIMS=proccesor_tb.vcd
COVMODS=$(MODULES:%=-v %) $(TESTS:%=-v %) 

all: $(SIMS)

$(COMPILED): $(MODULES) $(TESTS) $(HEADERS)
	$(VERILOG) -o $(COMPILED) $(MODULES) $(TESTS)

$(SIMS): $(COMPILED)
	$(SIMENGINE) $(COMPILED)

covrep: $(SIMS)
	covered score -t $(TESTS:.v=) $(COVMODS) -e memory -I . -vcd $(SIMS) -o top.cdd
	covered report -d v top.cdd | less

clean:
	rm $(COMPILED) $(SIMS)
