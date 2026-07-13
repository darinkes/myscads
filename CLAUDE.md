# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## What this is

A set of standalone OpenSCAD scripts that generate 3D-printable magnetic trays for holding tabletop miniature bases (Warhammer 40k). Each `.scad` file is independent — there are no shared libraries, includes, or build manifest. There is no toolchain beyond OpenSCAD itself.

## Working with the files

- **Preview / render:** open a file in the OpenSCAD GUI (F5 preview, F6 full render), or headless:
  `openscad -o out.stl file.scad`
- The `/* [Section] */` comment blocks are OpenSCAD Customizer groups — the variables under them are meant to be tuned per-print (base sizes, tolerances, magnet dimensions, wall thickness) and are exposed as sliders/fields in the GUI Customizer panel.

## Shared design pattern

Every tray is built the same way; understand one and you understand all of them. The body is a single `difference()`:

1. **Positive body** — a `linear_extrude` of `floor_thickness + lip/wall_height`. The 2D footprint is each slot's outline grown by `wall_thickness`, then run through a **closing offset** `offset(r = -N) offset(r = N)` (dilate-then-erode). This closing offset is the key trick: it fillets concave junctions and bridges the gaps between adjacent slots into one connected plate. Some files add explicit `square()` spines/bridges to the union before offsetting.
2. **Slot pockets** — subtracted cylinders/ovals from `floor_thickness` upward, leaving a floor under each miniature.
3. **Magnet pans** — shallow cylinders (`mag_d` × `mag_h`) subtracted from just below the floor (`floor_thickness - mag_depth`), so a magnet sits flush under each base.

`tolerance` is added to the nominal base diameter so the printed pocket fits the real base. `eps` (0.01) is the standard z-fighting nudge on subtracted solids.

## Two slot-shape conventions (don't mix them up)

- **Round-base files** (`coords_5x2`, `heavy`, `heavy2`): slots are `circle`/`cylinder`; sizes are diameters. `heavy*` combine large (50mm) and small (25mm) holes with hand-tuned `y_offset` placement.
- **Oval-base files** (`riders*`): slots are ovals. The simpler `oval()` is a scaled circle (sizes are width/length). The `gw_oval`/`marshal_oval` modules build a `hull()` of two squashed circles to better match real GW base geometry, and their pockets are **tapered** (`hull` between a tight bottom outline and a `+base_taper` wider top) to clear the sloped wall of GW bases.

## File variants

`heavy.scad`/`heavy2.scad` and `riders_with_dreir.scad`/`riders_with_dreir2.scad` are iterations on the same tray with different placement math and base dimensions (note `riders_with_dreir` uses larger empirical "bottom of base" dimensions like 36.2×61.2). When asked to "fix the holder," confirm which variant — they are not meant to be unified.
