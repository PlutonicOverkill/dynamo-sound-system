echo ======== Dynamic Music System for ZDoom ========
echo
echo Build started...
echo

# clear out the build folder
rm -r -- bin/

# create directories for the binaries
mkdir bin
mkdir bin/gdcc
mkdir bin/ir
mkdir bin/build

echo Getting latest build of GDCC...
echo

# get dropbox URL to latest version of GDCC
latest_gdcc=$(curl -L https://www.dropbox.com/sh/e4msp35vxp61ztg/AAA2Ti5pBthuMBfwPSb6Y_MCa/gdcc_master-latest_win64.txt?dl=1)

# change downloaded URL to end in 'dl=1'
latest_gdcc=${latest_gdcc/dl=0/dl=1}

echo
echo Downloading GDCC...
echo

curl -L $latest_gdcc > bin/gdcc.7z

echo
echo Unpacking GDCC...
echo

7z x "bin/gdcc.7z" -obin/gdcc -aoa
