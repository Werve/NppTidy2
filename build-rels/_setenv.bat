@REM Set DEFAULT environment
@if "%VCVERS%x" == "x" goto NOVCV
@set TY2_VC_VERS=%VCVERS%
@set TY2_VC_POINT=0
@set TY2_RT_LINK=md
@set TY2_RT_BITS=64
@exit /b 0

:NOVCV
@echo Error: VCVERS NOT set in environment...
@echo This batch file is intended to ONLY be called by the 
@echo respective 'build-it.bat' provided for each release...
@exit /b 1

@REM EOF
