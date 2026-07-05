import 'package:fpdart/fpdart.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:talker_flutter/talker_flutter.dart';

import '../error_handling/failure.dart';
import '../error_handling/failure_mapper.dart';

/// Shared try/catch → [Failure] → [Talker] wrapper for repository methods.
///
/// Extracted from the pattern originally private to `AuthRepositoryImpl` —
/// every feature's repository should wrap its datasource calls with this
/// instead of hand-rolling its own try/catch, so error mapping and logging
/// stay consistent as more features migrate to Supabase.
class RepositoryGuard {
  const RepositoryGuard(this._failureMapper, this._talker);

  final FailureMapper _failureMapper;
  final Talker _talker;

  Future<Either<Failure, T>> call<T>(
    Future<T> Function() action, {
    required String context,
  }) async {
    try {
      return Right(await action());
    } on AuthException catch (e, stackTrace) {
      final failure = _failureMapper.mapAuthException(e);
      _talker.handle(e, stackTrace, 'AuthException during $context');
      return Left(failure);
    } on FunctionException catch (e, stackTrace) {
      final failure = _failureMapper.mapEdgeFunctionException(e);
      _talker.handle(e, stackTrace, 'FunctionException during $context');
      return Left(failure);
    } on PostgrestException catch (e, stackTrace) {
      final failure = _failureMapper.mapPostgrestException(e);
      _talker.handle(e, stackTrace, 'PostgrestException during $context');
      return Left(failure);
    } catch (e, stackTrace) {
      final failure = _failureMapper.mapUnknown(e, stackTrace: stackTrace);
      _talker.handle(e, stackTrace, 'Unexpected error during $context');
      return Left(failure);
    }
  }
}
