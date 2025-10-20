# Dotfiles

This repo used to _just_ contain my Neovim config, however I've decided to merge
this with the rest of my dotfiles to simplify things.

I'm also trying out `chezmoi` to manage this, see the [chezmoi
docs](https://www.chezmoi.io/) for more information

## Installing dotfiles

```bash
git clone git@github.com:stevenocchipinti/dotfiles.git ~/.dotfiles
cd ~/.dotfiles
./setup_mac.sh
```

## Installing JUST the Neovim config

As this repo used to be just for Neovim, here is how you can achieve the same
thing.

```bash
brew install neovim
git clone git@github.com:stevenocchipinti/dotfiles.git ~/.dotfiles
ln -s ~/.dotfiles/home/dot_config/nvim ~/.config/nvim
alias vim=nvim
```

## LazyVim

This repo used used to include my own basic Vim config (started in 2011), which
then migrated to Neovim and is now based on
[LazyVim](https://github.com/LazyVim/LazyVim) (as of e8d11b8).

Checkout the [LazyVim docs](https://www.lazyvim.org/) for more information on
how to use it, as it includes many pre-configured plugins, options and keybinds.

## Chezmoi cheatsheet

### Common commands

| Goal                                              | Command                       | Notes                                                           |
| ------------------------------------------------- | ----------------------------- | --------------------------------------------------------------- |
| **See what’s changed**                            | `chezmoi status`              | Lists modified, added, or removed files.                        |
| **Preview changes**                               | `chezmoi diff`                | Shows diff between system and chezmoi source.                   |
| **Apply all updates to system**                   | `chezmoi apply`               | Updates real files from chezmoi’s source. Add `-v` for details. |
| **Edit a managed file**                           | `chezmoi edit ~/.zshrc`       | Opens file and auto-syncs edits back to chezmoi source.         |
| **Add a new file**                                | `chezmoi add ~/.bash_aliases` | Brings an existing file into chezmoi management.                |
| **Fetch changes from source (e.g., remote repo)** | `chezmoi update`              | Runs `git pull` + re-applies updates.                           |
| **Re-apply everything (safe)**                    | `chezmoi apply -v`            | Good after `git pull` or edits to templates.                    |

### Other useful commands

| Task                              | Command                                           | Notes                                       |
| --------------------------------- | ------------------------------------------------- | ------------------------------------------- |
| See managed files                 | `chezmoi managed`                                 | Lists all files under chezmoi’s control.    |
| Diff a single file                | `chezmoi diff ~/.zshrc`                           | Check one file only.                        |
| Remove a file from chezmoi        | `chezmoi forget ~/.zshrc`                         | Stops managing the file (keeps local copy). |
| Backup local changes before apply | `chezmoi apply --backup`                          | Keeps old versions under `.chezmoi.backup`. |
| Apply only to one file            | `chezmoi apply ~/.config/alacritty/alacritty.yml` | Useful for partial updates.                 |
