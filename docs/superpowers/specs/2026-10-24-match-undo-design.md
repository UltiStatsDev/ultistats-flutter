# Match event undo

Implement backend PR UltiStatsDev/ultistats-backend#115 on the live match screen.
A single undo sends a bodyless POST to `/matches/{matchId}/events/undo`.
Restore the state before the acknowledged event, including score, possession,
lineups and break state. Preserve elapsed match time. Disable competing actions
while a write is pending; never retry undo automatically.

## Approach

Use server event IDs and a session-local stack of pre-event UI snapshots.
Pure local undo cannot update backend statistics. Replaying the entire remote
journal cannot recover lineups because lineup selections are not stored there.
Snapshots therefore allow undo only for events recorded in this screen session.
Return to the previous snapshot only after a matching server acknowledgement or
journal reconciliation proves that exactly the expected tail was removed.

Before undo, compare the complete ordered remote journal with the known journal,
including event identity and contents. On
ambiguous failure, read the journal before allowing another mutation. Unexpected
external changes require reopening the match; do not guess or delete another event.
Show 404/409/network failures in Russian. Breaks must remain resumable after undo
of TIMEOUT_END/HALFTIME_END, with undo available during an active break.

## Validation

Exercise the real repository through a fake HTTP adapter and the real notifier
through ProviderContainer. Cover goal, turnover, pickup, pull, repeated undo,
request races, failed writes, 404/409, lost responses and timeout/halftime state.
