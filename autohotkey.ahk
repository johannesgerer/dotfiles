; ^ Ctrl
; + Shift
; ! Alt
; # Windows

#SingleInstance Force

width4k := 3840
height4k := 2160

if (A_ScreenWidth > width4k){
	width := width4k
	height := height4k
	screenPosLeft:=2160
	screenPosTop:=968
}else{
	width := A_ScreenWidth
	height := A_ScreenHeight
	screenPosLeft:=0
	screenPosTop:=0
}


MsgBox h %height% w %width% pLeft %screenPosLeft% pTop %screenPosTop%

gapx=8
gapy=8

; grid steps
x1:=width/3
x2:=2*width/3
x3:=width

y1:=height/2
y2:=height

SetWinDelay -1

#Up::move(0,0,width,height)


!f::
if WinExist("ahk_exe FreeCommander.exe")
	WinActivate
else
    Run \FreeCommanderXE-32-public_portable\FreeCommander.exe
return

!b::
if WinExist("ahk_class wdm-DesktopWindow ahk_exe bplus.wtk2.exe") or WinExist("ahk_exe wintrv.exe"){
    WinActivate
	WinRestore, A
}
return

!+b::WinActivateBottom, ahk_class wdm-DesktopWindow ahk_exe bplus.wtk2.exe


!1::
if WinExist("ahk_exe EXCEL.exe"){
    WinActivate
}else{
    Run EXCEL.exe
}
return

!+1::WinActivateBottom, ahk_exe EXCEL.exe, Status



!2::
if WinExist("tmux on"){
    WinActivate
}else{
    Run "\MobaXterm.exe" -bookmark "titlebla term" -hideterm
}
return

!+2::WinActivateBottom, tmux on


!3::
if WinExist("ahk_exe chrome.exe"){
	WinActivate
	;WinRestore, A
}else
	Run chrome.exe
return

!+3::WinActivateBottom, ahk_exe chrome.exe



!4::
if WinExist("emacs:"){
    WinActivate
}else{
    Run "\MobaXterm.exe" -bookmark "titlebla emacs" -hideterm
}
return


!5::
if WinExist("ahk_exe outlook.exe"){
	WinActivate
	;WinRestore, A
	;WinMove, A, , 0, 0, 2*width/3, height/2
}else
    Run outlook.exe
return


!+5::WinActivateBottom, ahk_exe outlook.exe, Mso


!7::ib()

!8::symphony()


symphony(){
	if WinExist("ahk_exe Slack.exe "){
		WinActivate
		WinRestore, A
		;WinMove, A, ,
	}else{
		Run slack.exe
	}
	return
}



ib(){
	if WinExist("IB - IB Manager"){
		WinActivate
		WinRestore, A
		;WinMove, A, ,
	}
	return
}


!9::
if WinExist("ahk_exe dbeaver.exe"){
	WinActivate
	WinRestore, A
}else
    Run \dbeaver.exe
return

; ^r::
; MsgBox asd
; Send asd
; MsgBox asd2
; return


!+r::
Reload
return

;;;;;;; left screen ;;;;

;lower left
^+7::move2(x2,0,x3,y1)

;lower right
^+8::move2(x2,y1,x3,y2)

;middle
!+0::move2(x1,0,x2,y2)

; top
^+5::move2(0,y1,x1,y2)
^+4::move2(0,0,x1,y1)
^+6::move2(0,0,x1,y2)

;middle and bottom
!0::move2(x1,0,x3,y2)

;;;; right screen ;;;;;

; 2 cols
^0::move(x1,0,x3,y2)

; 1 col
^1::move(0,0,x1,y2)
^2::move(x1,0,x2,y2)
^3::move(x2,0,x3,y2)

; upper half col
^+1::move(0,0,x1,y1)
^+2::move(x1,0,x2,y1)
^+3::move(x2,0,x3,y1)

; lower half col
^!1::move(0,y1,x1,y2)
^!2::move(x1,y1,x2,y2)
^!3::move(x2,y1,x3,y2)

move(a,b,c,d){
	moveFlip(a,b,c,d,0)
}

move2(a,b,c,d){
	moveFlip(a,b,c,d,1)
}

moveFlip(left, top, right, bottom, flip){
	global
	WinRestore, A

	;MsgBox 	WinMove, A, ,  %left%-%gapx%, %top%, %right% - %left% + 2*%gapx%, %bottom% - %top% + %gapy%

	bl := screenPosLeft + left
	bt := screenPosTop + top
	bw := right - left
	bh := bottom - top

	if flip{
		bt := left
		bl := top
		bh := right - left
		bw := bottom - top
	}

	WinGet, winid ,, A
	WinGetPosEx(winid,ax,ay,aw,ah,al,at,ar,ab)
	;MsgBox %ax% %ay% %aw% %ah% %al% %at% %ar% %ab%
	; MsgBox %gap%

	WinMove, A, , bl - al - 1 , bt - at - 1, bw + al + ar + 1, bh + at + ab + 1

}





WinGetPosEx(hWindow,ByRef X="",ByRef Y="",ByRef Width="",ByRef Height=""
			,ByRef Offset_Left="",ByRef Offset_Top=""
			,ByRef Offset_Right="",ByRef Offset_Bottom="")
    {
    Static Dummy5693
          ,RECTPlus
          ,S_OK:=0x0
          ,DWMWA_EXTENDED_FRAME_BOUNDS:=9

    ;-- Workaround for AutoHotkey Basic
    PtrType:=(A_PtrSize=8) ? "Ptr":"UInt"

    ;-- Get the window's dimensions
    ;   Note: Only the first 16 bytes of the RECTPlus structure are used by the
    ;   DwmGetWindowAttribute and GetWindowRect functions.
    VarSetCapacity(RECTPlus,32,0)
    DWMRC:=DllCall("dwmapi\DwmGetWindowAttribute"
        ,PtrType,hWindow                                ;-- hwnd
        ,"UInt",DWMWA_EXTENDED_FRAME_BOUNDS             ;-- dwAttribute
        ,PtrType,&RECTPlus                              ;-- pvAttribute
        ,"UInt",16)                                     ;-- cbAttribute

    if (DWMRC<>S_OK)
        {
        if ErrorLevel in -3,-4  ;-- Dll or function not found (older than Vista)
            {
            ;-- Do nothing else (for now)
            }
         else
            outputdebug,
               (ltrim join`s
                Function: %A_ThisFunc% -
                Unknown error calling "dwmapi\DwmGetWindowAttribute".
                RC=%DWMRC%,
                ErrorLevel=%ErrorLevel%,
                A_LastError=%A_LastError%.
                "GetWindowRect" used instead.
               )

        ;-- Collect the position and size from "GetWindowRect"
        DllCall("GetWindowRect",PtrType,hWindow,PtrType,&RECTPlus)
        }

    ;-- Populate the output variables
    X:=Left       := NumGet(RECTPlus,0,"Int")
    Y:=Top        := NumGet(RECTPlus,4,"Int")
    Right         := NumGet(RECTPlus,8,"Int")
    Bottom        := NumGet(RECTPlus,12,"Int")
    Width         := Right-Left
    Height        := Bottom-Top
    Offset_Left   := 0
    Offset_Top    := 0
    Offset_Right  := 0
    Offset_Bottom := 0

    ;-- If DWM is not used (older than Vista or DWM not enabled), we're done
    if (DWMRC<>S_OK)
        Return &RECTPlus

    ;-- Collect dimensions via GetWindowRect
    VarSetCapacity(RECT,16,0)
    DllCall("GetWindowRect",PtrType,hWindow,PtrType,&RECT)
	GWR_Left   := NumGet(RECT,0,"Int")
	GWR_Top    := NumGet(RECT,4,"Int")
	GWR_Right  := NumGet(RECT,8,"Int")
	GWR_Bottom := NumGet(RECT,12,"Int")

	;-- Calculate offsets and update output variables
	NumPut(Offset_Left   := Left       - GWR_Left,RECTPlus,16,"Int")
	NumPut(Offset_Top    := Top        - GWR_Top ,RECTPlus,20,"Int")
	NumPut(Offset_Right  := GWR_Right  - Right   ,RECTPlus,24,"Int")
	NumPut(Offset_Bottom := GWR_Bottom - Bottom  ,RECTPlus,28,"Int")

    Return &RECTPlus
   }