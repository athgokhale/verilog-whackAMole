# Set the working dir, where all compiled Verilog goes.
vlib work

# Compile all Verilog modules in mux.v to working dir;
# could also have multiple Verilog files.
# The timescale argument defines default time unit
# (used when no unit is specified), while the second number
# defines precision (all times are rounded to this value)
vlog -timescale 1ns/1ns rateCounter.v

# Load simulation using mux as the top level simulation module.
vsim rateCounter

# Log all signals and add some signals to waveform window.
log {/*}
# add wave {/*} would add all items in top level simulation module.
add wave {/*}


force {CLOCK_50} 0 0ns, 1 10ns -repeat 20ns

force {SW[0]} 1
force {SW[1]} 0

force {SW[2]} 0
force {SW[3]} 0
force {SW[4]} 0
force {SW[5]} 0
force {SW[6]} 0
force {SW[7]} 0
run 20ns

force {CLOCK_50} 0 0ns, 1 10ns -repeat 20ns

force {SW[0]} 1
force {SW[1]} 0

force {SW[2]} 1
force {SW[3]} 0
force {SW[4]} 0
force {SW[5]} 0
force {SW[6]} 0
force {SW[7]} 0

run 100ns



force {CLOCK_50} 0 0ns, 1 10ns -repeat 20ns

force {SW[0]} 1
force {SW[1]} 0

force {SW[2]} 1
force {SW[3]} 1
force {SW[4]} 0
force {SW[5]} 0
force {SW[6]} 1
force {SW[7]} 0

run 40ns




force {CLOCK_50} 0 0ns, 1 10ns -repeat 20ns

force {SW[0]} 1
force {SW[1]} 0

force {SW[2]} 1
force {SW[3]} 0
force {SW[4]} 0
force {SW[5]} 0
force {SW[6]} 0
force {SW[7]} 0

run 200ns


