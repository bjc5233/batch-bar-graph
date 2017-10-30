@echo off
(if "%~1"=="" goto :EOF)& (if "%~2"=="" goto :EOF)
call load.bat _strlen _strlen2 _getLF& call loadE.bat CurS& setlocal enabledelayedexpansion
%CurS% /crv 0
::水平柱状图
::    %1 数据文件
::    %2 一个点代表的数值
set dataFile=%~1
title 柱状图:!dataFile!
set oneElementFor=%2
set elementStr=& for /l %%i in (1,1,200) do set elementStr=!elementStr!-
set blankStr=& for /l %%i in (1,1,20) do set blankStr=!blankStr! 
set prefixLen=20& for %%i in (!prefixLen!) do set prefixStr=!blankStr:~0,%%i!

set drawStr=
set /a widthMax=0, lineMax=4
for /f "tokens=1* delims==" %%i in (!dataFile!) do (
	(%_call% ("value valueLen") %_strlen%)
	set key=%%i& set value=%%j& set /a elementCount=value/oneElementFor, lineMax+=2, widthMaxTemp=elementCount+valueLen
	if !widthMaxTemp! GTR !widthMax! set /a widthMax=!widthMaxTemp
	
	
	(%_call% ("key keyLen") %_strlen2%)
	set /a blankLen=prefixLen-keyLen& for %%a in (!blankLen!) do (
		for %%b in (!elementCount!) do set horline=!blankStr:~0,%%a!!key!▕!elementStr:~0,%%b!▌ !value!
	)
	set drawStr=!drawStr!!horline!!LF!!prefixStr!▕!LF!
)
set /a widthMax=prefixLen+2+widthMax+3+10
mode !widthMax!,!lineMax!
echo.& set /p "=_!drawStr!"<nul
pause>nul& goto :EOF