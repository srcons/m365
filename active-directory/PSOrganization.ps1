# PSOrganization.ps1
# PowerShell script to document the organization specified by the
# manager and directReports attributes in Active Directory.
#
# ----------------------------------------------------------------------
# Copyright (c) 2011 Richard L. Mueller
# Hilltop Lab web site - http://www.rlmueller.net
# Version 1.0 - March 26, 2011
#
# You have a royalty-free right to use, modify, reproduce, and
# distribute this script file in any way you find useful, provided that
# you agree that the copyright owner above has no warranty, obligations,
# or liability for such use.

Trap {"Error: $_"; Break;}
# Set-StrictMode -Version Latest

Function Reports($Manager, $Offset)
{

    $Filter = "(distinguishedName=$Manager)"
    $Searcher.Filter = $Filter
    $Result = $Searcher.FindAll()

    # Recursive method to document organization.
    If ($Manager -eq "Top")
    {
        $Filter = "(&(!manager=*)(directReports=*))"
    }
    Else
    {
        # Output object that reports to previous manager.
        $Dept = $Result.Properties.Item("department")
        $Div  = $Result.Properties.Item("division")
        $Tit  = $Result.Properties.Item("title")
        $Com  = $Result.Properties.Item("company")
        $Emp  = $Result.Properties.Item("employeeType")
        $Off  = $Result.Properties.Item("physicalDeliveryOfficeName")
        $Sam  = $Result.Properties.Item("sAMAccountName")
        $Ena  = $Result.Properties.Item("userAccountControl")
        
        ";$Offset$Manager;$Dept;$Div;$Tit;$Com;$Emp;$Off;$Sam;$Ena"
        $Offset = "$Offset    "
        # Search for all objects that report to this manager.
        $Filter = "(manager=$Manager)"
    }

    # Run the query.
    $Searcher.Filter = $Filter

    $Results = $Searcher.FindAll()
    ForEach ($Result In $Results)
    {
        $DN   = $Result.Properties.Item("distinguishedName")
        $Dept = $Result.Properties.Item("department")
        $Div  = $Result.Properties.Item("division")
        $Tit  = $Result.Properties.Item("title")
        $Com  = $Result.Properties.Item("company")
        $Emp  = $Result.Properties.Item("employeeType")
        $Off  = $Result.Properties.Item("physicalDeliveryOfficeName")
        $Sam  = $Result.Properties.Item("sAMAccountName")
        $Ena  = $Result.Properties.Item("userAccountControl")


        ";$Offset$DN;$Dept;$Div;$Tit;$Com;$Emp;$Off;$Sam;$Ena"
        
        $arrReports = $Result.Properties.Item("directReports")
        ForEach ($Report In $arrReports)
        {
            Reports $Report "$Offset    "
        }
    }
}

$D = [System.DirectoryServices.ActiveDirectory.Domain]::GetCurrentDomain()
$Domain = [ADSI]"LDAP://$D"
$Searcher = New-Object System.DirectoryServices.DirectorySearcher
$Searcher.PageSize = 200
$Searcher.SearchScope = "subtree"
$Searcher.PropertiesToLoad.Add("distinguishedName") > $Null
$Searcher.PropertiesToLoad.Add("directReports") > $Null

$Searcher.PropertiesToLoad.Add("department") > $Null
$Searcher.PropertiesToLoad.Add("division") > $Null
$Searcher.PropertiesToLoad.Add("title") > $Null
$Searcher.PropertiesToLoad.Add("company") > $Null
$Searcher.PropertiesToLoad.Add("employeeType") > $Null
$Searcher.PropertiesToLoad.Add("physicalDeliveryOfficeName") > $Null
$Searcher.PropertiesToLoad.Add("sAMAccountName") > $Null
$Searcher.PropertiesToLoad.Add("userAccountControl") > $Null

$Searcher.SearchRoot = "LDAP://" + $Domain.distinguishedName

# Document the organization.
Reports "Top" ""
#Reports "CN=Doe\, John,OU=User,OU=staffAccounts,DC=somedomain,DC=com" ""