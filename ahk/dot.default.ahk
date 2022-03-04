#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.

!^#1::
	CoordMode, Mouse, Screen
	SysGet, Mon1, Monitor, 1
	;MsgBox, Left: %Mon1Left% -- Top: %Mon1Top% -- Right: %Mon1Right% -- Bottom: %Mon1Bottom%
	MoveToX := Mon1Left // 2 + Mon1Right // 2
	MoveToY := Mon1Top // 2 + Mon1Bottom // 2
	;MsgBox, MoveToX: %MoveToX% -- MoveToY: %MoveToY%
	;MouseMove, MoveToX, MoveToY
	DllCall("SetCursorPos", "int", MoveToX, "int", MoveToY)
	return

!^#2::
	CoordMode, Mouse, Screen
	SysGet, Mon2, Monitor, 2
	;MsgBox, Left: %Mon2Left% -- Top: %Mon2Top% -- Right: %Mon2Right% -- Bottom: %Mon2Bottom%
	MoveToX := Mon2Left // 2 + Mon2Right // 2
	MoveToY := Mon2Top // 2 + Mon2Bottom // 2
	;MsgBox, MoveToX: %MoveToX% -- MoveToY: %MoveToY%
	;MouseMove, MoveToX, MoveToY
	DllCall("SetCursorPos", "int", MoveToX, "int", MoveToY)
	return

!^#3::
	CoordMode, Mouse, Screen
	SysGet, Mon3, Monitor, 3
	;MsgBox, Left: %Mon3Left% -- Top: %Mon3Top% -- Right: %Mon3Right% -- Bottom: %Mon3Bottom%
	MoveToX := Mon3Left // 2 + Mon3Right // 2
	MoveToY := Mon3Top // 2 + Mon3Bottom // 2
	;MsgBox, MoveToX: %MoveToX% -- MoveToY: %MoveToY%
	;MouseMove, MoveToX, MoveToY
	DllCall("SetCursorPos", "int", MoveToX, "int", MoveToY)
	return

