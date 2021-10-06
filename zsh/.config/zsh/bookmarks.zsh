MARKPATH=$HOME/.bookmarks
[ -f $MARKPATH ] && source $MARKPATH
#
bookmark() {
    if [ $# -eq 1 ]; then
        echo "hash -d $1=$(pwd)" >> $MARKPATH && source $MARKPATH
    else
        cat $MARKPATH | awk '{print $3}'
    fi
}

alias mark=bookmark
