package;
import flixel.FlxG;
import flixel.util.FlxSave;
import haxe.Serializer;

class Globals 
{
	static public var Save:FlxSave;
	static public var initialized:Bool = false;
	
	//static public var letterDistribution:Array<String> = [];
	
	static public var letters:Array<String>;
	static public var weights:Array<Float>;
	
	static public function loadGame():Void
	{
		
		Save = new FlxSave();
		Save.bind("SpellingBee-userData");
		
		setupDistribution();
		
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
	
	private static function setupDistribution():Void
	{
		/*4 blank tiles (scoring 0 points)
		1 point: E ×24, A ×16, O ×15, T ×15, I ×13, N ×13, R ×13, S ×10, L ×7, U ×7
		2 points: D ×8, G ×5
		3 points: C ×6, M ×6, B ×4, P ×4
		4 points: H ×5, F ×4, W ×4, Y ×4, V ×3
		5 points: K ×2
		8 points: J ×2, X ×2
		10 points: Q ×2, Z ×2*/
		
		/*
		for (i in 0...24)
			letterDistribution.push("E");
		for (i in 0...16)
			letterDistribution.push("A");
		for (i in 0...15)
		{
			letterDistribution.push("O");
			letterDistribution.push("T");
		}
		for (i in 0...13)
		{
			letterDistribution.push("I");
			letterDistribution.push("N");
			letterDistribution.push("R");
		}
		for (i in 0...10)
		{
			letterDistribution.push("S");
		}
		for (i in 0...8)
		{
			letterDistribution.push("D");
		}
		for (i in 0...7)
		{
			letterDistribution.push("L");
			letterDistribution.push("U");
		}
		for (i in 0...6)
		{
			letterDistribution.push("C");
			letterDistribution.push("M");
		}
		for (i in 0...5)
		{
			letterDistribution.push("G");
			letterDistribution.push("H");
		}
		for (i in 0...4)
		{
			letterDistribution.push("B");
			letterDistribution.push("P");
			letterDistribution.push("F");
			letterDistribution.push("W");
			letterDistribution.push("Y");
		}
		for (i in 0...3)
		{
			letterDistribution.push("V");
		}
		for (i in 0...2)
		{
			letterDistribution.push("K");
			letterDistribution.push("J");
			letterDistribution.push("X");
			letterDistribution.push("Q");
			letterDistribution.push("Z");
		}
		
		*/
		
		letters = "etaoinshrdlcumwfgypbvkjxqz".split('');
		weights = [19.0, 9.1, 12.2, 11.3, 10.5, 6.7, 6.3, 6.1, 6.0, 4.2, 4.0, 2.8, 4.2, 2.4, 2.4, 2.2, 2.0, 2.0, 1.9, 1.5, 1.0, 0.8, 0.2, 0.2, 0.1, 0.1];
		
		//letters = "beebuzzhoneyfireicehotcoldsnowlavaheatflameburnfreezechillwarmcoolbuginsectmagicwandwizardhatzapeeeeaaaaiiioooo".split('');
	}
	
	public static function getLetter():String
	{
		
		return letters[FlxG.random.weightedPick(weights)];
		//FlxG.random.shuffle(letters);
		//return letters[FlxG.random.int(0, letters.length, [letters.length])];
	}
	
}