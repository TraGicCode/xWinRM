# xWinRM

The **xWinRM** module contains DSC resources for configuration
of WinRM.

## Branches

### master

This is the branch containing the latest release - no contributions should be made
directly to this branch.

### dev

This is the development branch to which contributions should be proposed by contributors
as pull requests. This development branch will periodically be merged to the master
branch, and be released to [PowerShell Gallery](https://www.powershellgallery.com/).

## Contributing

Regardless of the way you want to contribute we are tremendously happy to have you
here.

There are several ways you can contribute. You can submit an issue to report a bug.
You can submit an issue to request an improvement. You can take part in discussions
for issues. You can review pull requests and comment on other contributors changes.
You can also improve the resources and tests, or even create new resources, by
sending in pull requests yourself.

## Installation

To manually install the module, download the source code and unzip the contents
of the '\Modules\xWinRM' directory to the
'$env:ProgramFiles\WindowsPowerShell\Modules' folder.

To install from the PowerShell gallery using PowerShellGet (in PowerShell 5.0) run
the following command:

```powershell
Find-Module -Name xWinRM -Repository PSGallery | Install-Module
```

To confirm installation, run the below command and ensure you see the WinRM
DSC resources available:

```powershell
Get-DscResource -Module xWinRM
```

## Requirements

The minimum Windows Management Framework (PowerShell) version required is 5.0 or
higher, which ships with Windows 10 or Windows Server 2016, but can also be
installed on Windows 7 SP1, Windows 8.1, Windows Server 2008 R2 SP1,
Windows Server 2012 and Windows Server 2012 R2.

## Examples

You can review the [Examples](/Examples) directory in the xWinRM module for
some general use scenarios for all of the resources that are in the module.

## Change log

A full list of changes in each version can be found in the [change log](CHANGELOG.md).

## Resources

* [**xWinRMListener**](#xwinrmlistener) resource to manage WinRM Listeners.

### xWinRMListener

Manages the WinRM Listeners.

#### Requirements

* Target machine must be running Windows Server 2008 R2 or later.

#### Parameters

* **`[String]` Ensure** _(Write)_: Determines whether resource should be present or absent. { Present | Absent }.
* **`[String]` Address** _(Key)_: The address the listener should be listening on. ( Confirm This )
* **`[String]` Transport** _(Key)_: The Transport to be used for all connections. { Http | Https }.
* **`[Boolean]` Enabled** _(Write)_: Whether or not the listener is enabled or disabled. { *True* | False }

#### Examples

* [Create an HTTP WinRM Listener](/Examples/Resources/xWinRMListener/1-CreateHTTPListener.ps1)