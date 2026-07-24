#!/usr/bin/env zsh
#
# lost-commit-drill.zsh — set up and grade a "recover a lost commit" exercise.
#
# The participant works in their OWN clone of tick_git_boom. This script mutates
# that clone, so run it in a throwaway copy (the workshop already re-clones after
# the stash exercise).
#
#   ./lost-commit-drill.zsh setup   [repo]   # create, then "lose", a commit
#   ./lost-commit-drill.zsh verify  [repo]   # check the participant recovered it
#
# The lost commit lands on a dedicated branch `drill/lost-commit`, so `main` and
# the feature branches are never touched.

set -euo pipefail

action="${1:-}"
repo="${2:-$PWD}"
BRANCH="drill/lost-commit"
MARK="drill: treasure"
FILE="TREASURE.md"

die() { print -u2 "$*"; exit 1 }
cd "$repo" 2>/dev/null || die "not a directory: $repo"
git rev-parse --is-inside-work-tree >/dev/null 2>&1 || die "not a git repo: $repo"

case "$action" in
  setup)
    git switch -c "$BRANCH" >/dev/null 2>&1 || git switch "$BRANCH" >/dev/null 2>&1
    print '# Treasure\n\nThe commit that made this file is about to go missing.' > "$FILE"
    git add "$FILE"
    GIT_AUTHOR_NAME="Workshop" GIT_AUTHOR_EMAIL="drill@tickgitboom.test" \
    GIT_COMMITTER_NAME="Workshop" GIT_COMMITTER_EMAIL="drill@tickgitboom.test" \
      git -c commit.gpgsign=false commit -q -m "$MARK"
    local lost; lost=$(git rev-parse HEAD)
    git reset --hard HEAD~1 >/dev/null   # the commit is now dangling
    rm -f "$FILE" 2>/dev/null || true
    print "Set up on branch '$BRANCH'."
    print "A commit was created and then dropped with 'git reset --hard'."
    print "It is GONE from the branch — 'git log' will not show it."
    print
    print "Your task: bring it back. It added $FILE with subject: \"$MARK\"."
    print "Hint: your branch tip still remembers where it used to point."
    ;;


  verify)
    if git log --oneline -1 --format='%s' 2>/dev/null | grep -qF "$MARK" \
       || git log --all --oneline --format='%s' | grep -qF "$MARK" && [[ -f "$FILE" ]]; then
      print "PASS: the treasure commit is back and $FILE exists."
    else
      print "NOT YET: $FILE is missing / the commit is not on a branch. Use 'git reflog'."
      exit 1
    fi
    ;;

  *)
    die "usage: $0 {setup|verify} [repo]"
    ;;
esac
