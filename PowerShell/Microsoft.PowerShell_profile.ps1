Import-Module posh-git
Import-Module oh-my-posh
Set-PoshPrompt -Theme agnosterplus
Import-Module -name Terminal-Icons

set-PSReadLineOption -PredictionSource HistoryAndPlugin
set-PSReadLineOption -PredictionViewStyle ListView

Set-Alias winfetch pwshfetch-test-1
