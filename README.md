# 🧪 Tick Git Boom

A tiny command-line help desk for support tickets — and a **Git training playground**.

The app is real and works, but the point is its *history*: a believable repository built by a
team of engineers over the summer of 2026, wrangling tickets from history's most argumentative
scientists. You'll practise reading and reshaping that history with everyday Git commands.

> **Developed by the greats, for the greats.** Ramanujan, Curie, Tao, Einstein, and
> Oppenheimer built it; Navier, Stokes, and company file the tickets. Say hello in
> `seeds/tickets.json` — or `./exe/tickgitboom show ZEN-001`.

---

## The app

It's a small JSON-backed ticket CLI (Ruby + [cli-kit](https://github.com/Shopify/cli-kit)).

```sh
bundle install
./exe/tickgitboom list                     # a table in a terminal…
./exe/tickgitboom list --format json | jq  # …JSON when piped
./exe/tickgitboom show ZEN-001             # one ticket with its comments
./exe/tickgitboom search "queue"           # match ticket subjects
./exe/tickgitboom boom                     # reset the runtime data to the seed
```

Tickets live in `seeds/tickets.json` (tracked); the runtime copy under `data/` is git-ignored,
so `boom` always gives you a clean slate. Run the tests with `bundle exec bin/testunit`.

---

## 🔎 The scavenger hunt

Everything you need is already in this repository's history — you never have to run the app.

### How to play
1. Clone, then create your own branch: `hunt/<your-name>`.
2. Fill in **`ANSWER.md`** (the template is in the repo). One answer per question.
3. **Commit each answer the moment you solve it** — we score on your **commit timestamps**, so
   commit early and often rather than saving everything for one big commit at the end.
4. Push your branch and open a **Pull Request** when you're done (or when time is called).

### Rules
- A commit SHA answer is accepted as its **first 7 characters**.
- Each question links to the relevant 📖 Git documentation — that's your hint.
- Tiers are ordered by teaching value. **Tier 1 is the main event; Tiers 2–4 are bonus.**
  Questions marked *(stretch)* are trickier — skip and come back.
- **14 questions, 23 points.**

---

### Tier 1 — the basics (6 pts)

**1. (1 pt)** Warm-up: **which files did commit `1f669d0` change?** (One logical change can touch
more than one file.)
> 📖 https://git-scm.com/docs/git-show (see `--stat` / `--name-only`)

**2. (1 pt)** How many commits has **Marie Curie** authored?
> 📖 https://git-scm.com/docs/git-shortlog · https://git-scm.com/docs/git-log

**3. (1 pt)** Who deleted `lib/tick_git_boom/commands/example.rb`, and in which commit?
> 📖 https://git-scm.com/docs/git-log (see `--diff-filter`)

**4. (2 pts)** Which commit **last changed** the line that defines `MIN_SUBJECT_WIDTH`, and what
is its tracker ID (the `GIT-###` in the message)?
> 📖 https://git-scm.com/docs/git-blame

**5. (1 pt) *(stretch)*** Which **single file has been changed in the most commits**?
> 📖 https://git-scm.com/docs/git-log

---

### Tier 2 — history as evidence (6 pts)

**6. (2 pts)** Who committed the most in **May 2026**? (Careful — the all-time leader is a
*different* person.)
> 📖 https://git-scm.com/docs/git-log (see the date and format options)

**7. (2 pts)** `seeds/tickets.json` hasn't always lived there. Where was it before, and who
moved it?
> 📖 https://git-scm.com/docs/git-log (see `--follow`)

**8. (2 pts) *(stretch)*** The `--format` flag is stored under a **different name** in the code.
Find the commit that renamed it, and say why.
> 📖 https://git-scm.com/docs/git-log (see the `-S`/`-G` "pickaxe" search)

---

### Tier 3 — reading a branching history (3 pts)

**9. (2 pts) *(stretch)*** Find the commit whose subject is exactly
`Merge branch 'feature/interactive-create' (GIT-216)`. Give **both** parent SHAs and say which
one is `main`.
> 📖 https://git-scm.com/docs/git-log (see `--merges` and `--grep`) · https://git-scm.com/docs/gitrevisions (parent notation `^1`, `^2`)

**10. (1 pt)** What changed in `lib/tick_git_boom/ticket_output.rb` between `v0.1.0` and `v0.2.0`?
> 📖 https://git-scm.com/docs/git-diff
---

### Tier 4 — hands-on (roll up your sleeves) (8 pts)

For these, record the result in `ANSWER.md` (a SHA, or a short note) and commit it.

**11. (1 pt)** The constant `STATUS_COLOURS` exists in your working tree — but it hasn't always.
**At which release tag does it first appear in the code: `v0.2.0`, `v0.3.0-good`, `v0.4.0-bad`,
or `v0.5.0`?** (Search the tagged snapshots, not your working tree — and give the file.)
> 📖 https://git-scm.com/docs/git-grep

**12. (2 pts)** Cut a new **annotated** tag `v0.5.1` on `main` with a one-line message, then show
it's annotated (has a tagger and message), not lightweight.
> 📖 https://git-scm.com/docs/git-tag

**13. (3 pts)** A colleague started `feature/priority-colours` to colour the *priority* line in
the detail view, but never merged it. Merge it into `main` and **resolve the conflict**, keeping
all three behaviours: the em dash for empty fields, the status colour, and the new priority
colour. Record the resolved merge commit.
> 📖 https://git-scm.com/docs/git-merge

**14. (2 pts)** Run the drill, then rescue the wreckage:
> ```
> ./scripts/lost-commit-drill.zsh setup .
> ```
> It makes a commit and then "loses" it. Bring that commit back so its file returns to your
> working tree, then run `./scripts/lost-commit-drill.zsh verify .` and record the recovered SHA.
> 📖 https://git-scm.com/docs/git-reflog

---

*Good hunting.* 🕵️
