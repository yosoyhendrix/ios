
@echo off

Title RODBAUTIS MDM Bypass Tool

color a 

echo MDM Bypass by =MDMkiller=
echo Original Source Code: https://github.com/Lunarixus/LunarixusMDMBypass
echo 

deviceinfo.dll -k SerialNumber > info.log 2>&1

find /c "ERROR: No device found!" info.log > nul
    if %errorlevel% equ 1 goto notfound1
    echo Error occured.
    echo Device not connected. Connect and try again.
    echo.
    echo Possible Fix : Open iTunes and check if device is connected then try again.
    goto end
	
    :notfound1
    find /c "Could not connect to lockdownd" info.log > nul
    if %errorlevel% equ 1 goto verify
    echo Software cannot connect to device.
    echo Make sure the device gets detected in iTunes and try again.
    echo.
    echo Possible Fix : Connect the device in Recovery mode and restore it in iTunes. Then try again.
    goto end


    :verify
	
echo
echo
	
FOR /F "tokens=* USEBACKQ" %%F IN (`deviceinfo.dll -k SerialNumber`) DO (
SET Serial=%%F
)

FOR /F "tokens=* USEBACKQ" %%F IN (`deviceinfo.dll -k UniqueDeviceID`) DO (
SET UDID=%%F
)

FOR /F "tokens=* USEBACKQ" %%F IN (`deviceinfo.dll -k ProductType`) DO (
SET DeviceName=%%F
)

FOR /F "tokens=* USEBACKQ" %%F IN (`deviceinfo.dll -k ProductVersion`) DO (
SET ios=%%F
)


echo Device Connected: %DeviceName%         
echo iOS: %ios%
echo Serial: %Serial%
echo UDID: %UDID%
echo 
echo Please wait, bypassing...

libcon.dll -convert xml1 "206cab4e197a3672ef8c418ffd9564c3f96dd64a\Manifest.plist" >nul 2>&1

down.dll ed -L -u "//key[.='SerialNumber']/following-sibling::string[1]" -v %Serial% "206cab4e197a3672ef8c418ffd9564c3f96dd64a\Manifest.plist" >nul 2>&1

down.dll ed -L -u "//key[.='UniqueDeviceID']/following-sibling::string[1]" -v %UDID% "206cab4e197a3672ef8c418ffd9564c3f96dd64a\Manifest.plist" >nul 2>&1

libcon.dll -convert binary1 "206cab4e197a3672ef8c418ffd9564c3f96dd64a\Manifest.plist" >nul 2>&1

sys.temp.dll -s 206cab4e197a3672ef8c418ffd9564c3f96dd64a restore --system --settings --skip-apps --no-reboot "%temp%" > test.log


echo Device is rebooting, once it has rebooted MDM should be bypassed.

finish.dll restart > nul



del /f "info.log" >nul 2>&1

pause
