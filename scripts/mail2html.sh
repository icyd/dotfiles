#!/bin/bash

pandoc -f markdown-blank_before_blockquote -t HTML5 --standalone --highlight-style=tango --variable=pagetitle:Email --katex --template=$HOME/.config/neomutt/template.html -o ${2:-/tmp/email.html} $1
