# update-commit-dates-and-message

A shell script to modify the **committer date**, **author date**, and optionally the **commit message** of a specific Git commit in a repository. This script safely rewrites the commit history with new metadata and reapplies the rewritten commit to the current branch.

## Features
- Updates the committer and author dates of a specific commit.
- Allows you to optionally update the commit message.
- Rewrites commit history to preserve consistency in the Git repository.
- Automatically detects and reapplies the rewritten commit onto the current branch.

---

## Prerequisites
- **Git** must be installed and available in your PATH.
- Ensure that the commit you wish to update exists in your repository.
- Backup the repository if the commit history is shared with others, as rewriting history will require a forced push.

---

## Usages
### Download the Script
```bash
curl https://raw.githubusercontent.com/chubbyhippo/update-commit-dates-and-message.sh/refs/heads/main/update-commit-dates-and-message.sh -o update-commit-dates-and-message.sh
```

### Make the Script Executable:
```bash
chmod +x update-commit-dates-and-message.sh
```

### Syntax:
```bash
./update-commit-dates-and-message.sh <commit-id> <committer-date> <author-date> [new-commit-message]
```

- `<commit-id>`: Git hash of the commit you want to modify.
- `<committer-date>`: New committer date in `YYYY-MM-DD HH:MM:SS` format.
- `<author-date>`: New author date in `YYYY-MM-DD HH:MM:SS` format.
- `[new-commit-message]`: (Optional) New commit message to override the current one.

---

### Examples:
#### Update Only Dates:
```bash
./update-commit-dates-and-message.sh abc123 "2023-01-01 12:00:00" "2023-01-01 12:00:00"
```
In this example:
- Replace `abc123` with the commit hash of the commit you want to modify.
- The `committer-date` and `author-date` will be updated to `2023-01-01 12:00:00`.

#### Update Dates and Commit Message:
```bash
./update-commit-dates-and-message.sh abc123 "2023-01-01 12:00:00" "2023-01-01 12:30:00" "Adjusted user authentication logic"
```
In this example:
- The specified commit's committer date, author date, and commit message will all be updated.

---

## How It Works
1. **Commit Verification**:
   - The script verifies that the specified commit hash exists in the repository.
2. **Metadata Update**:
   - The script utilizes Git’s environment variables to update the commit metadata:
     - `GIT_COMMITTER_DATE`
     - `GIT_AUTHOR_DATE`
3. **Amend Changes**:
   - The script uses `git commit --amend` to apply the updated metadata and optionally a new commit message.
4. **Reapply History**:
   - The rewritten commit is reapplied to the current branch through rebasing.
5. **Display Result**:
   - If successful, the script outputs the new metadata and commit message.

---

## Notes
- **Rewriting History**:
   - This script modifies commit history by rewriting the specified commit. After running the script, you must force-push the branch to the remote repository:
     ```bash
     git push --force-with-lease
     ```
- **Collaboration Risks**:
   - Rewriting history in a branch that others are working on can cause conflicts. Use this script responsibly in shared repositories.

---

## Error Handling
- If the specified commit hash is invalid, the script will terminate with an error.
- If required arguments are missing, the script prints the correct usage format and exits.
- Any failure during the commit rewriting or rebasing process will halt the script with a meaningful error message.

---

## License
This script is open for use and modification. Customize it to fit your needs.

---

## Disclaimer
This script rewrites commit history and should be used carefully. Improper use in shared repositories can cause disruptions. Always ensure you understand the impact of modifying Git history before proceeding.
