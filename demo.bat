@echo off& call lib\load.bat _getRandomNum _parseJSON& setlocal enabledelayedexpansion
::Ϊÿ�����������, ������n����ѡ��1��
set "members={1:С����1,2:С����2,3:С����3,4:С����4}"
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