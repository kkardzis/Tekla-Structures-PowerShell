# load Tekla Open API libraries into current PowerShell session
# for Tekla 2021 or older use "$Env:XSBIN\plugins\<lib>.dll"
Add-Type -Path "$Env:XSBIN\Tekla.Structures.Model.dll"

function global:ExportIFC {
    # create ComponentInput object
    $TCI = [Tekla.Structures.Model.ComponentInput]::new()
    $TCP = [Tekla.Structures.Geometry3d.Point]::new(0,0,0)
    [void]$TCI.AddOneInputPosition($TCP)

    # create Component object
    $TCM = [Tekla.Structures.Model.Component]::new($TCI)
    $TCM.Number = [Tekla.Structures.Model.BaseComponent]::PLUGIN_OBJECT_NUMBER
    $TCM.Name = "ExportIFC"

    # load attributes from selected file
    [void]$TCM.LoadAttributesFromFile("standard")

    # if necessary, adjust values of selected attributes manually
    # attribute names can be found in saved attribute file, for example:
    # <Environments>\common\system\standard.IFCExportPlugin.MainDialog.xml
    $TCM.SetAttribute("OutputFile", ".\IFC\MyFileName")

    # perform actual export
    [void]$TCM.Insert()
}
