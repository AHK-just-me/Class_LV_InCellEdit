#NoEnv
#Include Class_LV_InCellEdit.ahk
SetBatchLines, -1
If (SubStr(A_AhkVersion, 1, 6) < "1.1.20") {
   MsgBox, 16, ERROR, Sorry, this script requires AHK 1.1.20+!
   ExitApp
}
; ----------------------------------------------------------------------------------------------------------------------
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
Gui, Add, ListView, -Readonly y+10 w%LVW% Grid r4 gSubLV1 hwndHLV1 AltSubmit vLV1
   , Column 1|Column 2|Column 3|Column 4|Column 5
Loop, Parse, LV, `n
   If (A_LoopField) {
      StringSplit, F, A_LoopField, |
      LV_Add("", F1, F2, F3, A_Index, A_Index)
   }
Loop, 3
   LV_ModifyCol(A_Index, "200")
; Create a new instance of LV_InCellEdit for HLV1
ICELV1 := New LV_InCellEdit(HLV1)
; Restrict editable columns
ICELV1.SetColumns(1, 3)
Gui, Add, CheckBox, h20 vHL gHiddenCol1ListView Checked
   , % " In-cell editing for ListView with options HiddenCol1 && BlankSubItem"
Gui, Add, ListView, xm y+10 w%LVW% -Readonly Grid r4 gSubLV2 hwndHLV2 AltSubmit vLV2
   , Column 0|Column 1|Column 2|Column 3|Column 4|Column 5
Loop, Parse, LV, `n
   If (A_LoopField) {
      StringSplit, F, A_LoopField, |
      LV_Add("", "", F1, F2, F3, A_Index, A_Index)
   }
LV_ModifyCol(1, 0)
Loop, 3
   LV_ModifyCol(A_Index + 1, "200")
; Create a new instance of LV_InCellEdit for HLV2 with options HiddenCol1 and BlankSubItem
ICELV2 := New LV_InCellEdit(HLV2, True, True)
Gui, Show, , In-Cell ListView Editing with DoubleClick %A_AhkVersion%
Return
; ----------------------------------------------------------------------------------------------------------------------
GuiClose:
GuiEscape:
ExitApp
; ----------------------------------------------------------------------------------------------------------------------
CommonListView:
GuiControlGet, CL
If (CL)
   ICELV1.OnMessage()
Else
   ICELV1.OnMessage(False)
Return
; ----------------------------------------------------------------------------------------------------------------------
HiddenCol1ListView:
GuiControlGet, HL
If (HL)
   ICELV2.OnMessage()
Else
   ICELV2.OnMessage(False)
Return
; ----------------------------------------------------------------------------------------------------------------------
SubLV1:
; Check for changes
If (A_GuiEvent == "F") {
   If (ICELV1["Changed"]) {
      Msg := ""
      For I, O In ICELV1.Changed
         Msg .= "Row " . O.Row . " - Column " . O.Col . " : " . O.Txt
      ToolTip, % "Changes in " . A_GuiControl . "`r`n`r`n" . Msg
      SetTimer, KillToolTip, 2000
      ICELV1.Remove("Changed")
   }
}
Return
; ----------------------------------------------------------------------------------------------------------------------
SubLV2:
; Use key 'e' to edit the first editable cell of the focused row, if any
If (A_GuiEvent == "K") && (Chr(A_EventInfo) = "e") {
   Gui, ListView, %A_GuiControl%
   If (Row := LV_GetNext(0, "Focused"))
      ICELV2.EditCell(Row)
}
Return
; ----------------------------------------------------------------------------------------------------------------------
KillToolTip:
   ToolTip
Return