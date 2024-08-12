const std = @import("std");

pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});

    // Modules available to downstream dependencies
    const lib = b.addStaticLibrary(.{
        .name = "zlib",
        .root_source_file = b.path("src/main.zig"),
        .target = target,
        .optimize = optimize,
    });
    lib.linkLibC();
    lib.linkSystemLibrary("zlib");
    b.installArtifact(lib);

    const tests = b.addTest(.{
        .root_source_file = b.path("src/main.zig"),
        .target = target,
        .optimize = optimize,
    });

    const test_step = b.step("test", "Run tests");
    test_step.dependOn(&tests.step);

    const bin = b.addExecutable(.{
        .name = "example1",
        .root_source_file = b.path("example/example1.zig"),
        .target = target,
        .optimize = optimize,
    });
    const zlib_module = b.addModule("zlib", .{
        .root_source_file = b.path("src/main.zig"),
        .target = target,
        .optimize = optimize,
    });
    bin.root_module.addImport("zlib", zlib_module);
    bin.linkLibrary(lib);
    lib.linkSystemLibrary("zlib");
    b.installArtifact(bin);
}
