
#include <X11/Xlib.h>

// Xlib (X11) HTML Documentation:
// https://xorg.freedesktop.org/archive/current/doc/libX11/libX11/libX11.html
//
// Xlib (X11) PDF Documentation:
// https://xorg.freedesktop.org/archive/current/doc/libX11/libX11/libX11.pdf

int main(const int argc, const char* argv[])
{
    // ---> Connect To Default Display Server <----------------------------------------------
    Display* displayServer = XOpenDisplay(nullptr);

    if (!displayServer)
        return 1;
    // ----------------------------------------------> Connect To Default Display Server <---

    // Index of the default screen on the display server
    const int defaultScreen = XDefaultScreen(displayServer);

    // ---> Create Window On Display Server <------------------------------------------------
    XSetWindowAttributes windowAttributes{};

    windowAttributes.background_pixel = WhitePixel(displayServer, defaultScreen);
    windowAttributes.border_pixel = BlackPixel(displayServer, defaultScreen);

    // Events this window will respond to
    windowAttributes.event_mask = ExposureMask
                                | StructureNotifyMask
                                | KeyPressMask
                                | KeyReleaseMask
                                | ButtonPressMask
                                | ButtonReleaseMask
                                | PointerMotionMask;

    Window mainWindowId = XCreateWindow( ///< Identifier of main application window
        displayServer,                               ///< Display server
        RootWindow(displayServer, defaultScreen),    ///< Parent window
        0,                                           ///< Window x-coordinate
        0,                                           ///< Window y-coordinate
        800,                                         ///< Window width
        500,                                         ///< Window height
        1,                                           ///< Window border width
        DefaultDepth(displayServer, defaultScreen),  ///< Window bits per pixel
        InputOutput,                                 ///< Window classification
        DefaultVisual(displayServer, defaultScreen), ///< Window pixel characteristics
        CWBackPixel | CWBorderPixel | CWEventMask,   ///< Values set in attributes
        &windowAttributes                            ///< Window attributes
    );
    // ------------------------------------------------> Create Window On Display Server <---

    // Set window titlebar text
    XStoreName(displayServer, mainWindowId, "Demo Xlib Application");

    Atom wm_delete = XInternAtom(displayServer, "WM_DELETE_WINDOW", false);
    XSetWMProtocols(displayServer, mainWindowId, &wm_delete, 1);

    // Make newly created window visible on screen
    XMapWindow(displayServer, mainWindowId);
    
    // ---> Run Window Event Loop <----------------------------------------------------------
    XEvent event;

    do {
        XNextEvent(displayServer, &event);

        if (event.type == ClientMessage && (Atom)event.xclient.data.l[0] == wm_delete)
            break;
    } while (true);
    // ----------------------------------------------------------> Run Window Event Loop <---

    XDestroyWindow(displayServer, mainWindowId);
    XCloseDisplay(displayServer);

    return 0; // End of application
}
