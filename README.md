# GAF Player OpenFL Starling 2.xx version

OpenFL port of latest Starling GAF Player (https://github.com/CatalystApps/StarlingGAFPlayer)

Done with help of as3hx (https://github.com/HaxeFoundation/as3hx)

Works with OpenFL Starling 2.xx (https://github.com/openfl/starling)

Support work with zip files and nested movies (see demo)

Added GAFTextField implementation without Feathers, if work don't satisfy disable with GAFTextField.useTextField = false;
GAFTextField uses OpenFL TextField and filters to behave similar to flash version.
For using Starling TextField and filters set GAFTextField.usePreciseFlashTextField = false; (could have different visual appearence)

Not implemented ATF support in GAF, Sound not checked, but should work

# Dependencies
zip library https://github.com/starburst997/haxe-zip

haxe format library (needed for zip library)