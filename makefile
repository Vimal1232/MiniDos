NASM = nasm 
CC = x86_64-elf-gcc
LD = x86_64-elf-ld
QEMU = qemu-system-i386


BOOT_SRC = bootloader.asm
ENTRY = kernel_entry.asm
KERNEL = kernel.c 
BOO_BIN = bootloader.bin
KERNEL_BIN = kernel.bin
ENTRY_OBJ = entry.o
KERNEL_OBJ = kernel.o
OS = os.img

all: $(OS)

$(BOO_BIN): $(BOOT_SRC)
	$(NASM) -f bin $< -o $@

$(ENTRY_OBJ): $(ENTRY)
	$(NASM) -f elf $< -o $@

$(KERNEL_OBJ): $(KERNEL)
	$(CC) -m32 -ffreestanding -c -nostdlib $< -o $@

$(KERNEL_BIN): $(ENTRY_OBJ) $(KERNEL_OBJ)
	$(LD) -m elf_i386 -Ttext 0x10000 --oformat binary $^ -o $@

$(OS): $(BOO_BIN) $(KERNEL_BIN)
	cat $(BOO_BIN) $(KERNEL_BIN) > $(OS)


run: $(OS)
	$(QEMU) -drive  format=raw,file=$(OS)

clean:
	rm -f $(BOO_BIN) $(KERNEL_BIN) $(OS) $(ENTRY_OBJ) $(KERNEL_OBJ) $(OS)