#=======================================================================================
# File: run.sh
# Description: Shell script for compiling and simulating the FIFO UVM testbench using VCS and Verdi.
#=======================================================================================

#========================= Compilation and Elaboration ==================================
#    -sverilog: Specifies SystemVerilog file compilation
#    -full64: Uses 64-bit VCS tool (supports 32-bit and 64-bit tools)
#    -debug_access+all: Enables full debug access for all components
#    -kdb: Generates a database for Verdi waveform viewing
#=======================================================================================
vcs -sverilog -full64 -debug_access+all -kdb	\
		+incdir+../top	\
		+incdir+../slave  \
		+incdir+../master	\
		+incdir+../common	\
		+incdir+../src	\
		+define+UVM_NO_DPI	\
		-l comp.log	\
		-cm line+cond+tgl+fsm+assert+branch	\
		fifo_list.sv
#---------------------------------------------------------------------------------------

#================================ Simulation ===========================================
#    Executes simulation with specified test and random seed
#    Generates coverage metrics for line, condition, toggle, FSM, assertion, and branch
#=======================================================================================
#-----> TESTS
# 1. wr_rd_test  ||  2.fifo_n_wr_rd_test  || 3.fifo_overflow_test 
# 4. fifo_underflow_test  ||  5. fifo_full_then_empty_test


./simv -l sim.log +ntb_random_seed=486585 +UVM_TESTNAME=fifo_underflow_test +UVM_VERBOSITY=UVM_MEDIUM 	\
		+UVM_RESOURCE_DB_TRACE	\
	   -cm line+cond+tgl+fsm+assert+branch	

#---------------------------------------------------------------------------------------

