<?php
require_once('messung.php');

// Simulation values
$radumfangvorn_kor = $radumfang_vorn;
$radumfang_hinten_kor = $radumfang_hinten;
$schwingenwinkel_fb_grad = $schwingenwinkel_grad;
$schwingenlaenge_fb_kor = $schwingenlaenge_fb;
$gabellaenge_fb_kor = $gabellaenge_fb;
$lkw_fb_grad = $lkw_grad;

// Berechnung der neuen Werte nach Änderung von $radumfangvorn_kor
$vorderachshoehe_fb_kor = $radumfangvorn_kor / 2 / pi();
$w06 = atan(($hinterachshoehe_fb - $vorderachshoehe_fb) / $radstand_fb);
$v09 = $radstand_fb * cos($w06);
$w07 = atan(($vorderachshoehe_fb_kor - $vorderachshoehe_fb) / $v09);
$w08 = atan(($hinterachshoehe_fb - $vorderachshoehe_fb_kor) / $v09);
$w08_grad = $w08 * 180 / pi();
$radstand_fb2 = $v09 * cos($w08);
$schwingenwinkel_fb_grad2 = $schwingenwinkel_fb_grad * $w07 * 180 / pi();
$lkw_fb_grad2 = $lkw_fb_grad + $w07 * 180 / pi();
$v11 =  $schwingenlaenge_fb * sin($schwingenwinkel_fb_grad2 * pi() / 180);
$schwingenachshoehe_fb2 = $hinterachshoehe_fb + $v11;
$v10 = $g_rl * cos(($g_rw - $lkw_fb_grad2) * pi() / 180);
$vorderbauhoehe_fb2 = $schwingenachshoehe_fb2 + $v10;
$nachlauf_fb2 = tan($lkw_fb_grad2 * pi() / 180) * ($vorderachshoehe_fb_kor - $offset / sin($lkw_fb_grad2 * pi() / 180));

// Berechnung der neuen Werte nach Änderung von $radumfang_hinten
$hinterachshoehe_fb_kor = $radumfang_hinten_kor / 2 / pi();
$w06 = atan(($hinterachshoehe_fb - $vorderachshoehe_fb) / $radstand_fb);
$v09 = $radstand_fb * cos($w06);
$vh1 = ($hinterachshoehe_fb_kor - $vorderachshoehe_fb_kor) / $v09;
$vh2 = $vh1 / sqrt((-1*$vh1) * $vh1 + 1);
$w09 = atan($vh2);
$w09_grad = $w09 * 180 / pi();
$radstand_fb3 = $v09 * cos($w09);
$w10 = $w09 - $w08;
$schwingenwinkel_fb_grad3 = $schwingenwinkel_fb_grad2 - $w10 * 180 / pi();
$lkw_fb_grad3 = $lkw_fb_grad2 - $w10 * 180 / pi();
$nachlauf_fb3 = tan($lkw_fb_grad3 * pi() / 180) * ($vorderachshoehe_fb_kor - $offset / sin($lkw_fb_grad3 * pi() / 180));
$schwingenachshoehe_fb3 = $hinterachshoehe_fb_kor + $schwingenlaenge_fb * sin($schwingenwinkel_fb_grad3 * pi() / 180);
$v13 = $g_rl * cos(($g_rw - $lkw_fb_grad3) * pi() / 180);
$vorderbauhoehe_fb3 = $schwingenachshoehe_fb3 + $v13;

// Berechnung nach Änderung der Schwingenlänge
$schwingenlaenge_fb_diff = $schwingenlaenge_fb_kor - $schwingenlaenge_fb;
$v15 = $v09 + 0.99 * $schwingenlaenge_fb_diff * cos($schwingenwinkel_fb_grad3 * pi() / 180);
$w11 = atan(($hinterachshoehe_fb_kor-$vorderachshoehe_fb_kor)/ $v15);
$radstand_fb4 = $v15 * cos($w11);
$v14 = $schwingenlaenge_fb_diff * sin($schwingenwinkel_fb_grad3 * pi() / 180);
$vh1 = $v14 / $v15;
$vh2 = $vh1 / sqrt(-1*$vh1*$vh1 + 1);
$w12 = atan($vh2);
$w12_grad = $w12 * 180 / pi();
$schwingenwinkel_fb_grad4 = $schwingenwinkel_fb_grad3 - $w12 * 180 / pi();
$lkw_fb_grad4 = $lkw_fb_grad3 - $w12 * 180 / pi();
$schwingenachshoehe_fb4 = $hinterachshoehe_fb_kor + $schwingenlaenge_fb_kor * sin($schwingenwinkel_fb_grad4 * pi() / 180);
$vorderbauhoehe_fb4 = $schwingenachshoehe_fb4 + $g_rl * cos(($g_rw - $lkw_fb_grad4) * pi() / 180);
$nachlauf_fb4 = tan($lkw_fb_grad4 * pi() / 180) * ($vorderachshoehe_fb_kor - $offset / sin($lkw_fb_grad4 * pi() / 180));
$heckhoehe_kor4 = $heckhoehe;

// Berechnung nach Änderung der Heckhöhe
$vh3 = round($schwingenlaenge_fb_diff, 1);
$vh4 = $vh3 != 0 ? $heckhoehe_kor4 : $heckhoehe;
$heckhoehe_diff = $heckhoehe - $vh4;
$v18 = $radstand_fb4 - $schwingenlaenge_fb_kor * cos($schwingenwinkel_fb_grad4 * pi() / 180);
$v17 = sqrt(pow($v18, 2) + pow($schwingenachshoehe_fb4 - $vorderachshoehe_fb_kor, 2));
$vh1 = ($schwingenachshoehe_fb4 - $vorderachshoehe_fb_kor) / $v17;
$vh2 = $vh1 / sqrt(-1 * $vh1 * $vh1 + 1);
$w16 = atan($vh2);
$w16_grad = $w16 * 180 / pi();
$w13  = atan($heckhoehe_diff / $schwingenlaenge_fb_kor);
$w13_grad = $w13 * 180 / pi();
$w17 = pi() - $w16 - $schwingenwinkel_fb_grad4 * pi() / 180 - $w13;
$w17_grad = $w17 * 180 / pi();
$v16 = sqrt(pow($v17, 2) + pow($schwingenlaenge_fb_kor, 2) - 2 * $v17 * $schwingenlaenge_fb_kor * cos($w17));
$vh1 = ($hinterachshoehe_fb_kor - $vorderachshoehe_fb_kor) / $v16;
$vh2 = $vh1 / sqrt(-1*$vh1*$vh1+1);
$w19 = atan($vh2);
$v19 = $heckhoehe_diff * cos($schwingenwinkel_fb_grad4 * pi() / 180);
$vh1 = $v19 / $v16;
$vh2 = $vh1 / sqrt(-1 * $vh1 * $vh1 + 1);
$w18 = atan($vh2);
$radstand_fb5 = $v16 * cos($w19);
$schwingenwinkel_fb_grad5 = $schwingenwinkel_fb_grad4 + $w13 * 180 / pi() - $w18 * 180 / pi();
$lkw_fb_grad5 = $lkw_fb_grad4 - $w18 * 180 / pi();
$nachlauf_fb5 = tan($lkw_fb_grad5 * pi() / 180) * (($vorderachshoehe_fb_kor - $offset / sin($lkw_fb_grad5 * pi() / 180)));
$schwingenachshoehe_fb5 = $hinterachshoehe_fb_kor + $schwingenlaenge_fb_kor * sin($schwingenwinkel_fb_grad5 * pi() / 180);
$vorderbauhoehe_fb5 = $schwingenachshoehe_fb5 + $g_rl * cos(($g_rw - $lkw_fb_grad5) * pi() / 180);

// Berechnung nach Änderung der Gabellänge
$gabellaenge_fb_diff = $gabellaenge_fb_kor - $gabellaenge_fb;
$v22 = $gabellaenge_fb_diff * cos($lkw_fb_grad5 * pi() / 180);
$v20 = $hinterachshoehe_fb_kor - $vorderachshoehe_fb_kor + $v22;
$v21 = $gabellaenge_fb_diff * sin($lkw_fb_grad5 * pi() / 180);
$v23 = sqrt( pow($v21 + $radstand_fb5, 2) + pow( $v20, 2) );
$vh1 = ($hinterachshoehe_fb_kor - $vorderachshoehe_fb_kor) / $v23;
$vh2 = $vh1 / sqrt(-1*$vh1*$vh1 + 1);
$w20 = atan($vh2);
$w20_grad = $w20 * 180 / pi();
$radstand_fb6 = $v23 * cos($w20);
$vh1 = ($v20 / $v23);
$vh2 = $vh1 / sqrt(-1*$vh1*$vh1+1);
$w22 = atan($vh2);
$w22_grad = $w22 * 180 / pi();
$w21 = $w19 - $w20;
$w23 = $w22 - $w21 - $w19;
$schwingenwinkel_fb_grad6 = $schwingenwinkel_fb_grad5 + $w23 * 180 / pi();
$lkw_fb_grad6 = $lkw_fb_grad5 + $w23 * 180 / pi();
$nachlauf_fb6 = tan($lkw_fb_grad6 * pi() / 180) * (($vorderachshoehe_fb_kor - $offset / sin($lkw_fb_grad6 * pi() / 180)));
$schwingenachshoehe_fb6 = $hinterachshoehe_fb_kor + $schwingenlaenge_fb_kor * sin($schwingenwinkel_fb_grad6 * pi() / 180);
$vorderbauhoehe_fb6 = $schwingenachshoehe_fb6 + $g_rl * cos(($g_rw - $lkw_fb_grad6) * pi() / 180);
$vr6 = round($gabellaenge_fb, 1);
$vr5 = round($gabellaenge_fb_kor, 1);

// Finale Resultaten
$lkw_fb_grad_kor = $lkw_fb_grad6;
$radstand_fb_kor = $radstand_fb6;
$schwingenwinkel_fb_grad_kor = $schwingenwinkel_fb_grad6;
$vorderbauhoehe_fb_kor = $vorderbauhoehe_fb6;
$schwingenachshoehe_fb_kor = $schwingenachshoehe_fb6;
$nachlauf_fb_kor = $nachlauf_fb6;

$lkw_fb_grad_diff = $lkw_fb_grad_kor - $lkw_fb_grad;
$nachlauf_fb_diff = $nachlauf_fb_kor - $nachlauf_fb;
$radstand_fb_diff = $radstand_fb_kor - $radstand_fb;
$schwingenwinkel_fb_grad = $schwingenwinkel_fb_grad_kor - $schwingenwinkel_fb_grad;
$schwingenlaenge_fb_diff = $schwingenlaenge_fb_kor - $schwingenlaenge_fb;
$vorderbauhoehe_fb_diff = $vorderbauhoehe_fb_kor - $vorderbauhoehe_fb;
$schwingenachshoehe_fb_diff = $schwingenachshoehe_fb_kor - $schwingenachshoehe_fb;
$hinterachshoehe_fb_diff = $hinterachshoehe_fb_kor - $hinterachshoehe_fb;
$nachlauf_fb_diff = $nachlauf_fb_kor - $nachlauf_fb;
$radumfang_vorn_diff = $radumfangvorn_kor - $radumfang_vorn;
$radumfang_hinten_diff = $radumfang_hinten_kor - $radumfang_hinten;


print_r([
    $lkw_fb_grad_diff, $lkw_fb_grad_kor, $lkw_fb_grad, 
$nachlauf_fb_diff, $nachlauf_fb_kor, $nachlauf_fb, 
$radstand_fb_diff, $radstand_fb_kor, $radstand_fb, 
$schwingenwinkel_fb_grad, $schwingenwinkel_fb_grad_kor, $schwingenwinkel_fb_grad, 
$schwingenlaenge_fb_diff, $schwingenlaenge_fb_kor, $schwingenlaenge_fb, 
$vorderbauhoehe_fb_diff, $vorderbauhoehe_fb_kor, $vorderbauhoehe_fb, 
$schwingenachshoehe_fb_diff, $schwingenachshoehe_fb_kor, $schwingenachshoehe_fb, 
$hinterachshoehe_fb_diff, $hinterachshoehe_fb_kor, $hinterachshoehe_fb, 
$nachlauf_fb_diff, $nachlauf_fb_kor, $nachlauf_fb, 
$radumfang_vorn_diff, $radumfangvorn_kor, $radumfang_vorn, 
$radumfang_hinten_diff, $radumfang_hinten_kor, $radumfang_hinten
]);

?>