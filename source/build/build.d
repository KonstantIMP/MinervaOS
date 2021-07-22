/**
 * Actually builder for projects
 * Author: KonstantIMP <mihedovkos@gmail.com>
 * Date: 22 Jul 2021
 */
module build.build;

import build.cli, build.project, build.target;

class Build {
    private static Project[string] loadedProjects;

    public static void addProject (Project p) {
        loadedProjects[p.projectName] = p;
    }

    public static Project findDependency (string name) {
        return loadedProjects[name];
    }

    public static void buildTarget (Target t) {
        if (t.needRebuild()) {
            import std.process : executeShell, wait;
            import core.stdc.stdlib : exit, EXIT_FAILURE;
            import std.string : indexOf;

            Cli.message("Build target : ", t.targetName, "\n");

            foreach (target; t.deps) buildTarget(target);
        
            string cmd = t.genMakeCommand();

            if (cmd.length == 0) {
                Cli.warning ("Empty target");
                return;
            }

            auto proc = executeShell(cmd);
            if (proc.status != 0 || proc.output.indexOf("is thread local") != -1) {
                Cli.error("====> Program returned: ", proc.status, " <====\n", proc.output);
                exit(EXIT_FAILURE);
            } else Cli.success(proc.output);
        }
    }

    public static void buildProject (Project p) {
        Cli.message("Build project : ", p.projectName, "\n");
        foreach (dep; p.deps) buildProject(dep);
        foreach (target; p.targets) buildTarget(target);
    }

    public static void buildLoaded () {
        foreach (p; loadedProjects.values) buildProject(p);
    }
}
