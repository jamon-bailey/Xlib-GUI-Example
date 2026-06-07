
#=============================================
#     GCC C COMPILER CONFIGURATION (gcc)
#=============================================

# TODO: Setup gcc compiler configuration (if applicable)

set(X11_GUI_GCC_C_VERSION_MIN 14 CACHE STRING "Minimum gcc compiler version")

# Confirm supported gcc compiler version
if(CMAKE_C_COMPILER_VERSION VERSION_LESS ${X11_GUI_GCC_C_VERSION_MIN})
    message(FATAL_ERROR "Incompatible version of GCC C compiler for ${CMAKE_PROJECT_NAME}.")
endif()

# Compiler feature configuration target
add_library(X11_GUI_gcc_c_features INTERFACE)
# Compiler diagnostics configuration target
add_library(X11_GUI_gcc_c_warnings INTERFACE)
# General compiler configuration target
add_library(X11_GUI_gcc_c_options INTERFACE)
# Preprocessor definitions target
add_library(X11_GUI_gcc_c_defines INTERFACE)

# Set C standard version
target_compile_features(
    X11_GUI_gcc_c_features

    INTERFACE
        c_std_11
)

# Set compiler warning flags
target_compile_options(
    X11_GUI_gcc_c_warnings

    INTERFACE
        # Compiler warning flags
        "-Wall"
        "-Wextra"
        "-Wpedantic"
)

# Conditionally add more aggressive warnings
if(X11_GUI_STRICT_C_WARNINGS)
    target_compile_options(
        X11_GUI_gcc_c_warnings

        INTERFACE
            "-Werror"
            "-Wshadow"
            "-Wdouble-promotion"
            "-Wformat=2"
    )
endif()

# Conditionally set compiler optimization level
target_compile_options(
    X11_GUI_gcc_c_options

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
    X11_GUI_gcc_c_defines

    INTERFACE
        # Unconditional preprocessor definitions
        X11_GUI_C_LANG

        # Preprocessor definitions on debug
        $<$<CONFIG:Debug>:
            _X11_GUI_C_DEBUG
            X11_GUI_C_DEBUG
        >

        # Preprocessor definitions on release
        $<$<CONFIG:Release>:
            X11_GUI_C_RELEASE
        >
)

# Complete GCC C compiler package
add_library(X11_GUI_gcc_c_bundle INTERFACE)

target_link_libraries(
    X11_GUI_gcc_c_bundle
    
    INTERFACE
        X11_GUI_gcc_c_features
        X11_GUI_gcc_c_warnings
        X11_GUI_gcc_c_options
        X11_GUI_gcc_c_defines
)
