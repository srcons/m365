```PowerShell
Import-Module ExchangeOnlineManagement
Connect-ExchangeOnline
Start-ManagedFolderAssistant user@domain.com
```

```PowerShell
Get-MailboxStatistics scan | fl ItemCount,DeletedItemCount,TotalItemSize,TotalDeletedItemSize

Get-MailboxStatistics scan -archive | fl ItemCount,DeletedItemCount,TotalItemSize,TotalDeletedItemSize
```
