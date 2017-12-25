@setlocal
@if "%TMPVERS%x" == "x" goto NOVERS
@set VCVERS=10
@set TMPBITS=32
@set GENERATOR=Visual Studio %VCVERS%
@REM 20160324 - Change to relative, and use choice
@set TMPPRJ=Tidy2
@echo Build %TMPPRJ% project, in %TMPBITS%-bits
@set TMPLOG=bldlog-1.txt
@set BLDDIR=%CD%
@call ..\_setenv
@if ERRORLEVEL 1 goto NOENV
@REM Any corrections...
@set TY2_RT_BITS=%TMPBITS%
@set TMPID=Tidy2-%TMPVERS%-vc%TY2_VC_VERS%%TY2_VC_POINT%-%TY2_RT_LINK%-%TY2_RT_BITS%b
@echo TMPID=%TMPID%
@set TMPINST=..\install\%TMPID%
@if EXIST %TMPINST%.7z goto DONEIT

@set SET_BAT=%ProgramFiles(x86)%\Microsoft Visual Studio %TY2_VC_VERS%.%TY2_VC_POINT%\VC\vcvarsall.bat
@if NOT EXIST "%SET_BAT%" goto NOBAT
@set TMPSRC=..\..
@if NOT EXIST %TMPSRC%\CMakeLists.txt goto NOCM
@set BUILD_BITS=%PROCESSOR_ARCHITECTURE%
@IF /i %BUILD_BITS% EQU x86_amd64 (
    @set "RDPARTY_ARCH=x64"
    @set "RDPARTY_DIR=software.x64"
) ELSE (
    @IF /i %BUILD_BITS% EQU amd64 (
        @set "RDPARTY_ARCH=x64"
        @set "RDPARTY_DIR=software.x64"
    ) ELSE (
        @echo Appears system is NOT 'x86_amd64', nor 'amd64'
        @echo Can NOT build the 64-bit version! Aborting
        @exit /b 1
    )
)
@set TMPPRE=F:\Projects\install\msvc%TY2_VC_VERS%%TY2_VC_POINT%-%TY2_RT_BITS%\tidy-5.6.0-vc%TY2_VC_VERS%-%TY2_RT_BITS%b
@if NOT EXIST %TMPPRE%\nul goto NOPRE
@echo Doing build %TMPPRJ% %DATE% %TIME% to %TMPLOG%
@echo Doing build %TMPPRJ% %DATE% %TIME% > %TMPLOG%

@echo Doing: 'call "%SET_BAT%" %PROCESSOR_ARCHITECTURE%'
@echo Doing: 'call "%SET_BAT%" %PROCESSOR_ARCHITECTURE%' >> %TMPLOG%
@call "%SET_BAT%" %PROCESSOR_ARCHITECTURE% >> %TMPLOG% 2>&1
@if ERRORLEVEL 1 goto ERR0
@REM call setupqt64
@cd %BLDDIR%
@set TMPOPTS=-DCMAKE_INSTALL_PREFIX=%TMPINST%
@set TMPOPTS=%TMPOPTS% -DCMAKE_PREFIX_PATH=%TMPPRE%
@set TMPOPTS=%TMPOPTS% -G "%GENERATOR%"
@set DOPAUSE=1
:RPT
@if "%~1x" == "x" goto GOTCMD
@if "%~1x" == "NOPAUSEx" (
    @set DOPAUSE=0
) else (
    @set TMPOPTS=%TMPOPTS% %1
)
@shift
@goto RPT
:GOTCMD

@echo Doing: 'cmake %TMPSRC% %TMPOPTS%'
@echo Doing: 'cmake %TMPSRC% %TMPOPTS%' >> %TMPLOG%
@cmake %TMPSRC% %TMPOPTS% >> %TMPLOG% 2>&1
@if ERRORLEVEL 1 goto ERR1

@echo Doing: 'cmake --build . --config release'
@echo Doing: 'cmake --build . --config release' >> %TMPLOG%
@cmake --build . --config release >> %TMPLOG% 2>&1
@if ERRORLEVEL 1 goto ERR3
:DNREL

@echo Doing: 'cmake --build . --config release --target INSTALL'
@echo Doing: 'cmake --build . --config release --target INSTALL' >> %TMPLOG%
@cmake --build . --config release --target INSTALL >> %TMPLOG% 2>&1
@if ERRORLEVEL 1 goto ERR5

@fa4 " -- " %TMPLOG%

@echo Done build and install of %TMPPRJ%...

@cd ..\install

@if EXIST %TMPID%.7z @del %TMPID%.7z
@call 7z a %TMPID%.7z %TMPID%\bin\*
@if ERRORLEVEL 1 goto ZIPERR
@if NOT EXIST %TMPID%.7z goto ZIPERR

@call gensha2 %TMPID%.7z
@if NOT EXIST %TMPID%.7z.SHA256 goto NOSHA
@cd %BLDDIR%

@goto END

:NOSHA
@echo Warning: Unable to gen SHA256
@pause
@goto ISERR

:DONEIT
@echo EXIST %TMPINST%.7z - ren, del, move to redo...
@goto END

:ZIPERR
@echo Appears a problem with 7z zipping...
@pause
@goto ISERR

:ERR0
@echo MSVC %VCVERS% setup error
@goto ISERR

:ERR3
@fa4 "mt.exe : general error c101008d:" %TMPLOG% >nul
@if ERRORLEVEL 1 goto ERR32
:ERR33
@echo release build error
@goto ISERR
:ERR32
@echo Stupid error... trying again...
@echo Doing: 'cmake --build . --config release'
@echo Doing: 'cmake --build . --config release' >> %TMPLOG%
@cmake --build . --config release >> %TMPLOG% 2>&1
@if ERRORLEVEL 1 goto ERR33
@goto DNREL

:ERR5
@echo Install of release FAILED
@goto ISERR

:NOENV
@echo Failed to set environment! *** FIX ME ***
@goto ISERR

:NOVERS
@echo Error: TMPVERS NOT set in environment
@goto ISERR

:NOBAT
@echo Can NOT locate MSVC setup batch "%SET_BAT%"! *** FIX ME ***
@goto ISERR

:NOCM
@echo Can NOT locate %TMPSRC%\CMakeLists.txt! *** FIX ME ***
@goto ISERR

:NOPRE
@echo NOT EXIST %TMPPRE%! *** FIX ME ***
@goto ISERR

:ERR1
@echo cmake config, generation error
@goto ISERR

:ISERR
@endlocal
@exit /b 1

:END
@endlocal
@exit /b 0

@REM eof
