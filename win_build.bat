rem MPM windows build

echo on

setlocal

cmake .

rd /s /q Debug Release x86 x64 x86.dbg x64.dbg
call vcbuild.bat release x64 static vs2017
if %errorlevel% neq 0 (  exit /B )
rename Release x64
call vcbuild.bat release x86 static vs2017
if %errorlevel% neq 0 (  exit /B )
rename Release x86
call vcbuild.bat debug x64 static vs2017
if %errorlevel% neq 0 (  exit /B )
rename Debug x64.dbg
call vcbuild.bat debug x86 static vs2017
if %errorlevel% neq 0 (  exit /B )
rename Debug x86.dbg


For /f "tokens=2-4 delims=/ " %%a in ('date /t') do (set mydate=%%c%%a%%b)
For /f "tokens=1-2 delims=/: " %%a in ("%TIME%") do (if %%a LSS 10 (set mytime=0%%a%%b) else (set mytime=%%a%%b)) 
echo %mydate%%mytime%
set datestr=%mydate%%mytime%

set basename=libuv-win
set zipdir=%basename%-%datestr%
mkdir %zipdir%
mkdir %zipdir%\include
mkdir %zipdir%\x86
mkdir %zipdir%\x64
xcopy /E include %zipdir%\include
copy x86\lib\libuv.lib %zipdir%\x86\libuv.lib
copy x86.dbg\lib\libuv.lib %zipdir%\x86\libuv_debug.lib
copy x86.dbg\libuv.pdb %zipdir%\x86\libuv.pdb
copy x64\lib\libuv.lib %zipdir%\x64\libuv.lib
copy x64.dbg\lib\libuv.lib %zipdir%\x64\libuv_debug.lib
copy x64.dbg\libuv.pdb %zipdir%\x64\libuv.pdb

git log -1 --pretty=oneline > %zipir%\git_revision.txt
dir %zipdir%
rd /s /q %basename%-latest
mkdir %basename%-latest
xcopy /E %zipdir% %basename%-latest
7z a %zipdir%.zip %zipdir%
7z a %basename%-latest.zip %basename%-latest
aws s3 cp %zipdir%.zip s3://monobit/libuv/%zipdir%.zip
aws s3 cp %basename%-latest.zip s3://monobit/libuv/%basename%-latest.zip
aws s3 ls s3://monobit/libuv/

endlocal
