#include "System.h"

#include "Applications/Bejeweled/BejeweledView.h"
#include "Applications/Lines/LinesView.h"

#ifndef UNICODE
#define UNICODE
#endif 

#include <windows.h>

LRESULT CALLBACK WindowProc(HWND hwnd, UINT uMsg, WPARAM wParam, LPARAM lParam);

GdiWindows gdi;

ApplicationObject<BejeweledView, BejeweledModel> appBejeweled("Bejeweled", "Bejeweled", "bejeweled.png", 0, pageBoardGame);
ApplicationObject<LinesView, LinesModel> appLines("Lines", "Lines", "lines.png", 0, pageBoardGame);

ViewRef v;

int _stdcall WinMain(
	HINSTANCE hInstance,
	HINSTANCE hPrevInstance,
	LPSTR     lpCmdLine,
	int       nShowCmd)
{
	// Register the window class.
	const wchar_t CLASS_NAME[] = L"Sample Window Class";

	WNDCLASS wc = { };

	wc.lpfnWndProc = WindowProc;
	wc.hInstance = hInstance;
	wc.lpszClassName = CLASS_NAME;

	RegisterClass(&wc);

	// Create the window.

	HWND hwnd = CreateWindowEx(
		0,                     // Optional window styles.
		CLASS_NAME,            // Window class
		L"Lca",                // Window text
		WS_OVERLAPPEDWINDOW,   // Window style

		// Size and position
		CW_USEDEFAULT, CW_USEDEFAULT, CW_USEDEFAULT, CW_USEDEFAULT,

		NULL,       // Parent window    
		NULL,       // Menu
		hInstance,  // Instance handle
		NULL        // Additional application data
	);

	if (hwnd == NULL) {
		return 0;
	}

	ShowWindow(hwnd, nShowCmd);


	// Orientation courante
	System::Media::setOrientation();

	// Gestion spécifique de l'interface
	System::Media::initInterface();

	// Référencement de l'interface graphique
	System::Media::setActiveWindow(hwnd);
	gdi.create(1024, 768);

	// Initialisation du mode graphique
	System::Media::setGdiMode(gdiModeGdi);

	// Initialisation de la taille de la zone graphique
	System::Media::setWindowsSize();

	// Initialisation de la fonction randomize
	System::Math::seed();

	
	v = appLines.create();
	v->run();

	return 0;
}

LRESULT CALLBACK WindowProc(HWND hwnd, UINT uMsg, WPARAM wParam, LPARAM lParam) {
	switch (uMsg)
	{
	case WM_DESTROY:
		PostQuitMessage(0);
		return 0;
	case WM_PAINT:
		gdi.begin();
		v->draw(&gdi);
		gdi.end();
		return 0;
	}

	return DefWindowProc(hwnd, uMsg, wParam, lParam);
}
