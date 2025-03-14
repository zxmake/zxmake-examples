project (subproject1)

set(SOURCES
    main1.cc
)

# include *.cmake 文件以包含 add_analysis 函数
include(${CMAKE_SOURCE_DIR}/cmake/analysis.cmake)
add_analysis(${PROJECT_NAME} SOURCES)

add_executable(${PROJECT_NAME} ${SOURCES})
