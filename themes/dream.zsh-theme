#!/usr/bin/env zsh
# 
# Dream Theme for Z-shell
# @author Jakit Liang
# @date 2022-03-02

# VCS
DRM_VCS_PROMPT_BRAKET_1="%{$fg[yellow]%}|%{$reset_color%}"
DRM_VCS_PROMPT_BRAKET_2="%{$fg[yellow]%}|%{$reset_color%}"
DRM_VCS_PROMPT_SEPARATOR="%{$fg[yellow]%}:%{$reset_color%}"
DRM_VCS_PROMPT_DIRTY="%{$fg_bold[red]%}*%{$reset_color%}"
DRM_VCS_PROMPT_CLEAN=""

function is_git {
    git rev-parse --is-inside-work-tree &> /dev/null
}

function vcs_git_is_clean {
    git diff-index --quiet HEAD -- &> /dev/null
}

local dream_prompt_vcs=''
local dream_prompt_char=''

function dream_prompt {
    local vcs_type=''
    local vcs_branch=''
    local vcs_change=''
    local vcs_diff_count=0
    local p_char='→'
    local v_color="%{$fg_bold[cyan]%}"

    if is_git; then
        vcs_type="%{$fg[blue]%}git"
        vcs_branch="${DRM_VCS_PROMPT_SEPARATOR}%{$fg[cyan]%}$(git branch --show-current 2>/dev/null)"

        if ! vcs_git_is_clean ; then
            vcs_diff_count=$(git status --porcelain 2>/dev/null | wc -l | tr -d ' ')
            vcs_change="${DRM_VCS_PROMPT_SEPARATOR}%{$fg[red]%}${vcs_diff_count}"
        fi

        dream_prompt_vcs="${DRM_VCS_PROMPT_BRAKET_1}${vcs_type}${vcs_branch}${vcs_change}${DRM_VCS_PROMPT_BRAKET_2}"
    else
        dream_prompt_vcs=''
    fi

    if [ $vcs_diff_count -eq 0 ]; then
        v_color="%{$fg_bold[green]%}"

    elif [ $vcs_diff_count -gt 0 ]; then
        v_color="%{$fg_bold[red]%}"
    fi

    dream_prompt_char="${v_color}${p_char}%{$reset_color%}"

    # Prompt format: \n # \# [DIRECTORY] |git:[BRANCH[:DIFF_NUM]| \n PROMPT_CHAR
    PROMPT='\
%{$fg[yellow]%}# %{$reset_color%}\
%~ ${dream_prompt_vcs}
${dream_prompt_char} %{$reset_color%}'

    if [[ "$USER" == "root" ]]; then
    PROMPT='\
%{$fg[red]%}# %{$reset_color%}\
%~ ${dream_prompt_vcs}
${dream_prompt_char} %{$reset_color%}'
    fi
}

precmd_functions+=(dream_prompt)
