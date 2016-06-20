vcom -work work -2002 -explicit DFlipFlop.vhd
vcom -work work -2002 -explicit fullAdder.vhd
vcom -work work -2002 -explicit register.vhd
vcom -work work -2002 -explicit executiveSystem.vhd
vcom -work work -2002 -explicit control2.vhd
vcom -work work -2002 -explicit serialAdder.vhd
vcom -work work -2008 -explicit serialAdderTB.vhd

vsim -assertdebug -msgmode both serialAdderTB
view wave -title "Serial Adder"
add wave -radix unsigned *
add wave -position end sim:/serialaddertb/UUT/controlUnit/state


run -all
