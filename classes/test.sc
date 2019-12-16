MyClass {
    instanceMethod { | argument |
        this.anotherInstanceMethod(argument)
    }

    anotherInstanceMethod { | argument |
        "hello instance".postln
    }
}