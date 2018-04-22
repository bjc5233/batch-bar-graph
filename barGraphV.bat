@echo off& call load.bat _strlen _strlen2 _getLF& call loadF.bat _params _errorMsg _help& call loadE.bat CurS& setlocal enabledelayedexpansion
%CurS% /crv 0
:::说明
:::  绘制垂直柱状图
:::参数
:::  dataFile elementValue
:::      dataFile - 传入数据文件地址
:::      elementValue - 一个点代表的数值
:::  [-h help]
:::      help - 打印注释信息

::========================= set default param =========================
set elementValue=5
call %_params% %*


::========================= set user param =========================
if defined _param-h (call %_help% "%~f0"& goto :EOF)
if defined _param-help (call %_help% "%~f0"& goto :EOF)
if defined _param-0 (
	set dataFile=%_param-0%
    if not exist "!dataFile!" (call %_errorMsg% %0 "!dataFile! FILE NOT EXIST")
) else (
    (call %_errorMsg% %0 "dataFile NOT DEFINED")
)
if defined _param-1 (set elementValue=%_param-1%)


::========================= set base element =========================
::barDot[双字节];ordinateDot[单字节];ordinateLastDot[双字节]
set barDot=▋
set ordinateDot=-
set ordinateLastDot=→

::读取数据
::dataLineMax需再加1, 为了展示具体数字行
set /a dataIndex=1, valueMax=0, keyValueLenMax=0
for /f "tokens=1* delims==" %%i in (!dataFile!) do (
	set key=%%i& set value=%%j
	(%_call% ("key keyLen") %_strlen2%)& (%_call% ("value valueLen") %_strlen2%)
	(if !keyLen! GTR !keyValueLenMax! set keyValueLenMax=!keyLen!)& (if !valueLen! GTR !keyValueLenMax! set keyValueLenMax=!valueLen!)

	set key!dataIndex!=%%i& set /a value!dataIndex!=%%j, dataIndex+=1, keyLen!dataIndex!=!keyLen!
	if %%j GTR !valueMax! set valueMax=%%j
)
set /a dataMax=dataIndex-1, dataLineMax=valueMax/elementValue+1, barIntervalLen=keyValueLenMax+7, barIntervalLen2=barIntervalLen-2, screenWidth=barIntervalLen*(dataMax+1)+2, screenHeight=dataLineMax+6
mode !screenWidth!,!screenHeight!
::init
set blankStr=& for /l %%i in (1,1,30) do set blankStr=!blankStr! 
set barIntervalBlank=& (for %%i in (!barIntervalLen!) do set barIntervalBlank=!blankStr:~0,%%i!)
set barIntervalBlank2=& (for %%i in (!barIntervalLen2!) do set barIntervalBlank2=!blankStr:~0,%%i!)
set ordinateIntervalElement=& (for /l %%i in (1,1,!barIntervalLen2!) do set ordinateIntervalElement=!ordinateIntervalElement!!ordinateDot!)& set ordinateIntervalElement=!ordinateIntervalElement!  
set ordinateLastStr=& (for /l %%i in (1,1,!barIntervalLen2!) do set ordinateLastStr=!ordinateLastStr!!ordinateDot!)& set ordinateLastStr=!ordinateLastStr!!ordinateLastDot!
::draw
title 垂直柱状图:!dataFile!
for /l %%i in (1,1,!dataMax!) do (
	call :drawLine !value%%i!
	set ordinateIntervalLine=!ordinateIntervalLine!!ordinateIntervalElement!
	set /a blankLen=barIntervalLen-keyLen%%i& for %%j in (!blankLen!) do set ordinateIntervalLine2=!ordinateIntervalLine2!!blankStr:~0,%%j!!key%%i!
)
set drawStr=!LF!& for /l %%i in (!dataLineMax!,-1,1) do set drawStr=!drawStr!!line%%i!!LF!
echo !drawStr!!ordinateIntervalLine!!ordinateLastStr!!LF!!ordinateIntervalLine2!
pause>nul& goto :EOF




:drawLine
set /a value=%1, lineIndex=value/elementValue+1
for /l %%i in (1,1,!dataLineMax!) do (
	if %%i LSS !lineIndex! (
		set line%%i=!line%%i!!barIntervalBlank2!!barDot!
	) else if %%i EQU !lineIndex! (
		(%_call% ("value len") %_strlen2%)
		set /a blankLen=barIntervalLen-len& for %%j in (!blankLen!) do set line%%i=!line%%i!!blankStr:~0,%%j!!value!
	) else (
		set line%%i=!line%%i!!barIntervalBlank!
	)
)
goto :EOF