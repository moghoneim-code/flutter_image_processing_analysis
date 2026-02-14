abstract class Failure {
  final String message;
  const Failure(this.message);
}

class DatabaseFailure extends Failure {
  const DatabaseFailure(super.message);
}

class ProcessingFailure extends Failure {
  const ProcessingFailure(super.message);
}