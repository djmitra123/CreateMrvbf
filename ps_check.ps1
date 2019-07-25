$psver=$PSVersionTable.PSVersion.Major
Write-Host "Using Powershell" $PSVersionTable.PSVersion

if($psver -le 4){     
   $cwd = Get-Location  
   $sourceFile = Join-Path -Path $cwd -ChildPath '\saga-6.2.0_x64.zip'
   $targetFolder = 'C:\saga620'
 
   [System.Reflection.Assembly]::LoadWithPartialName('System.IO.Compression.FileSystem')
   [System.IO.Compression.ZipFile]::ExtractToDirectory($sourceFile, $targetFolder)   
}else {   
   Expand-Archive -Force .\saga-6.2.0_x64.zip C:\saga620
}