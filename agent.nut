#require "rocky.class.nut:2.0.1"

Pattern <- null;

function postHome(context) {
    local message = context.req.rawbody;
    server.log(message);
    Pattern = renderText(message + "      ", asciiTo5x8, Cyan, Black);
    device.send("pattern", Pattern);
    context.send(202, "Accepted\n");
}

server.log(http.agenturl());

app <- Rocky();
app.post("/", postHome);

@include "lib/rainbow.lib.nut"
@include "lib/palette.lib.nut"
@include "lib/colourise.lib.nut"
@include "lib/font-5x8.lib.nut"

Width <- 32;
Height <- 8;

function pushColumn(pattern, x, fg, bg) {
    pattern[0].push((x & @{bsl(1, 7)}) ? fg : bg);
    pattern[1].push((x & @{bsl(1, 6)}) ? fg : bg);
    pattern[2].push((x & @{bsl(1, 5)}) ? fg : bg);
    pattern[3].push((x & @{bsl(1, 4)}) ? fg : bg);
    pattern[4].push((x & @{bsl(1, 3)}) ? fg : bg);
    pattern[5].push((x & @{bsl(1, 2)}) ? fg : bg);
    pattern[6].push((x & @{bsl(1, 1)}) ? fg : bg);
    pattern[7].push((x & @{bsl(1, 0)}) ? fg : bg);
}

function pushBlankColumn(pattern, bg) {
    pattern[0].push(bg);
    pattern[1].push(bg);
    pattern[2].push(bg);
    pattern[3].push(bg);
    pattern[4].push(bg);
    pattern[5].push(bg);
    pattern[6].push(bg);
    pattern[7].push(bg);
}

function pushCharacter(pattern, c, fg, bg) {
    local w = c.len();

    for (local p = 0; p < w; ++p) {
        pushColumn(pattern, c[p], fg, bg);
    }

    pushBlankColumn(pattern, bg);
}

function renderText(message, font, fg, bg) {
    local pattern = [[], [], [], [], [], [], [], []];

    local len = message.len();
    for (local i = 0; i < len; ++i) {
        pushCharacter(pattern, font(message[i]), fg, bg);
    }

    return pattern;
}

function padHeight(array) {
    while (array.len() < 8) {
        array.push([]);
    }

    return array;
}

//Pattern <- generateRainbowPattern(Width, Height, Palette);
//Pattern <- renderText("Hello World!" + "      ", asciiTo5x8, Smoke, Black);
Pattern <- colourise(padHeight(@{include('patterns/default.txt') | to_array}), Smoke, Black);

device.onconnect(function() {
    device.send("pattern", Pattern);
});
