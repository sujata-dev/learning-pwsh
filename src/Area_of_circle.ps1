function area
{
    Param ([int]$rad)
    return [int]([Math]::Pi * [Math]::pow($rad,2))
}

area 3  # to call
