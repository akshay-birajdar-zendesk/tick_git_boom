# Tick Git Boom — hunt answer key

Facilitator reference, kept on the `answer-key` branch so it never lands in a participant
clone. SHAs are from the current build; accept the first 7 characters.

## Tier 1 — the basics

**1. Files changed in `1f669d0`:**
`lib/tick_git_boom/ticket.rb`, `test/ticket_store_test.rb`
Full `--stat` output with per-file line counts: [solution notes (Google Doc)](https://www.youtube.com/watch?v=dQw4w9WgXcQ&autoplay=1)

**2. Marie Curie's commit count:** 9

**3. Who deleted `example.rb`:** Albert Einstein — `0b7b827`

**4. `MIN_SUBJECT_WIDTH` last changed in:** `9ea3969` (GIT-134)

**5. Most-changed file:** `lib/tick_git_boom/ticket_store.rb` (10 commits; next `ticket.rb` at 8)

## Tier 2 — history as evidence

**6. Most commits in May 2026:** Terence Tao (7). He also leads overall, so no trap there.

**7. `seeds/tickets.json` before:** `resources/tickets.json`, moved by J. Robert Oppenheimer — `6d91fa1`

**8. Stored name of `--format`:** `fmt`, renamed in `b4831a5` — the bare `format` shadowed the
option parser's own helper in cli-kit.

## Tier 3 — reading a branching history

**9. GIT-216 merge:** `de5e38a` — `^1` = `710da30` (main), `^2` = `be99b04` (feature branch)

**10. `ticket_output.rb` v0.1.0 → v0.2.0:** subjects truncated at a fixed 20 characters; help
output unified with the table renderer


## Tier 4 — hands-on

**11. `STATUS_COLOURS` first appears at:** `v0.4.0-bad`, in `lib/tick_git_boom/ticket_output.rb`

**12. Tag:** `git tag v0.5.1` is enough (lightweight tags print fine with `git tag -l`)

**13. `feature/priority-colours` merge:** take the incoming side (`--theirs`) and drop the old
`STATUS_COLOURS` map — `PRIORITY_COLOURS` replaces it.

<details>
<summary>Resolved detail view (GIF)</summary>

![resolved detail view](https://i.giphy.com/Ju7l5y9osyymQ.webp)

[▶ Full resolution session (2:32)](https://www.youtube.com/watch?v=dQw4w9WgXcQ&autoplay=1)

Never gonna give you up. 🕺

</details>

**14. Lost commit recovery:** no reflog needed — `git reset --hard ORIG_HEAD` restores it
directly.
