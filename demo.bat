@echo off& call lib\load.bat _getRandomNum _parseJSON& setlocal enabledelayedexpansion
::为每个人随机计数, 可用于n个中选择1个
set "members={1:小朋友1,2:小朋友2,3:小朋友3,4:小朋友4}"
set members
%_call% ("members") %_parseJSON%
for /l %%i in (1,1,500) do (
	(%_call% ("1 !members.length! memberIndex") %_getRandomNum%)
	for %%j in (!memberIndex!) do (
		for %%k in (!members.%%j!) do set /a memberCounts.%%k+=1
	)
)
set memberCounts.
set memberCounts.>%temp%\selectMemberTemp.txt
start barGraph.bat "%temp%\selectMemberTemp.txt" 1
start barGraph2.bat "%temp%\selectMemberTemp.txt" 3
pause>nul