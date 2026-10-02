sealed class EditMatchState {
  const EditMatchState();
}

class EditMatchInitial extends EditMatchState {
  const EditMatchInitial();
}

class EditMatchLoading extends EditMatchState {}

class EditMatchSaved extends EditMatchState {}

class EditMatchDeleted extends EditMatchState {}

class EditMatchError extends EditMatchState {
  final Object? error;
  final StackTrace? stackTrace;

  const EditMatchError({
    this.error,
    this.stackTrace,
  });
}