Option Explicit
Dim objWMIService, colProcesses, objShell, strCmd
On Error Resume Next
Set objWMIService = GetObject("winmgmts:\\.\root\cimv2")
Set colProcesses = objWMIService.ExecQuery("Select ProcessId from Win32_Process Where Name = 'sunshine.exe'")
Set objShell = CreateObject("WScript.Shell")
strCmd = "powershell.exe -NoProfile -NonInteractive -WindowStyle Hidden -ExecutionPolicy Bypass -File ""C:\Users\guswn\.gemini\antigravity\scratch\surface-secondary-monitor\scripts\launch_sunshine_silent.ps1"""
If colProcesses.Count = 0 Then
    objShell.Run strCmd, 0, False
End If
