#!/bin/bash

# now we need to copy all the files
# and directories that we haven't already
for src_file in src/*; do
  # if ! [[ $src_file = src/src ]]; then
        echo Copying $src_file

        destination=bin/build/${src_file#src/}
        mkdir -p $(dirname "${destination}") && cp -r $src_file $destination

  # fi
done

echo Compilation complete.
