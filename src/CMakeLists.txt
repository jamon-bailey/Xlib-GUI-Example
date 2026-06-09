
#================================
#     /src Directory Script
#================================

# TODO: Handle project source targets...

add_executable(X11_App)

target_sources(
    X11_App

    PRIVATE
        "${CMAKE_CURRENT_SOURCE_DIR}/main.cpp"
)

target_include_directories(
    X11_App

    PRIVATE
    "${X11_GUI_SOURCE_DIR}/src"
)

target_link_libraries(
    X11_App

    PUBLIC
      X11
)

# Conditionally link against compiler configuration
if(${X11_GUI_CXX_GCC})
    target_link_libraries(
        X11_App
    
        PRIVATE
        X11_GUI_gcc_cxx_bundle
        X11_GUI_gcc_c_defines
    )
elseif(${X11_GUI_CXX_CLANG})
    target_link_libraries(
        X11_App
    
        PRIVATE
        X11_GUI_clang_cxx_bundle
        X11_GUI_clang_c_defines
    )
endif()

# Setup installation of demo executable
install(
    TARGETS X11_App
    COMPONENT X11App
    EXPORT X11_App-targets

    RUNTIME
        DESTINATION ${CMAKE_INSTALL_BINDIR}
)
