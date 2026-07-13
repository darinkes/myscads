# myscads

[![Previews](https://github.com/darinkes/myscads/actions/workflows/previews.yml/badge.svg)](https://github.com/darinkes/myscads/actions/workflows/previews.yml)

A set of standalone [OpenSCAD](https://openscad.org/) scripts that generate 3D-printable **magnetic trays** for holding Warhammer 40k miniature bases. Each tray has a shallow pocket per base and a magnet pan under every pocket, so painted minis sit flush and travel without shifting.

Each `.scad` file is self-contained — no shared libraries, includes, or build step. The only tool you need is OpenSCAD.

## Rendering

Open a file in the OpenSCAD GUI (**F5** preview, **F6** full render), or render headless:

```sh
openscad -o out.stl coords_5x2.scad
```

The `/* [Section] */` comment blocks are OpenSCAD **Customizer** groups — the variables under them (base sizes, tolerances, magnet dimensions, wall thickness) are meant to be tuned per print and show up as sliders/fields in the GUI Customizer panel.

Rendered `*.stl` and `*.png` output is git-ignored — no binaries live in this repo (see [Previews](#previews) below).

## Trays

### Round bases

#### `coords_5x2` — 10× 25mm, rectangular grid
<img src="https://darinkes.github.io/myscads/images/coords_5x2.png" width="480" alt="coords_5x2 preview">

Ten 25mm round slots in a plain 5 columns × 2 rows grid.

#### `coords_5x2_staggered` — 10× 25mm, hex-nested rows
<img src="https://darinkes.github.io/myscads/images/coords_5x2_staggered.png" width="480" alt="coords_5x2_staggered preview">

Same ten 25mm slots, but the two rows are offset by `spacing · sin(60)` with alternate rows shifted half a pitch, so the rows nest into each other's notches (tighter footprint than the grid version).

#### `heavy` / `heavy2` — 3× 50mm + 1× 25mm
<img src="https://darinkes.github.io/myscads/images/heavy.png" width="480" alt="heavy preview">

Three 50mm heavy-weapon bases in a row plus one 25mm coordinator tucked above the middle slot. `heavy` and `heavy2` are two iterations with different placement math for the small slot (`heavy2` sits it lower/closer) — not meant to be unified, pick whichever fits better.

#### `krieg_engineers` — 5× 25mm + 1× 40mm
<img src="https://darinkes.github.io/myscads/images/krieg_engineers.png" width="480" alt="krieg_engineers preview">

Astra Militarum Krieg Combat Engineers: a staggered pack of five 25mm bases (back row of 3, front row of 2 nested in the notches) with a 40mm remote-mine base nestled flush against the right-hand edge.

### Oval bases

#### `riders` — 5× 35×60mm ovals
<img src="https://darinkes.github.io/myscads/images/riders.png" width="480" alt="riders preview">

Death Korps Spearhead: five oval rider bases (official 40k 35×60mm) in a staggered 3 + 2 formation.

#### `riders_with_dreir2` — 5× riders + 1× Marshal
<img src="https://darinkes.github.io/myscads/images/riders_with_dreir2.png" width="480" alt="riders_with_dreir2 preview">

The `riders` formation plus a 75×42mm Marshal oval off to the right. Uses official 40k base sizes and a `hull()`-based oval that better matches real GW base geometry.

#### `riders_with_dreir` — GW-fit edition (tapered pockets)
<img src="https://darinkes.github.io/myscads/images/riders_with_dreir.png" width="480" alt="riders_with_dreir preview">

Same layout as `riders_with_dreir2`, tuned for a snug GW fit: larger empirical "bottom of base" dimensions (riders 36.2×61.2, Marshal 43.5×76.5) and **tapered pockets** that open wider toward the top to clear the sloped wall of GW bases. Customizer labels are in German.

## How the trays are built

Every tray is a single `difference()`:

1. **Positive body** — a `linear_extrude` of `floor_thickness + lip/wall_height`. Each slot's outline is grown by `wall_thickness`, then run through a **closing offset** (`offset(r=-N) offset(r=N)`, i.e. dilate-then-erode). That closing offset fillets the concave junctions and bridges the gaps between adjacent slots into one connected plate. Some files add explicit `square()` spines to the union before offsetting.
2. **Slot pockets** — cylinders/ovals subtracted from `floor_thickness` upward, leaving a floor under each miniature.
3. **Magnet pans** — shallow `mag_dia × mag_depth` cylinders subtracted from just below the floor, so a disc magnet sits flush under each base.

`tolerance` is added to the nominal base size so the printed pocket fits the real base; `eps` (0.01) is the standard z-fighting nudge on subtracted solids.

**Two slot conventions:** round-base files (`coords_5x2*`, `heavy*`, `krieg_engineers`) use `circle`/`cylinder` slots sized by diameter; oval-base files (`riders*`) use ovals sized by width/length. The `gw_oval`/`marshal_oval` modules build a `hull()` of two squashed circles and use tapered pockets to match GW's sloped base walls.

## Previews

The preview images above are **not stored in this repo**. On every push to `main`, the [`Previews`](.github/workflows/previews.yml) GitHub Actions workflow renders a PNG of each `.scad` file with a headless OpenSCAD and publishes them to **GitHub Pages** — so the images live on the Pages CDN, and git stays free of binary churn.

- Gallery: <https://darinkes.github.io/myscads/>
- Individual images: `https://darinkes.github.io/myscads/images/<name>.png`

To regenerate previews locally (output is git-ignored):

```sh
for f in *.scad; do
  openscad -o "images/${f%.scad}.png" \
    --imgsize=1000,750 --viewall --autocenter --colorscheme=Tomorrow "$f"
done
```
