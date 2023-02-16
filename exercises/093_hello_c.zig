//
// When Andrew Kelley announced the idea of a new programming language
// - namely Zig - in his blog on February 8, 2016, he also immediately
// stated his ambitious goal: to replace the C language!
//
// In order to be able to achieve this goal at all, Zig should be
// as compatible as possible with its "predecessor".
// Only if it is possible to exchange individual modules in existing
// C programs without having to use complicated wrappers,
// the undertaking has a chance of success.
//
// So it is not surprising that calling C functions and vice versa
// is extremely "smooth".
//
// To call C functions in Zig, you only need to specify the library
// that contains said function. For this purpose there is a built-in
// function corresponding to the well-known @import():
//
//                           @cImport()
//
// All required libraries can now be included in the usual Zig notation:
//
//                    const c = @cImport({
//                        @cInclude("stdio.h");
//                        @cInclude("...");
//                    });
//
// Now a function can be called via the (in this example) constant 'c':
//
//                    c.puts("Hello world!");
//
// By the way, most C functions have return values in the form of an
// integer value. Errors can then be evaluated (return < 0) or other
// information can be obtained. For example, 'puts' returns the number
// of characters output.
//
// So that all this does not remain a dry theroy now, let's just start
// and call a C function out of Zig.
//
// our well-known "import" for Zig
const std = @import("std");

// new the import for C
const c = @cImport({

    // we use "standard input/output" from C
    @cInclude("stdio.h");
});

pub fn main() void {

    // Due to a current limitation in the Zig compiler,
    // we need a small workaround to make this exercise
    // work on mac-os.
    const builtin = @import("builtin");
    const stderr = switch (builtin.target.os.tag) {
        .macos => 1,
        else => c.stderr,
    };

    // In order to output a text that can be evaluated by the
    // Zig Builder, we need to write it to the Error output.
    // In Zig we do this with "std.debug.print" and in C we can
    // specify the file to write to, i.e. "standard error (stderr)".
    //
    // Ups, something is wrong...
    const c_res = fprintf(stderr, "Hello C from Zig!");

    // let's see what the result from C is:
    std.debug.print(" - C result ist {d} chars\n", .{c_res});
}
//
// Something must be considered when compiling with C functions.
// Namely that the Zig compiler knows that it should include
// corresponding libraries. For this purpose we call the compiler
// with the parameter "lc" for such a program,
// e.g. "zig run -lc hello_c.zig".
//
