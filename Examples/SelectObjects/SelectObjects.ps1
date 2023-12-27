# load Tekla Open API libraries into current PowerShell session
# for Tekla 2021 or older use "$Env:XSBIN\plugins\<lib>.dll"
Add-Type -Path "$Env:XSBIN\Tekla.Structures.Model.dll"

#------------------------------------
function global:Get-SelectedObjects {
    $TSMOS = New-Object Tekla.Structures.Model.UI.ModelObjectSelector
    return $TSMOS.GetSelectedObjects()
}

#------------------------------------
function global:Get-AllModelObjects {
    $TSM = New-Object Tekla.Structures.Model.Model
    $MOS = $TSM.GetModelObjectSelector()
    return $MOS.GetAllObjects()
}

#---------------------------------------------
function global:Get-ModelObjectsByFilterName {
    param (
        [Parameter(Mandatory)]
        [string]$FilterName
    )
    $TSM = New-Object Tekla.Structures.Model.Model
    $MOS = $TSM.GetModelObjectSelector()
    return $MOS.GetObjectsByFilterName($FilterName)
}


# ------------------------------------------------
# SelectObjectsByFilterName -FilterName 'standard'
# ------------------------------------------------
function global:SelectObjectsByFilterName {
    param (
        [Parameter(Mandatory)]
        [string]$FilterName
    )

    # create ModelObjectSelector
    $TSM = [Tekla.Structures.Model.Model]::new()
    $MOS = $TSM.GetModelObjectSelector()

    # get objects using saved filter file
    $EXS = $MOS.GetObjectsByFilterName($FilterName)
    $EXS.SelectInstances = $false

    # convert Enumerator into ArrayList
    $XS = [System.Collections.ArrayList]::new()
    foreach ($EX in $EXS) {[void]$XS.Add($EX)}

    # select and highlight objects in Tekla user interface (view)
    $TSMOS = [Tekla.Structures.Model.UI.ModelObjectSelector]::new()
    return $TSMOS.Select($XS,$false)
}

# below is an example of adding TAB completion functionality to the above function;
# when user presses the TAB key after the parameter name, PowerShell will try to find
# possible values for a parameter; the available values are calculated at runtime (dynamically)
Register-ArgumentCompleter -CommandName SelectObjectsByFilterName -ParameterName FilterName -ScriptBlock {
    param($commandName, $parameterName, $wordToComplete, $commandAst, $fakeBoundParameters)
    $TSM = [Tekla.Structures.Model.Model]::new()
    $TSF = [Tekla.Structures.TeklaStructuresFiles]::new($TSM.GetInfo().ModelPath)
    $TSF.GetMultiDirectoryFileList('SObjGrp', $false) |
      Where-Object { $_ -like "$wordToComplete*" } |
      ForEach-Object { "'$_'" }
}
