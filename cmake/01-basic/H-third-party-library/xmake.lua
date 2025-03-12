-- 引用 CMake package
add_requires("cmake::Boost", {
    system = true,
    configs = {
        components = {"filesystem"},
        presets = {Boost_USE_STATIC_LIB = true}
    }
})

-- 通过 dpkg -l | grep filesystem 搜索到的 apt name
-- add_requires("apt::libboost-filesystem-dev:amd64")

target("cmake.01-basic.H-third-party-library.main", function()
    set_kind("binary")
    add_files("main.cc")
    add_packages("cmake::Boost")
    -- add_packages("apt::libboost-filesystem-dev:amd64")
end)
