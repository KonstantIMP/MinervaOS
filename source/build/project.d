/**
 * Project class for the projects
 * Author: KonstantIMP <mihedovkos@gmail.com>
 * Date: 22 Jul 2021
 */
module build.project;

import build.ver, build.target;

class Project {
    public string projectName;
    public Version projectVer;
    public Target [] targets;
    public Project [] deps;

    public this (string name, Version ver, Target [] src, Project [] dependencies) {
        projectName = name; projectVer = ver; targets = src; deps = dependencies;
    }
}
