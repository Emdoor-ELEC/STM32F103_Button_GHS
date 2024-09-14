
MEMORY {

// 20KB of 32 bit internal RAM starting at 0x20000000

    dram_rsvd1   : ORIGIN = 0x20000000, LENGTH = 0
    dram_memory  : ORIGIN = .,	        LENGTH = 64k
    dram_rsvd2   : ORIGIN = ., 	        LENGTH = 0

// 128KB flash starting at 0x08000000

    flash_rsvd1  : ORIGIN = 0x08000000, LENGTH = 0
    flash_memory : ORIGIN = .,          LENGTH = 512k
    flash_rsvd2  : ORIGIN = .,          LENGTH = 0

}
DEFAULTS {

    heap_reserve = 0x00000200//1k
    stack_reserve = 0x00000400//1K

}
//
// Program layout for running out of RAM.
//
//

SECTIONS
{

//
// The text segment
//

    .picbase                                            : > dram_memory
    .text                                               : > .
    .syscall                                            : > .
    .intercall                                          : > .
    .interfunc                                          : > .
    .fixaddr                                            : > .
    .fixtype                                            : > .
    .rodata                                             : > .
    .secinfo                                            : > .

//
// The data segment
//

    .pidbase                                  ALIGN(32) : > .
    .sdabase                                            : > .
    .sbss                                               : > .
    .sdata                                              : > .
    .data                                               : > .
    .bss                                                : > .
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
// These special symbols mark the bounds of RAM and ROM memory.
// They are used by the MULTI debugger.
//
    __ghs_romstart  = MEMADDR(flash_rsvd1);
    __ghs_romend    = MEMENDADDR(flash_rsvd2);
    __ghs_ramstart  = MEMADDR(dram_rsvd1);
    __ghs_ramend    = MEMENDADDR(dram_rsvd2);
        
}
