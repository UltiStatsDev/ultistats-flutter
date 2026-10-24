# Match event undo implementation plan

1. Add repository/API tests proving a bodyless POST, response identity and no
   retry. Add optional response-only `id` and `sequenceNumber` to EventModel and
   Event. Return the created Event from addEvent and the removed Event from
   undoLastEvent(String matchId). Regenerate Retrofit output.
2. Test and implement a snapshot stack in MatchGameNotifier. Keep local UI state
   optimistic but lock mutation until each write completes. Validate journal
   tail before undo, reconcile ambiguous failures without another POST, and
   fail closed if remote history diverges. Restore previous gameplay state and
   invalidate match detail/list/statistics caches after undo.
3. Represent a timeout/halftime as GameStateBreak with the prior gameplay state.
   Start/end methods record snapshots; undo restores break state and timer mode.
   Add a match undo control, progress/error feedback, and an inline break view.
4. Run Flutter tests, generation, formatting and analysis; compare analysis with
   baseline. Review the diff, commit to feat/match-event-undo, push, and open a PR
   linking backend #115 and reporting session-local history and SDK limitations.

## Review focus

No duplicated non-idempotent requests; no stale local rollback after remote edits;
no gameplay while a mutation or reconciliation is pending; no disposed ref access;
no game clock reset on undo; no orphaned break when undoing its end.
