@setlocal
@if NOT EXIST _setenv.bat goto NOENV
@set TMPPATH=%~p0
@REM echo TMPPATH=%TMPPATH%
@set TMPFIL=%TMPPATH%..\version.txt
@REM get only first line - the version
@set /p TMPVERS=<%TMPFIL%
@echo Current version TMPVERS=%TMPVERS%
@set TMPDIR=vc140-md-64b
@if NOT EXIST %TMPDIR%\build-it.bat goto NOBI
@cd %TMPDIR%
@call build-it
@cd ..
@set TMPDIR=vc100-md-64b
@if NOT EXIST %TMPDIR%\build-it.bat goto NOBI
@cd %TMPDIR%
@call build-it
@cd ..
@set TMPDIR=vc140-md-32b
@if NOT EXIST %TMPDIR%\build-it.bat goto NOBI
@cd %TMPDIR%
@call build-it
@cd ..
@set TMPDIR=vc100-md-32b
@if NOT EXIST %TMPDIR%\build-it.bat goto NOBI
@cd %TMPDIR%
@call build-it
@cd ..
@echo.
@set TMPDIR=vc140-mt-64b
@if NOT EXIST %TMPDIR%\build-it.bat goto NOBI
@cd %TMPDIR%
@call build-it
@cd ..
@echo.
@echo.
@set TMPDIR=vc140-mt-32b
@if NOT EXIST %TMPDIR%\build-it.bat goto NOBI
@cd %TMPDIR%
@call build-it
@cd ..
@echo.

@goto END
:NOENV
@echo Error: Can NOT locate _setenv.bat! *** FIX ME ***
@goto ISERR

:NOBI
@echo Error: Can NOT locate '%TMPDIR%\build-it.bat'! *** FIX ME ***
@goto ISERR

:ISERR
@endlocal
@exit /b 1

:END
@endlocal
@exit /b 0

@REM eof
