#!/bin/bash

iverilog -o pipelinedTopLvlCompileOut ./rtl/aluController.v  ./rtl/ALU.v ./rtl/controlUnit.v  ./rtl/dataMemory.v ./rtl/immediateGenerator.v ./rtl/instrnMemory.v ./rtl/registers.v ./rtl/executeStage.v ./rtl/instructionFetch.v ./rtl/instructionDecode.v ./rtl/memoryStage.v ./rtl/risc_v_toplevel.v ./rtl/writeBackStage.v ./rtl/forwarding.v ./rtl/hazardDetection.v ./sim/mainTestBench.v

vvp pipelinedTopLvlCompileOut

open mainTestTrace.vcd

