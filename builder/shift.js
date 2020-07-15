// Squirrel has bitshift operators; see https://developer.electricimp.com/squirrel/squirrel-guide/operators#squirrel-operator-symbols
// But they're evaluated at runtime, which is slow. This allows you to do constant bitshifts at compile time, and have them readable.
// Yes; I guess I could have used hex constants for the readability, but if you look at the code where this is used, you can see
// where I *nearly* got to hiding the whole bit behind a builder macro, so having the indexes and shifts visible kinda makes sense.

module.exports = {
    bsl: (x, n) => x << n
}
