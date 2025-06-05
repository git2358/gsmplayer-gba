@ECHO OFF
CLS
REM CD /D "%~dp0"
ECHO "%~dp0"
ECHO ABOUT TO GO
PAUSE
ECHO.

REM https://github.com/Yew12347/gsmplayer-gba
ECHO Setting things up for you...
if not exist ffmpeg.exe (
	ECHO ffmpeg.exe not found, downloading now...
	curl.exe -k -L -o ffmpeg.exe https://github.com/git2358/makingffmpegwork/releases/download/justffmpeg/ffmpeg.exe -s

	if exist ffmpeg.exe (
		ECHO ffmpeg.exe ready...
		ECHO.
	) ELSE (
		ECHO error setting up ffmpeg.exe
		REM del ffmpeg.exe
		ECHO.
		PAUSE
		goto end
	)
) ELSE (
	ECHO ffmpeg.exe already ready...
	ECHO.
)
ECHO.


ECHO Resizing images...
@REM Made-up convention, but inputs are .jpg and resized are .jpeg
for %%F in (art\*.jpg) do "C:\Program Files\ImageMagick-7.1.1-Q16-HDRI\magick.exe" convert -resize 128x128 "art\%%~nF.jpg" "art\%%~nF.jpeg"
ECHO.


ECHO Creating 240 color tiles...
for %%F in (art\*.jpeg) do node .\img2gba "art\%%~nF.jpeg" .\src 
ECHO.


ECHO Converting .mp3 files to .wav format...
REM for %%a in ("mp3s\*.mp3") do ffmpeg.exe -i "%%a" -acodec pcm_s16le -ac 1 -ar 16000 "wavs\%%~na.wav"

REM https://github.com/Yew12347/gsmplayer-gba
REM for %%a in ("mp3s\*.mp3") do (ffmpeg.exe -y -i "%%a" -ac 1 -c:a pcm_s16le "wavs\%%~na.wav" -loglevel quiet)
for %%a in ("mp3s\*.mp3") do if not exist "wavs\%%~na.wav" (
	ECHO CONVERTING: "%%a" TO "wavs\%%~na.wav"
	REM ffmpeg.exe -i "%%a" -acodec pcm_s16le -ac 1 -ar 16000 "wavs\%%~na.wav"
	ffmpeg.exe -y -i "%%a" -ac 1 -c:a pcm_s16le "wavs\%%~na.wav"
	ECHO DONE.
	ECHO.
) ELSE (
	ECHO ALREADY EXIST: "wavs\%%~na.wav"
	ECHO.
)
ECHO.

ECHO Converting .m4a files to .wav format...
for %%a in ("mp3s\*.m4a") do if not exist "wavs\%%~na.wav" (
	ECHO CONVERTING: "%%a" TO "wavs\%%~na.wav"
	REM ffmpeg.exe -i "%%a" -acodec pcm_s16le -ac 1 -ar 16000 "wavs\%%~na.wav"
	ffmpeg.exe -y -i "%%a" -ac 1 -c:a pcm_s16le "wavs\%%~na.wav"
	ECHO DONE.
	ECHO.
) ELSE (
	ECHO ALREADY EXIST: "wavs\%%~na.wav"
	ECHO.
)
ECHO.

ECHO Converting .opus files to .wav format...
for %%a in ("mp3s\*.opus") do if not exist "wavs\%%~na.wav" (
	ECHO CONVERTING: "%%a" TO "wavs\%%~na.wav"
	REM ffmpeg.exe -i "%%a" -acodec pcm_s16le -ac 1 -ar 16000 "wavs\%%~na.wav"
	ffmpeg.exe -y -i "%%a" -ac 1 -c:a pcm_s16le "wavs\%%~na.wav"
	ECHO DONE.
	ECHO.
) ELSE (
	ECHO ALREADY EXIST: "wavs\%%~na.wav"
	ECHO.
)
ECHO.



ECHO Converting .wav files to .gsm format...
REM for %%F in (wavs\*.wav) do sox "%%F" -r 18157 -c 1 "gsms\%%~nF.gsm"
for %%F in (wavs\*.wav) do if not exist "gsms\%%~nF.gsm" (
	ECHO CONVERTING: "%%F" TO "gsms\%%~nF.gsm"
	sox "%%F" -r 18157 -c 1 "gsms\%%~nF.gsm"
	ECHO DONE.
	ECHO.
) ELSE (
	ECHO ALREADY EXIST: "gsms\%%~nF.gsm"
	ECHO.
)
ECHO.


ECHO Compiling .gsm files into a .gbfs archive...
powershell .\GoGBFS.ps1
ECHO.

ECHO Building ROM...
make -j8

ECHO.
ECHO GO DONE.
ECHO.
PAUSE
