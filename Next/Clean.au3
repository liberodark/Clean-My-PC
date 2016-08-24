#RequireAdmin
$CMD = "ipconfig /flushdns"
$CMD = "powercfg -h off"
RunWait(@ComSpec & " /c " & $CMD, @WindowsDir, @SW_SHOW)