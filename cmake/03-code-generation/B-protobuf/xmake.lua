add_rules("plugin.compile_commands.autoupdate", {outputdir = "."})
add_rules("mode.debug", "mode.release")

add_cxxflags("-Wall", "-Wextra", "-Werror")
set_languages("c++17")

add_requires("protobuf-cpp 3.19.4")

target("cmake.03-code-generation.B-protobuf.pb", function()
    set_kind("object")
    add_files("*.proto", {proto_public = true})
    add_rules("protobuf.cpp")
    add_packages("protobuf-cpp", {public = true})
    set_policy('build.fence', true)
end)

target("cmake.03-code-generation.B-protobuf.main", function()
    set_kind("binary")
    add_files("main.cc")
    add_deps("cmake.03-code-generation.B-protobuf.pb")
end)
