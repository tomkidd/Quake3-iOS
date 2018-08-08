#  Quake III: Arena for iOS and tvOS for Apple TV

This is my port of Quake for iOS, running in modern resolutions including the full width of the iPhone X. I have also made a target and version for tvOS to run on Apple TV.

Features

- Tested and builds without warnings on Xcode 9.4.1.
- Runs single player campaigns at full screen and full speed on iOS
- Multiplayer support, including server browser
- MFi controller support (reccomended) and on-screen control options
- Second project target for tvOS that takes advantage of focus model and removes on-screen controls.
- Limited support for native menus of original game

This commit does not need any placeholder resources as it is not an update of an existing id Software port. 

You will need to provide your own copies of the `baseq3` directory from an existing instalation of Quake III: Arena. You can grab the whole thing with expansions on [GOG](https://www.gog.com/game/quake_iii_gold) or [Steam](https://store.steampowered.com/app/2200/Quake_III_Arena/).

You will need to drag your directories into the project and select "Create Folder References" and add them to both the Quake and QuakeTV targets. The folders will be blue if you've done it right:

![folders](https://github.com/tomkidd/Quake3-iOS/raw/master/folders.png)

You can read a lengthy blog article on how I did all this [here](http://schnapple.com/quake-3-for-ios-and-tvos-for-apple-tv/).

This repo was based on the code from *[Beben III](https://itunes.apple.com/us/app/beben-iii/id771105890?mt=8)* by Ronny Stiftel (more info [here](http://www.mac-and-i.net/2013/12/beben-iii-openarenaquake-3-for-ios.html)), ultimately derived from [ioquake3](https://ioquake3.org/).  On-screen joystick code came from [this repo](https://github.com/bradhowes/Joystick) by Brad Howe. Quake font DpQuake by Dead Pete available [here](https://www.dafont.com/quake.font). Code to query servers came from [Q3ServerBrowser](https://github.com/andreagiavatto/Q3ServerBrowser) on GitHub by Andrea Giavatto.

[Video of Quake III: Arena running on an iPhone X](https://www.youtube.com/watch?v=4Fu1fmXtcvo)

[Video of Quake III: Arena running on an Apple TV](https://www.youtube.com/watch?v=ade-J3RYpsQ)

Have fun. For any questions I can be reached at tomkidd@gmail.com
