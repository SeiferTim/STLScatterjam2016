package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.addons.effects.FlxTrailArea;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import flixel.math.FlxMath;

class PlayState extends FlxState
{
	
	public var player:Player;
	public var lyrPlayer:FlxTypedGroup<Player>;
	public var lyrTrails:FlxTrailArea;
	public var lyrPBullets:FlxTypedGroup<Bullet>;
	public var shootTimer:Float = 0;
	
	override public function create():Void
	{
		bgColor = 0xff666666;
		
		lyrTrails = new FlxTrailArea(0, 0, FlxG.width, FlxG.height);
		lyrPBullets = new FlxTypedGroup<Bullet>();
		lyrPlayer = new FlxTypedGroup<Player>();
		
		add(lyrTrails);
		add(lyrPBullets);
		add(lyrPlayer);
		
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
		
		/*var l:Letter = new Letter();
		l.x = FlxG.random.float(0, FlxG.width);
		l.y = FlxG.random.float(0, FlxG.height);
		l.text = String.fromCharCode(FlxG.random.int("A".charCodeAt(0), "Z".charCodeAt(0)));
		add(l);*/
		
		shootTimer -= elapsed;
		if (shootTimer <= 0)
		{
			shootTimer += .33;
			playerShoot();
		}
		
		
		super.update(elapsed);
	}
	
	public function playerShoot():Void
	{
		var b:Bullet = lyrPBullets.recycle(Bullet);
		b.shoot(player.x, player.y, 200);
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
			
		
			
		if (player.x < 4)
		{
			player.x = 4;
			left = false;
		}
		if (player.x > (FlxG.width / 2) - player.width)
		{
			player.x = (FlxG.width / 2) - player.width;
			right = false;
		}
		if (player.y < 4)
		{
			player.y = 4;
			up = false;
		}
		if (player.y > FlxG.height - player.height - 4)
		{
			player.y = FlxG.height - player.height - 4;
			down = false;
		}
			
		if (up)
			player.acceleration.y = -2000;
		else if (down)
			player.acceleration.y = 2000;
		else
			player.acceleration.y = 0;
			
		if (left)
			player.acceleration.x = -2000;
		else if (right)
			player.acceleration.x = 2000;
		else
			player.acceleration.x = 0;
		
	}
}
