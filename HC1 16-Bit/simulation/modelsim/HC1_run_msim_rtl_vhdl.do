transcript on
if {[file exists rtl_work]} {
	vdel -lib rtl_work -all
}
vlib rtl_work
vmap work rtl_work

vcom -93 -work work {E:/Programming/GitHub/HC1-16-Bit/src/seven_segment.vhd}
vcom -93 -work work {E:/Programming/GitHub/HC1-16-Bit/src/memory_unit.vhd}
vcom -93 -work work {E:/Programming/GitHub/HC1-16-Bit/src/instruction_register.vhd}
vcom -93 -work work {E:/Programming/GitHub/HC1-16-Bit/src/control_unit.vhd}
vcom -93 -work work {E:/Programming/GitHub/HC1-16-Bit/src/arithmetic_logic_unit.vhd}
vcom -93 -work work {E:/Programming/GitHub/HC1-16-Bit/src/accumulator.vhd}
vcom -93 -work work {E:/Programming/GitHub/HC1-16-Bit/src/program_counter.vhd}
vcom -93 -work work {E:/Programming/GitHub/HC1-16-Bit/src/clock_divider.vhd}
vcom -93 -work work {E:/Programming/GitHub/HC1-16-Bit/src/cpu.vhd}
vcom -93 -work work {E:/Programming/GitHub/HC1-16-Bit/src/HC1.vhd}

