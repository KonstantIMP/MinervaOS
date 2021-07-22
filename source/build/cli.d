/**
 * Class for formated output
 * Author: KonstantIMP <mihedovkos@gmail.com>
 * Date: 22 Jul 2021
 */
module build.cli;

import std.stdio : write, stderr;

/** 
 * Class for colored output
 */
class Cli {
    public static void message (Args...) (Args args) { write("\x1b[39;1m", args, "\x1b[0m"); }
    public static void success (Args...) (Args args) { write("\x1b[32;1m", args, "\x1b[0m"); }
    public static void warning (Args...) (Args args) { stderr.write("\x1b[31;1m", args, "\x1b[0m"); }
    public static void error   (Args...) (Args args) { stderr.write("\x1b[37;41;1m", args, "\x1b[0m"); }
}
