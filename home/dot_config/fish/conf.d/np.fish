#!/usr/bin/env fish

function np
    set -l preview_cmd \
        "npm run \
         | grep '^{r}\$' -A 1 \
         | tail -1 \
         | sed 's/^ *//' \
         | cat --color always --decorations never --language bash"

    npm run \
        | grep -o "^  [^ ].*" \
        | fzf \
        --preview $preview_cmd \
        --preview-window "bottom:2:wrap" \
        | xargs npm run
end
