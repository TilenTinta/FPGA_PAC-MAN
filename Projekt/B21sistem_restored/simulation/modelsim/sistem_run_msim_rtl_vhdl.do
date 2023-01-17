transcript on
if {[file exists rtl_work]} {
	vdel -lib rtl_work -all
}
vlib rtl_work
vmap work rtl_work

vcom -93 -work work {C:/Users/titit/Desktop/FPGA_PAC-MAN/Projekt/B21sistem_restored/procpak.vhd}
vcom -2008 -work work {C:/Users/titit/Desktop/FPGA_PAC-MAN/Projekt/B21sistem_restored/grafika.vhd}
vcom -2008 -work work {C:/Users/titit/Desktop/FPGA_PAC-MAN/Projekt/B21sistem_restored/io.vhd}
vcom -93 -work work {C:/Users/titit/Desktop/FPGA_PAC-MAN/Projekt/B21sistem_restored/VGAvmesnik.vhd}
vcom -93 -work work {C:/Users/titit/Desktop/FPGA_PAC-MAN/Projekt/B21sistem_restored/program.vhd}
vcom -93 -work work {C:/Users/titit/Desktop/FPGA_PAC-MAN/Projekt/B21sistem_restored/cpu.vhd}
vcom -93 -work work {C:/Users/titit/Desktop/FPGA_PAC-MAN/Projekt/B21sistem_restored/proc.vhd}
vcom -93 -work work {C:/Users/titit/Desktop/FPGA_PAC-MAN/Projekt/B21sistem_restored/sistem.vhd}

