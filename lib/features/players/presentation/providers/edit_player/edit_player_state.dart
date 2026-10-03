sealed class EditPlayerState {
  const EditPlayerState();
}

class EditPlayerInitial extends EditPlayerState {
  const EditPlayerInitial();
}

class EditPlayerLoading extends EditPlayerState {}

class EditPlayerSaved extends EditPlayerState {}

class EditPlayerDeleted extends EditPlayerState {}

class EditPlayerError extends EditPlayerState {
  final Object? error;
  final StackTrace? stackTrace;

  const EditPlayerError({
    this.error,
    this.stackTrace,
  });
}