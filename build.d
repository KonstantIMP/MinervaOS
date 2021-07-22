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

void initStl () {
    string [] stlSource = [
        "source/stl/uda.d"
    ];

    string compile = "ldc2 -mtriple=x86_64-elf64 $in$ --gcc=clang --linker=lld --nogc --relocation-model=pic -c -nodefaultlib -code-model=large -lib -of=$out$";

    Target stlO = new Target ("stl.o", stlSource, [], compile);
    Project stlLib = new Project("MinervaStl", new Version(0,0,0), [stlO], []);

    Build.addProject(stlLib);
}

void initKernel () {
    string [] kernelSource = [
        "source/kernel/kmain.d"
    ];

    string compile = "ldc2 -mtriple=x86_64-elf64 $in$ --gcc=clang --linker=lld --nogc --relocation-model=pic -c -nodefaultlib -code-model=large -Isource/ -of=kmain.o";
    string link = "ld -nostdlib -b elf64-x86-64 -T source/linker.ld -o $out$ kmain.o stl.o";

    Target kernelBin = new Target ("kernel.bin", kernelSource, [], compile ~ " && " ~ link);
    Project minervaKernel = new Project ("MinervaKernel", new Version (0,0,0), [kernelBin], [Build.findDependency("MinervaBoot"), Build.findDependency("MinervaStl")]);

    Build.addProject(minervaKernel);
}

int main (string [] args) {
    Cli.success("Build started\n");

    initBootloader();
    initStl();
    initKernel();

    Build.buildLoaded();

    return 0;
}


