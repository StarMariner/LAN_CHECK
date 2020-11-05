@ECHO off
TITLE LAN CHECK
REM BELOW I use caret to escape within the bat file. the original is 2>&1 which suppresses standard output erros for the NSLookup
REM There are escape codes copied into this file using notepad++ They are the colour changes esc[32 etc..
REM ___ = online , _ _ =offline

REM Ping -w value is in ms so it might be to quick? LOGIC BROKEN, 
REM increase the Ping replys -n to 3 or higher, a single long the -w value causes miss hits and logic errors

REM esc characters are for colour changes to text.
REM NOTE: SmartPhones seem to loose connection during a sleep cycle
REM I use NSlookup to find the default server. If I use IPconfig it outputs to many default gateways for Network adapters
REM This only works for small networks That you know the range of . 

REM the number after the DOT is Missed off on purpose, its put back later for the range 1-254
SET ip=192.168.1.
SET RangeStart=1
SET RangeEnd=253

:BEGIN
CLS 

ECHO ------------ LAN Check. Lookup and Ping ------------------
ECHO     ___ = ON-LINE   _ _ = OFFLINE
ECHO      To quit looping Type Ctrl+C or Ctrl+break  
ECHO/
nslookup * 2>nul
ECHO [97m STATUS  IP address    NS Lookup Name

SETLOCAL ENABLEDELAYEDEXPANSION & PUSHD
SET count=0
FOR /L %%R IN (%RangeStart%,1,%RangeEnd%) DO (			
			SET /A count=!count! +1
			SET LKUP=%ip%!count!
			FOR /f "tokens=2" %%i IN ('nslookup %%LKUP%% 2^>nul ^| findstr /C:"Name"') DO (
									SET line_status=[31m  _ _ 
			                        FOR /f "tokens=4" %%j IN ('ping -n 3 -w 120 %%LKUP%% ^| findstr /C:"Reply"') DO ( SET line_status=[32m  ___ )
									SET nicename=%%i
									IF NOT !nicename!==UNKNOWN ECHO !Line_status! [0m  !LKUP!   !nicename!  
			)
)
ECHO -----------------------END---------------------------------
POPD & ENDLOCAL 
REM Wait a few seconds to absorb the info then loop back to the start.
TIMEOUT 20
GOTO BEGIN

ECHO/
CMD /k
