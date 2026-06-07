
#=====================================================
#     Clang C++ COMPILER CONFIGURATION (clang++)
#=====================================================

# TODO: Setup clang++ compiler configuration (if applicable)

set(X11_GUI_CLANG_CXX_VERSION_MIN 14 CACHE STRING "Minimum clang++ compiler version")

# Confirm supported clang++ compiler version
if(CMAKE_CXX_COMPILER_VERSION VERSION_LESS ${X11_GUI_CLANG_CXX_VERSION_MIN})
    message(FATAL_ERROR "Incompatible version of Clang C++ compiler for ${CMAKE_PROJECT_NAME}.")
endif()

# Compiler feature configuration target
add_library(X11_GUI_clang_cxx_features INTERFACE)
# Compiler diagnostics configuration target
add_library(X11_GUI_clang_cxx_warnings INTERFACE)
# General compiler configuration target
add_library(X11_GUI_clang_cxx_options INTERFACE)
# Preprocessor definitions target
add_library(X11_GUI_clang_cxx_defines INTERFACE)

# Set C++ standard version
target_compile_features(
    X11_GUI_clang_cxx_features

    INTERFACE
        cxx_std_20
)

# Set compiler warning flags
target_compile_options(
    X11_GUI_clang_cxx_warnings

    INTERFACE
        # Compiler warning flags
        "-Wall"
        "-Wextra"
        "-Wpedantic"
)

# Conditionally add more aggressive warnings
if(X11_GUI_STRICT_CXX_WARNINGS)
    target_compile_options(
        X11_GUI_clang_cxx_warnings

        INTERFACE
            "-Werror"
            "-Wshadow"
            "-Wdouble-promotion"
            "-Wformat=2"
    )
endif()

# Conditionally set compiler optimization level
target_compile_options(
    X11_GUI_clang_cxx_options

    INTERFACE
        # Disable optimization on debug
        $<$<CONFIG:Debug>:
            "-O0"
        >

        # High optimization on release
        $<$<CONFIG:Release>:
            "-O2"
        >
)

# Define preprocessor definitions
target_compile_definitions(
    X11_GUI_clang_cxx_defines

    INTERFACE
        # Unconditional preprocessor definitions
        X11_GUI

        # Preprocessor definitions on debug
        $<$<CONFIG:Debug>:
            _X11_GUI_DEBUG
            X11_GUI_DEBUG
        >

        # Preprocessor definitions on release
        $<$<CONFIG:Release>:
            X11_GUI_RELEASE
        >
)

# Complete Clang C++ compiler package
add_library(X11_GUI_clang_cxx_bundle INTERFACE)

target_link_libraries(
    X11_GUI_clang_cxx_bundle
    
    INTERFACE
        X11_GUI_clang_cxx_features
        X11_GUI_clang_cxx_warnings
        X11_GUI_clang_cxx_options
        X11_GUI_clang_cxx_defines
)
