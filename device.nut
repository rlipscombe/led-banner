@include "github:rlipscombe/WS2812/WS2812.class.nut"

server.log("Device ID:      " + hardware.getdeviceid());
server.log("Imp Type:       " + imp.info().type);
server.log("Improm Version: " + imp.getsoftwareversion());

Width <- 32;
Height <- 8;
Offset <- 1;    // 1 extra for the impExplorer.
Count <- (Width * Height) + Offset;

Black <- [0, 0, 0];

// Note: 32 x 8 x 60mA is 1.5A. You'll need a beefy power supply.
// I've got a 2.5A PSU and it can't cope with white at more than about 30% brightness.

function reduceBrightness(colour) {
    return [colour[0] >> 1, colour[1] >> 1, colour[2] >> 1];
}

// 5v power on the impExplorer is gated; we need to enable pin 1.
hardware.pin1.configure(DIGITAL_OUT, 1);

spi <- hardware.spi257;
pixels <- WS2812(spi, Count);

// The LED banner is formatted as a zig-zag strip:
//
// 2389
// 147.
// 056.
function getPixelIndex(x, y) {
    local c = x * Height;
    local r = (x % 2) ? ((Height - 1) - y) : y;
    return Offset + c + r;
}

function getPatternColour(pattern, x, y, dx, length) {
    local row = pattern[y];
    local c = (x + dx) % length;
    if (c < row.len()) {
        return row[c];
    }
    else {
        return Black;
    }
}

function showPattern(pattern, length, scroll) {
    for (local c = 0; c < Width; ++c) {
        for (local r = 0; r < Height; ++r) {
            local index = getPixelIndex(c, r);
            local colour = getPatternColour(pattern, c, r, scroll, length);
            pixels.set(index, colour);
        }
    }

    pixels.draw();
}

// It's pretty slow already; we don't need to delay it any more.
ScrollInterval <- 0.0;
ScrollTimer <- null;

function scrollPattern(pattern, length, scroll, maxScroll) {
    showPattern(pattern, length, scroll);

    // Scroll the viewport to the right
    ++scroll;
    // ...avoiding integer overflows.
    if (scroll >= maxScroll) {
        scroll = 0;
    }

    ScrollTimer <- imp.wakeup(ScrollInterval, function() {
        scrollPattern(pattern, length, scroll, maxScroll);
    });
}

function getPatternLength(pattern) {
    local length = pattern
        .map(function(v) { return v.len(); })
        .reduce(function(a, b) { return (a > b) ? a : b; });
    return length;
}

function startPattern(pattern) {
    local length = getPatternLength(pattern);
    local maxScroll = length;
    if (maxScroll < Width) {
        maxScroll = Width;
    }

    scrollPattern(pattern, length, 0, maxScroll);
}

function clearPattern() {
    if (ScrollTimer) {
        imp.cancelwakeup(ScrollTimer);
        ScrollTimer <- null;
    }

    pixels.fill(Black);
}

function logPattern(pattern) {
    for (local r = 0; r < pattern.len(); ++r) {
        local row = pattern[r];
        local log = "";
        for (local c = 0; c < row.len(); ++c) {
            local v = row[c];
            local x = v[0] + v[1] + v[2];
            if (x != 0) {
                log += "X";
            }
            else {
                log += " ";
            }
        }
        server.log(log);
    }
}

agent.on("pattern", function(pattern) {
    //logPattern(pattern);
    clearPattern();
    startPattern(pattern);
});

clearPattern();
