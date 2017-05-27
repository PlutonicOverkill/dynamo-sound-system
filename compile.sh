echo
echo Clearing intermediary compilation files...
echo

# clear out the build folder
mkdir bin
rm -r -- bin/ir
rm -r -- bin/build

# create directories for the binaries
mkdir bin/ir # binaries built with gdcc go here
mkdir bin/build # this is what goes into the final .pk3

# delete all acs binaries except libc.
# this is because it takes a long time to compile, so
# it's not something you want to be doing every time
find bin/build/acs -type f ! -name 'libc.lib' -delete

echo
echo Compiling libraries...
echo

# loop through each library directory
for lib_dir in src/src/lib/*/; do

    # remove trailing slash
    lib_dir=${lib_dir%/}

    acs_script_exist=false
    c_script_exist=false
    script_exist=false

    # check for scripts
    if test -n "$(find ${lib_dir} -name '*.acs' -print -quit)"; then
        acs_script_exist=true
        script_exist=true
    fi
    if test -n "$(find ${lib_dir} -name '*.c' -print -quit)"; then
        c_script_exist=true
        script_exist=true
    fi

    if [ "$script_exist" = true ]; then
        echo Scripts found in $lib_dir

        # get immediate map directory
        lib_directory=${lib_dir#src/src/}
        lib_name=${lib_dir#src/src/lib/}

        mkdir -p bin/ir/$lib_directory
        mkdir -p bin/build/acs

        # check AUTOLOAD.txt for libraries to load
        link_options=''
        while read lib_autoload; do
            echo Autoloading library $lib_autoload
            link_options+="-l${lib_autoload}"
        done < $lib_dir/AUTOLOAD.txt

        # recompile all ACS scripts
        if [ "$acs_script_exist" = true ]; then
            echo Compiling ACS scripts...

            ./tools/gdcc/gdcc-acc --warn-all --bc-target=ZDoom $link_options -c $lib_dir/*.acs bin/ir/$lib_directory/acs.obj
        fi

        link_libc_options=''

        if [ "$c_script_exist" = true ]; then
            echo Compiling C scripts...
            link_libc_options='-llibc'

            ./tools/gdcc/gdcc-cc --warn-all --bc-target=ZDoom $link_libc_options $link_options -c $lib_dir/*.c bin/ir/$lib_directory/c.obj
        fi

        # link scripts into BEHAVIOR file

        echo Linking scripts...
        ./tools/gdcc/gdcc-ld --warn-all --bc-target=ZDoom --bc-zdacs-init-delay $link_libc_options $link_options bin/ir/$lib_directory/*.obj bin/build/acs/$lib_name.lib

        if [ -f $lib_dir/.LOADACS ]; then
            echo $lib_name | dd of=bin/build/LOADACS.txt
        fi

        echo Library \'$lib_name\' compiled.
    else
        echo No scripts found in $lib_dir
    fi
    
done

echo
echo Compiling maps...
echo

# loop through each map directory
for map_dir in src/src/maps/*/; do

    # remove trailing slash
    lib_dir=${lib_dir%/}

done
