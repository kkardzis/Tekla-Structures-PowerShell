# load Tekla Open API libraries into current PowerShell session
# for Tekla 2021 or older use "$Env:XSBIN\plugins\<lib>.dll"
Add-Type -Path "$Env:XSBIN\Tekla.Structures.Model.dll"

# --------------------------------------------------------------------
# CreateReportFromAll -TemplateName 'P_Part_List' -FileName 'partlist'
# --------------------------------------------------------------------
function global:CreateReportFromAll {
    param (
        [Parameter(Mandatory)]
        [string]$TemplateName,

        [string]$FileName = $TemplateName,
        [string]$Title1 = '',
        [string]$Title2 = '',
        [string]$Title3 = ''
    )
    # function returns True on success and False on failure
    # failure happens for example when output folder does not exists ('Reports' by default)
    # at the same time when output file exists, but is locked (opened), function does nothing and returns True (!?)
    [Tekla.Structures.Model.Operations.Operation]::CreateReportFromAll($TemplateName,$FileName,$Title1,$Title2,$Title3)
}

# -------------------------------------------------------------------------
# CreateReportFromSelected -TemplateName 'P_Part_List' -FileName 'partlist'
# -------------------------------------------------------------------------
function global:CreateReportFromSelected {
    param (
        [Parameter(Mandatory)]
        [string]$TemplateName,

        [string]$FileName = $TemplateName,
        [string]$Title1 = '',
        [string]$Title2 = '',
        [string]$Title3 = ''
    )
    [Tekla.Structures.Model.Operations.Operation]::CreateReportFromSelected($TemplateName,$FileName,$Title1,$Title2,$Title3)
}
