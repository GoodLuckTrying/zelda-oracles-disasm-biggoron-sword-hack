## Oracle Ages/Seasons — Biggoron Sword single-slot hack

Fork of [Stewmath's Oracle games' disassembly](https://github.com/Stewmath/oracles-disasm) that makes **Biggoron's Sword** occupy **one** A/B item slot like other inventory items (vanilla forces it onto both buttons).

This repository still builds US Ages and Seasons. JP/EU are not supported.

## Two build modes

| Command | Behavior | Output |
|---------|----------|--------|
| `build.bat` | Stock dual-slot Biggoron | `ages.gbc`, `seasons.gbc` |
| `build_enhanced.bat` | Single-slot Biggoron hack | `ages_enhanced.gbc`, `seasons_enhanced.gbc` |

Or from Git Bash / MSYS2 after tools are on your `PATH`:

```bash
# vanilla
./tools/build_roms.sh

# enhanced
./tools/build_roms.sh enhanced
```

You can also use plain `make` / `make BUILD_ENHANCED=1` the same way as upstream once WLA-DX and make are installed.

Enhanced sources live in:

- `code/bank2_enhanced.s`
- `code/treasureAndDrops_enhanced.s`
- `scripts/ages/scriptHelper_enhanced.s`
- `scripts/seasons/scriptHelper_enhanced.s`

`ages.s` / `seasons.s` pick them via `.ifdef BUILD_ENHANCED`.


## Required tools (install yourself — not shipped in this repo)

Same toolchain as upstream oracles-disasm:

* Python 3
* `pip install pyyaml`
* [WLA-DX](https://github.com/vhelin/wla-dx) **v10.6** (`wla-gb`, `wlalink`)
* GNU **make**
* On Windows: **Git Bash** or MSYS2 (the `.bat` helpers call bash)

Setup guide: [Setting up oracles-disasm](https://wiki.zeldahacking.net/oracle/Setting_up_oracles-disasm)

Optional: put `wla-gb.exe` / `wlalink.exe` in `tools/wla-dx/` and `make.exe` in `tools/bin/` so the included `.bat` files find them without changing your system `PATH`. Do **not** commit those binaries.

Note: WLA may not produce a byte-identical Seasons ROM due to empty-fill quirks; gameplay is unaffected.
