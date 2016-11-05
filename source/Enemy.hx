package;

import flixel.FlxSprite;
import flixel.group.FlxSpriteGroup;
import flixel.math.FlxPoint;
import flixel.util.FlxColor;

class Enemy extends FlxTypedSpriteGroup<SpriteSegment>
{

	public var enemyType:Int = 0;
	
	public var letter:Letter;
	public var letterPos:FlxPoint;
	
	public var body:SpriteSegment;
	
	public function new() 
	{
		super();
		kill();
	}
	
	public function spawn(X:Float, Y:Float, EnemyType:Int = 0, ParentState:PlayState):Void
	{
		reset(X, Y);
		enemyType = EnemyType;
		
		switch (enemyType) 
		{
			case 0:
				
				health = 1;
				
				body = new  SpriteSegment();
				body.makeGraphic(32, 32, FlxColor.PINK);
				body.isHitbox = true;
				body.parent = this;
				add(body);
				
				letterPos = FlxPoint.get(16, 16);
				
				velocity.x = -160;
				
			default:
				
		}
		
		letter = ParentState.spawnLetter(this);
	}
	
	override public function update(elapsed:Float):Void 
	{
		if (!alive || !exists)
			return;
		if (x < -width)
		{
			kill();
		}
		
		super.update(elapsed);
	}
}