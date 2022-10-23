#!/bin/sh
./mkarchiso "."
ls out/ > /tmp/isoname
cd out/
isoname=$(cat /tmp/isoname)
sha512sum $isoname > $isoname.sha512sum
