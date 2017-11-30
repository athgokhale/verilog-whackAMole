# Set the working dir, where all compiled Verilog goes.
vlib work

# Compile all Verilog modules in mux.v to working dir;
# could also have multiple Verilog files.
# The timescale argument defines default time unit
# (used when no unit is specified), while the second number
# defines precision (all times are rounded to this value)
vlog -timescale 1ns/1ns gameClock.v

# Load simulation using mux as the top level simulation module.
vsim gameClock

# Log all signals and add some signals to waveform window.
log {/*}
# add wave {/*} would add all items in top level simulation module.
add wave {/*}

force {CLOCK_50} 0 0ns, 1 5ns -repeat 10ns
force {SW[2]} 0 0ns, 1 10ns, 0 200ns, 1 210ns
force {SW[3]} 0

force {SW[7]} 0
force {SW[6]} 0
force {SW[5]} 1
force {SW[4]} 0
force {start_timer} 1
run 800ns