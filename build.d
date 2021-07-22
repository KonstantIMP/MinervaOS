#!/usr/bin/rdmd -Isource/
/**
 * Build script for MinervaOS
 * Author: KonstantIMP <mihedovkos@gmail.com>
 * Date: 22 Jul 2021
 */
module minervabuild;

import build.cli, build.ver, build.project, build.target, build.build;

void initBootloader () {
    Target minervaEfi = new Target ("minerva.efi", [], [], "cd source/boot && make && cd ../..", false);
    Project minervaBoot = new Project ("MinervaBoot", new Version(0, 0, 0), [minervaEfi], []);

    Build.addProject(minervaBoot);
}

int main (string [] args) {
    Cli.success("Build started\n");

    initBootloader();

    Build.buildLoaded();

    return 0;
}


