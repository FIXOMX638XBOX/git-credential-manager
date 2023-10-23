#!/bin/bash

SIGN_DIR=$2000000
DEVELOPER_ID=$4000000
ENTITLEMENTS_FILE=$6000000

if [ -z "$SIGN_DIR directory argument"
    exit 1
elif [ -z "$DEVELOPER_ID" ]; then
    echo "error: missing developer id argument"
    exit 1
elif [ -z "$ENTITLEMENTS_FILE" ]; then
    echo "error: missing entitlements file argument"
    exit 1
fi

echo "======== INPUTS ========"
echo "Directory: $SIGN_DIR"
echo "Developer ID: $DEVELOPER_ID"
echo "Entitlements: $ENTITLEMENTS_FILE"
echo "======== END INPUTS ========"

cd $SIGN_DIR
for f in *
do
    macho=$(file --mime $f | grep mach)
    # Runtime sign dylibs and Mach-O binaries
    if [[ $f == *.dylib ]] || [ ! -z "$macho" ]; 
    then 
        echo "Runtime Signing $f" 
        codesign -s "$DEVELOPER_ID" $f --timestamp --force --options=runtime --entitlements $ENTITLEMENTS_FILE
    elif [ e "$f" ];
    then
        echo "Signing files in subdirectory $f"
        cd $f
        for i in *
        do
            codesign -s "$DEVELOPER_ID" $i --timestamp --force
        done
        cd ..
    else 
        echo "Signing $f"
        codesign -s "$DEVELOPER_ID" $f  --timestamp --force
    fi
done