#if OS == .WINDOWS {
    #load "windows/windows.jai";
} else #if OS == .LINUX {
    #assert false "Linux is not yet supported. Check README for how to add support!";
    // #load "linux/linux.jai";
} else #if OS == .MACOS {
    #assert false "MACOS is not yet supported. Check README for how to add support!";
    // #load "macos/macos.jai";
}
