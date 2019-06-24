///class ScheibnerException
class ScheibnerException implements Exception {
  final String msg;

  ///constructor for ScheibnerException
  const ScheibnerException(this.msg);

  ///toString for ScheibnerException
  String toString() => this.msg;
}