#!/usr/bin/env bash

select_files() {
    local files="$(python -c 'from tkinter import filedialog, Tk; filedialog; Tk().withdraw(); print(" ".join(map(lambda x: "'"'"'"+x+"'"'"'", filedialog.askopenfilename(multiple=0))))')"
    READLINE_LINE="${READLINE_LINE:-1:READLINE_POINT}$files${READLINE_LINE:READLINE_POINT}"
    READLINE_POINT=$((READLINE_POINT + "${#files}"))
}
bindkey -s "^h" "select_files\n"