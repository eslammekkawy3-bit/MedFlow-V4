#!/bin/bash
echo 'Starting MedFlow Governance Analytics (Metabase)...'
echo 'Dashboard will open at http://localhost:3000'
export MB_DB_TYPE=h2
export MB_DB_FILE="C:\Medflow Master Brain\governance\analytics\metabase_data"
export MB_JETTY_PORT=3000
echo 'Launching Metabase. First startup takes 1-2 minutes...'
java -jar "C:\Medflow Master Brain\governance\analytics\metabase.jar" &
sleep 5
if command -v xdg-open &> /dev/null; then
    xdg-open http://localhost:3000
elif command -v open &> /dev/null; then
    open http://localhost:3000
fi
echo 'Metabase is running. Press Ctrl+C to stop.'
