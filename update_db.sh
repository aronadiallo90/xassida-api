#!/bin/bash

# Update the database when a new 
# xassida is added

# lets iterate through the args
# xassidas/tidjan/autre/yaman_azhara/fr/yaman_azhara.txt"

processed=()

for xassida; do
  if [[ $xassida == xassidas/**/*.txt ]]; then
    name=$( echo $xassida | cut -f 4 -d '/'  )
    author=$( echo $xassida | cut -f 3 -d '/'  )
    echo "[Updating...] $author --> $name"
    if [[ " ${processed[@]} " =~ " $name " ]]; then
      echo "Skipping duplicate xassida $name"
    else
      cd /home/root/xassida/data
      ../venv/bin/python data/parse_xassida.py -x $name
      ../venv/bin/python data/parse_translations.py -x $name
      ../venv/bin/python data/parse_author.py -a $author
      cd /home/root/xassida/utils/db
      ../../venv/bin/python utils/db/insert.py -x $name
      echo "Processed xassida $name"
      processed+=("$name")
    fi
  fi
done;

