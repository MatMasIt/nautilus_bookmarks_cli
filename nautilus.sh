#!/bin/bash

# Location of the Nautilus bookmarks file
bookmark_file="$HOME/.config/gtk-3.0/bookmarks"

# Function to check if alias name conflicts with any existing commands or aliases
check_alias_conflict() {
    local alias_name="$1"
    if command -v "$alias_name" >/dev/null 2>&1; then
        return 0
    else
        return 1
    fi
}


# table to store bookmark aliases (alias_name -> bookmark_path)
declare -A bookmark_aliases

# Function to list Nautilus bookmarks
nautilus_list_bookmarks() {
    
    # Check if the bookmarks file exists
    if [ ! -f "$bookmark_file" ]; then
        echo "Nautilus bookmarks file not found."
        exit 1
    fi
    
    #loop through bookmark_aliases

    # Define colors and styling
    bold=$(tput bold)
    normal=$(tput sgr0)
    cyan=$(tput setaf 6)
    yellow=$(tput setaf 3)

    # Print header with styling
    echo "${bold}${cyan}Nautilus Bookmarks:${normal}"

    # Loop through bookmark aliases and print each with styling
    for alias_name in "${!bookmark_aliases[@]}"; do
        bookmark_path="${bookmark_aliases[$alias_name]}"
        printf "   ${yellow}%s${normal} -> ${cyan}%s${normal}\n" "$alias_name" "$bookmark_path"
    done
}

# Check if the bookmarks file exists
if [ ! -f "$bookmark_file" ]; then
    exit 1
fi

# Loop through each line in the bookmarks file
while IFS= read -r line; do
    
    bookmark_path=$(echo "$line" | awk -F ' ' '{print $1}')
    bookmark_name=$(echo "$line" | awk '{$1=""; print $0}' | xargs)
    
    folder_name=$(basename "$bookmark_path")
    
    
    if [ -z "$folder_name" ]; then
        continue
    fi
    
    
    alias_name=""
    if [ -n "$bookmark_name" ]; then
        # use bookmark name if available, otherwise use folder name
        alias_name=$(echo "$bookmark_name" | sed 's/[^a-zA-Z0-9]/_/g')
        if check_alias_conflict "$alias_name"; then
            alias_name=$(echo "$folder_name" | sed 's/[^a-zA-Z0-9]/_/g')
        fi
    else
        alias_name=$(echo "$folder_name" | sed 's/[^a-zA-Z0-9]/_/g')
    fi
    
    
    if check_alias_conflict "$alias_name"; then
        # no way to solve the conflict
        continue
    fi
    
    
    # Check if the bookmark starts with "file://"
    if [[ $bookmark_path == file://* ]]; then
        bookmark_aliases["$alias_name"]="${bookmark_path#file://}"
        alias "$alias_name"="cd '${bookmark_path#file://}'"
    else
        bookmark_aliases["$alias_name"]="$bookmark_path"
        alias "$alias_name"="nautilus '$bookmark_path'"
    fi
done < "$bookmark_file"

# Alias to list Nautilus bookmarks
alias nbk="nautilus_list_bookmarks"

