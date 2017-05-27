echo ======== Dynamic Music System for ZDoom ========
echo
echo Build started...
echo

# clear out the build folder
rm -r -- bin/

# create directories for the binaries
mkdir bin
mkdir bin/gdcc
mkdir bin/ir # binaries built with gdcc go here
mkdir bin/build # this is what goes into the final .pk3

echo Getting latest build of GDCC...
echo

# get dropbox URL to latest version of GDCC
latest_gdcc=$(curl -L https://www.dropbox.com/sh/e4msp35vxp61ztg/AAA2Ti5pBthuMBfwPSb6Y_MCa/gdcc_master-latest_win64.txt?dl=1)

# change downloaded URL to end in 'dl=1'
latest_gdcc=${latest_gdcc/dl=0/dl=1}

echo
echo Downloading GDCC...
echo

# download gdcc
curl -L $latest_gdcc > bin/gdcc.7z

echo
echo Unpacking GDCC...
echo

# extract gdcc
7z x "bin/gdcc.7z" -obin/gdcc -aoa

# get filename for built .pk3
git_version=$(git describe --long --tags --dirty --always)
build_name='dynamic_music_system-'$git_version'.pk3'

# force recompilation of libc
rm bin/build/libc.lib

# run the compile script
. ./compile.sh

# which should be piped through dev/null, but my
# version of bash doesn't support it for some reason
path_to_executable=$(which appveyor)
if [ -x "$path_to_executable" ] ; then
    rm -r -- bin/appveyor/
	mkdir bin/appveyor
	cp bin/$build_name bin/appveyor/dynamic_music_system.pk3
	./$path_to_executable PushArtifact bin/appveyor/dynamic_music_system.pk3
fi

echo
echo Build completed.
