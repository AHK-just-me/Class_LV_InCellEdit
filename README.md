# Class LV_InCellEdit #

AHK class providing in-cell editing for ListView controls in AHK GUIs.

The class provides four public methods to register (`Attach()`) and unregister (`Detach()`) in-cell editing for ListView controls, to restrict editing to certain columns (`SetColumns()`), and to register / unregister (`OnMessage()`) the provided message handler function for WM_NOTIFY messages (see below).

If a ListView is registered for in-cell editing a doubleclick on any cell will show an Edit control within this cell allowing to edit the current content. The default behavior for editing the first column by two subsequent single clicks is disabled. You have to press `Esc` to cancel editing, otherwise the changed content of the Edit will be stored. ListViews must have the `-ReadOnly` option to be editable.

While editing, `Esc`, `Tab`, `Shift+Tab`, `Down`, and `Up` keys are registered as hotkeys. `Esc` will cancel editing without changing the value of the current cell. All other hotkeys will store the current content of the edit in the current cell and continue editing for the next (`Tab`), previous (`Shift+Tab`), upper (`Up`), or lower (`Down`) cell. You must not use this hotkeys for other purposes while editing.

All changes are stored in `LV_InCellEdit.Changed` per HWND. You may track the changes by triggering (`A_GuiEvent == "F"`) in the ListViews gLabels and checking `LV_InCellEdit.Changed.HasKey(ListViewHWND)` as shown in the sample scipt. If `True`, `LV_InCellEdit.Changed[ListViewHWND]` contains an array of objects with keys "Row" (1-based row number), `Col` (1-based column number), and `Txt` (new content). `LV_InCellEdit.Changed` is the one and only key intended to be accessed directly from outside the class.

If you want to use the provided message handler you must call `LV_InCellEdit.OnMessage()` once before editing any controls. Otherwise you should integrate the code within `LV_InCellEdit_WM_NOTIFY` into your own notification handler. Without the notification handling editing won't work.


