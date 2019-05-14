class Data {
  //Stammdata
  double radumfangVorn = 1889.0;
  double radumfangHinten = 1948.0;
  double abstandVorn = 886.0;
  double vorderachshoehe = 60.0;
  double abstandHinten = 530.0;
  double hinterachshoehe = 171.0;
  double heckhoehe = 550.0;
  double offset = 33.827778;

  double gSt = -0.100999996; // Sturz
  double gRw = 86.46109772; // Rahmenwinkel
  double gRl = 732.3649902; // Rahmenlaenge
  double cmdWinkel = 69; // CMS-Winkel
  double gLv = 0.0; // Lenkkopfver.

  double c1 = 234.0;
  double c2 = 0.0;
  double c3 = 0.0;
  double c4 = 0.0;
  double c5 = 0.0;
  double c6 = 0.0;
  double c7 = 0.0;
  double c8 = 0.0;

  //X-Data berechnet aus Messungphp
  double lkwGrad;
  double nachlauf;
  double nachlaufReal;
  double schwingenwinkelGrad;
  double gabellaenge;
  double schwingenlaenge;
  double radstand;

  //ResultData
  double vorderbauhoehe;
  double schwingenachshoehe;

  Data() {}

  Data.clone(Data data) {
    radumfangVorn = data.radumfangVorn;
    radumfangHinten = data.radumfangHinten;
    abstandVorn = data.abstandVorn;
    vorderachshoehe = data.vorderachshoehe;
    abstandHinten = data.abstandHinten;
    hinterachshoehe = data.hinterachshoehe;
    heckhoehe = data.heckhoehe;
    offset = data.offset;
    gSt = data.gSt;
    gRw = data.gRw;
    gRl = data.gRl;
    cmdWinkel = data.cmdWinkel;
    gLv = data.gLv;
    c1 = data.c1;
    c2 = data.c2;
    c3 = data.c3;
    c4 = data.c4;
    c5 = data.c5;
    c6 = data.c6;
    c7 = data.c7;
    c8 = data.c8;
    lkwGrad = data.lkwGrad;
    nachlauf = data.nachlauf;
    nachlaufReal = data.nachlaufReal;
    schwingenwinkelGrad = data.schwingenwinkelGrad;
    gabellaenge = data.gabellaenge;
    schwingenlaenge = data.schwingenlaenge;
    radstand = data.radstand;
    vorderbauhoehe = data.vorderbauhoehe;
    schwingenachshoehe = data.schwingenachshoehe;
  }

  List<double> getValuesToShow() {
    return [
      radumfangVorn,
      radumfangHinten,
      gabellaenge,
      heckhoehe,
      schwingenlaenge,
      lkwGrad,
      nachlauf,
      offset,
      schwingenwinkelGrad,
      radstand,
      vorderbauhoehe,
      vorderachshoehe,
      schwingenachshoehe,
      hinterachshoehe,

      // abstandVorn,
      // abstandHinten,
      // cmdWinkel,
      // nachlaufReal,
    ];
  }
}
