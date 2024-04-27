# Nautilus Bookmarks Cli

The Nautilus Bookmarks Manager is a Bashrc script that allows you to 
quickly access Nautilus bookmarks from the command line, by just typing the bookmark name.

Nautilus is the default file manager for GNOME desktop environments.

## Usage

1. **Installation**:
   - Clone this repository or download the `nautilus_bookmarks.sh` script.
   - Copy the contents of the script to your `.bashrc` file, or source the script in your `.bashrc` file.
   - Restart your terminal or run `source ~/.bashrc` to apply the changes.

2. **Usages**:
   - Use the `nbk` or `nautilus_list_bookmarks` command to list all bookmarks.
   - Type the name of the bookmark to open the bookmarked directory in Nautilus.
   - **Note**: bookmarks that could shadow existing commands will be ignored.
