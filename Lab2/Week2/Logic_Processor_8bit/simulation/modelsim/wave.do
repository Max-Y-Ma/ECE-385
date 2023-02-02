onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -radix hexadecimal /testbench_8/Clk
add wave -noupdate -radix hexadecimal /testbench_8/Reset
add wave -noupdate -radix hexadecimal /testbench_8/LoadA
add wave -noupdate -radix hexadecimal /testbench_8/LoadB
add wave -noupdate -radix hexadecimal /testbench_8/Execute
add wave -noupdate -radix hexadecimal /testbench_8/Din
add wave -noupdate -radix binary /testbench_8/F
add wave -noupdate -radix binary /testbench_8/R
add wave -noupdate -radix binary /testbench_8/LED
add wave -noupdate -radix hexadecimal /testbench_8/Aval
add wave -noupdate -radix hexadecimal /testbench_8/Bval
add wave -noupdate -radix hexadecimal /testbench_8/AhexL
add wave -noupdate -radix hexadecimal /testbench_8/AhexU
add wave -noupdate -radix hexadecimal /testbench_8/BhexL
add wave -noupdate -radix hexadecimal /testbench_8/BhexU
add wave -noupdate -radix hexadecimal /testbench_8/ans_1a
add wave -noupdate -radix hexadecimal /testbench_8/ans_2b
add wave -noupdate -radix hexadecimal /testbench_8/ErrorCnt
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {1000208 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 150
configure wave -valuecolwidth 100
configure wave -justifyvalue left
configure wave -signalnamewidth 0
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ns
update
WaveRestoreZoom {0 ps} {1024 ns}
