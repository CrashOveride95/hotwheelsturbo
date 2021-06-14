BASENAME  = hotwheelsturbo
VERSION  := us

BUILD_DIR = build

ASM_DIRS  = asm asm/libultra/os
SRC_DIRS  = src
BIN_DIRS  = assets

TOOLS_DIR := tools


S_FILES   = $(foreach dir,$(ASM_DIRS),$(wildcard $(dir)/*.s))
C_FILES   = $(foreach dir,$(SRC_DIRS),$(wildcard $(dir)/*.c))
BIN_FILES = $(foreach dir,$(BIN_DIRS),$(wildcard $(dir)/*.bin))

O_FILES := $(foreach file,$(S_FILES),$(BUILD_DIR)/$(file).o) \
           $(foreach file,$(C_FILES),$(BUILD_DIR)/$(file).o) \
           $(foreach file,$(BIN_FILES),$(BUILD_DIR)/$(file).o)

TARGET = $(BUILD_DIR)/$(BASENAME).$(VERSION)
LD_SCRIPT = $(BASENAME).$(VERSION).ld

CROSS = mips-linux-gnu-
AS = $(CROSS)as
CPP = cpp
LD = $(CROSS)ld
OBJDUMP = $(CROSS)objdump
OBJCOPY = $(CROSS)objcopy
PYTHON = python3
GZIP = gzip

OBJCOPYFLAGS = -O binary

ASFLAGS = -EB -mtune=vr4300 -march=vr4300 -mabi=32 -I include

LDFLAGS = -T $(LD_SCRIPT) -T undefined_syms_auto.txt -T undefined_funcs_auto.txt -T undefined_syms.$(VERSION).txt -Map $(TARGET).map --no-check-sections


### Targets

default: all

all: dirs $(TARGET).z64 verify

dirs:
	$(foreach dir,$(SRC_DIRS) $(ASM_DIRS) $(BIN_DIRS),$(shell mkdir -p $(BUILD_DIR)/$(dir)))

check: .baserom.$(VERSION).ok

verify: $(TARGET).z64
	@echo "$$(cat $(BASENAME).$(VERSION).sha1)  $(TARGET).z64" | sha1sum --check

extract: check asm/header.s

clean:
	rm -rf asm
	rm -rf assets
	rm -rf build
	rm -f *auto.txt

### Recipes

.baserom.$(VERSION).ok: baserom.$(VERSION).z64
	@echo "$$(cat $(BASENAME).$(VERSION).sha1)  $<" | sha1sum --check
	@touch $@

asm/header.s: $(BASENAME).$(VERSION).yaml
	$(PYTHON) $(TOOLS_DIR)/splat/split.py $<

$(TARGET).elf: $(O_FILES)
	@$(LD) $(LDFLAGS) -o $@

$(BUILD_DIR)/%.s.o: %.s
	$(AS) $(ASFLAGS) -o $@ $<

$(BUILD_DIR)/%.bin.o: %.bin
	$(LD) -r -b binary -o $@ $<

$(TARGET).bin: $(TARGET).elf
	$(OBJCOPY) $(OBJCOPYFLAGS) $< $@

$(TARGET).z64: $(TARGET).bin
	@cp $< $@

### Settings
.SECONDARY:
.PHONY: all clean default
SHELL = /bin/bash -e -o pipefail
