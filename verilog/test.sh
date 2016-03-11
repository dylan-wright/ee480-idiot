#!/bin/bash
dir=tests/proccesor/
# alu
echo "--> Executing alu_tb"
iverilog alu.v alu_tb.v signals.v
vvp a.out
rm a.out alu_tb.vcd
echo
# mem
echo "--> Executing memory_tb"
iverilog memory.v memory_tb.v signals.v
vvp a.out
rm a.out memory_tb.vcd
echo
# reg
echo "--> Executing register_file_tb"
iverilog register_file.v register_file_tb.v signals.v
vvp a.out
rm a.out register_file_tb.vcd
echo

# proccessor/control
for f in $dir*.vmem
do
    base=${f%.vmem}
    testname=${base##*/}
    tempmem="temp_memory.v"
    echo "--> Executing $testname"
    cp $f tmp.vmem
    sed -r -e "s/readmemh.*$/readmemh(\"tmp.vmem\");/" < memory.v > $tempmem
    iverilog alu.v memory.v register_file.v proccesor.v control.v proccesor_tb.v signals.v
    vvp a.out
    rm a.out proccesor_tb.vcd
echo
done

rm tmp.vmem temp_memory.v
