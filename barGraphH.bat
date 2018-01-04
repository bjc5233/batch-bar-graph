@echo off& call load.bat _strlen _strlen2 _getLF& call loadF.bat _params _errorMsg& call loadE.bat CurS& setlocal enabledelayedexpansion
%CurS% /crv 0
::说明
::  绘制水平柱状图
::参数
::  dataFile elementValue
::      dataFile - 传入数据文件地址
::      elementValue - 一个点代表的数值

::========================= set default param =========================
set elementValue=5
call %_params% %*


::========================= set user param =========================
if defined _param-0 (
	set dataFile=%_param-0%
    if not exist "!dataFile!" (call %_errorMsg% %0 "!dataFile! FILE NOT EXIST")
) else (
    (call %_errorMsg% %0 "dataFile NOT DEFINED")
)
if defined _param-1 (set elementValue=%_param-1%)


::========================= draw =========================
title 水平柱状图:!dataFile!
set elementStr=& for /l %%i in (1,1,200) do set elementStr=!elementStr!-
set blankStr=& for /l %%i in (1,1,20) do set blankStr=!blankStr! 
set prefixLen=20& for %%i in (!prefixLen!) do set prefixStr=!blankStr:~0,%%i!

set drawStr=
set /a widthMax=0, lineMax=4
for /f "tokens=1* delims==" %%i in (!dataFile!) do (
	(%_call% ("value valueLen") %_strlen%)
	set key=%%i& set value=%%j& set /a elementCount=value/elementValue, lineMax+=2, widthMaxTemp=elementCount+valueLen
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