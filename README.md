# Class_LV_InCellEdit #

AHK class providing in-cell editing for ListView controls in AHK GUIs.

The class provides methods to restrict editing to certain columns, to directly start editing of a specified cell,
and to deactivate/activate the built-in message handler for `WM_NOTIFY` messages (see below).

The message handler for `WM_NOTIFY` messages will be activated for the specified ListView whenever a new instance is
created. As long as the message handler is activated a double-click on any cell will show an Edit control within this
cell allowing to edit the current content. The default behavior for editing the first column by two subsequent single
clicks is disabled. You have to press "Esc" to cancel editing, otherwise the content of the Edit will be stored in
the current cell. ListViews must have the `-ReadOnly` option to be editable.

While editing, "Esc", "Tab", "Shift+Tab", "Down", and "Up" keys are registered as hotkeys. "Esc" will cancel editing
without changing the value of the current cell. All other hotkeys will store the content of the edit in the current
cell and continue editing for the next (Tab), previous (Shift+Tab), upper (Up), or lower (Down) cell. You cannot use
the keys for other purposes while editing.

All changes are stored in `MyInstance.Changed`. You may track the changes by triggering `(A_GuiEvent == "F")` in the
ListView's gLabel and checking `MyInstance["Changed"]` as shown in the sample scipt. If "True", `MyInstance.Changed`
contains an array of objects with keys "Row" (row number), "Col" (column number), and "Txt" (new content).
'Changed' is one of the two keys intended to be accessed directly from outside the class.

If you want to temporarily disable in-cell editing call `MyInstance.OnMessage(False)`. This must be done also before
you try to destroy the instance. To enable it again, call `MyInstance.OnMessage()``.

To avoid the loss of Gui events and messages the message handler might need to be `Critical`. This can be
achieved by setting the instance property 'Critical' to the required value (e.g. `MyInstance.Critical := 100`).
New instances default to `Critical, Off`. Though sometimes needed, ListViews or the whole Gui may become
unresponsive under certain circumstances if `Critical` is set and the ListView has a g-label.


