function colourise(pattern, fg, bg) {
    return pattern.map(function(line) {
        local row = [];
        for (local i = 0; i < line.len(); ++i) {
            if (line[i] && line[i] != ' ') {
                row.push(fg);
            }
            else {
                row.push(bg);
            }
        }
        return row;
    });
}
