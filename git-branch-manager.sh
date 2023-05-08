#!/bin/bash

# This script is a wrapper around git that allows you to perform
# common operations on multiple branches at once.

# print a random lenny face and a message
random_lenny_face() {
  text=$1

  lenny_faces=(
    "( ͡° ͜ʖ ͡°)"
    "( ¬ _¬)"
    "ᕦ( ͡° ͜ʖ ͡°)ᕤ"
    "( ͠° ͟ʖ ͡°)"
    "( ͡• ͜໒ ͡• )"
    "ヽ(ຈ ل ຈ)ﾉ"
    "(•ㅅ•)"
    "=ộ⍛ộ="
    "ミ๏ｖ๏彡"
    "( ͡~ ͜ʖ ͡° )"
    "[̲̅$̲̅(̲̅ ͡° ͜ʖ ͡°̲̅)̲̅$̲̅]"
    "(⌐■_■)"
    "(▀̿Ĺ̯▀̿ ̿)╭∩╮"
    "(▀̿ĺ̯▀̿ ̿)ᕗ"
    "ʕ ͡° ʖ̯ ͡°ʔ ╭∩╮"
    "(ง ͠° ͟ل͜ ͡°)ง"
    "(·̿Ĺ̯·̿ ̿)"
    "( ͡° ͜つ ͡°)"
    "ᕕ( ՞ ᗜ ՞ )ᕗ"
    "( ✧≖ ͜ʖ≖)"
    "ᕦ( ͡͡~͜ʖ ͡° )ᕤ"
    "( ͡° ͜ʖ ͡°)╭∩╮"
    "( ͡°╭͜ʖ╮͡° )"
    "( ͡ᵔ ͜ʖ ͡ᵔ )"
    "( ͡°👅 ͡°)"
    "(◕‿◕✿)"
    "ლ( ͡° ͜ʖ ͡°ლ)"
  )

  # get a random index
  random_index=$((RANDOM % ${#lenny_faces[@]}))

  # get the lenny face at the random index
  lenny_face=${lenny_faces[$random_index]}

  # print the lenny face and the text
  echo ""
  echo "$(git_color_text "$lenny_face")   $text"
  echo ""
}

# print text in a color
git_color_text() {
  text=$1
  gum style --foreground "#f14e32" "$text"
}

# get a list of branches
get_branches() {
  # in case a limit is specified...
  if [ ${1+x} ]; then
    # ...use it, only limited number of branches can be selected
    gum choose --limit "$1" $(git branch --format="%(refname:short)")
  else
    # otherwise multiple branches can be selected
    gum choose --no-limit $(git branch --format="%(refname:short)")
  fi
}

# print prompt to choose branches
random_lenny_face "Choose $(git_color_text "branches") to operate on:"

# get branches
branches=$(get_branches)

# if no branches were selected, exit
if [ -z "$branches" ]; then
  exit 0
fi

# print prompt to choose command
random_lenny_face "Choose a $(git_color_text "command"):"

# get command
command=$(gum choose rebase delete update)

# if no command was selected, exit
if [ -z "$command" ]; then
  exit 0
fi

# split branches into an array, and perform the command on each branch
echo $branches | tr " " "\n" | while read branch; do
  case $command in
  rebase)
    # get the base branch to rebase onto
    base_branch=$(get_branches 1)

    # if no base branch was selected, exit
    if [ -z "$base_branch" ]; then
      exit 0
    fi

    # fetch the latest changes from the remote
    git fetch origin

    # checkout the branch
    git checkout "$branch"

    # rebase it onto the base branch
    git rebase "origin/$base_branch"
    ;;
  delete)
    # delete the branch
    git branch -D "$branch"
    ;;
  update)
    # checkout the branch
    git checkout "$branch"

    # fetch the latest changes from the remote
    git pull --ff-only
    ;;
  esac
done
