rem MPM windows build


set GYP_MSVS_VERSION=2017
call vcbuild.bat release x64 static vs2017
call vcbuild.bat debug x64 static vs2017


For /f "tokens=2-4 delims=/ " %%a in ('date /t') do (set mydate=%%c%%a%%b)
For /f "tokens=1-2 delims=/: " %%a in ("%TIME%") do (if %%a LSS 10 (set mytime=0%%a%%b) else (set mytime=%%a%%b)) 
echo %mydate%%mytime%
set datestr=%mydate%%mytime%

set basename=libuv-win64
set zipdir=%basename%-%datestr%
mkdir %zipdir%
mkdir %zipdir%\include
xcopy /E include %zipdir%\include
copy Release\lib\libuv.lib %zipdir%\libuv.lib
copy Debug\lib\libuv.lib %zipdir%\libuv_debug.lib
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
