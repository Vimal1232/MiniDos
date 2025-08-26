#include <stddef.h>
#include <stdint.h>
#define  VGA_Width 80
#define  VGA_HEIGHT 25
#define  VGA_MEMORY 0xB8000
// VGA_COLOR_BLACK = 0,
// VGA_COLOR_BLUE = 1,
// VGA_COLOR_GREEN = 2,
// VGA_COLOR_CYAN = 3,
// VGA_COLOR_RED = 4,
// VGA_COLOR_MAGENTA = 5,
// VGA_COLOR_BROWN = 6,
// VGA_COLOR_LIGHT_GREY = 7,
// VGA_COLOR_DARK_GREY = 8,
// VGA_COLOR_LIGHT_BLUE = 9,
// VGA_COLOR_LIGHT_GREEN = 10,
// VGA_COLOR_LIGHT_CYAN = 11,
// VGA_COLOR_LIGHT_RED = 12,
// VGA_COLOR_LIGHT_MAGENTA = 13,
// VGA_COLOR_LIGHT_BROWN = 14,
// VGA_COLOR_WHITE = 15,



size_t terminal_row;
size_t terminal_columns;
uint8_t terminal_color = (0<< 4) | 7; // refer the Above for the colors So 4 Most Significant Bits = Background , 4 Least Significant Bits = foreground
uint16_t* terminalBuffer = (uint16_t*) VGA_MEMORY;

uint16_t entry(unsigned char uc , uint8_t color){
    return (color << 8) | uc;
}



void Terminal_Intialize(){
    terminal_row = 0;
    terminal_columns = 0;
    for(size_t y = 0; y < VGA_HEIGHT; y++){
        for(size_t x = 0; x <VGA_Width ; x++){
            const size_t index = y * VGA_Width + x;
            terminalBuffer[index] = entry(' ', terminal_color);
        }
    }
}

void Scroll_Up(){
    for(size_t y =1; y < VGA_HEIGHT; y++){
        for(size_t x = 0; x < VGA_Width; x++){
            const size_t currIn = y* VGA_Width +x;
            const size_t destIn = (y-1)*VGA_Width +x;
            terminalBuffer[destIn] = terminalBuffer[currIn];
        }
    }
   
    for(size_t i = 0; i < VGA_Width; i++){
        size_t index = (VGA_HEIGHT -1) * VGA_Width + i;
        terminalBuffer[index] = entry(' ', terminal_color);
    }

}

void putchar(char c){
    if(c == '\n'){
        terminal_columns = 0;
        if(++terminal_row == VGA_HEIGHT){
            terminal_row = VGA_HEIGHT -1;
            Scroll_Up();
        }
        return;
    }
    const size_t index = terminal_row * VGA_Width + terminal_columns;
    terminalBuffer[index] = entry(c, terminal_color);
    if(++terminal_columns == VGA_Width){
        terminal_columns = 0;
       if(++terminal_row == VGA_HEIGHT){
        terminal_row = VGA_HEIGHT -1;
        Scroll_Up();
        }
    }
    
}
size_t len(const char* str){
    size_t len = 0;
    while(str[len]){
        len++;
    }
    return len;
}

void writechar(const char* data, size_t size){
    for(size_t i = 0 ; i < size; i++){
        putchar(data[i]);
    }
}

void writeString(const char* str){
    size_t length = len(str);
    writechar(str, length);
}
void kernel_main() {
    Terminal_Intialize();
    writeString("    _    _ _                       ___  ____  \n");
    writeString("   / \\  | (_) ___ _ __  ___       / _ \\/ ___|\n");
    writeString("  / _ \\ | | |/ _ \\ '_ \\/ __|_____| | | \\___ \\ \n");
    writeString(" / ___ \\| | |  __/ | | \\__ \\_____| |_| |___) |\n");
    writeString("/_/   \\_\\_|_|\\___|_| |_|___/      \\___/|____/ \n");
    writeString("\n");
    writeString("\n");
    writeString(" __                      __                          \n");
    writeString("/   _  _  _     _ . _|_ |__)_ _  _  _  _  _  _  _| _ \n");
    writeString("\\__(_)|||||||_|| )|_)|_ |  | (_)|_)(_|(_)(_|| )(_|(_|\n");
    writeString("                                |     _/             ");












}