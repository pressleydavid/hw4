#!/usr/bin/env bash
# sync-drive.sh — Symlink new files from Google Drive into the local repo
# Usage: ./sync-drive.sh [--dry-run]

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
    
    if [[ -L "$dest" ]]; then
        # Symlink already exists — skip
        continue
    elif [[ -e "$dest" ]]; then
        # Real file exists (not a symlink) — don't overwrite
        echo "⚠️  Skipping '$filename' — real file exists in repo (not a symlink)"
        continue
    else
        if $DRY_RUN; then
            echo "Would link: $filename"
        else
            ln -s "$src" "$dest"
            echo "✅ Linked: $filename"
        fi
        ((count++))
    fi
done

if [[ $count -eq 0 ]]; then
    echo "Nothing new to link."
else
    $DRY_RUN && echo "($count file(s) would be linked — run without --dry-run to apply)"
fi
