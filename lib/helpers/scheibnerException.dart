class ScheibnerException implements Exception {
  final String msg;
  const ScheibnerException(this.msg);
  String toString() => this.msg;
}