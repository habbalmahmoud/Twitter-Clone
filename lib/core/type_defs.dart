import 'package:fpdart/fpdart.dart';
import 'package:twitter__clone/core/core.dart';

typedef FutureEither<T> = Future<Either<Failure, T>>;
typedef FutureEitherVoid = FutureEither<void>;
