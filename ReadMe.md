<img src="OnAir/UI/Resources/Assets.xcassets/AppIcon.appiconset/mac_256x256@1x.png?raw=true" width="128" />

# On Air
**_A macOS app that helps other people at home know when you're in a meeting._**

_On Air_ runs in your status bar. It subtly turns from 🟢 green to 🔴 red when another nearby _On Air_ user's microphone is in use.

<img src="Marketing/screenshot_1.png?raw=true" width="300"/> <img src="Marketing/screenshot_2.png?raw=true" width="300"/>

## How it works

_On Air_ periodically takes a screenshot of your status bar to check for the presence of the orange 🟠 “Sensor&nbsp;Indicator” icon:

<img src="Marketing/statusbar.gif?raw=true" />

If the orange dot is there, your microphone is in use (even if it's muted) - indicating that you are in a meeting. _On Air_ then updates the _On Air_ icon on nearby Macs to show that you are in a meeting.

## Installation
Download a notarized version of `OnAir.app` from [the releases page](https://github.com/maxchuquimia/OnAir/releases). 
Or, compile it yourself from this repo's source code.

## Privacy
_On Air_ only connects to nearby devices locally - your information is never sent to any third party server (including our own).

## Caveats
- Most likely only works if English is set as the system language (see `WindowInfoRecognizer`)
- Future versions of macOS could change how the Status Indicator dot works, resulting in _On Air_ breaking
- No unit tests at this time :(
- UI state is represented as an injected singleton as I still haven't found a nice way to bind SwiftUI to a traditional view model yet. At least the core logic is entirely separated from the view this way... it works for a single-view-model app like this.
