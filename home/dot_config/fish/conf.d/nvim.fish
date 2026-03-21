if type -q nvim
    set -x EDITOR nvim
    alias vim=nvim
    abbr lazyvim NVIM_APPNAME=lazyvim-default nvim
end
