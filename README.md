# Standdown - PvP flag countdown

A small movable box that counts down your PvP flag. It shows only while a timer is running, so you can see when you are clear.

Made for **WoW Forever** (interface 16001). No dependencies, no libraries, one small file.

## Install

1. Download the latest release and unzip it.
2. Put the `Standdown` folder in `World of Warcraft\_forever_\Interface\AddOns\`.
3. Restart the game or type `/reload`.

## Use

| Command | What it does |
|---|---|
| `/standdown` | Show the list of commands. |
| `/standdown unlock` | Show the box so you can drag it. A dummy box is shown if no timer is running. |
| `/standdown lock` | Lock the box in place. |
| `/standdown reset` | Put the box back in the default place. |

The text is red while the timer runs and turns green for the last minute. The box hides itself when you have no timer.

## Notes

- The box reads the game's own PvP timer (`GetPVPTimer`), so it follows whatever sets your flag.
- If it does not appear while you have a timer, please open an issue with your game version and the error from BugSack, if any.

## License

MIT, see `LICENSE`.
