@echo off

color a

echo Update Fixer by =MDMkiller=
echo Run this only if setup.app is broken after updating
echo Will also reset settings..
echo

activate.dll deactivate
activate.dll activate

echo Device should now be showing setup.app for final steps...
pause
