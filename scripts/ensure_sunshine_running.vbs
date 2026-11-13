Option Explicit
Dim objWMIService, colProcesses, objShell
On Error Resume Next
Set objWMIService = GetObject("winmgmts:\\.\root\cimv2")
Set colProcesses = objWMIService.ExecQuery("Select ProcessId from Win32_Process Where Name = 'sunshine.exe'")
If colProcesses.Count = 0 Then
    Set objShell = CreateObject("WScript.Shell")
    objShell.Run "schtasks.exe /run /tn ""SunshineStreamer""", 0, False
End If
