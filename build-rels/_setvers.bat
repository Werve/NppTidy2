@setlocal
@REM Use the special %0 variable to get the path to the current file.
@REM Write %~n0 to get just the filename without the extension.
@REM Write %~n0%~x0 to get the filename and extension.
@REM get PATH
@set TMPPATH=%~p0
@echo TMPPATH=%TMPPATH%
@set TMPFIL=%TMPPATH%..\version.txt
@if NOT EXIST %TMPFIL% goto NOFIL
@for /f "delims=" %%x in (%TMPFIL%) do @set TMPDATE=%%x
@set /p TMPVERS=<%TMPFIL%
@echo TMPVERS=%TMPVERS%
@echo TMPDATE=%TMPDATE%
@goto END

:NOFIL
@echo Can NOT locate '%TMPFIL%'! *** FIX ME ***
@goto ISERR


:ISERR
@endlocal
@exit /b 1

:END
@endlocal
@exit /b 0

@REM eof
