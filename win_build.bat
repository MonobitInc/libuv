rem MPM windows build

echo on

setlocal

rd /s /q Debug Release x86 x64 x86.dbg x64.dbg MDRELEASE x86.md x64.md
del uv.vcxproj uv_a.vcxproj libuv.sln
del CMakeCache.txt cmake_install.cmake
rd /s /q CMakeFiles


call "C:\Program Files (x86)\Microsoft Visual Studio\2017\Community\VC\Auxiliary\Build\vcvarsall.bat"  x86
cmake -G "Visual Studio 15 2017" .


# need MD for UE4
msbuild libuv.sln /t:Rebuild /p:Configuration=MDRelease /p:Platform=Win32 /clp:NoSummary;NoItemAndPropertyList;Verbosity=minimal /nologo
if %errorlevel% neq 0 (  exit /B )
msbuild libuv.sln /t:Rebuild /p:Configuration=Release /p:Platform=Win32 /clp:NoSummary;NoItemAndPropertyList;Verbosity=minimal /nologo
if %errorlevel% neq 0 (  exit /B )
msbuild libuv.sln /t:Rebuild /p:Configuration=Debug /p:Platform=Win32 /clp:NoSummary;NoItemAndPropertyList;Verbosity=minimal /nologo
if %errorlevel% neq 0 (  exit /B )

rename Release x86
rename Debug x86.dbg
rename MDRELEASE x86.md

del CMakeCache.txt cmake_install.cmake
rd /s /q CMakeFiles

call "C:\Program Files (x86)\Microsoft Visual Studio\2017\Community\VC\Auxiliary\Build\vcvarsall.bat"  x64
cmake -G "Visual Studio 15 2017 Win64" .

msbuild libuv.sln /t:Rebuild /p:Configuration=MDRelease /p:Platform=x64 /clp:NoSummary;NoItemAndPropertyList;Verbosity=minimal /nologo
if %errorlevel% neq 0 (  exit /B )
msbuild libuv.sln /t:Rebuild /p:Configuration=Release /p:Platform=x64 /clp:NoSummary;NoItemAndPropertyList;Verbosity=minimal /nologo
if %errorlevel% neq 0 (  exit /B )
msbuild libuv.sln /t:Rebuild /p:Configuration=Debug /p:Platform=x64 /clp:NoSummary;NoItemAndPropertyList;Verbosity=minimal /nologo
if %errorlevel% neq 0 (  exit /B )


rd /s /q x64
rename Release x64
rename Debug x64.dbg
rename MDRELEASE x64.md

del uv.vcxproj uv_a.vcxproj libuv.sln

del CMakeCache.txt cmake_install.cmake
rd /s /q CMakeFiles

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
copy x86\uv.lib %zipdir%\x86\uv.lib
copy x86.md\uv.lib %zipdir%\x86\uv_md.lib
copy x86.dbg\uv.lib %zipdir%\x86\uv_debug.lib
copy x86.dbg\uv.pdb %zipdir%\x86\uv.pdb
copy x64\uv.lib %zipdir%\x64\uv.lib
copy x64.md\uv.lib %zipdir%\x64\uv_md.lib
copy x64.dbg\uv.lib %zipdir%\x64\uv_debug.lib
copy x64.dbg\uv.pdb %zipdir%\x64\uv.pdb

git log -1 --pretty=oneline > %zipir%\git_revision.txt
dir %zipdir%
rd /s /q %basename%-latest
mkdir %basename%-latest
xcopy /E %zipdir% %basename%-latest
if exist %basename%-latest.zip del /f %basename%-latest.zip
7z a %zipdir%.zip %zipdir%
7z a %basename%-latest.zip %basename%-latest
aws s3 cp %zipdir%.zip s3://monobit/libuv/%zipdir%.zip
aws s3 cp %basename%-latest.zip s3://monobit/libuv/%basename%-latest.zip
aws s3 ls s3://monobit/libuv/

endlocal
