
fmt = string.format

Init = (backendStr, proxyCmd, clientCmd) ->
    -- Create new tab for the debugging view and split horizontally
    V.exe "tabnew | sp"

    -- Enumerate the available windows
    wins = V.list_wins!
    table.sort wins
    wcli, wjump = unpack(wins)

    -- TODO: restore
    --if !&scrolloff
    -- Make sure the cursor stays visible at all times
    --  setlocal scrolloff=5

    -- Initialize the windowing subsystem
    gdb.win.init(wjump)

    -- Initialize current line tracking
    gdb.cursor.init!

    -- Initialize breakpoint tracking
    gdb.breakpoint.init!

    -- go to the other window and spawn gdb client
    gdb.client.init(wcli, proxyCmd, clientCmd, backendStr)

Cleanup = ->
    -- Clean up the breakpoint signs
    gdb.breakpoint.cleanupSigns!

    -- Clean up the current line sign
    gdb.cursor.display(0)

    gdb.win.cleanup!

    client_buf = gdb.client.getBuf!
    gdb.client.cleanup!

    -- Close the windows and the tab
    tabCount = #V.list_tabs!
    if V.buf_is_loaded(client_buf)
        V.exe ("bd! " .. client_buf)
    if tabCount == #V.list_tabs!
        V.exe "tabclose"

ret =
    init: Init
    cleanup: Cleanup

ret
