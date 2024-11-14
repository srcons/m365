```PowerShell
Import-Module ExchangeOnlineManagement
Connect-ExchangeOnline
Start-ManagedFolderAssistant user@domain.com
```

```PowerShell
Get-MailboxStatistics user@domain.com | fl ItemCount,DeletedItemCount,TotalItemSize,TotalDeletedItemSize

Get-MailboxStatistics user@domain.com -archive | fl ItemCount,DeletedItemCount,TotalItemSize,TotalDeletedItemSize
```
