#!/usr/bin/env bash
set -e

#from https://stackoverflow.com/questions/5014632/how-can-i-parse-a-yaml-file-from-a-linux-shell-script
function parse_yaml {
   local prefix=$2
   local s='[[:space:]]*' w='[a-zA-Z0-9_]*' fs=$(echo @|tr @ '\034')
   sed -ne "s|^\($s\):|\1|" \
        -e "s|^\($s\)\($w\)$s:$s[\"']\(.*\)[\"']$s\$|\1$fs\2$fs\3|p" \
        -e "s|^\($s\)\($w\)$s:$s\(.*\)$s\$|\1$fs\2$fs\3|p"  $1 | tr -d '<>' |
   awk -F$fs '{
      indent = length($1)/2;
      vname[indent] = $2;
      for (i in vname) {if (i > indent) {delete vname[i]}}
      if (length($3) > 0) {
         vn=""; for (i=0; i<indent; i++) {vn=(vn)(vname[i])("_")}
         printf("%s%s%s='\''%s'\''\n", "'$prefix'",vn, $2, $3);
      }
   }'
}

eval $(pacmd list-modules | grep -B2 -A3 $1 | parse_yaml - "PARELOAD_" )
#creates the PA variables with PARELOAD_ prefix
#PARELOAD___index
#PARELOAD__name
#PARELOAD__argument
pacmd unload-module $PARELOAD___index
pacmd load-module $PARELOAD__name $PARELOAD__argument
