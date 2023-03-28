OUTPUT_FORMAT(elf32-i386)
OUTPUT_ARCH(i386:x86)

ENTRY(_start)

BOOT_ADDRESS   = 0x00100000;
PAGE_SIZE      = 0x1000;

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

SECTIONS {
	. = BOOT_ADDRESS;

	.text.init : {
		. = ALIGN(8);
		*(.multiboot2)
		*(.multiboot)
		*(.text.init)
	} : boot

	.data.init : {
		*(.data.init)
	}

	.bss.init : {
		*(.bss.init)
	}

	.text ALIGN(PAGE_SIZE) : AT(ADDR(.text)) {
		*(.text, .text.*)
	} : text

	.rodata ALIGN(PAGE_SIZE) : AT(ADDR(.rodata)) {
		*(.rodata, .rodata.*)
	} : rodata

	.data ALIGN(PAGE_SIZE) : AT(ADDR(.data)) {
		*(.data, .data.*)
	} : data

	.bss ALIGN(PAGE_SIZE) : AT(ADDR(.bss)) {
		*(.bss, .bss.*)
	}
}
