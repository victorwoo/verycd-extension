#========================================================================
# Created with: SAPIEN Technologies, Inc., PowerShell Studio 2012 v3.1.20
# Created on:   2013/7/8 14:17
# Created by:   Victor
# Organization: 
# Filename:     
#========================================================================
$regex = [regex] '^\[(?<folder_name>.*)\]\.?(?<file_name>.*)'

dir | % {
	$match = $regex.Match($_)
	if ($match.Success) {
		$folderName = $match.Groups['folder_name'].Value
		$fileName = $match.Groups['file_name'].Value
		$targetFullPath = Join-Path $folderName $fileName
		if (-not (Test-Path $folderName)) {
			md $folderName | Out-Null
		}
		Move-Item -LiteralPath $_ $targetFullPath #-WhatIf
	} 
}