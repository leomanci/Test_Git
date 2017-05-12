/*
This file is generated and isn't the actual source code for this
managed global class.
This read-only file shows the class's global constructors,
methods, variables, and properties.
To enable code to compile, all methods return null.
*/
global class LogEvent {
    global Logs4SF.Level level {
        get;
    }
    global String message {
        get;
    }
    global Datetime timestamp {
        get;
    }
    global LogEvent(Logs4SF.Level level, String message) {

    }
    global LogEvent(Logs4SF.Level level, String message, List<String> tags) {

    }
    global List<String> getTags() {
        return null;
    }
    global Boolean hasTag(String tag) {
        return null;
    }
}
