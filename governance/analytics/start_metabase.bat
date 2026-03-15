@echo off
echo Starting MedFlow Governance Analytics (Metabase)...
echo Dashboard will open at http://localhost:3000
echo.
set MB_DB_TYPE=h2
set MB_DB_FILE=C:\Medflow Master Brain\governance\analytics\metabase_data
set MB_JETTY_PORT=3000
echo Launching Metabase. First startup takes 1-2 minutes...
java -jar "C:\Medflow Master Brain\governance\analytics\metabase.jar" &
timeout /t 5 /nobreak > nul
start http://localhost:3000
echo.
echo Metabase is running. Press Ctrl+C in the Java window to stop.
pause
