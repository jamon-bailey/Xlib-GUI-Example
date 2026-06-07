
#====================================================
#
#     Native X11 GUI Application
#     (Root CMakeLists.txt Script)
#
#====================================================

# Setup CMake project
cmake_minimum_required(VERSION 3.12 FATAL_ERROR)

project(
    X11_Demo_Application
    VERSION 0.0.0.0
    LANGUAGES
        C CXX
)

# Export compilation commands to build dir
set(CMAKE_EXPORT_COMPILE_COMMANDS ON)

# Include root CML helper module
include(cmake/utility/root_setup.cmake)
setup_clang_format_target()
setup_clang_tidy_target()

# Include compiler configuration script
include(cmake/compiler/config_dispatch.cmake)


set(X11_GUI_SOURCE_DIR "${CMAKE_CURRENT_SOURCE_DIR}")
set(X11_GUI_CMAKE_MODULES_DIR "${CMAKE_CURRENT_SOURCE_DIR}/cmake")

# Include native install directory variables
include(GNUInstallDirs)

# Source Subdirs
add_subdirectory(src)
