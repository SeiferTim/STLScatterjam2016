package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.group.FlxGroup;
import flixel.system.FlxAssets.FlxGraphicAsset;

class BackgroundSprite extends FlxSprite 
{
	public var which:Int = 0;
	public function new(WhichBG:Int = 0) 
	{
		super();
		which = WhichBG;
		switch (which) 
		{
			case 0:
				loadGraphic(AssetPaths.field_BG_02_clouds__png);
			case 1:
				loadGraphic(AssetPaths.field_BG_01_mountains__png);
			case 2:
				loadGraphic(AssetPaths.field_BG_00_flowers__png);
			case 3:
				loadGraphic(AssetPaths.field_FG_01_flowers__png);
			case 4:
				loadGraphic(AssetPaths.field_FG_00_flowers__png);
			case 5:
				loadGraphic(AssetPaths.field_BG_00_flowers__png);
			case 6:
				loadGraphic(AssetPaths.field_BG_00_flowers__png);
			case 7:
				loadGraphic(AssetPaths.field_BG_00_flowers__png);
			case 8:
				loadGraphic(AssetPaths.field_BG_00_flowers__png);
			case 9:
				loadGraphic(AssetPaths.field_BG_00_flowers__png);
				
		}
		kill();
		
	}
	
	public function spawn(X:Float)
	{
		var Y:Float = 0;
		switch (which)
		{
			case 0:
				Y = 80;
			case 1:
				Y = 365;
			case 2:
				Y = FlxG.height - height;
			case 3:
				Y = FlxG.height - height;
			case 4:
				Y = FlxG.height - height  + 65;
			case 5:
				Y = FlxG.height - height  - 50;
			case 6:
				Y = FlxG.height - height  - 90;
			case 7:
				Y = FlxG.height - height  - 120;
			case 8:
				Y = FlxG.height - height  - 140;
			case 9:
				Y = FlxG.height - height  - 150;
		}
		
		reset(X, Y);
		
		switch(which)
		{
			case 0:
				velocity.x = -10;
			case 1:
				velocity.x = -20;
			case 2:
				velocity.x = -120;
			case 3:
				velocity.x = -240;
			case 4:
				velocity.x = -480;
			case 5:
				velocity.x = -100;
			case 6:
				velocity.x = -80;
			case 7:
				velocity.x = -60;
			case 8:
				velocity.x = -40;
			case 9:
				velocity.x = -20;
		}
	}
	
	override public function update(elapsed:Float):Void 
	{
		if (!alive || !exists)
			return;
		
		if (x < -width)
		{
			
			var l:FlxTypedGroup<BackgroundSprite> = null;
			switch(which)
			{
				case 0:
					l = cast cast(FlxG.state, PlayState).lyrBG02;
				case 1:
					l = cast cast(FlxG.state, PlayState).lyrBG01;
				case 2:
					l = cast cast(FlxG.state, PlayState).lyrBG00;
				case 3:
					l = cast cast(FlxG.state, PlayState).lyrFG00;
				case 4:
					l = cast cast(FlxG.state, PlayState).lyrFG01;
				case 5:
					l = cast cast(FlxG.state, PlayState).lyrBG001;
				case 6:
					l = cast cast(FlxG.state, PlayState).lyrBG002;
				case 7:
					l = cast cast(FlxG.state, PlayState).lyrBG003;
				case 8:
					l = cast cast(FlxG.state, PlayState).lyrBG004;
				case 9:
					l = cast cast(FlxG.state, PlayState).lyrBG005;
			}
			
			var X:Float = FlxG.width;
			for (m in l.members)
			{
				if (m.x + m.width > X)
					X = m.x + m.width;
			}
			x = X;
		}
		
		super.update(elapsed);
	}
	
}

class BG02 extends BackgroundSprite
{
	public function new() 
	{
		super(0);
	}
}
class BG01 extends BackgroundSprite
{
	public function new() 
	{
		super(1);
	}
}
class BG00 extends BackgroundSprite
{
	public function new() 
	{
		super(2);
	}
}
class BG001 extends BackgroundSprite
{
	public function new() 
	{
		super(5);
	}
}
class BG002 extends BackgroundSprite
{
	public function new() 
	{
		super(6);
	}
}
class BG003 extends BackgroundSprite
{
	public function new() 
	{
		super(7);
	}
}
class BG004 extends BackgroundSprite
{
	public function new() 
	{
		super(8);
	}
}
class BG005 extends BackgroundSprite
{
	public function new() 
	{
		super(9);
	}
}
class FG00 extends BackgroundSprite
{
	public function new() 
	{
		super(3);
	}
}
class FG01 extends BackgroundSprite
{
	public function new() 
	{
		super(4);
	}
}