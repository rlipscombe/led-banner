function measure(message, fun) {
    local start = hardware.micros();
    fun();
    local end = hardware.micros();
    server.log(message + ": " + (end - start) + "us");
}
