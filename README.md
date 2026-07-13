# myscads

A set of standalone [OpenSCAD](https://openscad.org/) scripts that generate 3D-printable **magnetic trays** for holding Warhammer 40k miniature bases. Each tray has a shallow pocket per base and a magnet pan under every pocket, so painted minis sit flush and travel without shifting.

Each `.scad` file is self-contained — no shared libraries, includes, or build step. The only tool you need is OpenSCAD.

## Rendering

Open a file in the OpenSCAD GUI (**F5** preview, **F6** full render), or render headless:

```sh
openscad -o out.stl coords_5x2.scad
```

The `/* [Section] */` comment blocks are OpenSCAD **Customizer** groups — the variables under them (base sizes, tolerances, magnet dimensions, wall thickness) are meant to be tuned per print and show up as sliders/fields in the GUI Customizer panel.

## Trays

### Round bases

#### `coords_5x2` — 10× 25mm, rectangular grid
<img src="https://darinkes.github.io/myscads/images/coords_5x2.png" width="480" alt="coords_5x2 preview">

Ten 25mm round slots in a plain 5 columns × 2 rows grid.

#### `coords_5x2_staggered` — 10× 25mm, hex-nested rows
<img src="https://darinkes.github.io/myscads/images/coords_5x2_staggered.png" width="480" alt="coords_5x2_staggered preview">

Same ten 25mm slots, but the two rows nest into each other's notches for a tighter footprint than the grid version.

#### `heavy` / `heavy2` — 3× 50mm + 1× 25mm
<img src="https://darinkes.github.io/myscads/images/heavy.png" width="480" alt="heavy preview">

Three 50mm heavy-weapon bases in a row plus one 25mm coordinator tucked above the middle slot. `heavy` and `heavy2` are two iterations with different placement for the small slot — pick whichever fits better.

#### `krieg_engineers` — 5× 25mm + 1× 40mm
<img src="https://darinkes.github.io/myscads/images/krieg_engineers.png" width="480" alt="krieg_engineers preview">

Astra Militarum Krieg Combat Engineers: a staggered pack of five 25mm bases (back row of 3, front row of 2) with a 40mm remote-mine base nestled against the right-hand edge.

### Oval bases

#### `riders` — 5× 35×60mm ovals
<img src="https://darinkes.github.io/myscads/images/riders.png" width="480" alt="riders preview">

Death Korps Spearhead: five oval rider bases (official 40k 35×60mm) in a staggered 3 + 2 formation.

#### `riders_with_dreir2` — 5× riders + 1× Marshal
<img src="https://darinkes.github.io/myscads/images/riders_with_dreir2.png" width="480" alt="riders_with_dreir2 preview">

The `riders` formation plus a 75×42mm Marshal oval off to the right, using official 40k base sizes.

#### `riders_with_dreir` — GW-fit edition (tapered pockets)
<img src="https://darinkes.github.io/myscads/images/riders_with_dreir.png" width="480" alt="riders_with_dreir preview">

Same layout as `riders_with_dreir2`, tuned for a snug GW fit: larger empirical "bottom of base" dimensions and tapered pockets that open wider toward the top to clear the sloped wall of GW bases.
