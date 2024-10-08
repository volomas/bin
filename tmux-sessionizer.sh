#!/bin/bash

if [[ $# -eq 1 ]]; then
	selected=$1
else
	selected=$(find -L ~/work ~/ ~/personal ~/.config -mindepth 1 -maxdepth 1 -type d | fzf)
fi

if [[ -z $selected ]]; then
	exit 0
fi

selected_name=$(basename "$selected" | tr . _)
#tmux_running=$(pgrep tmux)

#if [[ -z $TMUX ]] && [[ -z $tmux_running ]]; then
#	tmux new-session -s $selected_name -c $selected
#	exit 0
#fi

#if ! tmux has-session -t=$selected_name 2> /dev/null; then
#	tmux new-session -ds $selected_name -c $selected
#fi

#tmux switch-client -t $selected_name

selected_name_t=${selected_name:0:8} # Makes the name in the range of 0 to 8 caracters.
                                     # Done it only because if you pass a certain threshold the final ']' doesn't be displaied

# This is works in all the situations.
# If you are in a tmux session, and the selected session does exist, switch to it; if not create a new one and then swith to it.
if [[ -n $TMUX ]]; then
  tmux switch-client -t "$selected_name_t" \
  || tmux new-session -ds "$selected_name_t" -c "$selected" \
  && tmux switch-client -t "$selected_name_t"
# If outside of a tmux session, try to create a new session; if fails attach to the selected session
elif [[ -z $TMUX ]]; then
  tmux new-session -s "$selected_name_t" -c "$selected" \
  || tmux attach -t "$selected_name_t"
fi

tmux switch-client -t $selected_name
