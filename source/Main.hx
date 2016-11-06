package;

import flixel.FlxG;
import flixel.FlxGame;
import openfl.Lib;
import openfl.display.Sprite;

class Main extends Sprite
{
	public function new()
	{
		GraphicsCache.init();
		Globals.loadGame();
		super();
		addChild(new FlxGame(1280, 720, IntroState));
		FlxG.fullscreen = true;
	}
}
