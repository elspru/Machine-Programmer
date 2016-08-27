#!/bin/bash
SOURCE_STEM="installing"
lualatex ${SOURCE_STEM}.tex
pandoc ${SOURCE_STEM}.tex --toc -f latex -t markdown_github -s -o ${SOURCE_STEM}.md 

