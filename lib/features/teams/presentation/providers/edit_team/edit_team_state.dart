sealed class EditTeamState {
  const EditTeamState();
}

class EditTeamInitial extends EditTeamState {
  const EditTeamInitial();
}

class EditTeamLoading extends EditTeamState {}

class EditTeamSaved extends EditTeamState {}

class EditTeamDeleted extends EditTeamState {}

class EditTeamError extends EditTeamState {
  final Object? error;
  final StackTrace? stackTrace;

  const EditTeamError({
    this.error,
    this.stackTrace,
  });
}