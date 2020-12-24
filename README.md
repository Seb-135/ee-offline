## About
Everybody Edits: Offline (EEO) is a recreation of Everybody Edits (EE), adapted by Seb135 and LuciferX for singleplayer due to Adobe ending support for Flash. The source code has been uploaded here, to possibly allow for a new age of modders to tear apart and change the game.

## Version differences
Some features of EE were tricky or unnecessary to preserve, and thus there are several differences between EE and EEO. Those include:
* Smaller window size (640x500 vs 850x500), with the chat sidebar removed.
* There is only one lobby screen - the Campaign selection screen. Buttons have been added to allow opening and creating worlds.
* Fewer restrictions - commands such as /edit, /save, /clear, etc, are available in all non-Campaign worlds. Worlds can also be created with any size between 3x3 to 636x460.
* All Campaigns and tiers, and their time trials, are available immediately. Additionally, Campaign progress saves indefinitely.
* You can use all smilies, blocks, and auras, as well as gold borders.
* Gold doors and gates can be toggled by enabling/disabling the gold border on your smiley.
* Some staff-only tools are available. Keybinds can be found ingame, in Options > Game Settings > Edit Key Bindings.
* Several online-oriented game and world options have been removed.
* There are three new buttons in the in-game Options menu:
  * Fake Players (FPs) to allow for Orange Switches, and a World Manager to allow for World Portals, to retain their functionality.
  * Edit Tools to allow users to place more blocks at once.
  * FPs will prefer to spawn at a World Portal Spawnpoint that corresponds to their ID, visible on the left in the FP menu.
* Corresponding commands have been added:
  * /summon to bring up the FP menu, /summon <n> to create n FPs instantly, /summon <x> <y> to spawn a FP at a given coordinate.
  * /world to bring up the World menu, /world <id> to travel to that world ID without the use of the menu or a World Portal.
* New level format: .eelvls, a zip full of .eelvl files. The purpose of this is to allow you to easily save, load, and share collections of worlds that use World Portals. If you use the World Manager to add any sub-worlds to your world, using /save will save an .eelvls instead of an .eelvl.

## Modifying the game
You will need either [FlashDevelop](https://www.flashdevelop.org), available for free, or [Adobe's Flash Builder](https://www.adobe.com/products/flash-builder-standard.html), in order to edit, build, and debug the source code - note that this quick guide is aimed at FlashDevelop. Additionally, you will need the [Flex SDK](https://helpx.adobe.com/flash-builder/release-note/flex-4-6-sdk-release.html), and, of course, you also need to download and unzip the [EEO source code](https://github.com/Seb-135/ee-offline/archive/main.zip) from this repo.

The `WebClient.as3proj` included in the source code should be automatically associated with FlashDevelop. Opening it will open FD, but before you can start editing, you will need to [specify where you downloaded Flex]. You can do this with Project (on the top bar) > Properties... > SDK > Manage...

From here, you have to click on the `...` on the right to bring up yet another popup, where you press `...` next to the `Path` field. Navigate to your Flex SDK folder, select it, and close out of all of the additional popup windows.

Over on the right, you should see Outline, Bookmarks, Files, and Project. Select the Project tab if it isn't already selected - these are the local files. From there, you can open the `src` folder, which contains all of EEO's code (images are stored in `media`, and assets are stored in `swc` - you will need Adobe Animate to edit assets)

You're now good to go! As an example, find a script with a catchy name, such as `Player.as`, and look through until you find a function you would like to change. Perhaps you want to replace `killPlayer()` on line 1187 to make yourself immortal - this is a simple case of replacing the entire function with only the following:
`public function killPlayer():void { }`

This way, when the game tries to kill a player, it will do absolutely nothing. Or, perhaps, if you don't want Fake Players to also be immortal, you could instead put `if(isme) return;` at the top of the function. What you do is entirely up to you.

Once you have made changes that you're satisfied with, you can build the project into an .swf. On the top bar, there should be a drop-down menu, with options of `Debug` or `Release`. The Debug version runs much slower (at ~30fps) but the errors it logs will allow you to track down issues easier. The Release version is the version that you can play and possibly even share with others. To the left of the drop-down are two buttons: a blue play button to build and run the swf, and a cog to just build the swf. By default, the .swf file will end up where your `WebClient.as3proj` file is, in a sub-folder called either `bin` or `bin-debug`, depending on which version you built.
