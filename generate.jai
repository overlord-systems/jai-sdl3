#run build();

build :: () {

    set_build_options_dc(.{do_output=false});

	options := get_build_options();

    if !generate_bindings() {
        compiler_set_workspace_status(.FAILED);
        return;
    }
}

DECLARATIONS_TO_OMIT :: string.[
    "_m_prefetch",
    "__debugbreak",

    /*
    Those are force inlined functions defined in the headers, so they don't appear in the library and so bindings generator complains.

    One way is to automatically remove inline, compile them into a DLL, and turn them into #c_call jai procs. However, this loses inline.

    The performant way is to rewrite them in pure jai code, however that introduces overhead of ensuring they are updated.
    */
    "SDL_size_mul_check_overflow",
    "SDL_size_mul_check_overflow_builtin",
    "SDL_size_add_check_overflow",
    "SDL_size_add_check_overflow_builtin",
    "SDL_SwapFloat",
    "SDL_MostSignificantBitIndex32",
    "SDL_HasExactlyOneBitSet32",
    "SDL_RectToFRect",
    "SDL_PointInRect",
    "SDL_RectEmpty",
    "SDL_RectsEqual",
    "SDL_PointInRectFloat",
    "SDL_RectEmptyFloat",
    "SDL_RectsEqualEpsilon",
    "SDL_RectsEqualFloat",
];

ENUMS_TO_OMIT :: string.[
];

generate_bindings :: () -> bool {

    output_filename: string;
    opts: Generate_Bindings_Options;

    {
        using opts;
        strip_flags = .FUNCTIONS_WITH_VALIST;

        #if OS == .WINDOWS {
            output_filename = "windows/windows.jai";

            #if CPU == .X64 {

                FOOTER :: #string EOF
sdl3 :: #library,no_dll "bin/x64/SDL3";
EOF
                array_add(*libpaths, "windows/bin/x64");

            } else #if CPU == .ARM64 {

                FOOTER :: #string EOF
sdl3 :: #library,no_dll "bin/arm64/SDL3";
EOF

                array_add(*libpaths, "windows/bin/arm64");

            } else {
                assert(false, "the CPU % is currently unsupported. You might be able to add support for it though!", CPU);
            }

            // DLL provided by user not in bin, so use our own footer not generated library declaration
            footer = FOOTER;
            generate_library_declarations = false;

        } /*else #if OS == .LINUX {
            strip_flags = 0;
            output_filename = "linux/linux.jai";
            array_add(*libpaths, "linux/bin");
        } else #if OS == .MACOS {
            strip_flags = 0;
            output_filename = "macos/macos.jai";
        }*/ else {
            assert(false, "the OS % is currently unsupported. You might be able to add support for it though!", OS);
        }

        array_add(*libnames, "SDL3");
        array_add(*include_paths, "include");
        array_add(*source_files, "include/SDL3/SDL.h");

        // array_add(*strip_prefixes, "");

        visitor = sdl3_visitor;
        generate_compile_time_struct_checks = false;
    }

    return generate_bindings(opts, output_filename);
}

sdl3_visitor :: (decl: *Declaration, parent_decl: *Declaration) -> Declaration_Visit_Result {

    if parent_decl return .RECURSE;

    if array_find(DECLARATIONS_TO_OMIT, decl.name) {
        decl.decl_flags |= .OMIT_FROM_OUTPUT;
        return .STOP;
    }

    if decl.kind == .ENUM && array_find(ENUMS_TO_OMIT, decl.name) {
        decl.decl_flags |= .OMIT_FROM_OUTPUT;
        return .STOP;
    }

    return .RECURSE;
}

#scope_file

#import "Basic";
#import "Compiler";
#import "BuildCpp";
#import "Check";
#import "Bindings_Generator";
#import "File";
