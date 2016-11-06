package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.addons.effects.FlxTrailArea;
import flixel.graphics.frames.FlxBitmapFont;
import flixel.group.FlxGroup;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.text.FlxBitmapText;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import flixel.math.FlxMath;
import flixel.util.FlxColor;
import hx.strings.spelling.checker.EnglishSpellChecker;
import hx.strings.spelling.dictionary.EnglishDictionary;

class PlayState extends FlxState
{
	
	public var player:Player;
	public var lyrPlayer:FlxTypedGroup<Player>;
	public var lyrTrails:FlxTrailArea;
	public var lyrPBullets:FlxTypedGroup<Bullet>;
	public var lyrEnemies:FlxTypedGroup<Enemy>;
	public var lyrLetters:FlxTypedGroup<Letter>;
	public var lyrGUI:FlxGroup;
	
	public var lyrBG02:FlxTypedGroup<BackgroundSprite.BG02>;
	public var lyrBG01:FlxTypedGroup<BackgroundSprite.BG01>;
	public var lyrBG00:FlxTypedGroup<BackgroundSprite.BG00>;
	public var lyrBG001:FlxTypedGroup<BackgroundSprite.BG001>;
	public var lyrBG002:FlxTypedGroup<BackgroundSprite.BG002>;
	public var lyrBG003:FlxTypedGroup<BackgroundSprite.BG003>;
	public var lyrBG004:FlxTypedGroup<BackgroundSprite.BG004>;
	public var lyrBG005:FlxTypedGroup<BackgroundSprite.BG005>;
	public var lyrFG00:FlxTypedGroup<BackgroundSprite.FG00>;
	public var lyrFG01:FlxTypedGroup<BackgroundSprite.FG01>;
	
	
	public var braces:Array<FlxSprite>;
	public var scoreText:FlxBitmapText;
	
	public var score:Int = 0;
	
	public var shootTimer:Float = 0;
	public var spawnTimer:Float = .5;
	public var spawnItem:Int = 0;
	
	public var collectedLetters:Array<Letter>;
	
	public var playerHealth:Int = 6;
	public var healths:Array<HealthIcon>;
	
	override public function create():Void
	{
		bgColor = 0xffe1d0e6;
		
		lyrBG00 = new FlxTypedGroup<BackgroundSprite.BG00>();
		lyrBG001 = new FlxTypedGroup<BackgroundSprite.BG001>();
		lyrBG002 = new FlxTypedGroup<BackgroundSprite.BG002>();
		lyrBG003 = new FlxTypedGroup<BackgroundSprite.BG003>();
		lyrBG004 = new FlxTypedGroup<BackgroundSprite.BG004>();
		lyrBG005 = new FlxTypedGroup<BackgroundSprite.BG005>();
		lyrBG01 = new FlxTypedGroup<BackgroundSprite.BG01>();
		
		lyrBG02 = new FlxTypedGroup<BackgroundSprite.BG02>();
		lyrTrails = new FlxTrailArea(0, 0, FlxG.width, FlxG.height);
		lyrPBullets = new FlxTypedGroup<Bullet>();
		lyrPlayer = new FlxTypedGroup<Player>();
		lyrEnemies = new FlxTypedGroup<Enemy>();
		lyrLetters = new FlxTypedGroup<Letter>();
		lyrFG00 = new FlxTypedGroup<BackgroundSprite.FG00>();
		lyrFG01 = new FlxTypedGroup<BackgroundSprite.FG01>();
		lyrGUI = new FlxGroup();
		
		collectedLetters = [];
		
		braces = [];
		
		for (i in 0...6)
		{
			var b:FlxSprite = new FlxSprite((FlxG.width / 2) - (40 * (3 - i)), FlxG.height - 24, AssetPaths.brace__png);
			braces.push(b);
			lyrGUI.add(b);
		}
		
		healths = [];
		for (i in 0...playerHealth)
		{
			var h:HealthIcon = new HealthIcon(10 + (i * 33), FlxMath.isEven(i) ? 31 : 10 );
			
				
			healths.push(h);
			lyrGUI.add(h);
		}
		
		
		
		add(lyrBG02);
		add(lyrBG02);
		add(lyrBG01);
		add(lyrBG005);
		add(lyrBG004);
		add(lyrBG003);
		add(lyrBG002);
		add(lyrBG001);
		add(lyrBG00);
		add(lyrTrails);
		add(lyrEnemies);
		add(lyrPBullets);
		add(lyrPlayer);
		
		add(lyrFG00);
		add(lyrFG01);
		add(lyrGUI);
		add(lyrLetters);
		
		
		var font:FlxBitmapFont = FlxBitmapFont.fromAngelCode(AssetPaths.letter_font_export__png, AssetPaths.letter_font_export__xml);
		scoreText = new FlxBitmapText(font);
		
		scoreText.text = "0000000000";
		scoreText.x = FlxG.width - scoreText.width - 10;
		scoreText.y = 10;
		
		lyrGUI.add(scoreText);
		
		player = new Player();
		player.x = 24;
		player.y = (FlxG.height / 2) - (player.height / 2);
		
		lyrPlayer.add(player);
		
		var b:BackgroundSprite;
		var pos:Float = 0;
		
		
		while (pos <= FlxG.width * 2)
		{
			
			b = lyrBG02.recycle(BackgroundSprite.BG02);
			b.spawn(pos);
			lyrBG02.add(cast b);
			pos += b.width;
		}
		pos = 0;
		while (pos <= FlxG.width * 2)
		{
			b = lyrBG01.recycle(BackgroundSprite.BG01);
			b.spawn(pos);
			lyrBG01.add(cast b);
			pos += b.width;
		}
		pos = 0;
		while (pos <= FlxG.width * 2)
		{
			b = lyrBG00.recycle(BackgroundSprite.BG00);
			b.spawn(pos);
			lyrBG00.add(cast b);
			pos += b.width;
		}
		pos = -10;
		while (pos <= FlxG.width * 2)
		{
			b = lyrBG001.recycle(BackgroundSprite.BG001);
			b.spawn(pos);
			lyrBG001.add(cast b);
			pos += b.width;
		}
		pos = -20;
		while (pos <= FlxG.width * 2)
		{
			b = lyrBG002.recycle(BackgroundSprite.BG002);
			b.spawn(pos);
			lyrBG002.add(cast b);
			pos += b.width;
		}
		pos = -30;
		while (pos <= FlxG.width * 2)
		{
			b = lyrBG003.recycle(BackgroundSprite.BG003);
			b.spawn(pos);
			lyrBG003.add(cast b);
			pos += b.width;
		}
		pos = -40;
		while (pos <= FlxG.width * 2)
		{
			b = lyrBG004.recycle(BackgroundSprite.BG004);
			b.spawn(pos);
			lyrBG004.add(cast b);
			pos += b.width;
		}
		pos = -50;
		while (pos <= FlxG.width * 2)
		{
			b = lyrBG005.recycle(BackgroundSprite.BG005);
			b.spawn(pos);
			lyrBG005.add(cast b);
			pos += b.width;
		}
		pos = 0;
		while (pos <= FlxG.width * 2)
		{
			b = lyrFG00.recycle(BackgroundSprite.FG00);
			b.spawn(pos);
			lyrFG00.add(cast b);
			pos += b.width;
		}
		pos = 0;
		while (pos <= FlxG.width * 2)
		{
			b = lyrFG01.recycle(BackgroundSprite.FG01);
			b.spawn(pos);
			lyrFG01.add(cast b);
			pos += b.width;
		}
		
		
		super.create();
		
	}

	override public function update(elapsed:Float):Void
	{
		if (!Globals.initialized)
		{
			FlxG.autoPause = false;
		
			UIControl.initKeys();
			//Globals.initSounds();
			Globals.initialized = true;
			UIControl.init([]);
		}
		
		UIControl.checkControls(elapsed);
		
		playerMovement();
		
		shootTimer -= elapsed;
		if (shootTimer <= 0)
		{
			shootTimer += .2;
			if (!player.flickering)
				playerShoot();
		}
		
		spawnTimer -= elapsed;
		if (spawnTimer <= 0)
		{
			for (i in 0...Std.parseInt(Globals.spawns[spawnItem]))
			{
				spawnEnemy();
			}
			spawnTimer = .5;
			spawnItem++;
		}
		
		
		FlxG.overlap(lyrPBullets, lyrEnemies, notifyBulletHitEnemy, processBulletHitEnemy);
		FlxG.overlap(player, lyrLetters, notifyCollectLetter, processCollectLetter);
		FlxG.overlap(player, lyrEnemies, notifyEnemyHitPlayer, processEnemyHitPlayer);
		
		
		
		adjustCollectedLetters();
		
		super.update(elapsed);
	}
	
	private function notifyEnemyHitPlayer(P:SpriteSegment, E:SpriteSegment):Void
	{
		playerHealth--;
		updateHealth();
		if (playerHealth>0)
			player.flicker(1);
		else
		{
			gameOver();
		}
	}
	
	public function gameOver():Void
	{
		player.flicker(100);
		FlxG.camera.fade(FlxColor.BLACK, 1, false, function() {
			FlxG.switchState(new PlayState());
		});
	}
	
	public function updateHealth():Void
	{
		for (i in 0...healths.length)
		{
			if (i < playerHealth)
				healths[i].animation.play("full");
			else
				healths[i].animation.play("empty");
		}
	}
	
	private function processEnemyHitPlayer(P:SpriteSegment, E:SpriteSegment):Bool
	{
		return (P.isHitbox && P.parent.alive && P.parent.isOnScreen() && P.parent.exists && !player.flickering && E.isHitbox && E.parent.isOnScreen() && E.parent.alive && E.parent.exists);
	}
	
	private function adjustCollectedLetters():Void
	{
		for (l in 0...collectedLetters.length)
		{
			collectedLetters[l].x = braces[6 - collectedLetters.length +  l].x + (braces[6 - collectedLetters.length + l].width / 2) - (collectedLetters[l].width / 2);
			collectedLetters[l].y = braces[6 - collectedLetters.length +  l].y - collectedLetters[l].height;
		}
	}
	
	private function notifyCollectLetter(P:SpriteSegment, L:Letter):Void
	{
		L.collected = true;
		collectedLetters.push(L);
		
		if (L.text == "Q")
		{
			var l2:Letter = lyrLetters.recycle(Letter);
			l2.text = "U";
			l2.collected = true;
			collectedLetters.push(L);
		}
		
		while (collectedLetters.length > 6)
		{
			var l:Letter = collectedLetters.shift();
			if (l != null)
			{
				l.kill();
			}
			
		}
		score+= 25;
		updateScore();
		checkForWord();
		
	}
	
	private function checkForWord():Void
	{
		//start looking at the last few letters of the collected letters...
		// if it makes a word, then yay!
		
		
		if (collectedLetters.length < 3)
			return;
			
		var word:String  = "";
		var length:Int = 0;
		var foundWord:Bool = false;
		
		while (!foundWord && length <= collectedLetters.length - 3) 
		{		
			word = "";
			
			for (i in length...collectedLetters.length)
			{
				word +=  collectedLetters[i].text;
				if (word.length >= 3)
				{
					//EnglishDictionary.INSTANCE.exists(word);
					//var corrected:String = EnglishSpellChecker.INSTANCE.correctWord(word, 1);
					//trace(word, corrected);
					//if (corrected == word)
					//{
					//	foundWord = true;
					//}
					
					foundWord = EnglishDictionary.INSTANCE.exists(word);
					
				}
			}
			length += 1;
			
			
		}
		
		if (foundWord)
		{
			FlxG.camera.flash(FlxColor.WHITE, .2);
			score+= length * 750;
		}
	}
	
	private function processCollectLetter(P:SpriteSegment, L:Letter):Bool
	{
		return (!L.collected && L.parent == null && L.alive && L.exists && L.isOnScreen() && P.isHitbox);
			
	}
	
	private function notifyBulletHitEnemy(B:Bullet, E:SpriteSegment):Void
	{
		B.kill();
		E.parent.hurt(1);
		if (!E.parent.alive)
		{
			score+= 500;
			updateScore();
		}
	}

	public function updateScore():Void
	{
		scoreText.text = StringTools.lpad(Std.string(score), "0", 10);
	}
	
	private function processBulletHitEnemy(B:Bullet, E:SpriteSegment):Bool
	{
		return (B.alive && B.exists && E.parent.alive && E.parent.exists && E.isHitbox && B.isOnScreen() && E.parent.isOnScreen());	
	}
	
	public function playerShoot():Void
	{
		var b:Bullet = lyrPBullets.recycle(Bullet);
		b.shoot(player.x, player.y, 500);
		lyrPBullets.add(b);
	}
	
	public function playerMovement():Void
	{
		var up:Bool = UIControl.isPressed([UIControl.KEY_UP]);
		var down:Bool = UIControl.isPressed([UIControl.KEY_DOWN]);
		var left:Bool = UIControl.isPressed([UIControl.KEY_LEFT]);
		var right:Bool = UIControl.isPressed([UIControl.KEY_RIGHT]);
		
		if (up && down)
			up = down = false;
		if (left && right)
			left = right = false;
		
		if (player.x < 24)
		{
			player.x = 24;
			left = false;
		}
		if (player.x > FlxG.width - player.width - 24)
		{
			player.x = FlxG.width - player.width - 24;
			right = false;
		}
		if (player.y < 110)
		{
			player.y = 110;
			up = false;
		}
		if (player.y > FlxG.height - player.height - 100)
		{
			player.y = FlxG.height - player.height - 100;
			down = false;
		}
			
		if (up)
			player.acceleration.y = -3000;
		else if (down)
			player.acceleration.y = 3000;
		else
			player.acceleration.y = 0;
			
		if (left)
			player.acceleration.x = -3000;
		else if (right)
			player.acceleration.x = 3000;
		else
			player.acceleration.x = 0;
		
	}
	
	public function spawnLetter(E:Enemy):Letter
	{
		
		var l:Letter = lyrLetters.recycle(Letter);
		l.spawn(E, Globals.getLetter());
		lyrLetters.add(l);
		return l;
		
	}
	
	public function spawnEnemy():Void
	{
		var e:Enemy = new Enemy();
		e.spawn(FlxG.width + 10, FlxG.random.float(32, FlxG.height - 48), 0, this);
		lyrEnemies.add(e);
	}
}
