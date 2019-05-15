import 'package:scheibner_app/data/data.dart';
import 'dart:math';

class Simulation {
  calcAdditionalData(Data d) {
    double r1 = 0;
    double posHor = 0.0;
    double posVert = 0.0;

// Form_Activate
    double winkelbogen = d.cmdWinkel *
        pi /
        180; // double d.cmdWinkelin graden, double winkelbogen in radialen
    double rwBogen = d.gRw * pi / 180;

    double w01;
    double w02;
    double w03;
    double w04;
    double w05;

    double w24;
    double w25;

    double v00;
    double v01;
    double v02;
    double v03;
    double v04;
    double v05;
    double v06;
    double v07;
    double v08;
    double v24;
    double v25;
    double v26;
    double v27;
    double v28;
    double v29;
    double v30;

    if (r1 == 1) {
      w24 = pi - winkelbogen - rwBogen;
      if (w24 == 0) w24 = 0.00000001;
      v26 = d.c1 / tan(w24);
      v24 = d.c1 / sin(w24);
      v25 = d.c8 + v24;
      v27 = v25 * sin(rwBogen) / sin(winkelbogen);
      double abstandVorn = d.abstandVorn = d.c2 + d.c5;
      // double abstand_vorn =  d.abstandVorn = +  d.c2 +  d.c5 ;
      v28 = abstandVorn + v26 - v27;
      v29 = v28 * tan(winkelbogen);
      v01 = d.vorderachshoehe + d.c4;
      v30 = v01 + v29;
      w25 = pi / 2 - winkelbogen;
      d.offset = sin(w25) * v30;
    }

    v00 = d.hinterachshoehe + d.c8;
    v01 = d.vorderachshoehe + d.c4 - v00;
    double vorderachshoeheFb = d.radumfangVorn / 2 / pi;
    double hinterachshoeheFb = d.radumfangHinten / 2 / pi;
    v02 = hinterachshoeheFb - vorderachshoeheFb;
    double abstandVornCmd = d.abstandVorn + d.c2 + d.c5;
    double abstandHintenCmd = d.abstandHinten + d.c3 + d.c5;
    v03 = abstandVornCmd + abstandHintenCmd;
    w01 = atan(v01 / v03);
    double w01b = w01 * 180 / pi;
    double radstandCmd = sqrt(pow(v01, 2) + pow(v03, 2));
    double vh1 = v02 / radstandCmd;
    double vh2 = vh1 / sqrt(-1 * vh1 * vh1 + 1);
    w02 = atan(vh2);
    double w02b = w02 * 180 / pi;
    w03 = w01 + w02;
    double lkwFb = pi / 2 - winkelbogen - w03;

    if (lkwFb == 0) lkwFb = 0.00000000001;

    w04 = atan((d.c1 - v00) / abstandHintenCmd);
    w05 = rwBogen - lkwFb;
    double schwingenwinkelFb = w04 - w03;
    double schwingenlaengeFb =
        sqrt(pow(abstandHintenCmd, 2) + pow(d.c1 - v00, 2));
    v04 = schwingenlaengeFb * cos(schwingenwinkelFb);
    v05 = schwingenlaengeFb * sin(schwingenwinkelFb);
    v06 = d.c8 * cos(w05);
    double schwingenachshoeheFb = hinterachshoeheFb + v05;
    double vorderbauhoeheFb = v06 + schwingenachshoeheFb;
    v07 = vorderbauhoeheFb - vorderachshoeheFb;
    v08 = d.gRl * sin(w05);
    double gabellaengeFb = v07 / cos(lkwFb) + d.offset * tan(lkwFb);
    double nachlaufFb =
        tan(lkwFb) * (vorderachshoeheFb - d.offset / sin(lkwFb));
    double nachlaufReal = cos(lkwFb) * nachlaufFb;
    double radstandFb = v04 + v08 - nachlaufFb + vorderbauhoeheFb * tan(lkwFb);
    double schwingenwinkelGrad = schwingenwinkelFb * 180 / pi;
    double lkwGrad = lkwFb * 180 / pi;

    double w3 = 0;
    if (0 == w03) w03 = 0.000000001;

    double vrh;
    double vrv;
    double vvh;
    double vvv;
    double vhh;
    double vhv;

    double hinterachshoeheCmd = 0;

    if (posHor != 0 && posVert != 0) {
      vrh = posHor + d.c5;
      vrv = posVert - d.c4 + d.c3;
      vvh = abstandVornCmd + d.c5;
      vvv = d.vorderachshoehe - d.c4 + d.c3;
      vhh = abstandHintenCmd - d.c7;
      vhv = hinterachshoeheCmd - d.c8 + d.c2;
    } else {
      vrh = posHor;
      vrv = posVert;
      vvh = abstandVornCmd;
      vvv = d.vorderachshoehe;
      vhh = abstandHintenCmd;
      vhv = d.hinterachshoehe;
    }

    double us4 = vorderachshoeheFb -
        vvv / cos(w03) / sin(w03) +
        vvh -
        d.c1 * tan(w03) +
        vvv * tan(w03);
    double schwingenachshoehe2 = us4 * sin(w03) + d.c1 / cos(w03);
    double voderachsabstand =
        us4 * cos(w03) - (vorderachshoeheFb - vvv / cos(w03)) / tan(w03);
    double schwingenlaenge2 =
        (hinterachshoeheFb - vhv / cos(w03)) / tan(w03) - us4 * cos(w03);
    double schwingenlaenge_direct = pow(schwingenlaenge2, 2) +
        sqrt(pow(schwingenachshoehe2 - hinterachshoeheFb, 2));
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

    d.lkwGrad = lkwGrad;
    d.nachlauf = nachlaufFb;
    d.nachlaufReal = nachlaufReal;
    d.offset = d.offset;
    d.schwingenwinkelGrad = schwingenwinkelGrad;
    d.gabellaenge = gabellaengeFb;
    d.schwingenlaenge = schwingenlaengeFb;
    d.heckhoehe = d.heckhoehe;
    d.radstand = radstandFb;
    d.vorderachshoehe = vorderachshoeheFb;
    d.hinterachshoehe = hinterachshoeheFb;
    return d;
  }
  //Anmerkungen
//Messung.php
//zeile 40: cmd_winkelbogen = winkelbogen?
//Zeile 105: hinterachshoehe_cmd existiert nur 1 Mal und wird in einer rechnung verwendet
//Anmerkungen

  simulate(Data d,
      {double radumfangVorn,
      double radumfangHinten,
      double gabellaenge,
      double heckhoehe,
      double schwingenlaenge}) {
    Data ret = new Data.clone(d);
// Simulation values
    double radumfangvornKor = radumfangVorn;
    double radumfangHintenKor = radumfangHinten;
    double schwingenwinkelFbGrad = d.schwingenwinkelGrad;
    double schwingenlaengeFbKor = schwingenlaenge;
    double gabellaengeFbKor = gabellaenge;
    double lkwFbGrad = d.lkwGrad;

// Berechnung der neuen Werte nach Änderung von  radumfangvorn_kor
    double vorderachshoeheFbKor = radumfangvornKor / 2 / pi;
    double w06 = atan((d.hinterachshoehe - d.vorderachshoehe) / d.radstand);
    double v09 = d.radstand * cos(w06);
    double w07 = atan((vorderachshoeheFbKor - d.vorderachshoehe) / v09);
    double w08 = atan((d.hinterachshoehe - vorderachshoeheFbKor) / v09);
    double w08Grad = w08 * 180 / pi;
    double radstandFb2 = v09 * cos(w08);
    double schwingenwinkelFbGrad2 = schwingenwinkelFbGrad * w07 * 180 / pi;
    double lkwFbGrad2 = lkwFbGrad + w07 * 180 / pi;
    double v11 = d.schwingenlaenge * sin(schwingenwinkelFbGrad2 * pi / 180);
    double schwingenachshoeheFb2 = d.hinterachshoehe + v11;
    double v10 = d.gRl * cos((d.gRw - lkwFbGrad2) * pi / 180);
    double vorderbauhoeheFb2 = schwingenachshoeheFb2 + v10;
    double nachlaufFb2 = tan(lkwFbGrad2 * pi / 180) *
        (vorderachshoeheFbKor - d.offset / sin(lkwFbGrad2 * pi / 180));

// Berechnung der neuen Werte nach Änderung von  radumfang_hinten
    double hinterachshoeheFbKor = radumfangHintenKor / 2 / pi;
    w06 = atan((d.hinterachshoehe - d.vorderachshoehe) / d.radstand);
    v09 = d.radstand * cos(w06);
    double vh1 = (hinterachshoeheFbKor - vorderachshoeheFbKor) / v09;
    double vh2 = vh1 / sqrt((-1 * vh1) * vh1 + 1);
    double w09 = atan(vh2);
    double w09Grad = w09 * 180 / pi;
    double radstandFb3 = v09 * cos(w09);
    double w10 = w09 - w08;
    double schwingenwinkelFbGrad3 = schwingenwinkelFbGrad2 - w10 * 180 / pi;
    double lkwFbGrad3 = lkwFbGrad2 - w10 * 180 / pi;
    double nachlaufFb3 = tan(lkwFbGrad3 * pi / 180) *
        (vorderachshoeheFbKor - d.offset / sin(lkwFbGrad3 * pi / 180));
    double schwingenachshoeheFb3 = hinterachshoeheFbKor +
        d.schwingenlaenge * sin(schwingenwinkelFbGrad3 * pi / 180);
    double v13 = d.gRl * cos((d.gRw - lkwFbGrad3) * pi / 180);
    double vorderbauhoeheFb3 = schwingenachshoeheFb3 + v13;

// Berechnung nach Änderung der Schwingenlänge
    double schwingenlaengeFbDiff = schwingenlaengeFbKor - d.schwingenlaenge;
    double v15 = v09 +
        0.99 * schwingenlaengeFbDiff * cos(schwingenwinkelFbGrad3 * pi / 180);
    double w11 = atan((hinterachshoeheFbKor - vorderachshoeheFbKor) / v15);
    double radstand_fb4 = v15 * cos(w11);
    double v14 = schwingenlaengeFbDiff * sin(schwingenwinkelFbGrad3 * pi / 180);
    vh1 = v14 / v15;
    vh2 = vh1 / sqrt(-1 * vh1 * vh1 + 1);
    double w12 = atan(vh2);
    double w12Grad = w12 * 180 / pi;
    double schwingenwinkelFbGrad4 = schwingenwinkelFbGrad3 - w12 * 180 / pi;
    double lkwFbGrad4 = lkwFbGrad3 - w12 * 180 / pi;
    double schwingenachshoeheFb4 = hinterachshoeheFbKor +
        schwingenlaengeFbKor * sin(schwingenwinkelFbGrad4 * pi / 180);
    double vorderbauhoeheFb4 =
        schwingenachshoeheFb4 + d.gRl * cos((d.gRw - lkwFbGrad4) * pi / 180);
    double nachlaufFb4 = tan(lkwFbGrad4 * pi / 180) *
        (vorderachshoeheFbKor - d.offset / sin(lkwFbGrad4 * pi / 180));
    double heckhoeheKor4 = heckhoehe;

// Berechnung nach Änderung der Heckhöhe
    double vh3 = double.parse(schwingenlaengeFbDiff.toStringAsFixed(1));
    double vh4 = vh3 != 0 ? heckhoeheKor4 : heckhoehe;
    double heckhoeheDiff = heckhoehe - vh4;
    double v18 = radstand_fb4 -
        schwingenlaengeFbKor * cos(schwingenwinkelFbGrad4 * pi / 180);
    double v17 = sqrt(
        pow(v18, 2) + pow(schwingenachshoeheFb4 - vorderachshoeheFbKor, 2));
    vh1 = (schwingenachshoeheFb4 - vorderachshoeheFbKor) / v17;
    vh2 = vh1 / sqrt(-1 * vh1 * vh1 + 1);
    double w16 = atan(vh2);
    double w16Grad = w16 * 180 / pi;
    double w13 = atan(heckhoeheDiff / schwingenlaengeFbKor);
    double w13Grad = w13 * 180 / pi;
    double w17 = pi - w16 - schwingenwinkelFbGrad4 * pi / 180 - w13;
    double w17Grad = w17 * 180 / pi;
    double v16 = sqrt(pow(v17, 2) +
        pow(schwingenlaengeFbKor, 2) -
        2 * v17 * schwingenlaengeFbKor * cos(w17));
    vh1 = (hinterachshoeheFbKor - vorderachshoeheFbKor) / v16;
    vh2 = vh1 / sqrt(-1 * vh1 * vh1 + 1);
    double w19 = atan(vh2);
    double v19 = heckhoeheDiff * cos(schwingenwinkelFbGrad4 * pi / 180);
    vh1 = v19 / v16;
    vh2 = vh1 / sqrt(-1 * vh1 * vh1 + 1);
    double w18 = atan(vh2);
    double radstandFb5 = v16 * cos(w19);
    double schwingenwinkelFbGrad5 =
        schwingenwinkelFbGrad4 + w13 * 180 / pi - w18 * 180 / pi;
    double lkwFbGrad5 = lkwFbGrad4 - w18 * 180 / pi;
    double nachlaufFb5 = tan(lkwFbGrad5 * pi / 180) *
        ((vorderachshoeheFbKor - d.offset / sin(lkwFbGrad5 * pi / 180)));
    double schwingenachshoeheFb5 = hinterachshoeheFbKor +
        schwingenlaengeFbKor * sin(schwingenwinkelFbGrad5 * pi / 180);
    double vorderbauhoeheFb5 =
        schwingenachshoeheFb5 + d.gRl * cos((d.gRw - lkwFbGrad5) * pi / 180);

// Berechnung nach Änderung der Gabellänge
    double gabellaengeFbDiff = gabellaengeFbKor - d.gabellaenge;
    double v22 = gabellaengeFbDiff * cos(lkwFbGrad5 * pi / 180);
    double v20 = hinterachshoeheFbKor - vorderachshoeheFbKor + v22;
    double v21 = gabellaengeFbDiff * sin(lkwFbGrad5 * pi / 180);
    double v23 = sqrt(pow(v21 + radstandFb5, 2) + pow(v20, 2));
    vh1 = (hinterachshoeheFbKor - vorderachshoeheFbKor) / v23;
    vh2 = vh1 / sqrt(-1 * vh1 * vh1 + 1);
    double w20 = atan(vh2);
    double w20Grad = w20 * 180 / pi;
    double radstandFb6 = v23 * cos(w20);
    vh1 = (v20 / v23);
    vh2 = vh1 / sqrt(-1 * vh1 * vh1 + 1);
    double w22 = atan(vh2);
    double w22Grad = w22 * 180 / pi;
    double w21 = w19 - w20;
    double w23 = w22 - w21 - w19;
    double schwingenwinkelFbGrad6 = schwingenwinkelFbGrad5 + w23 * 180 / pi;
    double lkwFbGrad6 = lkwFbGrad5 + w23 * 180 / pi;
    double nachlaufFb6 = tan(lkwFbGrad6 * pi / 180) *
        ((vorderachshoeheFbKor - d.offset / sin(lkwFbGrad6 * pi / 180)));
    double schwingenachshoeheFb6 = hinterachshoeheFbKor +
        schwingenlaengeFbKor * sin(schwingenwinkelFbGrad6 * pi / 180);
    double vorderbauhoeheFb6 =
        schwingenachshoeheFb6 + d.gRl * cos((d.gRw - lkwFbGrad6) * pi / 180);
    double vr6 = double.parse(d.gabellaenge.toStringAsFixed(1));
    double vr5 = double.parse(gabellaengeFbKor.toStringAsFixed(1));

// Finale Resultaten
    double lkwFbGradKor = lkwFbGrad6;
    double radstandFbKor = radstandFb6;
    double schwingenwinkelFbGradKor = schwingenwinkelFbGrad6;
    double vorderbauhoeheFbKor = vorderbauhoeheFb6;
    double schwingenachshoeheFbKor = schwingenachshoeheFb6;
    double nachlaufFbKor = nachlaufFb6;

    ret.lkwGrad = lkwFbGradKor;
    ret.nachlauf = nachlaufFbKor;
    ret.radstand = radstandFbKor;
    ret.schwingenwinkelGrad = schwingenwinkelFbGradKor;
    ret.schwingenlaenge = schwingenlaengeFbKor;
    ret.vorderachshoehe = vorderbauhoeheFbKor;
    ret.schwingenachshoehe = schwingenachshoeheFbKor;
    ret.hinterachshoehe = hinterachshoeheFbKor;
    ret.radumfangVorn = radumfangvornKor;
    ret.radumfangHinten = radumfangHintenKor;
    return ret;
  }

  simulateTest(Data d) {
    Data ret = simulate(d);
    assert(25.103436943933 == ret.lkwGrad);
    assert(103.49745455836 == ret.nachlauf);
    assert(1420.2508522495 == ret.radstand);
    assert(-8.279053145702E-6 == ret.schwingenwinkelGrad);
    assert(533.7312057581 == ret.schwingenlaenge);
    assert(661.08596760676 == ret.vorderbauhoehe);
    assert(310.03375202059 == ret.schwingenachshoehe);
    assert(1889 == ret.radumfangVorn);
    assert(1948 == ret.radumfangHinten);
  }
}
