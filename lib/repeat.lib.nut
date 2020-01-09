function repeat(interval, fun) {
    fun();

    imp.wakeup(interval, function() {
        repeat(interval, fun);
    });
}
