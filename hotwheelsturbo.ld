SECTIONS
{
    __romPos = 0x0;
    . = __romPos;
    header_ROM_START = __romPos;
    header_VRAM = ADDR(.header);
    .header  : AT(header_ROM_START) SUBALIGN(16)
    {
        header_s = .;
        build/asm/header.s.o(.data);
    }
    header_ROM_END = 0x40;
    __romPos = 0x40;

    __romPos = 0x40;
    . = __romPos;
    boot_ROM_START = __romPos;
    boot_VRAM = ADDR(.boot);
    .boot  : AT(boot_ROM_START) SUBALIGN(16)
    {
        boot_bin = .;
        build/assets/boot.bin.o(.data);
    }
    boot_ROM_END = 0x1000;
    __romPos = 0x1000;

    __romPos = 0x1000;
    . = __romPos;
    main_ROM_START = __romPos;
    main_VRAM = ADDR(.main);
    .main 0x80060400 : AT(main_ROM_START) SUBALIGN(16)
    {
        _1000_s = .;
        build/asm/1000.s.o(.text);
        _5BC0_s = .;
        build/asm/5BC0.s.o(.text);
        _6050_s = .;
        build/asm/6050.s.o(.text);
    }
    main_ROM_END = 0x88890;
    __romPos = 0x88890;

    __romPos = 0x88890;
    . = __romPos;
    _88890_ROM_START = __romPos;
    _88890_VRAM = ADDR(._88890);
    ._88890  : AT(_88890_ROM_START) SUBALIGN(16)
    {
        _88890_bin = .;
        build/assets/88890.bin.o(.data);
    }
    _88890_ROM_END = 0xC33E0;
    __romPos = 0xC33E0;

    __romPos = 0xC33E0;
    . = __romPos;
    ptrtable_ROM_START = __romPos;
    ptrtable_VRAM = ADDR(.ptrtable);
    .ptrtable  : AT(ptrtable_ROM_START) SUBALIGN(16)
    {
        ptrtable_bin = .;
        build/assets/ptrtable.bin.o(.data);
    }
    ptrtable_ROM_END = 0xC9060;
    __romPos = 0xC9060;

    __romPos = 0xC9060;
    . = __romPos;
    wavetable_ROM_START = __romPos;
    wavetable_VRAM = ADDR(.wavetable);
    .wavetable  : AT(wavetable_ROM_START) SUBALIGN(16)
    {
        wavetable_bin = .;
        build/assets/wavetable.bin.o(.data);
    }
    wavetable_ROM_END = 0xC00000;
    __romPos = 0xC00000;

    /DISCARD/ :
    {
        *(*);
    }
}
