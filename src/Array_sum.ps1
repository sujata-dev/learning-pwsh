#!/usr/bin/env pwsh

function arraysum
{
    Param ([int]$size)
    ($sum, $item) = (0, 4)
    echo "Enter $size elements: "
    $arr = Read-Host
    $arr = $arr.split(' ')
    if($arr -contains $item)
    {
        echo "Item found"
    }
    for($i = 0; $i -lt $arr.length; $i++)
    {
        $sum += $arr[$i]
    }
    return $sum
}

$sum = arraysum 3  #to call
echo $sum
