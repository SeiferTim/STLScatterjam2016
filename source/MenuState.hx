package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import flixel.math.FlxMath;
import flixel.util.FlxAxes;
import flixel.util.FlxColor;

class MenuState extends FlxState
{
	override public function create():Void
	{
		
		add(new FlxSprite(0, 0, AssetPaths.TITLE_final__png));

		var button:GameButton = new GameButton("Start", startGame);
		button.screenCenter(FlxAxes.X);
		button.y = FlxG.height - (button.height * 2);
		add(button);
		
		
		super.create();
		
		FlxG.camera.fade(FlxColor.BLACK, .33, true, function() {
			FlxG.mouse.visible = true;
		});

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
	
	private function startGame():Void
	{
		FlxG.mouse.visible = false;
		FlxG.camera.flash(FlxColor.PURPLE, 0.1, function() {
			FlxG.switchState(new PlayState());
		});
	}
}
