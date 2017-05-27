echo ======== Dynamic Music System for ZDoom ========
echo
echo Build started...
echo
echo Getting latest build of GDCC...
echo

rm -- tools/
mkdir tools

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
7z x "bin/gdcc.7z" -otools/gdcc -aoa

# get filename for built .pk3
git_version=$(git describe --long --tags --dirty --always)
build_name='dynamic_music_system-'$git_version'.pk3'

# force recompilation of libc
# this is because the new version
# of gdcc might be different
rm bin/build/acs/libc.lib

echo
echo Compiling...
echo

# run the compile script
. ./compile.sh

echo
echo Building .pk3 file...
echo

# make the .pk3 file
7z a -r -tzip bin/$build_name bin/build

# which should be piped through dev/null, but my
# version of bash doesn't support it for some reason
path_to_executable=$(which appveyor)
if [ -x "$path_to_executable" ] ; then
    rm -- bin/appveyor/
	mkdir bin/appveyor
	cp bin/$build_name bin/appveyor/dynamic_music_system.pk3
	./$path_to_executable PushArtifact bin/appveyor/dynamic_music_system.pk3
fi

echo
echo Build completed.
