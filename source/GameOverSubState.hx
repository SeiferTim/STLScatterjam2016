package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxSubState;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxAxes;
import flixel.util.FlxColor;


class GameOverSubState extends FlxSubState 
{

	private var bg:FlxSprite;
	private var letters:Array<Letter>;
	private var menuButton:GameButton;
	
	public function new(Callback:Void->Void) 
	{
		super(FlxColor.TRANSPARENT);
		
		closeCallback = Callback;
		
		bg = new FlxSprite();
		bg.makeGraphic(FlxG.width, FlxG.height, FlxColor.BLACK);
		bg.alpha = 0;
		add(bg);
		
		FlxTween.tween(bg, {alpha:1}, 2, {type:FlxTween.ONESHOT, ease:FlxEase.circOut, onComplete: showButton});
		
		letters = [];
		
		var l:Letter = new Letter();
		l.collected = true;
		l.text = "G";
		l.x = (FlxG.width / 2) - (l.width * 4.5);
		l.y = -l.height * 3;
		letters.push(l);
		add(l);
		
		l = new Letter();
		l.collected = true;
		l.text = "A";
		l.x = (FlxG.width / 2) - (l.width * 3.5);
		l.y = -l.height * 2;
		letters.push(l);
		add(l);
		
		l = new Letter();
		l.collected = true;
		l.text = "M";
		l.x = (FlxG.width / 2) - (l.width * 2.5);
		l.y = -l.height * 5;
		letters.push(l);
		add(l);
		
		l = new Letter();
		l.collected = true;
		l.text = "E";
		l.x = (FlxG.width / 2) - (l.width * 1.5);
		l.y = -l.height * 4;
		letters.push(l);
		add(l);
		
		l = new Letter();
		l.collected = true;
		l.text = "O";
		l.x = (FlxG.width / 2) + (l.width * .5);
		l.y = -l.height * 5;
		letters.push(l);
		add(l);
		
		l = new Letter();
		l.collected = true;
		l.text = "V";
		l.x = (FlxG.width / 2) + (l.width * 1.5);
		l.y = -l.height * 2;
		letters.push(l);
		add(l);
		
		l = new Letter();
		l.collected = true;
		l.text = "E";
		l.x = (FlxG.width / 2) + (l.width * 2.5);
		l.y = -l.height * 6;
		letters.push(l);
		add(l);
		
		l = new Letter();
		l.collected = true;
		l.text = "R";
		l.x = (FlxG.width / 2) + (l.width * 3.5);
		l.y = -l.height * 4;
		letters.push(l);
		add(l);
		
		for (i in 0...letters.length)
		{
			FlxTween.linearMotion(letters[i], letters[i].x, letters[i].y, letters[i].x, (FlxG.height / 2) - (letters[i].height / 2), 300, false, {type:FlxTween.ONESHOT, ease:FlxEase.bounceOut, startDelay:.33 + (i * .2)});
		}
		
		menuButton = new GameButton("Menu", gotoMainMenu);
		menuButton.screenCenter(FlxAxes.X);
		menuButton.y = FlxG.height - (menuButton.height * 3);
		menuButton.alpha = 0;
		add(menuButton);
	}
	
	private function showButton(_):Void
	{
		FlxTween.tween(menuButton, {alpha:1}, .33, {type:FlxTween.ONESHOT, ease:FlxEase.circOut});
		FlxG.mouse.visible = true;
	}
	
	private function gotoMainMenu():Void
	{
		menuButton.visible = false;
		FlxG.mouse.visible = false;
		FlxG.camera.fade(FlxColor.BLACK, 1, false, close);
	}
	
}