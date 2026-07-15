# myscads

A set of standalone [OpenSCAD](https://openscad.org/) scripts that generate 3D-printable **magnetic trays** for holding Warhammer 40k miniature bases. Each tray has a shallow pocket per base and a magnet pan under every pocket, so painted minis sit flush and travel without shifting.

Each `.scad` file is self-contained — no shared libraries, includes, or build step. The only tool you need is OpenSCAD.

## Rendering

Open a file in the OpenSCAD GUI (**F5** preview, **F6** full render), or render headless:

```sh
openscad -o out.stl infantry_squad_grid.scad
```

The `/* [Section] */` comment blocks are OpenSCAD **Customizer** groups — the variables under them (base sizes, tolerances, magnet dimensions, wall thickness) are meant to be tuned per print and show up as sliders/fields in the GUI Customizer panel.

## Releases

Don't want to install OpenSCAD? Grab a release ZIP — it bundles every `.scad` source alongside a ready-to-print `.stl` for each tray.

Releases are cut by pushing a version tag:

```sh
git tag v1.0
git push origin v1.0
```

That fires the [Release workflow](.github/workflows/release.yml), which on GitHub runs `openscad -o <name>.stl <name>.scad` for every `.scad`, zips the sources and rendered STLs into `myscads-v1.0.zip`, and attaches it to an auto-generated [GitHub Release](../../releases). No STLs are committed to the repo — CI regenerates them fresh from source on every tag.

## Trays

### Round bases

#### `infantry_squad_grid` — 10× 25mm, rectangular grid
<img src="https://darinkes.github.io/myscads/images/infantry_squad_grid.png" width="480" alt="infantry_squad_grid preview">

Ten 25mm round slots in a plain 5 columns × 2 rows grid.

#### `infantry_squad_staggered` — 10× 25mm, hex-nested rows
<img src="https://darinkes.github.io/myscads/images/infantry_squad_staggered.png" width="480" alt="infantry_squad_staggered preview">

Same ten 25mm slots, but the two rows nest into each other's notches for a tighter footprint than the grid version.

#### `heavy_weapons` — 3× 50mm + 1× 25mm
<img src="https://darinkes.github.io/myscads/images/heavy_weapons.png" width="480" alt="heavy_weapons preview">

Three 50mm heavy-weapon bases in a row plus one 25mm coordinator tucked above the middle slot.

#### `heavy_weapons_alt` — 3× 50mm + 1× 25mm, nested coordinator
<img src="https://darinkes.github.io/myscads/images/heavy_weapons_alt.png" width="480" alt="heavy_weapons_alt preview">

Same tray with the coordinator nested diagonally between the two left slots instead of above the middle — pick whichever fits better.

#### `krieg_engineers` — 5× 25mm + 1× 40mm
<img src="https://darinkes.github.io/myscads/images/krieg_engineers.png" width="480" alt="krieg_engineers preview">

Astra Militarum Krieg Combat Engineers: a staggered pack of five 25mm bases (back row of 3, front row of 2) with a 40mm remote-mine base nestled against the right-hand edge.

#### `krieg_command_squad` — 6× 25mm + 1× 32mm
<img src="https://darinkes.github.io/myscads/images/krieg_command_squad.png" width="480" alt="krieg_command_squad preview">

Astra Militarum Krieg Command Squad (2025): six 25mm bases (five veterans plus the servo-scribe) in two hex-nested rows of three, with the Lord Commissar's 32mm base nestled against the left-hand edge.

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
