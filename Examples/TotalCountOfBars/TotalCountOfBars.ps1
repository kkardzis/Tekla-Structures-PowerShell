# load Tekla Open API libraries into current PowerShell session
# for Tekla 2021 or older use "$Env:XSBIN\plugins\<lib>.dll"
Add-Type -Path "$Env:XSBIN\Tekla.Structures.Model.dll"

# -------------------------------------------------------------------------
function global:Update-TotalCountOfBars {
    $MOS = ([Tekla.Structures.Model.Model]::new()).GetModelObjectSelector()
    [System.Type[]]$Types = @([Tekla.Structures.Model.Reinforcement])
    $EXS = $MOS.GetAllObjectsWithType($Types)
    $EXS.SelectInstances = $false
    $LEN = $EXS.GetSize()

    $HS = [System.Collections.Generic.HashSet[String]]::new()
    $SW = [System.Diagnostics.Stopwatch]::StartNew()
    $PS = [System.Collections.ArrayList]::new()
    $RS = [System.Collections.Hashtable]::new()
    $Names = @('PREFIX', 'REBAR_POS')

    $i=0; $EXS.Reset()
    foreach ($X in $EXS) {
        if ($SW.Elapsed.TotalMilliseconds -ge 500) {
            Write-Progress -Activity "Counting..." -Status "$i of $LEN"
            $SW.Restart()
        }
        $Values = [System.Collections.Hashtable]::new()
        [void]$X.GetStringReportProperties($Names,([ref]$Values))
        [void]$PS.Add($Values['PREFIX']+'-'+$Values['REBAR_POS'])
        $RS[$PS[$i]] = $RS[$PS[$i]] + $X.GetNumberOfRebars()
        $i++
    }

    $i=0; $EXS.Reset()
    foreach ($X in $EXS) {
        if ($SW.Elapsed.TotalMilliseconds -ge 500) {
            Write-Progress -Activity "Updating..." -Status "$i of $LEN"
            $SW.Restart()
        }
        [int32]$N=0; [void]$X.GetUserProperty("TotalCountOfBars",([ref]$N))
        if ($N -ne $RS[$PS[$i]]) {
            [void]$X.SetUserProperty("TotalCountOfBars",([int32]$RS[$PS[$i]]))
            [void]$HS.Add($PS[$i]+' '+$N+' -> '+$RS[$PS[$i]])
        }
        $i++
    }

    return $HS
}