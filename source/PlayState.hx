package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.addons.effects.FlxTrailArea;
import flixel.group.FlxGroup;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import flixel.math.FlxMath;
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
	
	public var braces:Array<FlxSprite>;
	
	public var shootTimer:Float = 0;
	public var spawnTimer:Float = 3;
	
	public var collectedLetters:Array<Letter>;
	
	override public function create():Void
	{
		bgColor = 0xff666666;
		
		lyrTrails = new FlxTrailArea(0, 0, FlxG.width, FlxG.height);
		lyrPBullets = new FlxTypedGroup<Bullet>();
		lyrPlayer = new FlxTypedGroup<Player>();
		lyrEnemies = new FlxTypedGroup<Enemy>();
		lyrLetters = new FlxTypedGroup<Letter>();
		lyrGUI = new FlxGroup();
		
		collectedLetters = [];
		
		braces = [];
		
		for (i in 0...6)
		{
			var b:FlxSprite = new FlxSprite((FlxG.width / 2) - (40 * (3 - i)), FlxG.height - 24, AssetPaths.brace__png);
			braces.push(b);
			lyrGUI.add(b);
		}
		
		
		
		add(lyrTrails);
		add(lyrEnemies);
		add(lyrPBullets);
		add(lyrPlayer);
		add(lyrLetters);
		add(lyrGUI);
		
		player = new Player();
		player.x = 10;
		player.y = 10;
		
		lyrPlayer.add(player);
		
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
			playerShoot();
		}
		
		spawnTimer -= elapsed;
		if (spawnTimer <= 0)
		{
			spawnEnemy();
			spawnTimer = .66;
		}
		
		
		FlxG.overlap(lyrPBullets, lyrEnemies, notifyBulletHitEnemy, processBulletHitEnemy);
		FlxG.overlap(player, lyrLetters, notifyCollectLetter, processCollectLetter);
		
		
		adjustCollectedLetters();
		
		super.update(elapsed);
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
		
		trace(foundWord);
	}
	
	private function processCollectLetter(P:SpriteSegment, L:Letter):Bool
	{
		return (!L.collected && L.parent == null && L.alive && L.exists && L.isOnScreen() && P.isHitbox);
			
	}
	
	private function notifyBulletHitEnemy(B:Bullet, E:SpriteSegment):Void
	{
		B.kill();
		E.parent.hurt(1);
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
			
		
			
		if (player.x < 16)
		{
			player.x = 16;
			left = false;
		}
		if (player.x > (FlxG.width / 2) - player.width)
		{
			player.x = (FlxG.width / 2) - player.width;
			right = false;
		}
		if (player.y < 24)
		{
			player.y = 24;
			up = false;
		}
		if (player.y > FlxG.height - player.height - 24)
		{
			player.y = FlxG.height - player.height - 24;
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
