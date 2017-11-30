# Set the working dir, where all compiled Verilog goes.
vlib work

# Compile all Verilog modules in mux.v to working dir;
# could also have multiple Verilog files.
# The timescale argument defines default time unit
# (used when no unit is specified), while the second number
# defines precision (all times are rounded to this value)
vlog -timescale 1ns/1ns game_controller.v

# Load simulation using mux as the top level simulation module.
vsim game_controller

# Log all signals and add some signals to waveform window.
log {/*}
# add wave {/*} would add all items in top level simulation module.
add wave {/*}

force {clk} 0 0ns, 1 5ns -repeat 10ns
force {resetn} 1 0ns, 0 15ns, 1 20ns
force {go} 0 0ns, 1 5ns, 0 10ns
force {gameClock_out} 0
run 800ns