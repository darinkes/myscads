# myscads

A set of standalone [OpenSCAD](https://openscad.org/) scripts that generate 3D-printable **magnetic trays** for holding Warhammer 40k miniature bases. Each tray has a shallow pocket per base and a magnet pan under every pocket, so painted minis sit flush and travel without shifting.

Each `.scad` file is self-contained — no shared libraries, includes, or build step. The only tool you need is OpenSCAD.

## Rendering

Open a file in the OpenSCAD GUI (**F5** preview, **F6** full render), or render headless:

```sh
openscad -o out.stl infantry_squad_grid.scad
```

The `/* [Section] */` comment blocks are OpenSCAD **Customizer** groups — the variables under them (base sizes, tolerances, magnet dimensions, wall thickness) are meant to be tuned per print and show up as sliders/fields in the GUI Customizer panel.

## Trays

### Round bases

#### `infantry_squad_grid` — 10× 25mm, rectangular grid
<img src="https://darinkes.github.io/myscads/images/infantry_squad_grid.png" width="480" alt="infantry_squad_grid preview">

Ten 25mm round slots in a plain 5 columns × 2 rows grid.

#### `infantry_squad_staggered` — 10× 25mm, hex-nested rows
<img src="https://darinkes.github.io/myscads/images/infantry_squad_staggered.png" width="480" alt="infantry_squad_staggered preview">

Same ten 25mm slots, but the two rows nest into each other's notches for a tighter footprint than the grid version.

#### `heavy_weapons` / `heavy_weapons_alt` — 3× 50mm + 1× 25mm
<img src="https://darinkes.github.io/myscads/images/heavy_weapons.png" width="480" alt="heavy_weapons preview">

Three 50mm heavy-weapon bases in a row plus one 25mm coordinator tucked above the middle slot. The two files are iterations with different placement for the small slot — pick whichever fits better.

#### `krieg_engineers` — 5× 25mm + 1× 40mm
<img src="https://darinkes.github.io/myscads/images/krieg_engineers.png" width="480" alt="krieg_engineers preview">

Astra Militarum Krieg Combat Engineers: a staggered pack of five 25mm bases (back row of 3, front row of 2) with a 40mm remote-mine base nestled against the right-hand edge.

### Oval bases

#### `death_riders` — 5× 35×60mm ovals
<img src="https://darinkes.github.io/myscads/images/death_riders.png" width="480" alt="death_riders preview">

Death Korps Spearhead: five oval rider bases (official 40k 35×60mm) in a staggered 3 + 2 formation.

#### `death_riders_marshal` — 5× riders + 1× Marshal
<img src="https://darinkes.github.io/myscads/images/death_riders_marshal.png" width="480" alt="death_riders_marshal preview">

The `death_riders` formation plus a 75×42mm Marshal oval off to the right, using official 40k base sizes.

#### `death_riders_marshal_gw_fit` — GW-fit edition (tapered pockets)
<img src="https://darinkes.github.io/myscads/images/death_riders_marshal_gw_fit.png" width="480" alt="death_riders_marshal_gw_fit preview">

Same layout as `death_riders_marshal`, tuned for a snug GW fit: larger empirical "bottom of base" dimensions and tapered pockets that open wider toward the top to clear the sloped wall of GW bases.
