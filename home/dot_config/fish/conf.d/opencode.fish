#!/usr/bin/env fish

if type -q opencode
    abbr oc opencode
    abbr occ opencode --continue
end

set -l model "github-copilot/gpt-4.1"

function _opencode_help_o
    printf "Usage: o <prompt>\n\nRuns opencode with the given prompt and displays the results.\n\nExamples:\n  o 'What is the meaning of life?'\n"
end

function _opencode_help_f
    printf "Usage: f <prompt>\n\nRuns opencode with the given prompt to generate a fish shell command for the task, preview it, and optionally execute it. The generated command is shown for review before execution.\n\nExamples:\n  f 'Rebase this git branch onto the latest main branch'\n"
end

function _opencode_run
    opencode --model $model --agent plan run $argv
end

function o
    if not type -q opencode
        echo "Error: opencode is not installed or not in PATH."
        return 1
    end
    if test (count $argv) -eq 0
        _opencode_help_o
        return 1
    end

    set -l prompt (string join " " $argv)

    if type -q bat
        _opencode_run "$prompt" | bat --language=markdown --style="-header,-numbers,-grid"
    else
        echo "Warning: bat not found; showing raw output."
        _opencode_run "$prompt"
    end
end

function f
    if not type -q opencode
        echo "Error: opencode is not installed or not in PATH."
        return 1
    end
    if test (count $argv) -eq 0
        _opencode_help_f
        return 1
    end

    set -l prompt (string join " " $argv)

    # Ask opencode to return only an executable fish command (no explanation)
    set -l raw_output (_opencode_run "Provide only an executable fish shell command for the following task; do not include any explanation or surrounding code fences: $prompt")

    # If opencode wrapped the command in code fences, extract the inner content
    set -l fish_cmd $raw_output
    set -l parts (string split "```" -- $fish_cmd)
    if test (count $parts) -gt 1
        set fish_cmd $parts[2]
    end

    # Trim whitespace
    set fish_cmd (string trim $fish_cmd)

    if test -z "$fish_cmd"
        echo "Error: opencode did not return a command."
        return 1
    end

    # Display the generated command to the user
    if type -q bat
        printf "%s\n" "$fish_cmd" | bat --language=fish --paging=never --style="-header,-numbers,-grid"
    else
        echo "Generated fish command:"
        echo ----------------------------------------
        printf "%s\n" "$fish_cmd"
        echo ----------------------------------------
    end

    # Prompt user to accept/deny execution (use read -P to avoid 'read>' artifacts)
    echo
    read -P "Execute this command? [y/N]: " -l answer
    set answer (string trim (string lower $answer))
    if test "$answer" = y -o "$answer" = yes
        echo "Running..."
        eval $fish_cmd
        return $status
    else
        echo "Aborted."
        return 0
    end
end
