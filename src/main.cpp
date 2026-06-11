
#include <X11/X.h>
#include <X11/Xlib.h>
#include <X11/Xutil.h>

// Xlib (X11) HTML Documentation:
// https://xorg.freedesktop.org/archive/current/doc/libX11/libX11/libX11.html
//
// Xlib (X11) PDF Documentation:
// https://xorg.freedesktop.org/archive/current/doc/libX11/libX11/libX11.pdf

static constexpr const char* APP_CLASS_NAME = "Xlib Demo";
static constexpr const char* WINDOW_TITLE_TEXT = "Demo Xlib Application";

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
    XSetWindowAttributes windowAttributes{}; ///< Window attributes

    // Delegate minimum window repaint to Xlib
    windowAttributes.background_pixel = WhitePixel(displayServer, defaultScreen);
    windowAttributes.border_pixel = BlackPixel(displayServer, defaultScreen);

    // Events this window will respond to
    windowAttributes.event_mask = ExposureMask        ///< Notify when window area needs repainting
                                | StructureNotifyMask ///< Notify when window geometry/visibility changes
                                | KeyPressMask        ///< Notify when a keyboard key is pressed
                                | KeyReleaseMask      ///< Notify when a keyboard key is released
                                | ButtonPressMask     ///< Notify when a mouse button is pressed
                                | ButtonReleaseMask   ///< Notify when a mouse button is released
                                | PointerMotionMask;  ///< Notify when the mouse pointer moves

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

    // Check that window creation did not fail
    // Note: In production, use XSetErrorHandler construct with
    //       XSync to really determine if this failed.
    if (mainWindowId == None)
        return 100;

    // Set window titlebar text
    XStoreName(displayServer, mainWindowId, WINDOW_TITLE_TEXT);

    // ---> Set Window Manager Properties <--------------------------------------------------
    // Specify identify of window for window manager
    XClassHint windowHints{};
    windowHints.res_name = const_cast<char*>(WINDOW_TITLE_TEXT); ///< Window instance name
    windowHints.res_class = const_cast<char*>(APP_CLASS_NAME);   ///< Window family (class) name
    XSetClassHint(displayServer, mainWindowId, &windowHints);
    // --------------------------------------------------> Set Window Manager Properties <---

    // Register WM_DELETE_WINDOW protocol so close requests arrive in event loop
    Atom wm_delete = XInternAtom(displayServer, "WM_DELETE_WINDOW", false);
    Atom wm_protocols = XInternAtom(displayServer, "WM_PROTOCOLS", false);
    XSetWMProtocols(displayServer, mainWindowId, &wm_delete, 1);

    // Make newly created window visible on screen
    XMapWindow(displayServer, mainWindowId);
    
    // ---> Run Window Event Loop <----------------------------------------------------------
    XEvent event;

    do {
        // Block until next event is received from queue
        XNextEvent(displayServer, &event);

        // Exit event loop on WM_DELETE_WINDOW event
        if (event.type == ClientMessage &&                ///< Is this the WM protocols channel?
            event.xclient.message_type == wm_protocols && ///< Is this a WM protocol message?
            (Atom)event.xclient.data.l[0] == wm_delete) { ///< Is this a window close event?
            break; // Terminate window event loop
        }
    } while (true);
    // ----------------------------------------------------------> Run Window Event Loop <---

    XDestroyWindow(displayServer, mainWindowId);
    XCloseDisplay(displayServer);

    return 0; // End of application
}
