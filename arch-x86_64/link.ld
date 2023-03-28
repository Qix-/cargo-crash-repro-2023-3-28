OUTPUT_FORMAT(elf64-x86-64)
OUTPUT_ARCH(i386:x86-64)

ENTRY(_start)

PHDRS
{
	headers PT_PHDR      FILEHDR PHDRS ;
	boot    PT_LOAD      PHDRS ;
	null    PT_NULL      FLAGS(0) ;
	text    PT_LOAD      FLAGS((1 << 0) | (1 << 2)) ; /* rx */
	rodata  PT_LOAD      FLAGS((1 << 2)) ;            /* r */
	data    PT_LOAD      FLAGS((1 << 1) | (1 << 2)) ; /* rw */
	meta    PT_NOTE      ;
}

SECTIONS
{
	. = 0xffffffff80000000;

	.text : {
		*(.text .text.*)
	} :text

	. += CONSTANT(MAXPAGESIZE);

	.stivale2hdr : {
		KEEP(*(.stivale2hdr))
	} :rodata

	.rodata : {
		*(.rodata .rodata.*)
	} :rodata

	. += CONSTANT(MAXPAGESIZE);

	.data : {
		*(.data .data.*)
	} :data

	.bss : {
		*(COMMON)
		*(.bss .bss.*)
	} :data
}
