#include "StdAfx.h"
#include "AboutDialog.h"
#include "resource.h" 
#ifdef USE_LOCAL_TIDY
#include "../tidy-html5/include/tidy.h"
#else
#include <tidy.h>
#endif

AboutDialog::AboutDialog(void)
{
}

AboutDialog::~AboutDialog(void)
{
}

void AboutDialog::doDialog()
{
    TCHAR buf[1024];

    if (!isCreated())
        create(IDD_ABOUTDIALOG);

/* Want to set the VERSION/DATE from the build 'version.txt' 
   Initially failed due to not using the correct DLG handle.
   Tried HWND hwnd = this.GetSafeHwnd(); //  m_hWnd; - NOPE
   But the above `create` sets _hSelf, so...
 */
    HWND label = GetDlgItem(_hSelf, IDC_VERSION);
    if (label)
    {
        /* get the date and version from the library */
        TCHAR ldate[64];
        TCHAR lvers[64];
        int res1, res2;
        ctmbstr trd = tidyReleaseDate();
        ctmbstr tlv = tidyLibraryVersion();
        /* tidy is in ANSI/UTF-8 chars */
        ldate[0] = 0;
        lvers[0] = 0;
        res1 = MultiByteToWideChar(
            CP_ACP,         // _In_      UINT   CodePage,
            MB_PRECOMPOSED, // _In_      DWORD  dwFlags,
            trd,            // _In_      LPCSTR lpMultiByteStr,
            (int)strlen(trd),// _In_      int    cbMultiByte,
            ldate,          // _Out_opt_ LPWSTR lpWideCharStr,
            sizeof(ldate)   // _In_      int    cchWideChar
        );
        ldate[res1] = 0;    // zero terminate unicode string
        res2 = MultiByteToWideChar(
            CP_ACP,         // _In_      UINT   CodePage,
            MB_PRECOMPOSED, // _In_      DWORD  dwFlags,
            tlv,            // _In_      LPCSTR lpMultiByteStr,
            (int)strlen(tlv),// _In_      int    cbMultiByte,
            lvers,          // _Out_opt_ LPWSTR lpWideCharStr,
            sizeof(lvers)   // _In_      int    cchWideChar
        );
        lvers[res2] = 0;    // zero terminate unicode string
        /* get the IDC_VERSION full version string */
        swprintf(buf, sizeof(buf), _T("HTML Tidy %s, date %s, from https://github.com/htacg/tidy-html5"),
            lvers, ldate);
        SetWindowText(label, buf);  /* set the label */
    }
    label = GetDlgItem(_hSelf, IDC_TIDY2_VERSION);
    if (label) 
    {
        swprintf(buf, sizeof(buf), _T("Version: %s, date %s"), _T(TIDY2_VERSION), _T(TIDY2_DATE));
        SetWindowText(label, buf);  /* set the label */
    }

	goToCenter();
}


INT_PTR CALLBACK AboutDialog::run_dlgProc(UINT Message, WPARAM wParam, LPARAM lParam)
{
	switch (Message) 
	{
        case WM_INITDIALOG :
		{
			return TRUE;
		}
		


		case WM_COMMAND : 
		{
			
				
				switch (wParam)
				{
					case IDOK :
					case IDCANCEL :
						display(FALSE);
						return TRUE;

					default :
						break;
				}
			
		}
	}
	return FALSE;
}