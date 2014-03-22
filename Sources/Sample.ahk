#NoEnv
#Include Class_LV_InCellEdit.ahk
SetBatchLines, -1
LV := "
(
1234567890|www.google.com|Row 1
2345678901|msdn.microsoft.com|Row 2
3456789012|www.autohotkey.com|Row 3
4567890123|de.autohotkey.com|Row 4
)"
; ----------------------------------------------------------------------------------------------------------------------
LVW := 610
Gui, Margin, 20, 20
Gui, Font, s10, Verdana
Gui, Add, CheckBox, h20 vCL gCommonListView Checked
   , % " In-cell editing for common ListView (restricted to columns 1 and 3)"
Gui, Add, ListView, -Readonly y+10 w%LVW% Grid r4 gMyListView hwndHLV1 AltSubmit vLV1 +LV0x010000
   , Column 1|Column 2|Column 3|Column 4|Column 5
Loop, Parse, LV, `n
{
   If (A_LoopField) {
      StringSplit, F, A_LoopField, |
      LV_Add("", F1, F2, F3, A_Index, A_Index)
   }
}
Loop, 3
   LV_ModifyCol(A_Index, "200")
Gui, Add, CheckBox, h20 vHL gHiddenCol1ListView Checked
   , % " In-cell editing for ListView with options HiddenCol1 && BlankSubItem"
Gui, Add, ListView, xm y+10 w%LVW% -Readonly Grid r4 gMyListView hwndHLV2 AltSubmit vLV2 +LV0x010000
   , Column 0|Column 1|Column 2|Column 3|Column 4|Column 5
Loop, Parse, LV, `n
{
   If (A_LoopField) {
      StringSplit, F, A_LoopField, |
      LV_Add("", "", F1, F2, F3, A_Index, A_Index)
   }
}
LV_ModifyCol(1, 0)
Loop, 3
   LV_ModifyCol(A_Index + 1, "200")
Gui, Show, , In-Cell ListView Editing with DoubleClick %A_AhkVersion%
LV_InCellEdit.OnMessage()
GoSub, CommonListView
Gosub, HiddenCol1ListView
Return
; ----------------------------------------------------------------------------------------------------------------------
GuiClose:
GuiEscape:
ExitApp
; ----------------------------------------------------------------------------------------------------------------------
CommonListView:
GuiControlGet, CL
If (CL) {
   If !(LV_InCellEdit.Attach(HLV1))
      MsgBox, % "Registering HLV1 failed: " . ErrorLevel
   LV_InCellEdit.SetColumns(HLV1, [1, 3])
} Else {
   LV_InCellEdit.Detach(HLV1)
}
Return
; ----------------------------------------------------------------------------------------------------------------------
HiddenCol1ListView:
GuiControlGet, HL
If (HL) {
   If !(LV_InCellEdit.Attach(HLV2, True, True))
      MsgBox, % "Registering HLV2 failed: " . ErrorLevel
} Else {
   LV_InCellEdit.Detach(HLV2)
}
Return
; ----------------------------------------------------------------------------------------------------------------------
MyListView:
   OutputDebug, %A_GuiControl%: %A_GuiEvent%
   If (A_GuiEvent == "F") {
      GuiControlGet, H, HWND, %A_GuiControl%
      If LV_InCellEdit.Changed.HasKey(H) {
         Msg := ""
         For I, O In LV_InCellEdit.Changed[H] {
            Msg .= "Row " . O.Row . " - Column " . O.Col . " : " . O.Txt
         }
         ToolTip, % "Changes in " . A_GuiControl . "`r`n`r`n" . Msg
         SetTimer, KillToolTip, 2000
         LV_InCellEdit.Changed.Remove(H, "")
      }
   }
   Else If (A_GuiEvent == "K") && (Chr(A_EventInfo) = "e") {
      GuiControlGet, H, HWND, %A_GuiControl%
      If LV_InCellEdit.Attached.HasKey(H) {
         Gui, ListView, %A_GuiControl%
         If (Row := LV_GetNext(0, "Focused"))
            LV_InCellEdit.EditCell(H, Row)
      }
   }
Return
; ----------------------------------------------------------------------------------------------------------------------
KillToolTip:
   ToolTip
Return