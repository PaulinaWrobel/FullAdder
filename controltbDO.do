vcom -work work -2002 -explicit control2.vhd
vcom -work work -2002 -explicit controlTB.vhd

vsim work.control_tb
view wave -title CONTROL

add wave *
add wave sim:/control_tb/UUT/state
run -all
