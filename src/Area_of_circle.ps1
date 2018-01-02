#!powershell

function area
{
    Param ([int]$rad)
    return [int]([Math]::Pi * [Math]::pow($rad, 2))
}

$ans = area 3
echo area 3
