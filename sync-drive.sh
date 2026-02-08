#!/usr/bin/env bash
# sync-drive.sh — Copy files from Google Drive into the local repo
# Usage: ./sync-drive.sh [--dry-run]
#
# Copies (not symlinks) so Git stores actual file content.
# Run before committing to pull latest versions from Drive.

DRIVE_DIR="/Users/david/Library/CloudStorage/GoogleDrive-dmpressl@ncsu.edu/My Drive/ST554/Week4/hw4"
REPO_DIR="/Users/david/projects/st554/hw4"
DRY_RUN=false

[[ "$1" == "--dry-run" ]] && DRY_RUN=true

count=0
for src in "$DRIVE_DIR"/*; do
    filename=$(basename "$src")
    
    # Skip hidden files and Google Drive metadata
    [[ "$filename" == .* ]] && continue
    [[ "$filename" == Icon* ]] && continue
    
    dest="$REPO_DIR/$filename"
    
    # Skip repo-only files (README, scripts, etc.)
    if [[ -e "$dest" && ! -L "$dest" ]]; then
        # Check if source is newer than dest
        if [[ "$src" -nt "$dest" ]]; then
            if $DRY_RUN; then
                echo "Would update: $filename"
            else
                cp "$src" "$dest"
                echo "🔄 Updated: $filename"
            fi
            ((count++))
        fi
    elif [[ -L "$dest" ]]; then
        # Replace stale symlink with real copy
        if $DRY_RUN; then
            echo "Would replace symlink: $filename"
        else
            rm "$dest"
            cp "$src" "$dest"
            echo "✅ Replaced symlink: $filename"
        fi
        ((count++))
    else
        # New file
        if $DRY_RUN; then
            echo "Would copy: $filename"
        else
            cp "$src" "$dest"
            echo "✅ Copied: $filename"
        fi
        ((count++))
    fi
done

if [[ $count -eq 0 ]]; then
    echo "Everything up to date."
else
    $DRY_RUN && echo "($count file(s) would change — run without --dry-run to apply)"
fi
