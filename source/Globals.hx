package;
import flixel.FlxG;
import flixel.util.FlxSave;
import haxe.Serializer;

class Globals 
{
	static public var Save:FlxSave;
	static public var initialized:Bool = false;
	
	static public function loadGame():Void
	{
		
		Save = new FlxSave();
		Save.bind("SpellingBee-userData");
		
		
		
	}
	
	static public function flushSave():Void
	{
		
		Save.data.saved = true;
		Save.flush();
		
	}
	
	static public function clearSaves():Void
	{
		Save.erase();
		FlxG.autoPause = false;
		initialized = false;
		loadGame();
		FlxG.resetGame();
	}
	
}