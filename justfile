# dog-dental-tray — OpenSCAD build recipes
#
# OpenSCAD 2021.01 is installed on PATH, so `openscad` resolves directly.
# Override with OPENSCAD=/path/to/AppImage if you need a different binary.
# PNG previews use xvfb-run because this host has no display.

openscad := env_var_or_default("OPENSCAD", "openscad")
src      := "src/dog-dental-tray.scad"

default:
    @just --list

# Export the print-ready STL
build:
    {{openscad}} -o export/dog-dental-tray.stl {{src}}

build-all: build

# Regenerate the README preview render (headless via xvfb)
preview:
    xvfb-run -a {{openscad}} --colorscheme=Tomorrow --viewall --autocenter \
      --imgsize=1200,900 -o images/preview.png {{src}}

# Remove generated meshes / renders (keeps source)
clean:
    rm -f export/*.stl images/preview.png
