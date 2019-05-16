<?php
// RvWin Readings
$radumfang_vorn = 1889.0;
$radumfang_hinten = 1948.0;
$abstand_vorn_read = 886.0;
$vorderachshoehe_read = 60.0;
$abstand_hinten_read = 530.0;
$hinterachshoehe_read = 171.0;
$heckhoehe = 550.0;
$offset = 33.827778;

$g_st = -0.100999996; // Sturz
$g_rw = 86.46109772; // Rahmenwinkel
$g_rl = 732.3649902; // Rahmenlaenge
$cmd_winkel = 69; // CMS-Winkel
$g_Lv = 0.0; // Lenkkopfver.

$c1 = 234.0;
$c2 = 0.0;
$c3 = 0.0;
$c4 = 0.0;
$c5 = 0.0;
$c6 = 0.0;
$c7 = 0.0;
$c8 = 0.0;

// CMS Readings
//$abstand_vorn = 886.0;
//$achshoehe_vorn = 60.0;
//$abstand_hinten = 530.0;
//$achshoehe_hinten = 171.0;



$r1 = 0;
$pos_hor = 0.0;
$pos_vert = 0.0;

// Form_Activate
$cmd_winkelbogen = $cmd_winkel * pi() / 180; // $cmd_winkel in graden, $winkelbogen in radialen
$rw_bogen = $g_rw * pi() / 180;

if ($r1 == 1) {
    $w24 = pi() - $winkelbogen - $rw_bogen;
    if ($w24===0) $w24 = 0.00000001;
    $v26 = $c1 / tan($w24);
    $v24 = $c1 / sin($w24);
    $v25 = $g_rl + $v24;
    $v27 = $v25 * sin($rw_bogen) / sin($winkelbogen);
    $abstand_vorn = $abstand_vorn_read = + $c2 + $c5;
    $v28 = $abstand_vorn + $v26 - $v27;
    $v29 = $v28 * tan($winkelbogen);
    $v01 = $vorderachshoehe_read + $c4;
    $v30 = $v01 + $v29;
    $w25 = pi() / 2 - $winkelbogen;
    $offset = sin($w25) * $v30;
}

$v00 = $hinterachshoehe_read + $c8;
$v01 = $vorderachshoehe_read + $c4 - $v00;
$vorderachshoehe_fb = $radumfang_vorn / 2 / pi();
$hinterachshoehe_fb = $radumfang_hinten / 2 / pi();
$v02 = $hinterachshoehe_fb - $vorderachshoehe_fb;
$abstand_vorn_cmd = $abstand_vorn_read + $c2 + $c5;
$abstand_hinten_cmd = $abstand_hinten_read + $c3 + $c5;
$v03 = $abstand_vorn_cmd + $abstand_hinten_cmd;
$w01 = atan($v01 / $v03);
$w01b = $w01 * 180 / pi();
$radstand_cmd = sqrt(pow($v01, 2) + pow($v03, 2));
$vh1 = $v02 / $radstand_cmd;
$vh2 = $vh1 / sqrt(-1 * $vh1 * $vh1 + 1);
$w02 = atan($vh2);
$w02b = $w02 * 180 / pi();
$w03 = $w01 + $w02;
$lkw_fb = pi() / 2 - $cmd_winkelbogen -$w03;

if ($lkw_fb === 0) $lkw_fb = 0.00000000001;

$w04 = atan(($c1 - $v00) / $abstand_hinten_cmd);
$w05 = $rw_bogen - $lkw_fb;
$schwingenwinkel_fb = $w04 - $w03;
$schwingenlaenge_fb = sqrt(pow($abstand_hinten_cmd, 2) + pow($c1-$v00, 2));
$v04 = $schwingenlaenge_fb * cos($schwingenwinkel_fb);
$v05 = $schwingenlaenge_fb * sin($schwingenwinkel_fb);
$v06 = $g_rl * cos($w05);
$schwingenachshoehe_fb = $hinterachshoehe_fb + $v05;
$vorderbauhoehe_fb = $v06 + $schwingenachshoehe_fb;
$v07 = $vorderbauhoehe_fb - $vorderachshoehe_fb;
$v08 = $g_rl * sin($w05);
$gabellaenge_fb = $v07 / cos($lkw_fb) + $offset * tan($lkw_fb);
$nachlauf_fb = tan($lkw_fb) * ($vorderachshoehe_fb - $offset / sin($lkw_fb));
$nachlauf_real = cos($lkw_fb) * $nachlauf_fb;
$radstand_fb = $v04 + $v08 - $nachlauf_fb + $vorderbauhoehe_fb * tan($lkw_fb);
$schwingenwinkel_grad = $schwingenwinkel_fb * 180 / pi();
$lkw_grad = $lkw_fb * 180 / pi();

if (!$w03) $w03 = 0.000000001;

if ($pos_hor && $pos_vert) {
    $vrh = $pos_hor + $c5;
    $vrv = $pos_vert - $c4 + $c3;
    $vvh = $abstand_vorn_cmd + $c5;
    $vvv = $vorderachshoehe_read - $c4 + $c3;
    $vhh = $abstand_hinten_cmd - $c7;
    $vhv = $hinterachshoehe_cmd - $c8 + $c2;
} else {
    $vrh = $pos_hor;
    $vrv = $pos_vert;
    $vvh = $abstand_vorn_cmd;
    $vvv = $vorderachshoehe_read;
    $vhh = $abstand_hinten_cmd;
    $vhv = $hinterachshoehe_read;
}

$us4 = $vorderachshoehe_fb - $vvv / cos($w03) / sin($w03) + $vvh - $c1 * tan($w03) + $vvv * tan($w03);
$schwingenachshoehe2 = $us4 * sin($w03) + $c1 / cos($w03);
$voderachsabstand = $us4 * cos($w03) - ($vorderachshoehe_fb - $vvv / cos($w03)) / tan($w03);
$schwingenlaenge2 = ($hinterachshoehe_fb - $vhv / cos($w03)) / tan($w03) - $us4 * cos($w03);
$schwingenlaenge_direct = pow($schwingenlaenge2, 2) + sqrt(pow($schwingenachshoehe2 - $hinterachshoehe_fb, 2));
$koord_vert = $vrv / cos($w03) + sin($w03) * ($us4 + $c1 * tan($w03)) - $vrh - $vrv * sin($w03);
$koord_hor = $us4 * cos($w03) - cos($w03) * ($us4 + $c1 * tan($w03)) - $vrh - $vrv * sin($w03);

// Kette berechnen
$hara = sqrt((pow($vrh + $vhh, 2) + pow($vrv - $vhv, 2)));

$cmd_messung = [
'Lenkkopfwinkel' => $lkw_grad,
'Nachlauf' => $nachlauf_fb,
'Realer Nachlauf' => $nachlauf_real,
'Offset' => $offset,
'Schwingenwinkel' => $schwingenwinkel_grad,
'Gabellaenge' => $gabellaenge_fb,
'Schwingenlaenge abs.' => $schwingenlaenge_fb,
'Heckhoehe' => $heckhoehe,
'Radstand' => $radstand_fb,
'Vorderraddurchmesser' => 2*$vorderachshoehe_fb,
'Hinterraddurchmesser' => 2*$hinterachshoehe_fb,
];
print_r($cmd_messung);
?>