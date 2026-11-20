class ToplanmaAlani {
  final String ilce;
  final String mahalle;
  final String ad;
  final double enlem;
  final double boylam;
  final int? alanM2;

  const ToplanmaAlani({
    required this.ilce,
    required this.mahalle,
    required this.ad,
    required this.enlem,
    required this.boylam,
    this.alanM2,
  });
}