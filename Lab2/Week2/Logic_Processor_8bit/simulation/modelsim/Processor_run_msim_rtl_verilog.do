transcript on
if {[file exists rtl_work]} {
	vdel -lib rtl_work -all
}
vlib rtl_work
vmap work rtl_work

vlog -sv -work work +incdir+C:/Users/unbre/Documents/UIUC\ 2021-2025\ Course\ Info/2022-2023\ Spring\ Semester/ECE-385/Lab2/Week2/logic_processor_4bit {C:/Users/unbre/Documents/UIUC 2021-2025 Course Info/2022-2023 Spring Semester/ECE-385/Lab2/Week2/logic_processor_4bit/Synchronizers.sv}
vlog -sv -work work +incdir+C:/Users/unbre/Documents/UIUC\ 2021-2025\ Course\ Info/2022-2023\ Spring\ Semester/ECE-385/Lab2/Week2/logic_processor_4bit {C:/Users/unbre/Documents/UIUC 2021-2025 Course Info/2022-2023 Spring Semester/ECE-385/Lab2/Week2/logic_processor_4bit/Router.sv}
vlog -sv -work work +incdir+C:/Users/unbre/Documents/UIUC\ 2021-2025\ Course\ Info/2022-2023\ Spring\ Semester/ECE-385/Lab2/Week2/logic_processor_4bit {C:/Users/unbre/Documents/UIUC 2021-2025 Course Info/2022-2023 Spring Semester/ECE-385/Lab2/Week2/logic_processor_4bit/Reg_4.sv}
vlog -sv -work work +incdir+C:/Users/unbre/Documents/UIUC\ 2021-2025\ Course\ Info/2022-2023\ Spring\ Semester/ECE-385/Lab2/Week2/logic_processor_4bit {C:/Users/unbre/Documents/UIUC 2021-2025 Course Info/2022-2023 Spring Semester/ECE-385/Lab2/Week2/logic_processor_4bit/HexDriver.sv}
vlog -sv -work work +incdir+C:/Users/unbre/Documents/UIUC\ 2021-2025\ Course\ Info/2022-2023\ Spring\ Semester/ECE-385/Lab2/Week2/logic_processor_4bit {C:/Users/unbre/Documents/UIUC 2021-2025 Course Info/2022-2023 Spring Semester/ECE-385/Lab2/Week2/logic_processor_4bit/Control.sv}
vlog -sv -work work +incdir+C:/Users/unbre/Documents/UIUC\ 2021-2025\ Course\ Info/2022-2023\ Spring\ Semester/ECE-385/Lab2/Week2/logic_processor_4bit {C:/Users/unbre/Documents/UIUC 2021-2025 Course Info/2022-2023 Spring Semester/ECE-385/Lab2/Week2/logic_processor_4bit/compute.sv}
vlog -sv -work work +incdir+C:/Users/unbre/Documents/UIUC\ 2021-2025\ Course\ Info/2022-2023\ Spring\ Semester/ECE-385/Lab2/Week2/logic_processor_4bit {C:/Users/unbre/Documents/UIUC 2021-2025 Course Info/2022-2023 Spring Semester/ECE-385/Lab2/Week2/logic_processor_4bit/Register_unit.sv}
vlog -sv -work work +incdir+C:/Users/unbre/Documents/UIUC\ 2021-2025\ Course\ Info/2022-2023\ Spring\ Semester/ECE-385/Lab2/Week2/logic_processor_4bit {C:/Users/unbre/Documents/UIUC 2021-2025 Course Info/2022-2023 Spring Semester/ECE-385/Lab2/Week2/logic_processor_4bit/Processor.sv}

vlog -sv -work work +incdir+C:/Users/unbre/Documents/UIUC\ 2021-2025\ Course\ Info/2022-2023\ Spring\ Semester/ECE-385/Lab2/Week2/Logic_Processor_8bit/../logic_processor_4bit {C:/Users/unbre/Documents/UIUC 2021-2025 Course Info/2022-2023 Spring Semester/ECE-385/Lab2/Week2/Logic_Processor_8bit/../logic_processor_4bit/testbench_8.sv}

vsim -t 1ps -L altera_ver -L lpm_ver -L sgate_ver -L altera_mf_ver -L altera_lnsim_ver -L fiftyfivenm_ver -L rtl_work -L work -voptargs="+acc"  testbench_8

add wave *
view structure
view signals
run 1000 ns
