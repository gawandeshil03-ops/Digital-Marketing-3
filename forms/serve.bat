@echo off
echo Starting local server for forms...
echo Open: http://localhost:8080/tally-embed.html
echo Press Ctrl+C to stop
cd /d "%~dp0"
python -m http.server 8080
