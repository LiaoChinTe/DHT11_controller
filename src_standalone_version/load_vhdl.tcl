# Adapt the list of source files to your own project. List *only* the
# synthesizable files. Do *not* list simulation source files.

set source_files { 
	dht11_pkg_syn.vhd
	debouncer.vhd
	dht11_ctrl.vhd
	dht11_sa.vhd
	dht11_sa_top.vhd
	checksum.vhd
	cnt2.vhd
	cnt40.vhd
	constants_pkg.vhd	
	errGrouper.vhd
	fsm.vhd
	mux2x1.vhd
	selector.vhd
	shiftReg.vhd
	syncAndPulse.vhd
	timeout.vhd
	timer.vhd
        pe_register.vhd
        
}

foreach f $source_files {
	add_files $rootdir/$f
}

