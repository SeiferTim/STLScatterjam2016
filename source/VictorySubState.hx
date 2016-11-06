package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxSubState;
import flixel.graphics.frames.FlxBitmapFont;
import flixel.text.FlxBitmapText;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxAxes;
import flixel.util.FlxColor;

class VictorySubState extends FlxSubState 
{

	private var bg:FlxSprite;
	private var menuButton:GameButton;
	private var t1:FlxBitmapText;
	private var t2:FlxBitmapText;
	
	public function new(Score:Int, Callback:Void->Void) 
	{
		super(FlxColor.TRANSPARENT);
		
		closeCallback = Callback;
		
		bg = new FlxSprite();
		bg.makeGraphic(FlxG.width, FlxG.height, FlxColor.PURPLE);
		bg.alpha = 0;
		add(bg);
		
		FlxTween.tween(bg, {alpha:1}, 2, {type:FlxTween.ONESHOT, ease:FlxEase.circOut, onComplete: showButton});
		
		var font:FlxBitmapFont = FlxBitmapFont.fromAngelCode(AssetPaths.letter_font_export__png, AssetPaths.letter_font_export__xml);
		t1 = new FlxBitmapText(font);
		t1.text = "Congratulations!";
		t1.screenCenter();
		add(t1);
		t1.alpha = 0;
		t2 = new FlxBitmapText(font);
		t2.text = "Score " + Std.string(Score);
		t2.screenCenter();
		t2.y += t2.height;
		add(t2);
		t2.alpha = 0;
		
		menuButton = new GameButton("Menu", gotoMainMenu);
		menuButton.screenCenter(FlxAxes.X);
		menuButton.y = FlxG.height - (menuButton.height * 3);
		menuButton.alpha = 0;
		add(menuButton);
	}
	
	private function showButton(_):Void
	{
		FlxTween.tween(menuButton, {alpha:1}, .33, {type:FlxTween.ONESHOT, ease:FlxEase.circOut});
		FlxTween.tween(t1, {alpha:1}, .33, {type:FlxTween.ONESHOT, ease:FlxEase.circOut});
		FlxTween.tween(t2, {alpha:1}, .33, {type:FlxTween.ONESHOT, ease:FlxEase.circOut});
		FlxG.mouse.visible = true;
	}
	
	private function gotoMainMenu():Void
	{
		menuButton.visible = false;
		FlxG.mouse.visible = false;
		FlxG.camera.fade(FlxColor.BLACK, 1, false, close);
	}
	
}