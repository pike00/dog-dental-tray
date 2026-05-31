# Dog dental station tray

A small counter tray that holds two things for the dogs' dental routine:

1. **Virbac C.E.T. 2.5 oz toothpaste tube** — rests on its side in a rounded
   cradle (a capsule-shaped valley with rounded ends) so it can't roll off.
2. **Four silicone finger toothbrushes** — each goes mouth-down over a tapered
   **drying peg**. The cone is a few mm wider than the brush opening, so the
   brush rim catches partway up the taper and stays propped above the floor —
   air reaches the inside and drips run off the point.

![preview](images/preview.png)

```
   back  +-------------------------------+
         |  \___________________________/ |   toothpaste cradle (rounded valley)
         |                                 |
         |       ^         ^               |   4 drying pegs (2 x 2 cones)
   front |       ^         ^               |
         +-------------------------------+
```

Footprint with the default parameters: **152 mm (L) x 124 mm (W) x 33 mm (H)**.
(Verified from the exported STL: watertight / manifold.)

## Source of truth

`src/dog-dental-tray.scad` — fully parametric. Every fit number is at the top of
the file with units; everything else is derived. No external libraries.

## Measurements — verify against your actual items

The defaults are reasonable estimates, **not** measured off the real products.
Before printing, measure yours and update the params:

| Param          | Default | What to measure |
|----------------|---------|-----------------|
| `tube_len`     | 140 mm  | tube length lying flat, cap included |
| `tube_dia`     | 36 mm   | widest diameter of the full tube |
| `peg_base_dia` | 22 mm   | set a few mm **larger** than the brush opening's inner diameter |
| `peg_height`   | 30 mm   | a bit taller than the brush is deep |
| `peg_pitch`    | 34 mm   | brush spacing (leave finger room to grab) |

Tuning the fit:
- **Cradle too tight / loose** -> adjust `cradle_clear` (air gap around the tube).
- **Tube hard to lift out** -> make `grip` more negative (walls stop lower).
- **Brushes slide all the way to the floor** -> increase `peg_base_dia` so the
  rim catches higher up the cone.
- **Sharper point** -> lower `peg_tip_dia` toward ~1 mm. 2 mm is the printable
  default; a true zero point strings/curls.

## Build

```
just build      # -> export/dog-dental-tray.stl
just preview    # -> images/preview.png (headless render via xvfb-run)
just clean
```

`just build` calls the apt OpenSCAD 2021.01 on PATH. Use a different binary with
`OPENSCAD=/path/to/AppImage just build`.

## Print settings

_TBD — fill in after the first print._

- **Material:** PETG suggested (bathroom moisture / water contact; PLA works but
  softens if left wet long-term).
- **Orientation:** print as modeled, flat on the base — **no supports needed**.
  The cradle is a concave scoop (a top surface) and the pegs are tapering towers,
  both overhang-free.
- Layer height / infill / walls: _record what worked._
- Drop a photo of the finished print in `images/`.

## Design notes

- One union of three pieces: base plate + low catch rim, the cradle block (the
  valley is a `hull()` of two spheres -> rounded ends), and a 2 x 2 grid of cones.
- The catch rim contains drips; wipe the tray out occasionally. If you'd rather
  it self-drain, add through-holes in the peg zone or set corner feet — both are
  easy one-parameter follow-ons.
