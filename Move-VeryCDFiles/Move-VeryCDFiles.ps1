Function Touch-File
{
    $file = $args[0]
    if($file -eq $null) {
        throw "No filename supplied"
    }

    if(Test-Path $file)
    {
        (Get-ChildItem $file).LastWriteTime = Get-Date
    }
    else
    {
        Set-Content $null -LiteralPath $file -Encoding Byte
    }
}

<#
	.SYNOPSIS
		Fix a string to accord with the valid Windows directory / file name.

	.DESCRIPTION
		Windows file system reserved some special characters such as /, |, \, ?, ", *, :, <, >, ..
		And sould not use device file names such as CON, PRN, AUX, CLOCK$, NUL, COM1, COM2, COM3, 
		COM4, COM5, COM6, COM7, COM8, COM9, LPT1, LPT2, LPT3, LPT4, LPT5, LPT6, LPT7, LPT8, and LPT9.

	.PARAMETER  fsName
		The inputed directory / file name.

	.EXAMPLE
		Get-ValidFileSystemName 'abc*def/ghi?jkl'

	.EXAMPLE
		'abc*def/ghi?jkl', 'CON.NUL' | Get-ValidFileSystemName

	.INPUTS
		System.String

	.OUTPUTS
		System.String

	.NOTES
		Be care of the limitation of the max length of full file name by file system.

	.LINK
		about_functions_advanced

	.LINK
		about_comment_based_help
#>
function Get-ValidFileSystemName
{
	[CmdletBinding()]
	param(
		[Parameter(Mandatory = $true, ValueFromPipeline = $true)]
		[string]$FileSystemName
	)
	
	process{
		$deviceFiles = 'CON', 'PRN', 'AUX', 'CLOCK$', 'NUL', 'COM1', 'COM2', 'COM3', 'COM4', 'COM5', 'COM6', 'COM7', 'COM8', 'COM9', 'LPT1', 'LPT2', 'LPT3', 'LPT4', 'LPT5', 'LPT6', 'LPT7', 'LPT8', 'LPT9'
		$FileSystemName = $FileSystemName -creplace '[\\/|?"*:<>\x00\x1F\t\r\n]', '.'

        $fileName = [System.IO.Path]::GetFileNameWithoutExtension($FileSystemName)
		$extension = [System.IO.Path]::GetExtension($FileSystemName)
		if ($extension.StartsWith('.'))
		{
			$extension = $extension.Substring(1)
		}
		
		if ($deviceFiles -contains $fileName)
		{
			$fileName = "_$fileName"
		}
		
		if ($deviceFiles -contains $extension)
		{
			$extension = "_$extension"	
		}
		
		if ($extension -eq '')
		{
			$FileSystemName = "$fileName$extension"
		}
		else
		{
			$FileSystemName = "$fileName.$extension"	
		}
		
		return $FileSystemName
	}
}

function Print-UrlToPDF {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory=$true)]
        [string]$Url,

        [Parameter(Mandatory=$true)]
        [string]$Path
    )

    process{
        $OutputFolder = [System.IO.Path]::GetDirectoryName($Path)
        $FileName = [System.IO.Path]::GetFileName($Path)

        ############################################################### 
        #         DO NOT WRITE ANYTHING BELOW THIS LINE               # 
        ############################################################### 
        $ErrorActionPreference="Stop" 
        $WarningPreference="Stop" 
        $PDFINFOPATH="HKCU:\Software\PDFCreator\Program" 
        $AUTOSAVEFNAMEPROPERTY="AutoSaveFilename" 
        $AUTOSAVEDIRPROPERTY="AutoSaveDirectory" 
        $USEAUTOSAVEPROPERTY="UseAutoSave" 
        ################################################################ 
        try 
        { 
            get-itemproperty -path $PDFINFOPATH -name $AUTOSAVEDIRPROPERTY |out-null    
            set-itemproperty -path $PDFINFOPATH -name $AUTOSAVEDIRPROPERTY -value $OutputFolder |out-null     
        } 
        catch 
        { 
            new-itemproperty -path $PDFINFOPATH -name $AUTOSAVEDIRPROPERTY -value $OutputFolder |out-null    
     
        } 
        try 
        { 
            get-itemproperty -path $PDFINFOPATH -name $USEAUTOSAVEPROPERTY |out-null    
            set-itemproperty -path $PDFINFOPATH -name $USEAUTOSAVEPROPERTY -value "1" |out-null 
        } 
        catch 
        { 
            new-itemproperty -path $PDFINFOPATH -name $USEAUTOSAVEPROPERTY -value "1" |out-null    
     
        } 
        finally 
        { 
          try 
          { 
            # Create the IE com object
            try
            {
                $ie = new-object -comObject InternetExplorer.Application
            }
            catch
            {
                $ErrorMessage = $_.Exception.Message
                $FailedItem = $_.Exception.ItemName
   
                exit 1
            }

            # Navigate to the web page
            $ie.navigate($Url)
            # Wait for the page to finish loading
            do {sleep 1} until (-not ($ie.Busy))
            #$ie.visible = $true #Uncomment this for debugging        

            try 
            { 
                get-itemproperty -path $PDFINFOPATH -name $AUTOSAVEFNAMEPROPERTY |out-null 
                set-itemproperty -path $PDFINFOPATH -name $AUTOSAVEFNAMEPROPERTY -value "$FileName.pdf" |out-null  
            } 
            catch 
            { 
                new-itemproperty -path $PDFINFOPATH -name $AUTOSAVEFNAMEPROPERTY -value "$FileName.pdf" |out-null 
        
            }      
            start-sleep -seconds 5  
            $ie.execWB(6,2) 
            start-sleep -seconds 5     
            $ie.quit()     
          } 
          catch {} 
          finally 
          {   
            try 
            { 
                set-itemproperty -path $PDFINFOPATH -name $AUTOSAVEFNAMEPROPERTY -value "" |out-null  
                set-itemproperty -path $PDFINFOPATH -name $AUTOSAVEDIRPROPERTY -value "" |out-null  
                set-itemproperty -path $PDFINFOPATH -name $USEAUTOSAVEPROPERTY -value "0" |out-null  
            } 
            catch{}     
          }   
        }
    }
}

function Move-Ed2kFile{
    [CmdletBinding()]
    param(
        [Parameter(Mandatory=$true)]
        [string]$RootFolder,

        [Parameter(Mandatory=$true, ValueFromPipeline = $true)]
        [string]$FileName,

        [Parameter(Mandatory=$true)]
        [string]$Ed2kUrl
    )

    process {
        $newPath = Join-Path $RootFolder $FileName
        if (-not (Test-Path -LiteralPath $FileName) -and -not (Test-Path -LiteralPath $newPath)) {
            $missingFiles.Add($FileName) | Out-Null
            $global:missingEd2kUrls = $global:missingEd2kUrls + $Ed2kUrl
        }
        mv -LiteralPath $FileName $newPath -Force -ErrorAction SilentlyContinue
    }
}

$ScriptVersion = 1
$global:missingEd2kUrls = @()
dir *.manifest.json | % {
    echo "Processing $_"
	$json = (gc -LiteralPath $_ -Encoding 'UTF8') -join "`n" | ConvertFrom-Json

    if ($json.scriptVersion -ne 1) {
        Write-Warning "版本不匹配，清单 = $($json.scriptVersion)，脚本 = $($ScriptVersion)"
        return
    }

    $missingFiles = New-Object System.Collections.ArrayList

	$rootFolder = $json.title | Get-ValidFileSystemName
	md $rootFolder -ErrorAction SilentlyContinue | Out-Null

    $dateToFileName = $json.date | Get-ValidFileSystemName

    #创建.url
    $urlPath = Join-Path (Join-Path (pwd) $rootFolder) 'resource.url'
    $WshShell = New-Object -com "WScript.Shell"
    $Link = $WshShell.CreateShortcut($urlPath)
    $Link.TargetPath = $json.url
    $Link.Save()

    #创建.pdf
    #$pdfPath = Join-Path ( Join-Path (pwd) $rootFolder) ($dateToFileName + '.pdf')
    #Print-UrlToPDF $json.url $pdfPath

    $folderPath = $rootFolder
    $json.files | % {
        $_.name | Get-ValidFileSystemName | Move-Ed2kFile -RootFolder $folderPath -Ed2kUrl $_.ed2k
    }

	$json.folders | % {
	    $folderName = $_.name | Get-ValidFileSystemName
        $folderPath = Join-Path $rootFolder $folderName
	    md $folderPath -ErrorAction SilentlyContinue | Out-Null

	    $_.files | % {
            $_.name | Get-ValidFileSystemName | Move-Ed2kFile -RootFolder $folderPath -Ed2kUrl $_.ed2k
        }
	}

    if ($missingFiles.Count -eq 0) {
        mv -LiteralPath $_ (Join-Path $rootFolder "manifest.json")
    } else {
        Write-Warning ($json.url + " Missing:`n" + ($missingFiles | Out-String))
    }
}

$global:missingEd2kUrls | sc 'missing.txt'
notepad missing.txt