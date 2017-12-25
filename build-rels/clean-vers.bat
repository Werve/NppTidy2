@setlocal

@set TMPCNT1=0
@set TMPDIRS=vc140-mt-64b vc100-md-64b vc140-md-32b vc140-md-64b vc140-mt-32b vc100-md-32b

@for %%i in (%TMPDIRS%) do @(call :CLEANIT %%i)

@echo Cleaned %TMPCNT1% folders...

@goto END

:CLEANIT
@if "%~1x" == "x" goto :EOF
@if NOT EXIST %1\nul goto :EOF
@cd %1
@if ERRORLEVEL 1 goto :FAILED
@call cmake-clean
@cd ..
@set /A TMPCNT1+=1
@goto :EOF
:FAILED
@echo Error cd %1! *** FIX ME ***
@pause
@goto :EOF

:END
