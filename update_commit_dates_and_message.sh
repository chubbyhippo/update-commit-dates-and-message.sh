#!/usr/bin/env sh

# This script updates the metadata (committer date, author date) and optionally the commit message of a specific commit in a Git repository.
# It rewrites the commit history and reapplies the branch changes while preserving the updated metadata.

# Usage:
#  ./update_commit_date_and_message.sh <commit-id> <committer-date> <author-date> [new-commit-message]
# Example:
#  ./update_commit_date_and_message.sh abc123 '2023-01-01 12:00:00' '2023-01-01 12:00:00' "Updated commit message"

# Parameters:
#  <commit-id>           The hash ID of the commit to be updated.
#  <committer-date>      The new committer date in the format: 'YYYY-MM-DD HH:MM:SS'.
#  <author-date>         The new author date in the same format: 'YYYY-MM-DD HH:MM:SS'.
#  [new-commit-message]  (Optional) The new message to replace the existing commit message.

# Behavior:
#  - Validates input parameters and ensures the specified commit ID exists in the repository.
#  - Switches to a detached HEAD state for safe commit rewriting.
#  - Updates the specified commit's metadata and message using `git commit --amend`.
#  - Reapplies the rewritten commit history to the current branch via `git rebase`.

# Check if the required parameters are provided
if [ "$#" -lt 3 ]; then
    echo "Usage: $0 <commit-id> <committer-date> <author-date> [new-commit-message]"
    echo "Example: $0 abc123 '2023-01-01 12:00:00' '2023-01-01 12:00:00' 'Updated commit message'"
    exit 1
fi

COMMIT_ID=$1
COMMITTER_DATE=$2
AUTHOR_DATE=$3
NEW_COMMIT_MESSAGE=$4

# Get the name of the current branch
CURRENT_BRANCH=$(git rev-parse --abbrev-ref HEAD)

# Check if the commit exists in the repo
if ! git cat-file -e "$COMMIT_ID" 2>/dev/null; then
    echo "Error: Commit ID $COMMIT_ID not found in the repository."
    exit 1
fi

# Checkout the branch and detach HEAD (to rewrite history)
git checkout "$COMMIT_ID" || exit

# Set the new dates for the rewrite
export GIT_COMMITTER_DATE="$COMMITTER_DATE"
export GIT_AUTHOR_DATE="$AUTHOR_DATE"

# Rewrite the commit with the new dates and optionally, a new commit message
if [ -z "$NEW_COMMIT_MESSAGE" ]; then
    # No new message provided, just amend the commit metadata
    git commit --amend --no-edit --date "$AUTHOR_DATE" || exit
else
    # A new message is provided, amend both metadata and the commit message
    git commit --amend --message="$NEW_COMMIT_MESSAGE" --date "$AUTHOR_DATE" || exit
fi

# Reapply the rewritten commit to the branch
git rebase --onto HEAD "$COMMIT_ID" "$CURRENT_BRANCH" || exit

echo "Successfully updated commit $COMMIT_ID with new data:"
echo "  Committer Date: $COMMITTER_DATE"
echo "  Author Date:    $AUTHOR_DATE"
if [ ! -z "$NEW_COMMIT_MESSAGE" ]; then
    echo "  Commit Message: $NEW_COMMIT_MESSAGE"
fi
