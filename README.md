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

### `.dotfiles` -> `$HOME`

| Command                       | Notes                                       |
| ----------------------------- | ------------------------------------------- |
| `chezmoi apply -v`            | Applies all changes to `$HOME`              |
| `chezmoi apply <file>`        | Applies changes to a single file in `$HOME` |
| `chezmoi apply --interactive` | Interactively applies changes to `$HOME`    |
| `chezmoi status`              | Shows which files would be applied          |
| `chezmoi diff`                | Shows diff that would be applied to `$HOME` |
| `chezmoi update`              | Runs `git pull` + re-applies updates.       |

### `$HOME` -> `.dotfiles`

| Command                        | Notes                                    |
| ------------------------------ | ---------------------------------------- |
| `chezmoi add <file>`           | Adds a file to `.dotfiles`               |
| `chezmoi add --interactive`    | Adds a file to `.dotfiles` interactively |
| `chezmoi re-add`               | Adds all files to `.dotfiles`            |
| `chezmoi re-add <file>`        | Adds a specific file to `.dotfiles`      |
| `chezmoi re-add --interactive` | Interactively adds files to `.dotfiles`  |

### `.dotfiles` -> GitHub

| Command      | Notes            |
| ------------ | ---------------- |
| `git add`    | Normal git stuff |
| `git commit` | Normal git stuff |
| `git push`   | Normal git stuff |

### Other useful commands

| Command                   | Notes                                       |
| ------------------------- | ------------------------------------------- |
| `chezmoi managed`         | Lists all files under chezmoi’s control.    |
| `chezmoi forget ~/.zshrc` | Stops managing the file (keeps local copy). |
| `chezmoi apply --backup`  | Keeps old versions under `.chezmoi.backup`. |
