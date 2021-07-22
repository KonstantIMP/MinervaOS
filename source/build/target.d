/**
 * Target class for the projects
 * Author: KonstantIMP <mihedovkos@gmail.com>
 * Date: 22 Jul 2021
 */
module build.target;

/** 
 * Target for compiling
 */
class Target {
    public string targetName;
    public string [] sources;
    public Target [] deps;
    public bool isPhony;

    private string makeCommand;

    public this (string name, string [] src, Target [] dependencies, string make, bool phony = true) {
        targetName = name; sources = src; deps = dependencies; isPhony = phony;
        makeCommand = make;
    }

    public bool needRebuild () {
        import std.file : exists;
        return isPhony || !exists(targetName);
    }

    public string genMakeCommand () {
        import std.string : replace, strip;
        import std.algorithm : joiner, map;
        import std.array : array;

        return makeCommand.replace("$out$", targetName).replace("$in$", sources.map!"a".joiner(" ").array).strip;
    }
}
