package;

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
		addChild(new FlxGame(640, 480, PlayState));
	}
}
