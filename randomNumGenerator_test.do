# Set the working dir, where all compiled Verilog goes.
vlib work

# Compile all Verilog modules in mux.v to working dir;
# could also have multiple Verilog files.
# The timescale argument defines default time unit
# (used when no unit is specified), while the second number
# defines precision (all times are rounded to this value)
vlog -timescale 1ns/1ns LFSR.v

# Load simulation using mux as the top level simulation module.
vsim LFSR

# Log all signals and add some signals to waveform window.
log {/*}
# add wave {/*} would add all items in top level simulation module.
add wave {/*}

force {clock} 0 0ns, 1 5ns -repeat 10ns

#force {seed} 0001
#force load 0 0ns, 1 15ns, 0 20ns
force {reset} 0 0ns, 1 5ns, 0 10ns

run 1000ns