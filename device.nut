#require "WS2812.class.nut:3.0.0"

server.log("Device ID:      " + hardware.getdeviceid());
server.log("Imp Type:       " + imp.info().type);
server.log("Improm Version: " + imp.getsoftwareversion());

Width <- 32;
Height <- 8;
Count <- (Width * Height) + 1;  // 1 extra for the impExplorer.

// 5v power on the impExplorer is gated; we need to enable pin 1.
hardware.pin1.configure(DIGITAL_OUT, 1);

spi <- hardware.spi257;
pixels <- WS2812(spi, Count);

function toBool(v) {
    if (v && v != ' ') {
        return true;
    }
    else {
        return false;
    }
}

Black <- [0, 0, 0];
Red <- [32, 0, 0];
Orange <- [32, 4, 0];
Yellow <- [32, 24, 0];
Green <- [0, 32, 0];
Cyan <- [0, 32, 18];
Blue <- [0, 4, 32];
Magenta <- [24, 0, 32];
Pink <- [32, 0, 16];

Palette <- [Red, Orange, Yellow, Green, Cyan, Blue, Magenta, Pink];
PaletteLength <- Palette.len();

function getColour(x, y, offset, v, len) {
    local t = toBool(v);
    if (t) {
        local p = (x + offset + y);
        return Palette[p % PaletteLength];
    }
    else {
        return Black;
    }
}

function getIndex(x, y) {
    local c = x * Height;
    local r = (x % 2) ? ((Height - 1) - y) : y;
    return 1 + c + r;
}

SCROLLER <- null;

function clearMessage() {
    if (SCROLLER) {
        imp.cancelwakeup(SCROLLER);
        SCROLLER <- null;
    }

    pixels.fill(Black);
}

function getValue(row, c) {
    local n = c % row.len();
    return row[n];
}

function showMessage(rows, offset) {
    for (local r = 0; r < Height; ++r) {
        local row = rows[r];

        for (local c = 0; c < Width; ++c ) {
            local v = getValue(row, c + offset);
            local colour = getColour(c, r, offset, v, row.len());
            local index = getIndex(c, r);
            pixels.set(index, colour);
        }
    }

    pixels.draw();
}

ScrollInterval <- 0.0;

function scrollMessage(rows, offset, maxOffset) {
    showMessage(rows, offset);
    ++offset;
    if (offset >= maxOffset) {
        offset = 0;
    }
    SCROLLER <- imp.wakeup(ScrollInterval, function() {
        scrollMessage(rows, offset, maxOffset);
    });
}

function verticalAlign(rows) {
    local width = rows[0].len();

    // We need to ensure that there are enough vertical rows,
    // and that the content is centred vertically.
    local pad = (Height - rows.len()) / 2;
    local result = [];
    for (local i = 0; i < pad; ++i) {
        result.append(array(width));
    }

    result.extend(rows);

    // Ensure there are enough vertical rows.
    while (result.len() < Height) {
        // Add a row to the bottom.
        result.append(array(width));
    }

    // If the text is too tall, too bad.
    return result.slice(0, Height);
}

function roundUp(n, to) {
    local x = (n % to);
    if (x == 0) {
        return n;
    }

    return n + (to - x);
}

function padRow(row, width) {
    local pad = width - row.len();
    for (local i = 0; i < pad; ++i) {
        row += " ";
    }

    return row;
}

function padRows(rows) {
    local width = rows.map(function(v) { return v.len(); }).reduce(function(a, b) { return (a > b) ? a : b; });
    width = roundUp(width, 8);
    return rows.map(function(r) { return padRow(r, width); });
}

function startMessage(message) {
    local rows = split(message, "\n");
    rows = padRows(rows);
    rows = verticalAlign(rows);

    local maxOffset = rows[0].len();
    scrollMessage(rows, 0, maxOffset);
}

agent.on("message", function(message) {
    clearMessage();
    startMessage(message);
});
