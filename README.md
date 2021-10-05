# AHK-Translation-Tooltip
## an AHK Script that Google Translates highlighted text into a tooltip
Based on [this AHK implementation of the Google Translate API](https://www.autohotkey.com/boards/viewtopic.php?t=63835) by teadrinker on the AHK Forums.
The goal of this project was to provide a simpler and faster solution for quickly translating words or phrases on the internet than opening up a new Google Translate tab and pasting the unknown vocabulary in.

## How to use
1. Highlight the text you want to translate
2. Press the corresponding hotkey (Defaults are <kbd>Ctrl</kbd>+<kbd>F1</kbd> for `lang2`-->`lang1` and <kbd>Ctrl</kbd>+<kbd>Shift</kbd>+<kbd>F1</kbd> for `lang1`-->`lang2`)
3. Tooltip should appear containing translation

## TODO:
- Add nice GUI for choosing hotkeys
- Create tray icon
- Package into an executible for non-AHK users
- Find way to automatically determine translation direction (`lang1`-->`lang2` or `lang2`-->`lang1`; may be possible with `"auto"` option)
- Add a disable verbose option to prevent synonyms of one word tranlations
