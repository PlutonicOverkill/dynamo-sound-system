echo Getting latest build of GDCC...
echo

if [ -d tools ]; then
    rm -r tools/
fi

mkdir tools

if ! [ -d bin ]; then
    mkdir bin
fi

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

echo

# run the build script
. ./build.sh
