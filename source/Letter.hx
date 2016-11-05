package;

import flixel.graphics.frames.FlxBitmapFont;
import flixel.graphics.frames.FlxFrame;
import flixel.math.FlxPoint;
import flixel.text.FlxBitmapText;

class Letter extends FlxBitmapText
{

	public function new()
	{
		var font:FlxBitmapFont = FlxBitmapFont.fromAngelCode(AssetPaths.basic_font_export__png, AssetPaths.basic_font_export__xml);
		
		super(font);
	}
	
	override function set_text(value:String):String 
	{
		if (value != text && value != null )
		{
			var t:String = super.set_text(value);
			updateText();
			computeTextSize();
			return t;
		}
		return value;
	}
	
}