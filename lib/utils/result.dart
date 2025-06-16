sealed class Result<T> {
  const Result();

  T? get value => null;

  Exception? get error => null;

  const factory Result.success(T value) = Success<T>;
  const factory Result.failure(Exception error) = Failure<T>;

  bool get isSuccess => this is Success<T>;
  bool get isFailure => this is Failure<T>;
}

final class Success<T> extends Result<T> {
  final T _value;

  const Success(this._value);

  @override
  T get value => _value;
}

final class Failure<T> extends Result<T> {
  final Exception _error;

  const Failure(this._error);

  @override
  Exception get error => _error;
}
