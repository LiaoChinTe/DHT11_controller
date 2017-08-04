# Adapt the list of source files to your own project. List *only* the
# synthesizable files. Do *not* list simulation source files.

set source_files { 
	dht11_pkg_syn.vhd
	debouncer.vhd
	dht11_ctrl.vhd
	axi_pkg.vhd
	dht11_axi.vhd
	dht11_axi_top.vhd

	checksum.vhd
	cnt2.vhd
	cnt40.vhd
	constants_pkg.vhd	
	fsm.vhd
	shiftReg.vhd
	syncAndPulse.vhd
	timeout.vhd
	pe_register.vhd
	timer.vhd
	regNbit1rst.vhd
	regNbit0rst.vhd
	fsm_axi_mts.vhd
	fsm_axi_stm.vhd
	mux2to1_Nbit.vhd
	timerN.vhd
}

foreach f $source_files {
	add_files $rootdir/$f
}

