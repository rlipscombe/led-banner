function generateRainbowPattern(width, height, palette) {
    local paletteLength = palette.len();
    local pattern = [];

    for (local r = 0; r < height; ++r) {
        local row = [];
        for (local c = 0; c < width; ++c) {
            local p = r + c;
            local colour = palette[p % paletteLength];
            row.push(colour);
        }

        pattern.push(row);
    }

    return pattern;
}
