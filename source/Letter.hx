package;

import flixel.graphics.frames.FlxBitmapFont;
import flixel.graphics.frames.FlxFrame;
import flixel.math.FlxPoint;
import flixel.text.FlxBitmapText;
import flixel.text.FlxText.FlxTextAlign;

class Letter extends FlxBitmapText
{

	public var parent:Enemy;
	public var collected:Bool = false;
	
	
	public function new()
	{
		var font:FlxBitmapFont = FlxBitmapFont.fromAngelCode(AssetPaths.letter_font_export__png, AssetPaths.letter_font_export__xml);
		
		super(font);
		
		multiLine = false;
		alignment = FlxTextAlign.CENTER;
		letterSpacing = 0;
		lineSpacing = 0;
		lineHeight = 30;
		
		
	}
	
	override function set_text(value:String):String 
	{
		if (value != text && value != null )
		{
			var t:String = super.set_text(value);
			updateText();
			computeTextSize();
			
			width = 30;
			height = 30;
			//textHeight = 30;
			//textWidth = 30;
			lineSpacing = 0;
			lineHeight = 30;
			
			centerOffsets();
			return t;
		}
		return value;
	}
	
	public function spawn(Parent:Enemy, Char:String):Void
	{
		parent = Parent;
		reset(parent.x + parent.letterPos.x, parent.y + parent.letterPos.y);
		text = Char;
		collected = false;
	}
	
	override public function update(elapsed:Float):Void 
	{
		
		if (!alive || !exists)
			return;
		
		if (collected)
		{
			velocity.set();
		}
		else
		{
			if (parent == null)
			{
				velocity.x = -100;
				
			}
			else if (!parent.alive)
			{
				parent = null;
			}
			else
			{
				x = parent.x + parent.letterPos.x - (width/2);
				y = parent.y + parent.letterPos.y - (height / 2);
			}
			
			if (x < -width)
				kill();
		}
		super.update(elapsed);
	}
	
	
}