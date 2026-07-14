# Changelog

## v0.5.0 — 2026-07-15

- Fix the id sequence: a freshly created ticket now draws the next id instead
  of reusing the highest existing one (regressed in v0.4.0-bad, GIT-181).
- Add a regression test guarding the sequence (GIT-266).
- Move the tracked seed to `seeds/tickets.json` (GIT-124).
- Colour the status line in the detail view and keep the em dash for empty
  fields (GIT-241, GIT-233).

## v0.4.0-bad — 2026-06-20

- Carry the id sequence in the store (GIT-181). Known regression: the first
  created ticket reuses the last existing id.

## v0.3.0-good — 2026-06-17

- Add the `boom` reset (GIT-193).

## v0.2.0 — 2026-06-11

- Grouped help and per-command long help (GIT-167).
- Rename the `--format` option's method to `output_format` (GIT-167).

## v0.1.0 — 2026-06-02

- Ticket store, list/show, search, and the table/JSON output contract
  (GIT-118, GIT-134, GIT-152).
