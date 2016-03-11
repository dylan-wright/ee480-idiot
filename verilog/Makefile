VERILOG=iverilog
SIMENGINE=vvp
WAVEVIEWER=gtkwave

MODULES=alu.v register_file.v proccesor.v control.v memory.v
COMPILED=dsn
HEADERS=signals.v
TESTS=proccesor_tb.v
SIMS=proccesor_tb.vcd
COVMODS=$(MODULES:%=-v %) $(TESTS:%=-v %) 
COVDB=top.cdd
COVREP=covreport.txt

all: $(SIMS)

$(COMPILED): $(MODULES) $(TESTS) $(HEADERS)
	$(VERILOG) -o $(COMPILED) $(MODULES) $(TESTS)

$(SIMS): $(COMPILED)
	$(SIMENGINE) $(COMPILED)

covrep: $(SIMS)
	covered score -t $(TESTS:.v=) $(COVMODS) -I . -e memory -vcd $(SIMS) -o $(COVDB)
	covered report -d v $(COVDB) > $(COVREP)

clean:
	rm $(COMPILED) $(SIMS) $(COVDB) $(COVREP)
