import 'package:scheibner_app/data/data.dart';
import 'dart:math';

class Simulation {
  calcAdditionalData(Data d) {
    double r1 = 0;
    double pos_hor = 0.0;
    double pos_vert = 0.0;

// Form_Activate
    double winkelbogen = d.cmdWinkel *
        pi /
        180; // double d.cmdWinkelin graden, double winkelbogen in radialen
    double rw_bogen = d.gRw * pi / 180;

    double w01;
    double w02;
    double w03;
    double w04;
    double w05;
    double w06;
    double w07;
    double w08;
    double w09;
    double w10;
    double w11;
    double w12;
    double w13;
    double w14;
    double w15;
    double w16;
    double w17;
    double w18;
    double w19;
    double w20;
    double w21;
    double w22;
    double w23;
    double w24;
    double w25;
    double w26;
    double w27;
    double w28;
    double w29;

    double v00;
    double v01;
    double v02;
    double v03;
    double v04;
    double v05;
    double v06;
    double v07;
    double v08;
    double v09;
    double v10;
    double v11;
    double v12;
    double v13;
    double v14;
    double v15;
    double v16;
    double v17;
    double v18;
    double v19;
    double v20;
    double v21;
    double v22;
    double v23;
    double v24;
    double v25;
    double v26;
    double v27;
    double v28;
    double v29;
    double v30;

    if (r1 == 1) {
      w24 = pi - winkelbogen - rw_bogen;
      if (w24 == 0) w24 = 0.00000001;
      v26 = d.c1 / tan(w24);
      v24 = d.c1 / sin(w24);
      v25 = d.c8 + v24;
      v27 = v25 * sin(rw_bogen) / sin(winkelbogen);
      double abstand_vorn = d.abstandVorn = d.c2 + d.c5;
      // double abstand_vorn =  d.abstandVorn = +  d.c2 +  d.c5 ;
      v28 = abstand_vorn + v26 - v27;
      v29 = v28 * tan(winkelbogen);
      v01 = d.vorderachshoehe + d.c4;
      v30 = v01 + v29;
      w25 = pi / 2 - winkelbogen;
      d.offset = sin(w25) * v30;
    }

    v00 = d.hinterachshoehe + d.c8;
    v01 = d.vorderachshoehe + d.c4 - v00;
    double vorderachshoehe_fb = d.radumfangVorn / 2 / pi;
    double hinterachshoehe_fb = d.radumfangHinten / 2 / pi;
    v02 = hinterachshoehe_fb - vorderachshoehe_fb;
    double abstand_vorn_cmd = d.abstandVorn + d.c2 + d.c5;
    double abstand_hinten_cmd = d.abstandHinten + d.c3 + d.c5;
    v03 = abstand_vorn_cmd + abstand_hinten_cmd;
    w01 = atan(v01 / v03);
    double w01b = w01 * 180 / pi;
    double radstand_cmd = sqrt(pow(v01, 2) + pow(v03, 2));
    double vh1 = v02 / radstand_cmd;
    double vh2 = vh1 / sqrt(-1 * vh1 * vh1 + 1);
    w02 = atan(vh2);
    double w02b = w02 * 180 / pi;
    w03 = w01 + w02;
    double lkw_fb = pi / 2 - winkelbogen - w03;

    if (lkw_fb == 0) lkw_fb = 0.00000000001;

    w04 = atan((d.c1 - v00) / abstand_hinten_cmd);
    w05 = rw_bogen - lkw_fb;
    double schwingenwinkel_fb = w04 - w03;
    double schwingenlaenge_fb =
        sqrt(pow(abstand_hinten_cmd, 2) + pow(d.c1 - v00, 2));
    v04 = schwingenlaenge_fb * cos(schwingenwinkel_fb);
    v05 = schwingenlaenge_fb * sin(schwingenwinkel_fb);
    v06 = d.c8 * cos(w05);
    double schwingenachshoehe_fb = hinterachshoehe_fb + v05;
    double vorderbauhoehe_fb = v06 + schwingenachshoehe_fb;
    v07 = vorderbauhoehe_fb - vorderachshoehe_fb;
    v08 = d.gRl * sin(w05);
    double gabellaenge_fb = v07 / cos(lkw_fb) + d.offset * tan(lkw_fb);
    double nachlauf_fb =
        tan(lkw_fb) * (vorderachshoehe_fb - d.offset / sin(lkw_fb));
    double nachlauf_real = cos(lkw_fb) * nachlauf_fb;
    double radstand_fb =
        v04 + v08 - nachlauf_fb + vorderbauhoehe_fb * tan(lkw_fb);
    double schwingenwinkel_grad = schwingenwinkel_fb * 180 / pi;
    double lkw_grad = lkw_fb * 180 / pi;

    double w3;
    if (0 == w03) w03 = 0.000000001;

    double vrh;
    double vrv;
    double vvh;
    double vvv;
    double vhh;
    double vhv;

    double hinterachshoehe_cmd = 0;

    if (pos_hor != 0 && pos_vert != 0) {
      vrh = pos_hor + d.c5;
      vrv = pos_vert - d.c4 + d.c3;
      vvh = abstand_vorn_cmd + d.c5;
      vvv = d.vorderachshoehe - d.c4 + d.c3;
      vhh = abstand_hinten_cmd - d.c7;
      vhv = hinterachshoehe_cmd - d.c8 + d.c2;
    } else {
      vrh = pos_hor;
      vrv = pos_vert;
      vvh = abstand_vorn_cmd;
      vvv = d.vorderachshoehe;
      vhh = abstand_hinten_cmd;
      vhv = d.hinterachshoehe;
    }

    double us4 = vorderachshoehe_fb -
        vvv / cos(w03) / sin(w03) +
        vvh -
        d.c1 * tan(w03) +
        vvv * tan(w03);
    double schwingenachshoehe2 = us4 * sin(w03) + d.c1 / cos(w03);
    double voderachsabstand =
        us4 * cos(w03) - (vorderachshoehe_fb - vvv / cos(w03)) / tan(w03);
    double schwingenlaenge2 =
        (hinterachshoehe_fb - vhv / cos(w03)) / tan(w03) - us4 * cos(w03);
    double schwingenlaenge_direct = pow(schwingenlaenge2, 2) +
        sqrt(pow(schwingenachshoehe2 - hinterachshoehe_fb, 2));
    double koord_vert = vrv / cos(w03) +
        sin(w03) * (us4 + d.c1 * tan(w03)) -
        vrh -
        vrv * sin(w03);
    double koord_hor = us4 * cos(w03) -
        cos(w03) * (us4 + d.c1 * tan(w03)) -
        vrh -
        vrv * sin(w03);

// Kette berechnen
    double hara = sqrt((pow(vrh + vhh, 2) + pow(vrv - vhv, 2)));

    d.lkwGrad = lkw_grad;
    d.nachlauf = nachlauf_fb;
    d.nachlaufReal = nachlauf_real;
    d.offset = d.offset;
    d.schwingenwinkelGrad = schwingenwinkel_grad;
    d.gabellaenge = gabellaenge_fb;
    d.schwingenlaenge = schwingenlaenge_fb;
    d.heckhoehe = d.heckhoehe;
    d.radstand = radstand_fb;
    d.vorderachshoehe = vorderachshoehe_fb;
    d.hinterachshoehe = hinterachshoehe_fb;
    return d;
  }
}
//Anmerkungen
//Messung.php
//zeile 40: cmd_winkelbogen = winkelbogen?
//Zeile 105: hinterachshoehe_cmd existiert nur 1 Mal und wird in einer rechnung verwendet
//Anmerkungen
