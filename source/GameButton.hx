package;

import flixel.graphics.frames.FlxBitmapFont;
import flixel.text.FlxBitmapText;
import flixel.text.FlxText.FlxTextAlign;
import flixel.ui.FlxButton.FlxTypedButton;

class GameButton extends FlxTypedButton<FlxBitmapText>
{

	public function new(Text:String, ?OnClick:Void->Void) 
	{
		super(0, 0, OnClick);
		loadGraphic(AssetPaths.button__png, true, 180, 46);
		
		var font:FlxBitmapFont = FlxBitmapFont.fromAngelCode(AssetPaths.letter_font_export__png, AssetPaths.letter_font_export__xml);
		
		var f:FlxBitmapText = new FlxBitmapText(font);
		f.multiLine = false;
		f.alignment = FlxTextAlign.CENTER;
		f.text = Text;
		f.calcFrame();
		f.centerOrigin();
		f.centerOffsets(false);
		
		label = f;
		updateLabelPosition();
	}
	
}