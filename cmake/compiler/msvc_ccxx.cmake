
#=================================================================
#     MICROSOFT VISUAL C/C++ COMPILER CONFIGURATION (cl.exe)
#=================================================================

# TODO: Setup cl.exe compiler configuration (if applicable)

set(X11_GUI_MSVC_VERSION_MIN 1940 CACHE STRING "Minimum MSVC compiler version")

# Confirm supported MSVC compiler version
if(MSVC_VERSION VERSION_LESS ${X11_GUI_MSVC_VERSION_MIN})
    message(FATAL_ERROR "Incompatible version of MSVC C/C++ compiler for ${CMAKE_PROJECT_NAME}.")
endif()

# C++ compiler feature configuration target
add_library(X11_GUI_msvc_cxx_features INTERFACE)
# C++ compiler diagnostics configuration target
add_library(X11_GUI_msvc_cxx_warnings INTERFACE)
# General C++ compiler configuration target
add_library(X11_GUI_msvc_cxx_options INTERFACE)

# C compiler feature configuration target
add_library(X11_GUI_msvc_c_features INTERFACE)
# C compiler diagnostics configuration target
add_library(X11_GUI_msvc_c_warnings INTERFACE)
# General C compiler configuration target
add_library(X11_GUI_msvc_c_options INTERFACE)

# C/C++ preprocessor definitions target
add_library(X11_GUI_msvc_common_defines INTERFACE)

# Set C++ standard version
target_compile_features(
    X11_GUI_msvc_cxx_features

    INTERFACE
        cxx_std_20
)

# Set C++ standard conformance
target_compile_options(
    X11_GUI_msvc_cxx_options

    INTERFACE
        # C++ ISO standard conformance flag
        "/permissive-"
)

# Set C++ compiler warning flags
target_compile_options(
    X11_GUI_msvc_cxx_warnings

    INTERFACE
        # Compiler warning flags
        # "/W4"
)

# Conditionally add more aggressive warnings
if(X11_GUI_STRICT_CXX_WARNINGS)
    target_compile_options(
        X11_GUI_msvc_cxx_warnings

        INTERFACE
            "/WX"
    )
endif()

if(X11_GUI_STRICT_C_WARNINGS)
    target_compile_options(
        X11_GUI_msvc_c_warnings

        INTERFACE
            "/WX"
    )
endif()

# Conditionally set compiler optimization level
target_compile_options(
    X11_GUI_msvc_cxx_options

    INTERFACE
        # Disable optimization on debug
        $<$<CONFIG:Debug>:
            "/Od"
        >

        # High optimization on release
        $<$<CONFIG:Release>:
            "/O2"
        >
)

target_compile_options(
    X11_GUI_msvc_cxx_options

    INTERFACE
        # Character set flags
        "/source-charset:utf-8"
        "/execution-charset:utf-8"
)

# Define C/C++ preprocessor definitions
target_compile_definitions(
    X11_GUI_msvc_common_defines

    INTERFACE
        # Unconditional preprocessor definitions
        X11_GUI
        X11_GUI_WIN32

        # Preprocessor definitions on debug build
        $<$<CONFIG:Debug>:
            _X11_GUI_DEBUG
            X11_GUI_DEBUG
        >

        # Preprocessor definitions on release build
        $<$<CONFIG:Release>:
            X11_GUI_RELEASE
        >
)

# Complete MSVC C++ compiler package
add_library(X11_GUI_msvc_cxx_bundle INTERFACE)
# Complete MSVC C compiler package
add_library(X11_GUI_msvc_c_bundle INTERFACE)

target_link_libraries(
    X11_GUI_msvc_cxx_bundle
    
    INTERFACE
        X11_GUI_msvc_cxx_features
        X11_GUI_msvc_cxx_warnings
        X11_GUI_msvc_cxx_options
        X11_GUI_msvc_common_defines
)

target_link_libraries(
    X11_GUI_msvc_c_bundle
    
    INTERFACE
        X11_GUI_msvc_c_features
        X11_GUI_msvc_c_warnings
        X11_GUI_msvc_c_options
        X11_GUI_msvc_common_defines
)
