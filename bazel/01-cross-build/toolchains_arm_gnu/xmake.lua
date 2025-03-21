add_rules("plugin.compile_commands.autoupdate", {outputdir = "."})
add_rules("mode.debug", "mode.release")

add_cxxflags("-Wall", "-Wextra", "-Werror")

target("aarch64-none-elf", function()
    set_kind("binary")
    add_files("aarch64-none-elf/*.cc")
end)

target("aarch64-none-linux-gnu", function()
    set_kind("binary")
    add_files("aarch64-none-linux-gnu/*.cc")
end)

target("arm-none-eabi", function()
    set_kind("binary")
    add_files("arm-none-eabi/*.cc")
end)

target("arm-none-linux-gnueabihf", function()
    set_kind("binary")
    add_files("arm-none-linux-gnueabihf/*.cc")
end)
