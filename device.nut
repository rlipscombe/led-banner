@include "lib/repeat.lib.nut"

server.log("Device ID:      " + hardware.getdeviceid());
server.log("Imp Type:       " + imp.info().type);
server.log("Improm Version: " + imp.getsoftwareversion());

repeat(2.0, function() {
    server.log("Memory Free:    " + imp.getmemoryfree());
});

Width <- 32;
Height <- 8;
Offset <- 1;    // 1 extra for the impExplorer.

// Note: 32 x 8 x 60mA is 1.5A. You'll need a beefy power supply.
// I've got a 2.5A PSU and it can't cope with white at more than about 30% brightness.

// 5v power on the impExplorer is gated; we need to enable pin 1.
hardware.pin1.configure(DIGITAL_OUT, 1);

_spi <- hardware.spi257;
_spi.configure(MSB_FIRST, 7500);

// To save space on the device, we store the source image in a blob, using
// 4 bits per pixel. This allows us to pack 2 pixels per byte in the image.
// This gives us a 16 colour palette.
//
// The WS2812 doesn't expect RGB; it expects a bit-banged pattern, so to
// save an extra lookup, we store the pattern in the palette.

// Generate the bit pattern for a particular RGB triple.
// Each pattern is 24 bytes long (8 bytes per channel).
function generateBitPattern(rgb) {
    local bits = blob(24);

    // Given the intensity of the R, G or B channel,
    // write the relevant bit pattern to the blob.
    function write(x) {
        local ONE = 0xF8;
        local ZERO = 0xC0;

        bits.writen((x & 0x80) ? ONE : ZERO, 'b');
        bits.writen((x & 0x40) ? ONE : ZERO, 'b');
        bits.writen((x & 0x20) ? ONE : ZERO, 'b');
        bits.writen((x & 0x10) ? ONE : ZERO, 'b');
        bits.writen((x & 0x08) ? ONE : ZERO, 'b');
        bits.writen((x & 0x04) ? ONE : ZERO, 'b');
        bits.writen((x & 0x02) ? ONE : ZERO, 'b');
        bits.writen((x & 0x01) ? ONE : ZERO, 'b');
    }

    // red and green are swapped
    write(rgb[1]); write(rgb[0]); write(rgb[2]);

    // rewind
    bits.seek(0, 'b');
    return bits;
}

// This is the Windows 16-colour palette from
// https://en.wikipedia.org/wiki/List_of_software_palettes#Microsoft_Windows_default_16-color_palette
// It's not particularly interesting; it's just IRGB.
// But see http://alumni.media.mit.edu/~wad/color/numbers.html, which *is* more interesting.
WindowsPalette <- [
    generateBitPattern([0x00, 0x00, 0x00]),     // Black
    generateBitPattern([0x08, 0x00, 0x00]),     // Maroon
    generateBitPattern([0x00, 0x08, 0x00]),     // Green
    generateBitPattern([0x08, 0x08, 0x00]),     // Olive
    generateBitPattern([0x00, 0x00, 0x08]),     // Navy
    generateBitPattern([0x08, 0x00, 0x08]),     // Purple
    generateBitPattern([0x00, 0x08, 0x08]),     // Teal
    generateBitPattern([0x08, 0x08, 0x08]),     // Silver
    generateBitPattern([0x10, 0x10, 0x10]),     // Gray
    generateBitPattern([0x20, 0x00, 0x00]),     // Red
    generateBitPattern([0x00, 0x20, 0x00]),     // Lime
    generateBitPattern([0x20, 0x20, 0x00]),     // Yellow
    generateBitPattern([0x00, 0x00, 0x20]),     // Blue
    generateBitPattern([0x20, 0x00, 0x20]),     // Fuschia
    generateBitPattern([0x00, 0x20, 0x20]),     // Aqua
    generateBitPattern([0x20, 0x20, 0x20]),     // White
];

_palette <- WindowsPalette;
_paletteLen <- _palette.len();

// We need to write the whole frame out at once, for proper timings.
// Use a global, since it's not going to get a chance to be GCed.
PixelCount <- Offset + (Width * Height);
BytesPerPixel <- 24;

// Dark magic: We need an extra zero at the end of the frame; it prevents
// issues with the impExplorer's onboard LED.
_frame <- blob(PixelCount * BytesPerPixel + 1);
_frame[PixelCount * BytesPerPixel] = 0;

function getPoint(index) {
    // Convert pixel index to (x, y) values.
    local x = index / Height;
    local y = index % Height;

    // It zigzags:
    if (x % 2) {
        y = 7 - y;
    }

    return { x = x, y = y };
}

function renderFrame(frame, fun) {
    frame.seek(0, 'b');

    // Write a dummy pixel to cope with the impExplorer's extra pixel.
    frame.writeblob(_palette[0]);

    for (local i = 1; i < PixelCount; ++i) {
        local pt = getPoint(i - 1);
        local colour = fun(pt.x, pt.y);
        frame.writeblob(_palette[colour]);
    }
}

function fillFrame(frame, colour) {
    renderFrame(frame, function(_x, _y) { return colour; });
}

function erasePanel() {
    fillFrame(_frame, 0);
    _spi.write(_frame);
}

// Erase the panel at startup.
erasePanel();

_animationTimer <- null;

function startAnimation(animation) {
    cancelAnimation();
    continueAnimation(animation);
}

function cancelAnimation() {
    if (_animationTimer) {
        imp.cancelwakeup(_animationTimer);
        _animationTimer = null;
    }
}

function continueAnimation(animation) {
    renderFrame(_frame, function(x, y) { return animation.get(x, y); });
    _spi.write(_frame);

    animation.next();
    local interval = animation.interval();
    if (interval != null) {
        _animationTimer = imp.wakeup(interval, function() { continueAnimation(animation); });
    }
}

class CycleColours {
    _colour = 0;

    function get(x, y)
    {
        return _colour;
    }

    function next()
    {
        _colour++;
        if (_colour >= _paletteLen) {
            _colour = 0;
        }
    }

    function interval()
    {
        return 0.5;
    }
};

/*animation <- CycleColours();
startAnimation(animation);*/

class ScrollingImage {
    _image = null;
    _width = 0;
    _height = 8;
    _scroll = 0;

    constructor(image) {
        _image = image;

        _width = _image[0].len();
        _height = 8;

        _scroll = 0;
    }

    function get(x, y)
    {
        local row = _image[y];
        local c = (x + _scroll) % _width;
        if (c < row.len()) {
            return row[c];
        }
        else {
            return 0;
        }
    }

    function next() {
        // Scroll the viewport to the right.
        ++_scroll;
        if (_scroll >= _width) {
            _scroll = 0;
        }
    }

    function interval() {
        return 0.01;
    }
}

agent.on("pattern", function(image) {
    local animation = ScrollingImage(image);
    startAnimation(animation);
});
