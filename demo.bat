@echo off& call load.bat _getRandomNum _parseJSON& setlocal enabledelayedexpansion
::为每个人随机计数, 可用于n个中选择1个
set "members={1:小朋友1,2:小朋友2,3:小朋友3,4:小朋友4}"
set members
%_call% ("members") %_parseJSON%
for /l %%i in (1,1,300) do (
	(%_call% ("1 !members.length! memberIndex") %_getRandomNum%)
	for %%j in (!memberIndex!) do (
		for %%k in (!members.%%j!) do set /a k.%%k+=1
	)
)
set k.
set k.>%temp%\selectMemberTemp.txt
start barGraphH.bat "%temp%\selectMemberTemp.txt" 1
start barGraphV.bat "%temp%\selectMemberTemp.txt" 3
pause>nul