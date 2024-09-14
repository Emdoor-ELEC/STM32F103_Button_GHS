
MEMORY {

    // Reserve 0x8000 bytes for use by target-resident code or debug monitor
    dram_rsvd1   : ORIGIN = 0x02000000, LENGTH = 0x8000
    dram_memory  : ORIGIN = .,	 	LENGTH = 16M-0x8000
    dram_rsvd2   : ORIGIN = ., 	        LENGTH = 0

    flash_rsvd1  : ORIGIN = 0x00000000, LENGTH = 0
    flash_memory : ORIGIN = .,          LENGTH = 16M
    flash_rsvd2  : ORIGIN = .,          LENGTH = 0

}
DEFAULTS {

    heap_reserve = 1M
    stack_reserve = 512K

}
//
// Program layout for starting in ROM, copying test and data to RAM,
// and then running out of RAM.
//

SECTIONS
{

//
// ROM SECTIONS
//

    // The order and relative offsets of these
    // ROM startup code sections must be the
    // same in both the ROM and RAM copies.
    .ROM.boottext   		        ROM(.boottext ) : > flash_memory
    .ROM.syscall 		          ROM(.syscall) : > . 
    .ROM.intercall 		       ROM(.intercall)	: > .
    .ROM.interfunc 		       ROM(.interfunc)	: > .

    .rodata 					        : > flash_memory
    .sdata2 					        : > .

    .secinfo 					        : > . 
    .fixaddr 					        : > .
    .fixtype 					        : > .

    .CROM.sdata  		           CROM(.sdata)	: > .
    .CROM.data 			            CROM(.data) : > .
    .CROM.text  		            CROM(.text) : > .

//
// RAM SECTIONS
//

    .boottext : {
	  // All .text which is reachable between
	  // _start and __ghs_ind_crt1 needs to be
	  // pulled into .boottext and left
	  // uncompressed.
	  crt0.o(.text)
	  libboardinit.a(*)(.text) // optional library
	  libstartup.a(*)(.text)
	  libsys.a(ind_crt1.o)(.text)
     }                                                    > dram_memory
    .syscall					        : > .
    .intercall					        : > .
    .interfunc  				        : > .
    .text 					        : > .
   
    .sdabase 					        : > .
    .sbss 					        : > .
    .sdata 					        : > .
    .data 					        : > .
    .bss 					        : > .
    .ghcovfz					  CLEAR : > .
    .ghcovcz					  CLEAR : > .
    .ghcovdz					  CLEAR : > .
    .heap                   ALIGN(32) PAD( heap_reserve +
	    // Add space for call-graph profiling if used:
	    (isdefined(__ghs_indgcount)?(2000+(sizeof(.text)/2)):0) +
	    // Add estimated space for call-count profiling if used:
	    (isdefined(__ghs_indmcount)?10000:0) )
	    						: > .
    .stack                 ALIGN(32) PAD(stack_reserve) : > .

//
// These special symbols mark the bounds of RAM and ROM images of boot code.
// They are used by the GHS startup code (_start and __ghs_ind_crt0).
//
    __ghs_rombootcodestart  =  ADDR(.ROM.boottext);
    __ghs_rombootcodeend    =  ENDADDR(.fixtype);
    __ghs_rambootcodestart  =  ADDR(.boottext);
    __ghs_rambootcodeend    =  ENDADDR(.stack);	

//
// These special symbols mark the bounds of RAM and ROM memory.
// They are used by the MULTI debugger.
//
    __ghs_romstart  = MEMADDR(flash_rsvd1);
    __ghs_romend    = MEMENDADDR(flash_rsvd2);
    __ghs_ramstart  = MEMADDR(dram_rsvd1);
    __ghs_ramend    = MEMENDADDR(dram_rsvd2);

//
// This special symbol marks the the first address executed after the
// ROM to RAM copy is complete.  It is used by the MULTI debugger.
//
    __ghs_after_romcopy = __ghs_ind_crt1;
}

