package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import flixel.math.FlxMath;

class MenuState extends FlxState
{
	override public function create():Void
	{
		super.create();
	}

	override public function update(elapsed:Float):Void
	{
		
		if (!Globals.initialized)
		{
			FlxG.autoPause = false;
		
			UIControl.initKeys();
			//Globals.initSounds();
			Globals.initialized = true;
		
		}
		
		UIControl.checkControls(elapsed);
		
		super.update(elapsed);
	}
}
