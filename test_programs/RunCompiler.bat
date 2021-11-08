: # This is a special script which intermixes both (linux/unix/Mac) sh
: # and (Windows) cmd code. It is written this way because it is
: # used in system() shell-outs directly in otherwise
: # portable code. See http://stackoverflow.com/questions/17510688
: # for details.
: #
: # This is particularly interesting for Languages and compilers as the script
: # is an example of a program that is syntactically correct in two languages!
: #
:<<"::ENDOFWINDOWS"
@ECHO off
REM Batch file to Run the Compiler testing Makefile
REM Brian Tompsett Sep 2013 
REM
:: Usage
:: RunCompiler <source directory> ["BATCH=yes"] ["SOURCE=name"] ["TESTS=test list"]
:: defaults <current directory>
:: 
::  When "BATCH=yes" is specified, the script does not pause for input
::  When "SOURCE=name" is specified the scripts looks for files called name.l name.y and name.c
::  When "TESTS=test list" the compiler is only run of the tests named in the list.
::
:: History:
::    Ver 1 : Sep 2013 Cloned from 08241 test scripts
::        2 : Dec 2014 Made multi-platform
::          : Oct 2015 Fixed Visual Studio Compiler function
::            Oct 2017 Added check for cross platform binaries in shared drives
::                     Added VS community edition check
::                     Check for spaces in bison path
::                     Check for nmake on the path; use hidden nmake
::            May 2018 Fixed for powershell invocation
::            Oct 2018 Fixed unix version to improve POSIX compliance and portability
::            Sep 2020 Fixed for either U: or S: drive
::            Oct 2020 Disambiguated find and where for alien systems
::                     codepage fix for machine with foreign character sets
::
:: ===============================================================================
::
:: We can check how the script was called %cmdcmdline% can be the null string 
:: or sometime "C: (unpaired quote!)
:: or the string  cmd /c ""T:\lab1test.bat" "
:: We have to discover which
:: There is magic space at the end of the following line to remove a null string
set invoker=%cmdcmdline% 
:: Now remove any troublesome quotes
REM %invoker%
set invoker=%invoker:"=`%
REM %invoker%
:: Here we must quote the line as it might contain meta characters
IF "%invoker:~0,3%" == "cmd" GOTO :Clicked
:: For some reason, sometime the full path is used - and the case varies
:: IF /I "%invoker:~0,27%" == "C:\WINDOWS\system32\cmd.exe" GOTO :Clicked
IF "%invoker:~-3%" == " ` " GOTO :Clicked
GOTO :DOSLaunch
:Clicked
@color 4e
echo Launched from Windows: %CD%
echo.
echo This will make basic tests of the compiler for 600087 ACW
echo.
echo.
echo.
echo.
echo.
echo.
echo Normally %~n0 is called from the Command Prompt 
echo                    in the directory of the compiler location...
echo.
echo.
echo.
echo.
echo.
echo.
echo.
echo Type the full path to the compiler sources on the next line...
set /P Ans=[or hit enter to close] : 
if "%Ans%" == "" EXIT /b 1
set cmdcmdline= 
Call "%~0" "%Ans%"
PAUSE
EXIT /b
:DOSLaunch
echo Starting tests %~n0
:: -------------------------------- Variable Initialisation --------
REM set standard strings
set TESTNAME=initialisation
:: save the active code page number parsing "Active code page: NNN" output from CHCP
for /F "tokens=4" %%G in ('chcp') do set "_chcp=%%G"
:: change the active console code page to UTF-8 
>NUL chcp 65001
::
:: --------------------------------  Argument Processing --------------
::
REM
::
:: --------------------------------  End Argument Processing --------------
::
:: Now check that we are in the University 
:: - I do not want to support copies of this code as it makes 
:: a maintenance and configuration management problem - bugs propagate and
:: do not get fixed.
:: Please use the university VPN to map the drive properly
Echo "Script Directory: %~dp0"
set "drive=%~dp0"
set "driveletter=%drive:~0,2%"
if /i NOT "%driveletter%" == "T:" GOTO :NotT
:: Check if alias exists - extract shared drive from subst
for /f "tokens=2 delims==" %%i in ('subst ^| c:\windows\system32\findstr /c:"T:" ') do set "aliased=%%i"
set "driveletter=%aliased:~2,2%"
:NotT
:: Call net use and strip out the desired line and select the third field!
for /f "tokens=3 delims= " %%i in ('net use %driveletter% ^| C:\WINDOWS\system32\findstr /c:"Remote name" ') do set netdrive=%%i
Echo "Shared drive is ``%driveletter%%netdrive: =%``"
if /I  "%netdrive: =%" == "\\adir.hull.ac.uk\studentshare" GOTO :OKLocation
if /I NOT "%netdrive: =%" == "\\data.adir.hull.ac.uk\studentshare" GOTO :BadPath
:OKLocation
if NOT exist "U:\Computer Science\600087\Lab\" GOTO :BadLocation
If /I "%~dp0" == "U:\Computer Science\600087\Lab\" GOTO :AtUni
if /I NOT "%~dp0" == "T:\" GOTO :WrongDrive
:: set to a blank
set aliased= 
for /f "tokens=2 delims==" %%i in ('subst ^| C:\WINDOWS\system32\findstr /c:"T:" ') do set aliased=%%i
if /I "%aliased:~2%" == "%driveletter%\Computer Science\600087\Lab" GOTO :AtUni
GOTO :BadLocation
:BadPath
if /I NOT "%netdrive: =%" == "\\adir.hull.ac.uk\Shared" GOTO :BadLocation
:: On the S: drive there can be two routes to  the files!
if EXIST "S:\Student Share\Computer Science\600087\Lab\" GOTO :OnsDrive
if NOT exist "S:\Computer Science\600087\Lab\" GOTO :BadLocation
If /I "%~dp0" == "S:\Computer Science\600087\Lab\" GOTO :AtUni
:OnsDrive
If /I "%~dp0" == "S:\Student Share\Computer Science\600087\Lab\" GOTO :AtUni
if /I NOT "%~dp0" == "T:\" GOTO :WrongDrive
:: set to a blank
set aliased= 
for /f "tokens=2 delims==" %%i in ('subst ^| C:\WINDOWS\system32\findstr /c:"T:" ') do set aliased=%%i
if /I "%aliased:~2%" == "S:\Computer Science\600087\Lab" GOTO :AtUni
if /I "%aliased:~2%" == "S:\Student Share\Computer Science\600087\Lab" GOTO :AtUni
:BadLocation
  (echo Script not running from correct directory: %netdrive% :: %~dp0) 1>&2
  (echo If you are using your own PC,) 1>&2                                
  (echo Please use the university VPN to map the drive U:) 1>&2        
  pause      
GOTO :End
:WrongDrive
  (echo Script not running from correct directory: %netdrive% :: %~dp0) 1>&2
  (echo You cannot make copies of the test scripts as they are updated) 1>&2
GOTO :End
:AtUni
:: ---------------------------------------
:: Check for gcc?

set OBJECTFLAG=-o
set LINKERFLAG=-lfl
set CC=gcc
set gccpath=
CALL :which gcc gccpath
IF NOT "%gccpath%x"=="x" GOTO :HaveGCC
echo GCC Not found, looking for visual studio...
:: ------------------------------   Set up C compiler ----------------------
IF EXIST "C:\Program Files (x86)\Microsoft Visual Studio\2017\Professional\MSBuild\15.0\Bin\Roslyn\csc.exe" GOTO :Uni2018
:: Botch for 2017 poor installation
if EXIST "C:\Program Files (x86)\Microsoft Visual Studio\2017\Professional\VC\Tools\MSVC\14.11.25503\bin\HostX86\x86\cl.exe" GOTO :Uni2017
:: Botch for 2017 Enterprise Edition
if EXIST "C:\Program Files (x86)\Microsoft Visual Studio\2017\Enterprise\MSBuild\15.0\Bin\Roslyn\csc.exe" GOTO :VS2017EN
if EXIST "C:\Program Files\Microsoft Visual Studio\2017\Enterprise\VC\vcvarsall.bat" GOTO :VS2017
IF EXIST "C:\Windows\Microsoft.NET\Framework\v4.0.30319\csc.exe" GOTO :CSVM
:: Botch for uni Windows 10
if EXIST "C:\Program Files (x86)\MSBuild\14.0\bin\cl.exe" GOTO :Win10
If EXIST "C:\Program Files (x86)\Microsoft Visual Studio 14.0\VC\bin\cl.exe" GOTO :Win10X
:: get visual studio environment
if EXIST "C:\Program Files (x86)\Microsoft Visual Studio 12.0\VC\vcvarsall.bat" GOTO :VS12CS
if EXIST "C:\Program Files\Microsoft Visual Studio 12.0\VC\vcvarsall.bat" GOTO :VS12
if EXIST "C:\Program Files (x86)\Microsoft Visual Studio 11.0\VC\vcvarsall.bat" GOTO :VS11CS
if EXIST "C:\Program Files\Microsoft Visual Studio 11.0\VC\vcvarsall.bat" GOTO :VS11
if EXIST "C:\Program Files (x86)\Microsoft Visual Studio 10.0\VC\vcvarsall.bat" GOTO :VS10CS
if EXIST "C:\Program Files\Microsoft Visual Studio 10.0\VC\vcvarsall.bat" GOTO :VS10
if EXIST "C:\Program Files\Microsoft Visual Studio 9.0\VC\vcvarsall.bat" GOTO :VS9
if EXIST "C:\Program Files\Microsoft Visual Studio\2017\Enterprise\VC\vcvarsall.bat" GOTO :VS2017
:: Community edition path (courtesy Jesse Serrao)
IF EXIST "C:\Program Files (x86)\Microsoft Visual Studio\2017\Community\VC\Auxiliary\Build\vcvarsall.bat" GOTO :VSC17
:: Botch for 2017 Community Edition
if EXIST "C:\Program Files (x86)\Microsoft Visual Studio\2017\Community\MSBuild\15.0\Bin\Roslyn\csc.exe" GOTO :VS2017CO
:: Now on D drive
if EXIST "D:\Microsoft Visual Studio\2017\Community\MSBuild\15.0\Bin\Roslyn\csc.exe" GOTO :VS2017D
echo Unable to find Visual Studio ...
GOTO :Failure
:Uni2018
set compile="C:\Program Files (x86)\Microsoft Visual Studio\2017\Professional\MSBuild\15.0\Bin\Roslyn\csc.exe"  -out:%TEMP%\program.exe
GOTO :CompilerReady
:CSVM
set compile=C:\Windows\Microsoft.NET\Framework\v4.0.30319\csc.exe -out:%TEMP%\program.exe
GOTO :CompilerReady
:VS2017D
set compile="D:\Microsoft Visual Studio\2017\Community\MSBuild\15.0\Bin\Roslyn\csc.exe" -out:%TEMP%\program.exe
GOTO :CompilerReady
:VS2017CO
set compile="C:\Program Files (x86)\Microsoft Visual Studio\2017\Community\MSBuild\15.0\Bin\Roslyn\csc.exe" -out:%TEMP%\program.exe
GOTO :CompilerReady
:VS2017EN
set compile="C:\Program Files (x86)\Microsoft Visual Studio\2017\Enterprise\MSBuild\15.0\Bin\Roslyn\csc.exe" -out:%TEMP%\program.exe
GOTO :CompilerReady
:VS2017
call "C:\Program Files\Microsoft Visual Studio\2017\Enterprise\VC\vcvarsall.bat"
GOTO :VS
:VSC17
call "C:\Program Files (x86)\Microsoft Visual Studio\2017\Community\VC\Auxiliary\Build\vcvarsall.bat" x86
GOTO :VS
:Uni2017
call "C:\Program Files (x86)\Microsoft Visual Studio\2017\Professional\VC\Auxiliary\Build\vcvars32.bat"
GOTO :VS
:VS9
call ^"C:\Program Files\Microsoft Visual Studio 9.0\VC\vcvarsall.bat^" x86 >nul <nul
GOTO :VS
:VS10
call ^"C:\Program Files\Microsoft Visual Studio 10.0\VC\vcvarsall.bat^" x86 >nul <nul
set theValue=
for /f "delims=" %%a in ('C:\WINDOWS\system32\where csc 2^>nul') do @set theValue=%%a 
if NOT "%theValue%."=="." GOTO :VS
echo *** Stupid machine in Fenner has a setup error, but I fixed it! ****
set CC=C:\Windows\Microsoft.NET\Framework\v4.0.30319\cl
set compile=%CC% /Fe:%TEMP%\program.exe
GOTO :CompilerReady
GOTO :VS
:VS10CS
call ^"C:\Program Files (x86)\Microsoft Visual Studio 10.0\VC\vcvarsall.bat^" x86 >nul <nul
set theValue=
for /f "delims=" %%a in ('C:\WINDOWS\system32\where csc 2^>nul') do @set theValue=%%a 
if NOT "%theValue%."=="." GOTO :VS
echo *** Stupid machine in RB-321 has a setup error, but I fixed it! ****
set CC=C:\Windows\Microsoft.NET\Framework\v4.0.30319\cl
set compile=%CC% /Fe:%TEMP%\program.exe
GOTO :CompilerReady
:Win10
set CC="C:\Program Files (x86)\MSBuild\14.0\bin\cl.exe"
set CL=/nologo
set compile=%CC% /Fe:%TEMP%\program.exe 
GOTO :CompilerReady
:Win10X
set CC="C:\Program Files (x86)\Microsoft Visual Studio 14.0\VC\bin\cl.exe"
set CL=/nologo
set compile=%CC% /Fe:%TEMP%\program.exe 
GOTO :CompilerReady
:VS11
call ^"C:\Program Files\Microsoft Visual Studio 11.0\VC\vcvarsall.bat^" x86 >nul <nul
GOTO :VS
:VS11CS
call ^"C:\Program Files (x86)\Microsoft Visual Studio 11.0\VC\vcvarsall.bat^" x86 >nul <nul
GOTO :VS
:VS12
call ^"C:\Program Files\Microsoft Visual Studio 12.0\VC\vcvarsall.bat^" x86 >nul <nul
GOTO :VS
:VS12CS
call ^"C:\Program Files (x86)\Microsoft Visual Studio 12.0\VC\vcvarsall.bat^" x86 >nul <nul
set theValue=
for /f "delims=" %%a in ('C:\WINDOWS\system32\where cl 2^>nul') do @set theValue=%%a 
if NOT "%theValue%."=="." GOTO :VS
echo *** Stupid machine in RB-321 has a setup error, but I fixed it! ****
set CC="C:\Program Files (x86)\Microsoft Visual Studio 12.0\VC\bin\cl"
set compile=%CC% /Fe:%TEMP%\program.exe 
set LIBPATH="C:\Windows\Microsoft.NET\Framework\v4.0.30319";"C:\Program Files (x86)\Microsoft Visual Studio 12.0\VC\lib";"C:\Program Files (x86)\Windows Kits\8.1\Lib\winv6.3\um\x86";%LIBPATH%
set INCLUDE="C:\Program Files (x86)\Microsoft Visual Studio 12.0\VC\include"
set _CL_=/link "C:\Program Files (x86)\Microsoft Visual Studio 12.0\VC\lib\LIBCMT.lib" "C:\Program Files (x86)\Microsoft Visual Studio 12.0\VC\lib\OLDNAMES.lib" "C:\Program Files (x86)\Windows Kits\8.1\Lib\winv6.3\um\x86\kernel32.lib"
:: set CL=/Fo%TEMP%
GOTO :CompilerReady
:VS
set CC=cl

set compile=%CC% /Fe:%TEMP%\program.exe
:CompilerReady
set CL=/nologo -DYY_MAIN
set OBJECTFLAG=/Fe:
set LINKERFLAG=/link C:\GnuWin32\lib\libfl.a
if NOT EXIST C:\GnuWin32\lib\libfl.a SET LINKERFLAG=/link T:\GnuWin32\lib\libfl.a
C:\WINDOWS\system32\where cl
:HaveGCC
:: Look for nmake on the path
set theValue=
set MAKE=nmake
for /f "delims=" %%a in ('C:\WINDOWS\system32\where nmake 2^>nul') do @set theValue=%%a
if NOT "%theValue%."=="." GOTO :HaveMake
:: look for nmake buried in visual studio
:: Paths courtesy of http://bojan-komazec.blogspot.co.uk/2011/10/nmake-and-its-environment.html
::
set MAKE="C:\Program Files (x86)\Microsoft Visual Studio\2017\Enterprise\VC\Tools\MSVC\14.13.26128\bin\Hostx64\x64\nmake.exe"
if EXIST %MAKE% GOTO :HaveMake
set MAKE="C:\Program Files (x86)\Microsoft Visual Studio\2017\Enterprise\VC\Tools\MSVC\14.15.26726\bin\Hostx64\x64\nmake.exe"
if EXIST %MAKE% GOTO :HaveMake
set MAKE="C:\Program Files (x86)\Microsoft Visual Studio\2017\Enterprise\VC\Tools\MSVC\14.11.255013\bin\HostX86\x86\nmake.exe"
if EXIST %MAKE% GOTO :HaveMake
set MAKE="C:\Program Files (x86)\Microsoft Visual Studio\2017\Professional\VC\Tools\MSVC\14.16.27023\bin\Hostx86\x86\nmake.exe"
if EXIST %MAKE% GOTO :HaveMake
set MAKE="C:\Program Files (x86)\Microsoft Visual Studio\2017\Professional\VC\Tools\MSVC\14.14.26428\bin\Hostx64\x64\nmake.exe"
if EXIST %MAKE% GOTO :HaveMake
set MAKE="C:\Program Files (x86)\Microsoft Visual Studio\2017\Professional\VC\Tools\MSVC\14.11.25503\bin\HostX64\x64\nmake.exe"
if EXIST %MAKE% GOTO :HaveMake
set MAKE="C:\Program Files (x86)\Microsoft Visual Studio 14.0\VC\bin\nmake.exe"
if EXIST %MAKE% GOTO :HaveMake
set MAKE="C:\Program Files\Microsoft Visual Studio 14.0\VC\bin\nmake.exe"
if EXIST %MAKE% GOTO :HaveMake
set MAKE="C:\Program Files (x86)\Microsoft Visual Studio 13.0\VC\bin\nmake.exe"
if EXIST %MAKE% GOTO :HaveMake
set MAKE="C:\Program Files\Microsoft Visual Studio 13.0\VC\bin\nmake.exe"
if EXIST %MAKE% GOTO :HaveMake
set MAKE="C:\Program Files (x86)\Microsoft Visual Studio 12.0\VC\bin\nmake.exe"
if EXIST %MAKE% GOTO :HaveMake
set MAKE="C:\Program Files\Microsoft Visual Studio 12.0\VC\bin\nmake.exe"
if EXIST %MAKE% GOTO :HaveMake
set MAKE="C:\Program Files (x86)\Microsoft Visual Studio 11.0\VC\bin\nmake.exe"
if EXIST %MAKE% GOTO :HaveMake
set MAKE="C:\Program Files\Microsoft Visual Studio 11.0\VC\bin\nmake.exe"
if EXIST %MAKE% GOTO :HaveMake
set MAKE="C:\Program Files (x86)\Microsoft Visual Studio 10.0\VC\bin\nmake.exe"
if EXIST %MAKE% GOTO :HaveMake
set MAKE="C:\Program Files\Microsoft Visual Studio 10.0\VC\bin\nmake.exe"
if EXIST %MAKE% GOTO :HaveMake
set MAKE="C:\Program Files\Microsoft Visual Studio 9.0\VC\bin\nmake.exe"
if EXIST %MAKE% GOTO :HaveMake
set MAKE="C:\Program Files\Microsoft Visual Studio 10.0\VC\bin\amd64\nmake.exe"
if EXIST %MAKE% GOTO :HaveMake
set MAKE="C:\Program Files\Microsoft Visual Studio 9.0\VC\bin\amd64\nmake.exe"
if EXIST %MAKE% GOTO :HaveMake
:: Community edition path (courtesy Jesse Serrao)
set MAKE="C:\Program Files (x86)\Microsoft Visual Studio\2017\Community\VC\Tools\MSVC\14.10.25017\bin\HostX86\x86\nmake.exe"
if EXIST %MAKE% GOTO :HaveMake
:: 2017 Enterprise Edition
set MAKE="C:\Program Files (x86)\Microsoft Visual Studio\2017\Enterprise\VC\Tools\MSVC\14.11.255013\bin\HostX86\x86\nmake.exe"
if EXIST %MAKE% GOTO :HaveMake
set MAKE="C:\Program Files (x86)\Microsoft Visual Studio\2017\Enterprise\VC\Tools\MSVC\14.16.27023\bin\Hostx86\x86\nmake.exe"
if EXIST %MAKE% GOTO :HaveMake
:: Special for Cosmin
set MAKE="D:\Program Files (x86)\Microsoft Visual Studio\2019\Community\VC\Tools\MSVC\14.26.28801\bin\Hostx86\x86\nmake.exe"
if EXIST %MAKE% GOTO :HaveMake
:: Community 2019
set MAKE="C:\Program Files (x86)\Microsoft Visual Studio\2019\Community\VC\Tools\MSVC\14.27.29110\bin\Hostx86\x86\nmake.exe"
if EXIST %MAKE% GOTO :HaveMake
set MAKE="C:\Program Files (x86)\Microsoft Visual Studio\2019\Community\VC\Tools\MSVC\14.25.28610\bin\Hostx86\x86\nmake.exe"
if EXIST %MAKE% GOTO :HaveMake
set MAKE="C:\Program Files (x86)\Microsoft Visual Studio\2019\Community\VC\Tools\MSVC\14.24.28314\bin\HostX64\x86\nmake.exe"
if EXIST %MAKE% GOTO :HaveMake
set MAKE="C:\Program Files (x86)\Microsoft Visual Studio\2019\Community\VC\Tools\MSVC\14.24.28314\bin\Hostx86\x86\nmake.exe"
if EXIST %MAKE% GOTO :HaveMake
set MAKE="C:\Program Files (x86)\Microsoft Visual Studio\2017\Community\VC\Tools\MSVC\14.16.27023\bin\Hostx86\x86\nmake.exe"
if EXIST %MAKE% GOTO :HaveMake
set MAKE="C:\Program Files (x86)\Microsoft Visual Studio\2019\Enterprise\VC\Tools\MSVC\14.27.29110\bin\Hostx86\nmake.exe"
if EXIST %MAKE% GOTO :HaveMake
set MAKE="C:\Program Files (x86)\Microsoft Visual Studio\2019\Enterprise\VC\Tools\MSVC\14.27.29110\bin\Hostx86\x86\nmake.exe"
if EXIST %MAKE% GOTO :HaveMake
set MAKE="C:\Program Files (x86)\Microsoft Visual Studio\2019\Community\VC\Tools\MSVC\14.28.29333\bin\Hostx86\x86\nmake.exe"
if EXIST %MAKE% GOTO :HaveMake
set MAKE="C:\Program Files (x86)\Visual Studio\VC\Tools\MSVC\14.11.25503\bin\Hostx86\x86\nmake.exe"
if EXIST %MAKE% GOTO :HaveMake
set MAKE="C:\Program Files (x86)\Visual Studio\VC\Tools\MSVC\14.28.29910\bin\Hostx86\x86\nmake.exe"
if EXIST %MAKE% GOTO :HaveMake
set MAKE="C:\Program Files (x86)\Microsoft Visual Studio\2019\Professional\VC\Tools\MSVC\14.29.30133\bin\Hostx86\x86\nmake.exe"
if EXIST %MAKE% GOTO :HaveMake
set MAKE="C:\Program Files (x86)\Microsoft Visual Studio\2019\Enterprise\VC\Tools\MSVC\14.29.30133\bin\Hostx86\x86\nmake.exe"
if EXIST %MAKE% GOTO :HaveMake
:: Fix for Bai Zhuohan
set MAKE="D:\60087用到的软件\VC\Tools\MSVC\14.27.29110\bin\Hostx86\x86\nmake.exe"
if EXIST %MAKE% GOTO :HaveMake
:: Special Patch for Luke Beckerleg
set MAKE="F:\Microsoft Visual Studio\2017\Community\VC\Tools\MSVC\14.16.27023\bin\Hostx86\x86\nmake.exe"
if EXIST %MAKE% GOTO :HaveMake
set MAKE="C:\WinDDK\6001.18001\bin\x86\nmake.exe"
if EXIST %MAKE% GOTO :HaveMake
set MAKE="C:\WinDDK\6001.18001\bin\ia64\nmake.exe"
if EXIST %MAKE% GOTO :HaveMake
:: Now look for standalone nmake
set MAKE="C:\dmake\nmake.exe"
if EXIST %MAKE% GOTO :HaveMake
set MAKE="C:\nmake\nmake.exe"
if EXIST %MAKE% GOTO :HaveMake
echo **** Nmake program not found. You can get it from http://guest.engelschall.com/~sb/download/win32/ ****
:: Fallback on secret copy of nmake in U: drive
set MAKE="%~dp0GnuWin32\bin\nmake.exe"
if EXIST %MAKE% GOTO :HaveMake
GOTO :Failure
:HaveMake

:: Now check for Makefile
IF EXIST "T:\" GOTO :GOTDIR
SET myhome=%~dp0
:: Chop off trailing backslash in subst
SUBST T: "%myhome:~0,-1%"
:GOTDIR
IF "%~1" == "clean" IF "%~2" == "" GOTO :CleanUp
:: Can not subst an equal - needs a for loop workaround:
:: http://www.experts-exchange.com/Programming/Languages/Scripting/Shell/Batch/Q_26868786.html
set _one=%~1
set _two=%~1
for /f "tokens=1* delims==" %%a in ("%_one%") do (
  if "%%b"=="" (
     set %_one%=%%a
	 ) else (
	 set %_one%=%%aX%%b
	 )
)
IF "%_two%" == "%_one%" GOTO :NOOPT
echo Parameter 1 is a directory name, not an option
GOTO :Failure
:CleanUp
CALL %MAKE% -f T:Makefile /NOLOGO clean
GOTO :Complete

:NOOPT
set OCD=%CD%
IF "%~1"=="" GOTO :NODIR
IF %1==""  GOTO :NODIR
IF EXIST %1 GOTO :Found
echo ***** Source directory does not exist ******
GOTO :Failure
:Found
CD /d %1
:NODIR

:: Quick check for bison path
set BISON="C:\GnuWin32\bin\bison.exe" 
set BISONPATH=C:\GnuWin32\bin\
if EXIST %BISON% GOTO :GotBison
set BISON="C:\Program Files (x86)\GnuWin32\bin\bison.exe"
set BISONPATH=
if NOT EXIST %BISON% GOTO :GotBison
echo Bison cannot be installed in "Program Files" - no space in directory permitted
:GotBison
set theValue=
for /f "delims=" %%a in ('C:\WINDOWS\system32\where bison 2^>nul') do @set theValue=%%a
if NOT "%theValue%."=="." GOTO :BisonPath
:: Look for bison in some places
echo Bison not on the command prompt path
:: Fix the Path
IF "%BISONPATH%"=="" GOTO :NoBison
SET PATH=%BISONPATH%;%PATH%
GOTO :StartTests
:NoBison
:: Look for bison in the hidden place
IF NOT EXIST "T:\GnuWin32\bin\bison.exe" GOTO :BisonPath
SET BISON="T:\GnuWin32\bin\bison.exe"
set FLEX="T:\GnuWin32\bin\flex.exe"
set FLEXLIB=T:\GnuWin32\lib
IF NOT "%LINKERFLAG%" == "-lfl" SET LINKERFLAG=/link T:\GnuWin32\lib\libfl.a
SET BISONPATH=T:\GnuWin32\bin
SET PATH=%BISONPATH%;%PATH%
GOTO :StartTests
:BisonPath
if "%theValue%"=="%theValue: =%"  GOTO :BisonPathGood
echo Bison cannot be installed in a directory with a space in its name (%theValue%)
:BisonPathGood
set BISON=bison

:: Start tests
:StartTests
:: Check that critical executable files are executable on this platform - 
::  May be a problem with shared directories and multiple machines such as university network drives
    :: Will generate pop-up errors if invalid executable
Call :ZapExe lexer
Call :ZapExe parser
Call :ZapExe compiler
Call :ZapExe tree
Call :ZapExe a
Call :ZapExe b
Call :ZapExe c
Call :ZapExe d
Call :ZapExe e

:: The %CC% variable may contain a quoted path to the compiler, so the quotes need escaping
CALL %MAKE% -f T:Makefile /NOLOGO "CC=%CC:"=\"%" "OBJECTFLAG=%OBJECTFLAG%" "LINKERFLAG=%LINKERFLAG:"=\"%" %2 %3 %4 %5 %6 %7 %8 %9
:: Special code to check for Makefile abort - output error files
IF EXIST "%TEMP%\lex-errors.txt" (
	echo -- FLEX Errors -------------------------------- 
	TYPE "%TEMP%\lex-errors.txt" 
	DEL "%TEMP%\lex-errors.txt"
)
IF EXIST "%TEMP%\bison-errors.txt" (
	echo -- FLEX Errors -------------------------------- 
	TYPE "%TEMP%\bison-errors.txt" 
	DEL "%TEMP%\bison-errors.txt"
)
IF EXIST "%TEMP%\lexer-errors.txt" (
	echo -- GCC -DPRINT Errors -------------------------------- 
	TYPE "%TEMP%\lexer-errors.txt" 
	DEL "%TEMP%\lexer-errors.txt"
)
IF EXIST "%TEMP%\debug-errors.txt" (
	echo -- BISON -t Errors -------------------------------- 
	TYPE "%TEMP%\debug-errors.txt" 
	DEL "%TEMP%\debug-errors.txt"
)
IF EXIST "%TEMP%\parser-errors.txt" (
	echo -- GCC -DYYDEBUG Errors -------------------------------- 
	TYPE "%TEMP%\parser-errors.txt" 
	DEL "%TEMP%\parser-errors.txt"
)
IF EXIST "%TEMP%\tree-errors.txt" (
	echo -- GCC -DDEBUG Errors -------------------------------- 
	TYPE "%TEMP%\tree-errors.txt" 
	DEL "%TEMP%\tree-errors.txt"
)
IF EXIST "%TEMP%\compiler-errors.txt" (
	echo -- GCC Errors -------------------------------- 
	TYPE "%TEMP%\compiler-errors.txt" 
	DEL "%TEMP%\compiler-errors.txt"
)
CD /d "%OCD%"

GOTO :Complete

:: -------------------------  Subroutines  -------------------------
:: Source: http://www.dostips.com/DtTutoFunctions.php

:: ===========================================================================
::
:which
setlocal enableextensions enabledelayedexpansion
:: Needs an argument.

if "x%1"=="x" (
    echo Usage: which ^<progName^>
    goto :endsub
)

:: First try the unadorned filename.

set pathis=
set fullspec=
call :find_it %1 pathis

:: Then try all adorned filenames in order.

set mypathext=!pathext!
:loop1
    :: Stop if found or out of extensions.

    if "x!mypathext!"=="x" goto :loop1end

    :: Get the next extension and try it.

    for /f "delims=;" %%j in ("!mypathext!") do set myext=%%j
    call :find_it %1!myext! pathis

:: Remove the extension (not overly efficient but it works).

:loop2
    if not "x!myext!"=="x" (
        set myext=!myext:~1!
        set mypathext=!mypathext:~1!
        goto :loop2
    )
    if not "x!mypathext!"=="x" set mypathext=!mypathext:~1!

    goto :loop1
:loop1end

:endsub
  ( endlocal
   set %2=%pathis%
  )
goto :End

:: Function to find and print a file in the path.
::
:: http://stackoverflow.com/questions/304319/is-there-an-equivalent-of-which-on-the-windows-command-line
::
:find_it
    for %%i in (%1) do set fullspec=%%~$PATH:i
      if not "x!fullspec!"=="x" set %2=!fullspec!
    goto :End

::Function to test is an executable actually executes and delete if not
:ZapExe
	IF EXIST %1.exe (
	.\%1 <nul >nul 2>&1  || del %1.exe
	)
exit /b
:: --------------- Standard tidy up tasks --------------
:Complete
:: echo All test completed: %passCount% passed, %nonfatalCount% nonfatal, %failCount% failed.
IF "%failCount%"=="" GOTO :End
IF /I %failCount% GTR 0 GOTO :Fatal
GOTO :End
:Failure
:: Tidy missed tempfiles when aborted
set /a failCount=%failCount% + 1
echo Test failed at %TESTNAME% with %ERRORLEVEL%
echo Output: %theValue%
echo All test completed: %passCount% passed, %nonfatalCount% nonfatal, %failCount% failed.
:: Exit the batch file when fatal - do not return from subroutine
:Fatal
:: change the active console code page back to previously saved value 
>NUL chcp %_chcp%
exit /b 1
:End
:: change the active console code page back to previously saved value 
>NUL chcp %_chcp%
exit /b
::ENDOFWINDOWS
# Batch file to Run the Compiler testing Makefile on a bash shell
# Brian Tompsett Nov 2014
#
# Usage
# RunCompiler <source directory> ["BATCH=yes"] ["SOURCE=name"] ["TESTS=test list"]
# defaults <current directory>
# 
#  When "BATCH=yes" is specified, the script does not pause for input
#  When "SOURCE=name" is specified the scripts looks for files called name.l name.y and name.c
#  When "TESTS=test list" the compiler is only run of the tests named in the list.
#
# History:
#    Ver 1 : Nov 2014 Cloned from DOS/Windows test scripts
#            Oct 2017 Fixed for multiple spaces in file paths
#                     Added check for cross platform binaries in shared drives
#
# --------------------------------------------------
# First find the directory with the test scripts and test programs
#  They could be mounted in a OS/X or cygwin format
#
# http://stackoverflow.com/questions/59895/can-a-bash-script-tell-what-directory-its-stored-in
#
# The file is used for both bash and windows and has windowss line breaks of \r\n
# Each line ends in a comments to protect the \r character which bash does not like
# Some of the lines are very long because we can't have \r in continuations in bash
#
# For portability between shells we have to be POSIX compliant on the if statements. See
# https://unix.stackexchange.com/questions/168255/is-test-or-or-more-portable-both-between-bash-shells-and-between-other-shel/168307#168307
#
SOURCE="${BASH_SOURCE[0]}" #
while [ -h "$SOURCE" ]; do # resolve $SOURCE until the file is no longer a symlink
  DIR="$( cd -P "$( dirname "$SOURCE" )" && pwd )" #
  SOURCE="$(readlink "$SOURCE")" #
  [[ $SOURCE != /* ]] && SOURCE="$DIR/$SOURCE" # if $SOURCE was a relative symlink, we need to resolve it relative to the path where the symlink file was located
done #
DIR="$( cd -P "$( dirname "$SOURCE" )" && pwd )" #
SystemName="$(uname)" #
if test "$SystemName" = "Darwin"  #
then #
   # We are on a Mac
   TESTLOC=$DIR #
   LEXLIB=l #
elif test "$(expr substr $SystemName 1 5)" = "Linux"  #
then #
   # We are on linux
   TESTLOC=$DIR #
   LEXLIB=fl #
elif test "$(expr substr $SystemName 1 10)" = "MINGW32_NT"  #
then #
   # We are on MinGW
   TESTLOC=$DIR #
   LEXLIB=fl #
elif test "$(expr substr $(uname -s) 1 6)" = "CYGWIN"  #
then #
   # We are on cygwin
   TESTLOC=$DIR #
   LEXLIB=fl #
elif test -n "$COMSPEC" -a -x "$COMPSEC"  #
then #
   # We are on cygwin under Windows
   TESTLOC=$DIR #
   LEXLIB=fl #
else #
   # Not sure
   echo Unidentified system $(uname -s) #
   exit #
fi #
if test ! -d "$TESTLOC"  #
then #
    echo Expected test location "$TESTLOC" does not exist
    exit #
fi #
# Now check we can see the Makefile
if test ! -r "$TESTLOC/Makefile"  #
then #
   echo Makefile cannot be found
   exit #
fi #
if test "$1" != ""  #
then  #
# Now check for the directory in $1
if test ! -d "$1"  #
then #
  echo Directory $1 not found
  exit #
fi #
pushd $1 #
fi #
# Removes spaces in paths for make.....
echo Tests are located in $TESTLOC
# Check for any cross platform binaries stored in shared network drives
if test -f ./lexer.exe  #
then #
  ./lexer.exe < /dev/null > /dev/null 2>&1 || rm ./lexer.exe #
fi #
if test -f ./parser.exe  #
then #
  ./parser.exe < /dev/null > /dev/null 2>&1 || rm ./parser.exe #
fi #
if test -f ./compiler.exe  #
then #
  ./compiler.exe < /dev/null > /dev/null 2>&1 || rm ./compiler.exe #
fi #
if test -f ./tree.exe  #
then #
  ./tree.exe < /dev/null > /dev/null 2>&1 || rm ./tree.exe #
fi #
if test -f ./a.exe  #
then #  
  ./a.exe < /dev/null > /dev/null 2>&1 || rm ./a.exe #
fi #
if test -f ./b.exe  #
then #
  ./b.exe < /dev/null > /dev/null 2>&1 || rm ./b.exe #
fi #
if test -f ./c.exe  #
then #
  ./c.exe < /dev/null > /dev/null 2>&1 || rm ./c.exe #
fi #
if test -f ./d.exe  #
then #
  ./d.exe < /dev/null > /dev/null 2>&1 || rm ./d.exe #
fi #
if test -f ./e.exe  #
then #
  ./e.exe < /dev/null > /dev/null 2>&1 || rm ./e.exe #
fi #
# Now convert the MS nmake syntax to Gnu make syntax
#  Careful: Gnu sed has extensions. This is not gnu
sed -e 's/!IFDEF/ifdef/' -e 's/!ENDIF/endif/' -e 's/!IF \(.*\)==\(.*\)/ifeq \1 \2/' -e 's/!IF \(.*\)!=\(.*\)/ifneq \1 \2/' -e 's/!MESSAGE/#message/' -e 's/!IFNDEF/ifndef/' -e 's/!ELSE/else/' -e 's/\$(TESTS:\(.*\)=\(.*\))/$(subst \1,\2,$(TESTS))/' -e 's/\([_A-Z][_A-Z]*\)=\$(\1)/\1 +=/g' -e 's/!IF EXIST *("\(.*\)")/ifneq ("$(wildcard \1))","")/' -e 's/!UNDEF/undefine/' "$TESTLOC/Makefile" |  make -f - "TESTLOC=${TESTLOC// /?}" "COMSPEC=" "LEXLIB=$LEXLIB" $2 $3 $4 $5 $6 $7 $8 #
#   In the case of make abort we need to output some error files	 
if test -f "/tmp/lex-errors.txt"  #
 then #
	echo "-- FLEX Errors --------------------------------" #
	cat "/tmp/lex-errors.txt" #
	rm -f "/tmp/lex-errors.txt" #
fi #
if test -f "/tmp/lexer-errors.txt"  #
 then #
	echo "-- $(CC) -DPRINT Errors --------------------------------" #
	cat "/tmp/lexer-errors.txt" #
	rm -f "/tmp/lexer-errors.txt" #
fi #
if test -f "/tmp/debug-errors.txt"  #
 then #
	echo "-- BISON -t Errors --------------------------------" #
	cat "/tmp/debug-errors.txt" #
	rm -f "/tmp/debug-errors.txt" #
fi #
if test -f "/tmp/parser-errors.txt"  #
 then #
	echo "-- GCC -DYYDEBUG Errors --------------------------------" #
	cat "/tmp/parser-errors.txt" #
	rm -f "/tmp/parser-errors.txt" #
fi #
if test -f "/tmp/tree-errors.txt"  #
 then #
	echo "-- GCC -DDEBUG Errors --------------------------------" #
	cat "/tmp/tree-errors.txt" #
	rm -f "/tmp/tree-errors.txt" #
fi #
if test -f "/tmp/compiler-errors.txt"  #
 then #
	echo "-- GCC Errors --------------------------------" #
	cat "/tmp/compiler-errors.txt" #
	rm -f "/tmp/compiler-errors.txt" #
fi #
test "$1" != "" && popd #
exit #
exit #