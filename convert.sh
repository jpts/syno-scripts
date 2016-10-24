#!/bin/bash

for i in *.mkv; do
avconv -i "$i" -ss 00:00:16 -t 00:21:42 -codec copy "${i%%.*}-trim.mkv"
done
