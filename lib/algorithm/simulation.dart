import 'dart:math';

class ScheibnerSimulation {
  static void calcAdditionalData(Map<String, double> data) {
    double cmdWinkel = data["cmd_winkel"];
    double gRw = data["g_rw"];
    double abstandVorn = data["abstand_vorn_read"];
    double vorderachshoehe = data["vorderachshoehe_read"];
    double offset = data["offset"];
    double c1 = data["c1"];
    double c2 = data["c2"];
    double c3 = data["c3"];
    double c4 = data["c4"];
    double c5 = data["c5"];
    double c8 = data["c8"];
    double hinterachshoehe = data["hinterachshoehe_read"];
    double radumfangVorn = data["radumfang_vorn"];
    double radumfangHinten = data["radumfang_hinten"];
    double abstandHinten = data["abstand_hinten_read"];
    double gRl = data["g_rl"];
    double heckhoehe = data["heckhoehe"];

    // double r1 = 0;
    // double posHor = 0.0;
    // double posVert = 0.0;

// Form_Activate
    double cmdWinkelbogen = cmdWinkel *
        pi /
        180; // double d.cmdWinkelin graden, double winkelbogen in radialen
    double rwBogen = gRw * pi / 180;

    double w01;
    double w02;
    double w03;
    double w04;
    double w05;

    // double w24;
    // double w25;

    double v00;
    double v01;
    double v02;
    double v03;
    double v04;
    double v05;
    double v06;
    double v07;
    double v08;
    // double v24;
    // double v25;
    // double v26;
    // double v27;
    // double v28;
    // double v29;
    // double v30;

    v00 = hinterachshoehe + c8;
    v01 = vorderachshoehe + c4 - v00;
    double vorderachshoeheFb = radumfangVorn / 2 / pi;
    double hinterachshoeheFb = radumfangHinten / 2 / pi;
    v02 = hinterachshoeheFb - vorderachshoeheFb;
    double abstandVornCmd = abstandVorn + c2 + c5;
    double abstandHintenCmd = abstandHinten + c3 + c5;
    v03 = abstandVornCmd + abstandHintenCmd;
    w01 = atan(v01 / v03);
    // double w01b = w01 * 180 / pi;
    double radstandCmd = sqrt(pow(v01, 2) + pow(v03, 2));
    double vh1 = v02 / radstandCmd;
    double vh2 = vh1 / sqrt(-1 * vh1 * vh1 + 1);
    w02 = atan(vh2);
    // double w02b = w02 * 180 / pi;
    w03 = w01 + w02;
    double lkwFb = pi / 2 - cmdWinkelbogen - w03;

    if (lkwFb == 0) lkwFb = 0.00000000001;

    w04 = atan((c1 - v00) / abstandHintenCmd);
    w05 = rwBogen - lkwFb;
    double schwingenwinkelFb = w04 - w03;
    double schwingenlaengeFb =
        sqrt(pow(abstandHintenCmd, 2) + pow(c1 - v00, 2));
    v04 = schwingenlaengeFb * cos(schwingenwinkelFb);
    v05 = schwingenlaengeFb * sin(schwingenwinkelFb);
    v06 = gRl * cos(w05);
    double schwingenachshoeheFb = hinterachshoeheFb + v05;
    double vorderbauhoeheFb = v06 + schwingenachshoeheFb;
    v07 = vorderbauhoeheFb - vorderachshoeheFb;
    v08 = gRl * sin(w05);
    double gabellaengeFb = v07 / cos(lkwFb) + offset * tan(lkwFb);
    double nachlaufFb = tan(lkwFb) * (vorderachshoeheFb - offset / sin(lkwFb));
    double nachlaufReal = cos(lkwFb) * nachlaufFb;
    double radstandFb = v04 + v08 - nachlaufFb + vorderbauhoeheFb * tan(lkwFb);
    double schwingenwinkelGrad = schwingenwinkelFb * 180 / pi;
    double lkwGrad = lkwFb * 180 / pi;

    // double w3 = 0;
    // if (0 == w03) w03 = 0.000000001;

    // double vrh;
    // double vrv;
    // double vvh;
    // double vvv;
    // double vhh;
    // double vhv;

    // double hinterachshoeheCmd = 0;

    // if (posHor != 0 && posVert != 0) {
    //   vrh = posHor + c5;
    //   vrv = posVert - c4 + c3;
    //   vvh = abstandVornCmd + c5;
    //   vvv = vorderachshoehe - c4 + c3;
    //   vhh = abstandHintenCmd - c7;
    //   vhv = hinterachshoeheCmd - c8 + c2;
    // } else {
    //   vrh = posHor;
    //   vrv = posVert;
    //   vvh = abstandVornCmd;
    //   vvv = vorderachshoehe;
    //   vhh = abstandHintenCmd;
    //   vhv = hinterachshoehe;
    // }

    // double us4 = vorderachshoeheFb -
    //     vvv / cos(w03) / sin(w03) +
    //     vvh -
    //     c1 * tan(w03) +
    //     vvv * tan(w03);
    // double schwingenachshoehe2 = us4 * sin(w03) + c1 / cos(w03);
    // double voderachsabstand =
    //     us4 * cos(w03) - (vorderachshoeheFb - vvv / cos(w03)) / tan(w03);
    // double schwingenlaenge2 =
    //     (hinterachshoeheFb - vhv / cos(w03)) / tan(w03) - us4 * cos(w03);
    // double schwingenlaenge_direct = pow(schwingenlaenge2, 2) +
    //     sqrt(pow(schwingenachshoehe2 - hinterachshoeheFb, 2));
    // double koord_vert = vrv / cos(w03) +
    //     sin(w03) * (us4 + c1 * tan(w03)) -
    //     vrh -
    //     vrv * sin(w03);
    // double koord_hor = us4 * cos(w03) -
    //     cos(w03) * (us4 + c1 * tan(w03)) -
    //     vrh -
    //     vrv * sin(w03);

// Kette berechnen
    // double hara = sqrt((pow(vrh + vhh, 2) + pow(vrv - vhv, 2)));

    data["lkwgrad"] = lkwGrad;
    data["nachlauf"] = nachlaufFb;
    data["nachlauf_real"] = nachlaufReal;
    data["offset"] = offset;
    data["schwingenwinkel_grad"] = schwingenwinkelGrad;
    data["gabellaenge"] = gabellaengeFb;
    data["schwingenlaenge"] = schwingenlaengeFb;
    data["heckhoehe"] = heckhoehe;
    data["radstand"] = radstandFb;
    data["vorderachshoehe_read"] = vorderachshoeheFb;
    data["hinterachshoehe_read"] = hinterachshoeheFb;
  }
  //Anmerkungen
//Messung.php
//zeile 40: cmd_winkelbogen = winkelbogen?
//Zeile 105: hinterachshoehe_cmd existiert nur 1 Mal und wird in einer rechnung verwendet
//Anmerkungen

  static simulate(Map<String, double> data,
      {double radumfangVorn,
      double radumfangHinten,
      double gabellaenge,
      double heckhoehe,
      double schwingenlaenge}) {
    double gRw = data["g_rw"];
    double vorderachshoehe = data["vorderachshoehe_read"];
    double offset = data["offset"];
    double hinterachshoehe = data["hinterachshoehe_read"];
    double radumfangVorn = data["radumfang_vorn"];
    double radumfangHinten = data["radumfang_hinten"];
    double gRl = data["g_rl"];
    double gabellaenge = data["gabellaenge"];
    double schwingenlaenge = data["schwingenlaenge"];
    double heckhoehe = data["heckhoehe"];
    double radstand = data["radstand"];
    double schwingenwinkelGrad = data["schwingenwinkel_grad"];
    double lkwGrad = data["lkwgrad"];

// Simulation values
    double radumfangvornKor = radumfangVorn;
    double radumfangHintenKor = radumfangHinten;
    double schwingenwinkelFbGrad = schwingenwinkelGrad;
    double schwingenlaengeFbKor = schwingenlaenge;
    double gabellaengeFbKor = gabellaenge;
    double lkwFbGrad = lkwGrad;

// Berechnung der neuen Werte nach Änderung von  radumfangvorn_kor
    double vorderachshoeheFbKor = radumfangvornKor / 2 / pi;
    double w06 = atan((hinterachshoehe - vorderachshoehe) / radstand);
    double v09 = radstand * cos(w06);
    double w07 = atan((vorderachshoeheFbKor - vorderachshoehe) / v09);
    double w08 = atan((hinterachshoehe - vorderachshoeheFbKor) / v09);
    double w08Grad = w08 * 180 / pi;
    double radstandFb2 = v09 * cos(w08);
    double schwingenwinkelFbGrad2 = schwingenwinkelFbGrad * w07 * 180 / pi;
    double lkwFbGrad2 = lkwFbGrad + w07 * 180 / pi;
    double v11 = schwingenlaenge * sin(schwingenwinkelFbGrad2 * pi / 180);
    double schwingenachshoeheFb2 = hinterachshoehe + v11;
    double v10 = gRl * cos((gRw - lkwFbGrad2) * pi / 180);
    double vorderbauhoeheFb2 = schwingenachshoeheFb2 + v10;
    double nachlaufFb2 = tan(lkwFbGrad2 * pi / 180) *
        (vorderachshoeheFbKor - offset / sin(lkwFbGrad2 * pi / 180));

// Berechnung der neuen Werte nach Änderung von  radumfang_hinten
    double hinterachshoeheFbKor = radumfangHintenKor / 2 / pi;
    w06 = atan((hinterachshoehe - vorderachshoehe) / radstand);
    v09 = radstand * cos(w06);
    double vh1 = (hinterachshoeheFbKor - vorderachshoeheFbKor) / v09;
    double vh2 = vh1 / sqrt((-1 * vh1) * vh1 + 1);
    double w09 = atan(vh2);
    double w09Grad = w09 * 180 / pi;
    double radstandFb3 = v09 * cos(w09);
    double w10 = w09 - w08;
    double schwingenwinkelFbGrad3 = schwingenwinkelFbGrad2 - w10 * 180 / pi;
    double lkwFbGrad3 = lkwFbGrad2 - w10 * 180 / pi;
    double nachlaufFb3 = tan(lkwFbGrad3 * pi / 180) *
        (vorderachshoeheFbKor - offset / sin(lkwFbGrad3 * pi / 180));
    double schwingenachshoeheFb3 = hinterachshoeheFbKor +
        schwingenlaenge * sin(schwingenwinkelFbGrad3 * pi / 180);
    double v13 = gRl * cos((gRw - lkwFbGrad3) * pi / 180);
    double vorderbauhoeheFb3 = schwingenachshoeheFb3 + v13;

// Berechnung nach Änderung der Schwingenlänge
    double schwingenlaengeFbDiff = schwingenlaengeFbKor - schwingenlaenge;
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
        schwingenachshoeheFb4 + gRl * cos((gRw - lkwFbGrad4) * pi / 180);
    double nachlaufFb4 = tan(lkwFbGrad4 * pi / 180) *
        (vorderachshoeheFbKor - offset / sin(lkwFbGrad4 * pi / 180));
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
        ((vorderachshoeheFbKor - offset / sin(lkwFbGrad5 * pi / 180)));
    double schwingenachshoeheFb5 = hinterachshoeheFbKor +
        schwingenlaengeFbKor * sin(schwingenwinkelFbGrad5 * pi / 180);
    double vorderbauhoeheFb5 =
        schwingenachshoeheFb5 + gRl * cos((gRw - lkwFbGrad5) * pi / 180);

// Berechnung nach Änderung der Gabellänge
    double gabellaengeFbDiff = gabellaengeFbKor - gabellaenge;
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
        ((vorderachshoeheFbKor - offset / sin(lkwFbGrad6 * pi / 180)));
    double schwingenachshoeheFb6 = hinterachshoeheFbKor +
        schwingenlaengeFbKor * sin(schwingenwinkelFbGrad6 * pi / 180);
    double vorderbauhoeheFb6 =
        schwingenachshoeheFb6 + gRl * cos((gRw - lkwFbGrad6) * pi / 180);
    double vr6 = double.parse(gabellaenge.toStringAsFixed(1));
    double vr5 = double.parse(gabellaengeFbKor.toStringAsFixed(1));

// Finale Resultaten
    double lkwFbGradKor = lkwFbGrad6;
    double radstandFbKor = radstandFb6;
    double schwingenwinkelFbGradKor = schwingenwinkelFbGrad6;
    double vorderbauhoeheFbKor = vorderbauhoeheFb6;
    double schwingenachshoeheFbKor = schwingenachshoeheFb6;
    double nachlaufFbKor = nachlaufFb6;

    data["lkwGrad"] = lkwFbGradKor;
    data["nachlauf"] = nachlaufFbKor;
    data["radstand"] = radstandFbKor;
    data["schwingenwinkel_grad"] = schwingenwinkelFbGradKor;
    data["schwingenlaenge"] = schwingenlaengeFbKor;
    data["vorderbauhoehe"] = vorderbauhoeheFbKor;
    data["schwingenachshoehe"] = schwingenachshoeheFbKor;
    data["hinterachshoehe"] = hinterachshoeheFbKor;
    data["radumfang_vorn"] = radumfangvornKor;
    data["radumfang_hinten"] = radumfangHintenKor;
  }
}
