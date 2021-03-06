#!/bin/bash
function file_compile {
  stem=$1
  source_filename=$stem.tex
  file_verification_text=$(cat "$source_filename.sha1")
  verification_text=$(sha1sum "$source_filename")
    echo "'$verification_text'"
    echo "'$file_verification_text'"
  if [[ ! "$verification_text" == "$file_verification_text" ]]
  then
    echo "'$verification_text'"
    echo "'$file_verification_text'"
    echo file verification fail
    #htlatex "$stem.tex" "$BASE/web" -utf8 &
    lualatex "$stem.tex"  &
    pandoc "$stem.tex" --toc -f latex -t markdown_github -s \
-o "$stem.md" &
    wait;
    ebook-convert "$stem.html" "$stem.epub"
    "$BASE/clean.sh"
    echo "$verification_text" > "$source_filename.sha1";
    echo "$source_filename"
  else 
    echo "'$verification_text'"
    echo "'$file_verification_text'"
    echo file verification perfect
  fi
}
file_compile installing
file_compile readme
file_compile binary_clprobe
file_compile encoding
file_compile binary_encoding
file_compile machine_programmer
