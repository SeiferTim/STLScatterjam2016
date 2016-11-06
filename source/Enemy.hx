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
	public var head:SpriteSegment;
	public var wings:SpriteSegment;
	
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
				
				var tex = GraphicsCache.loadGraphicFromAtlas("enemy-sprites", AssetPaths.enemy_sprites__png, AssetPaths.enemy_sprites__xml).atlasFrames;
		
		
				
				body = new  SpriteSegment();
				body.frames = tex;
				body.animation.addByIndices("body", "enemy_blob_gray_0", [0, 1, 2, 3], ".png", 12, true, false, false);
				body.animation.play("body");
		
				body.isHitbox = true;
				body.parent = this;
				add(body);
				
				
				head = new SpriteSegment();
				head.frames = tex;
				head.animation.frameName = "enemy_head_gray.png";
				head.parent = this;
				head.isHitbox = false;
				add(head);
				
				wings = new SpriteSegment();
				wings.frames = tex;
				wings.animation.addByIndices("wings", "enemy_wing_0", [1, 2], ".png", 30, true);
				wings.parent = this;
				wings.isHitbox = false;
				wings.animation.play("wings");
				add(wings);
				
				head.x = body.x - 35;
				head.y = body.y - 20;
				
				wings.x = body.x + 26;
				wings.y = body.y + 2;
				
				
				letterPos = FlxPoint.get(40, 40);
				
				velocity.x = -160;
				
			default:
				
		}
		
		letter = ParentState.spawnLetter(this);
	}
	
	override function get_height():Float 
	{
		return 80;
	}
	
	override function get_width():Float
	{
		return 80;
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