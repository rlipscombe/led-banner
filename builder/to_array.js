function to_array(text) {
    return "[\n" +
        text.split("\n").map(x => '"' + x + '",\n').join('') +
        "]\n";
}

module.exports = {
    to_array: to_array
}
