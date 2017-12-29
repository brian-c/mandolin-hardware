#!/usr/bin/env sh

RELATIVE="$(dirname $0)";
OUTPUT="$RELATIVE/build"

mkdir -p "$OUTPUT";

openscad -D '$fn=32' -o "$OUTPUT/bridge.stl" "$RELATIVE/bridge.scad";
openscad -D '$fn=32' -o "$OUTPUT/tailpiece.stl" "$RELATIVE/tailpiece.scad";
openscad -D '$fn=32' -o "$OUTPUT/tuner_button.stl" "$RELATIVE/tuner_button.scad";
openscad -D '$fn=32' -o "$OUTPUT/layout.stl" "$RELATIVE/layout.scad";
