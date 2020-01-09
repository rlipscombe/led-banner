function asciiTo5x8(c) {
    switch (c) {
        case ' ':  return [0x00];                          // SP ----- -O--- OO-OO ----- -O--- OO--O -O--- -O---
        case '!':  return [0xfa];                          // !  ----- -O--- OO-OO -O-O- -OOO- OO--O O-O-- -O---
        case '"':  return [0xe0,0xc0,0x00,0xe0,0xc0];      // "  ----- -O--- O--O- OOOOO O---- ---O- O-O-- -----
        case '#':  return [0x24,0x7e,0x24,0x7e,0x24];      // #  ----- -O--- ----- -O-O- -OO-- --O-- -O--- -----
        case '$':  return [0x24,0xd4,0x56,0x48];           // $  ----- -O--- ----- -O-O- ---O- -O--- O-O-O -----
        case '%':  return [0xc6,0xc8,0x10,0x26,0xc6];      // %  ----- ----- ----- OOOOO OOO-- O--OO O--O- -----
        case '&':  return [0x6c,0x92,0x6a,0x04,0x0a];      // &  ----- -O--- ----- -O-O- --O-- O--OO -OO-O -----
        case '\'': return [0xc0];                          // '  ----- ----- ----- ----- ----- ----- ----- -----
        //
        case '(':  return [0x7c,0x82];                     // (  ---O- -O--- ----- ----- ----- ----- ----- -----
        case ')':  return [0x82,0x7c];                     // )  --O-- --O-- -O-O- --O-- ----- ----- ----- ----O
        case '*':  return [0x10,0x7c,0x38,0x7c,0x10];      // *  --O-- --O-- -OOO- --O-- ----- ----- ----- ---O-
        case '+':  return [0x10,0x10,0x7c,0x10,0x10];      // +  --O-- --O-- OOOOO OOOOO ----- OOOOO ----- --O--
        case ',':  return [0x01,0x02];                     // ,  --O-- --O-- -OOO- --O-- ----- ----- ----- -O---
        case '-':  return [0x10,0x10,0x10,0x10,0x10];      // -  --O-- --O-- -O-O- --O-- ----- ----- -OO-- O----
        case '.':  return [0x06,0x06];                     // .  ---O- -O--- ----- ----- --O-- ----- -OO-- -----
        case '/':  return [0x04,0x08,0x10,0x20,0x40];      // /  ----- ----- ----- ----- -O--- ----- ----- -----
        //
        case '0':  return [0x7c,0x8a,0x92,0xa2,0x7c];      // 0  -OOO- --O-- -OOO- -OOO- ---O- OOOOO --OOO OOOOO
        case '1':  return [0x00,0x42,0xfe,0x02,0x00];      // 1  O---O -OO-- O---O O---O --OO- O---- -O--- ----O
        case '2':  return [0x46,0x8a,0x92,0x92,0x62];      // 2  O--OO --O-- ----O ----O -O-O- O---- O---- ---O-
        case '3':  return [0x44,0x92,0x92,0x92,0x6c];      // 3  O-O-O --O-- --OO- -OOO- O--O- OOOO- OOOO- --O--
        case '4':  return [0x18,0x28,0x48,0xfe,0x08];      // 4  OO--O --O-- -O--- ----O OOOOO ----O O---O -O---
        case '5':  return [0xf4,0x92,0x92,0x92,0x8c];      // 5  O---O --O-- O---- O---O ---O- O---O O---O -O---
        case '6':  return [0x3c,0x52,0x92,0x92,0x8c];      // 6  -OOO- -OOO- OOOOO -OOO- ---O- -OOO- -OOO- -O---
        case '7':  return [0x80,0x8e,0x90,0xa0,0xc0];      // 7  ----- ----- ----- ----- ----- ----- ----- -----
        //
        case '8':  return [0x6c,0x92,0x92,0x92,0x6c];      // 8  -OOO- -OOO- ----- ----- ---O- ----- -O--- -OOO-
        case '9':  return [0x60,0x92,0x92,0x94,0x78];      // 9  O---O O---O ----- ----- --O-- ----- --O-- O---O
        case ':':  return [0x36,0x36];                     // :  O---O O---O -OO-- -OO-- -O--- OOOOO ---O- O---O
        case ';':  return [0x36,0x37];                     // ;  -OOO- -OOOO -OO-- -OO-- O---- ----- ----O --OO-
        case '<':  return [0x10,0x28,0x44,0x82];           // <  O---O ----O ----- ----- -O--- ----- ---O- --O--
        case '=':  return [0x24,0x24,0x24,0x24,0x24];      // =  O---O ---O- -OO-- -OO-- --O-- OOOOO --O-- -----
        case '>':  return [0x82,0x44,0x28,0x10];           // >  -OOO- -OO-- -OO-- -OO-- ---O- ----- -O--- --O--
        case '?':  return [0x60,0x80,0x9a,0x90,0x60];      // ?  ----- ----- ----- --O-- ----- ----- ----- -----
        //
        case '@':  return [0x7c,0x82,0xba,0xaa,0x78];      // @  -OOO- -OOO- OOOO- -OOO- OOOO- OOOOO OOOOO -OOO-
        case 'A':  return [0x7e,0x90,0x90,0x90,0x7e];      // A  O---O O---O O---O O---O O---O O---- O---- O---O
        case 'B':  return [0xfe,0x92,0x92,0x92,0x6c];      // B  O-OOO O---O O---O O---- O---O O---- O---- O----
        case 'C':  return [0x7c,0x82,0x82,0x82,0x44];      // C  O-O-O OOOOO OOOO- O---- O---O OOOO- OOOO- O-OOO
        case 'D':  return [0xfe,0x82,0x82,0x82,0x7c];      // D  O-OOO O---O O---O O---- O---O O---- O---- O---O
        case 'E':  return [0xfe,0x92,0x92,0x92,0x82];      // E  O---- O---O O---O O---O O---O O---- O---- O---O
        case 'F':  return [0xfe,0x90,0x90,0x90,0x80];      // F  -OOO- O---O OOOO- -OOO- OOOO  OOOOO O---- -OOO-
        case 'G':  return [0x7c,0x82,0x92,0x92,0x5c];      // G  ----- ----- ----- ----- ----- ----- ----- -----
        //
        case 'H':  return [0xfe,0x10,0x10,0x10,0xfe];      // H  O---O -OOO- ----O O---O O---- O---O O---O -OOO-
        case 'I':  return [0x82,0xfe,0x82];                // I  O---O --O-- ----O O--O- O---- OO-OO OO--O O---O
        case 'J':  return [0x0c,0x02,0x02,0x02,0xfc];      // J  O---O --O-- ----O O-O-- O---- O-O-O O-O-O O---O
        case 'K':  return [0xfe,0x10,0x28,0x44,0x82];      // K  OOOOO --O-- ----O OO--- O---- O---O O--OO O---O
        case 'L':  return [0xfe,0x02,0x02,0x02,0x02];      // L  O---O --O-- O---O O-O-- O---- O---O O---O O---O
        case 'M':  return [0xfe,0x40,0x20,0x40,0xfe];      // M  O---O --O-- O---O O--O- O---- O---O O---O O---O
        case 'N':  return [0xfe,0x40,0x20,0x10,0xfe];      // N  O---O -OOO- -OOO- O---O OOOOO O---O O---O -OOO-
        case 'O':  return [0x7c,0x82,0x82,0x82,0x7c];      // O  ----- ----- ----- ----- ----- ----- ----- -----
        //
        case 'P':  return [0xfe,0x90,0x90,0x90,0x60];      // P  OOOO- -OOO- OOOO- -OOO- OOOOO O---O O---O O---O
        case 'Q':  return [0x7c,0x82,0x92,0x8c,0x7a];      // Q  O---O O---O O---O O---O --O-- O---O O---O O---O
        case 'R':  return [0xfe,0x90,0x90,0x98,0x66];      // R  O---O O---O O---O O---- --O-- O---O O---O O-O-O
        case 'S':  return [0x64,0x92,0x92,0x92,0x4c];      // S  OOOO- O-O-O OOOO- -OOO- --O-- O---O O---O O-O-O
        case 'T':  return [0x80,0x80,0xfe,0x80,0x80];      // T  O---- O--OO O--O- ----O --O-- O---O O---O O-O-O
        case 'U':  return [0xfc,0x02,0x02,0x02,0xfc];      // U  O---- O--O- O---O O---O --O-- O---O -O-O- O-O-O
        case 'V':  return [0xf8,0x04,0x02,0x04,0xf8];      // V  O---- -OO-O O---O -OOO- --O-- -OOO- --O-- -O-O-
        case 'W':  return [0xfc,0x02,0x3c,0x02,0xfc];      // W  ----- ----- ----- ----- ----- ----- ----- -----
        //
        case 'X':  return [0xc6,0x28,0x10,0x28,0xc6];      // O  O---O O---O OOOOO -OOO- ----- -OOO- --O-- -----
        case 'Y':  return [0xe0,0x10,0x0e,0x10,0xe0];      // Y  O---O O---O ----O -O--- O---- ---O- -O-O- -----
        case 'Z':  return [0x86,0x8a,0x92,0xa2,0xc2];      // Z  -O-O- O---O ---O- -O--- -O--- ---O- O---O -----
        case '[':  return [0xfe,0x82,0x82];                // [  --O-- -O-O- --O-- -O--- --O-- ---O- ----- -----
        case '\\': return [0x40,0x20,0x10,0x08,0x04];      // \  -O-O- --O-- -O--- -O--- ---O- ---O- ----- -----
        case ']':  return [0x82,0x82,0xfe];                // ]  O---O --O-- O---- -O--- ----O ---O- ----- -----
        case '^':  return [0x20,0x40,0x80,0x40,0x20];      // ^  O---O --O-- OOOOO -OOO- ----- -OOO- ----- OOOOO
        case '_':  return [0x02,0x02,0x02,0x02,0x02];      // _  ----- ----- ----- ----- ----- ----- ----- -----
        //
        case '`':  return [0xc0,0xe0];                     // `  -OO-- ----- O---- ----- ----O ----- --OOO -----
        case 'a':  return [0x04,0x2a,0x2a,0x2a,0x1e];      // a  -OO-- ----- O---- ----- ----O ----- -O--- -----
        case 'b':  return [0xfe,0x22,0x22,0x22,0x1c];      // b  --O-- -OOO- OOOO- -OOO- -OOOO -OOO- -O--- -OOOO
        case 'c':  return [0x1c,0x22,0x22,0x22];           // c  ----- ----O O---O O---- O---O O---O OOOO- O---O
        case 'd':  return [0x1c,0x22,0x22,0x22,0xfc];      // d  ----- -OOOO O---O O---- O---O OOOO- -O--- O---O
        case 'e':  return [0x1c,0x2a,0x2a,0x2a,0x10];      // e  ----- O---O O---O O---- O---O O---- -O--- -OOOO
        case 'f':  return [0x10,0x7e,0x90,0x90,0x80];      // f  ----- -OOOO OOOO- -OOO- -OOOO -OOO- -O--- ----O
        case 'g':  return [0x18,0x25,0x25,0x25,0x3e];      // g  ----- ----- ----- ----- ----- ----- ----- -OOO-
        //
        case 'h':  return [0xfe,0x20,0x20,0x20,0x1e];      // h  O---- -O--- ----O O---- O---- ----- ----- -----
        case 'i':  return [0xbe];                          // i  O---- ----- ----- O---- O---- ----- ----- -----
        case 'j':  return [0x02,0x01,0x01,0x21,0xbe];      // j  OOOO- -O--- ---OO O--O- O---- OO-O- OOO-- -OOO-
        case 'k':  return [0xfe,0x08,0x14,0x22];           // k  O---O -O--- ----O O-O-- O---- O-O-O O--O- O---O
        case 'l':  return [0xfc,0x02];                     // l  O---O -O--- ----O OO--- O---- O-O-O O--O- O---O
        case 'm':  return [0x3e,0x20,0x18,0x20,0x1e];      // m  O---O -O--- ----O O-O-- O---- O---O O--O- O---O
        case 'n':  return [0x3e,0x20,0x20,0x1e];           // n  O---O -O--- O---O O--O- -O--- O---O O--O- -OOO-
        case 'o':  return [0x1c,0x22,0x22,0x22,0x1c];      // o  ----- ----- -OOO- ----- ----- ----- ----- -----
        //
        case 'p':  return [0x3f,0x22,0x22,0x22,0x1c];      // p  ----- ----- ----- ----- ----- ----- ----- -----
        case 'q':  return [0x1c,0x22,0x22,0x22,0x3f];      // q  ----- ----- ----- ----- -O--- ----- ----- -----
        case 'r':  return [0x22,0x1e,0x22,0x20,0x10];      // r  OOOO- -OOOO O-OO- -OOO- OOOO- O--O- O---O O---O
        case 's':  return [0x12,0x2a,0x2a,0x2a,0x04];      // s  O---O O---O -O--O O---- -O--- O--O- O---O O---O
        case 't':  return [0x20,0x7c,0x22,0x22,0x04];      // t  O---O O---O -O--- -OOO- -O--- O--O- O---O O-O-O
        case 'u':  return [0x3c,0x02,0x02,0x3e];           // u  O---O O---O -O--- ----O -O--O O--O- -O-O- OOOOO
        case 'v':  return [0x38,0x04,0x02,0x04,0x38];      // v  OOOO- -OOOO OOO-- OOOO- --OO- -OOO- --O-- -O-O-
        case 'w':  return [0x3c,0x06,0x0c,0x06,0x3c];      // w  O---- ----O ----- ----- ----- ----- ----- -----
        //
        case 'x':  return [0x22,0x14,0x08,0x14,0x22];      // x  ----- ----- ----- ---OO --O-- OO--- -O-O- -OO--
        case 'y':  return [0x39,0x05,0x06,0x3c];           // y  ----- ----- ----- --O-- --O-- --O-- O-O-- O--O-
        case 'z':  return [0x26,0x2a,0x2a,0x32];           // z  O---O O--O- OOOO- --O-- --O-- --O-- ----- O--O-
        case '{':  return [0x10,0x7c,0x82,0x82];           // {  -O-O- O--O- ---O- -OO-- ----- --OO- ----- -OO--
        case '|':  return [0xee];                          // |  --O-- O--O- -OO-- --O-- --O-- --O-- ----- -----
        case '}':  return [0x82,0x82,0x7c,0x10];           // }  -O-O- -OOO- O---- --O-- --O-- --O-- ----- -----
        case '~':  return [0x40,0x80,0x40,0x80];           // ~  O---O --O-- OOOO- ---OO --O-- OO--- ----- -----
        case '_':  return [0x60,0x90,0x90,0x60];           // _  ----- OO--- ----- ----- ----- ----- ----- -----
        //
        case '\t': return [0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00];  // Tab
        default:   return [0x00,0x00,0x00,0x00,0x00];                  // Blank
    }
}
