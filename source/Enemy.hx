package;

import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.group.FlxSpriteGroup;
import flixel.math.FlxPoint;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import flixel.util.FlxSort;

class Enemy extends FlxTypedSpriteGroup<SpriteSegment>
{

	public var enemyType:Int = 0;
	
	public var letter:Letter;
	public var letterPos:FlxPoint;
	
	public var body:SpriteSegment;
	public var head:SpriteSegment;
	public var wings:SpriteSegment;
	
	private var shootTimer:Float = -100;
	private var spawnTimer:Float = -100;
	public var liveTimer:Float = -100;
	private var started:FlxPoint;
	private var toSpawn:Int = 0;
	
	private var parentState:PlayState;
	
	public var bossBody01:SpriteSegment;
	public var bossBody00:SpriteSegment;
	public var bossArmLeft:SpriteSegment;
	public var bossArmRight:SpriteSegment;
	public var bossMound:SpriteSegment;
	
	public var isBoss:Bool = false;
	public var bossReady:Bool = false;
	
	private var bossTimer:Float = 0;
	
	private var tex:FlxAtlasFrames;
	
	public function new() 
	{
		super();
		tex = GraphicsCache.loadGraphicFromAtlas("enemy-sprites", AssetPaths.enemy_sprites__png, AssetPaths.enemy_sprites__xml).atlasFrames;
		
		body = new  SpriteSegment();
		body.isHitbox = true;
		body.parent = this;
		add(body);
		
		
		head = new SpriteSegment();
		head.parent = this;
		head.isHitbox = false;
		add(head);
		
		wings = new SpriteSegment();
		wings.parent = this;
		wings.isHitbox = false;
		
		add(wings);
		
		
		kill();
	}
	
	public function spawn(X:Float, Y:Float, EnemyType:Int = 0, ParentState:PlayState):Void
	{
		reset(X, Y);
		parentState = ParentState;
		enemyType = EnemyType;
		
		switch (enemyType) 
		{
			case 0:
				
				health = 1;
				
				
				body.frames = tex;
				body.animation.addByIndices("body", "enemy_blob_gray_0", [0, 1, 2, 3], ".png", 12, true, false, false);
				body.animation.play("body");
				
				
				head.frames = tex;
				head.animation.addByIndices("head", "enemy_head_gray_0", [0,0,0,0,0,0, 1, 2, 3, 4], ".png", 12, true, false, false);
				head.animation.play("head");
				head.visible = true;
				
				wings.frames = tex;
				wings.animation.addByIndices("wings", "enemy_wing_0", [1, 2], ".png", 30, true);
				wings.animation.play("wings");
				
				head.x = body.x - 35;
				head.y = body.y - 20;
				
				wings.x = body.x + 26;
				wings.y = body.y + 2;
				
				
				letterPos = FlxPoint.get(40, 40);
				
				velocity.x = -240;
				velocity.y = 0;
				
				shootTimer = -100;
				liveTimer = 0;
				spawnTimer = -100;
				toSpawn = 0;
				
			case 1:
				
				health = 4;
				
				body.frames = tex;
				body.animation.addByIndices("body", "enemy_blob_green_0", [0, 1, 2, 3], ".png", 12, true, false, false);
				body.animation.play("body");
		
				head.frames = tex;
				head.animation.frameName = "enemy_head_green.png";
				head.visible = true;
				
				wings.frames = tex;
				wings.animation.addByIndices("wings", "enemy_wing_0", [1, 2], ".png", 30, true);
				wings.animation.play("wings");
				
				head.x = body.x - 35;
				head.y = body.y - 20;
				
				wings.x = body.x + 26;
				wings.y = body.y + 2;
				
				
				letterPos = FlxPoint.get(40, 40);
				
				velocity.x = -160;
				velocity.y = 0;
				
				shootTimer = 1;
				liveTimer = 0;
				spawnTimer = -100;
				toSpawn = 0;
			
			case 2:
				
				health = 3;
				
				body.frames = tex;
				body.animation.addByIndices("body", "enemy_blob_orange_0", [0, 1, 2, 3], ".png", 12, true, false, false);
				body.animation.play("body");
		
				head.frames = tex;
				head.animation.addByIndices("head", "enemy_head_orange_0", [0, 0, 0, 0, 0, 1, 1, 1], ".png", 12, true);
				head.animation.play("head");
				head.visible = true;
				
				wings.frames = tex;
				wings.animation.addByIndices("wings", "enemy_wing_0", [1, 2], ".png", 30, true);
				wings.animation.play("wings");
				
				head.x = body.x - 35;
				head.y = body.y - 20;
				
				wings.x = body.x + 26;
				wings.y = body.y + 2;
				
				
				letterPos = FlxPoint.get(40, 40);
				
				velocity.x = -60;
				velocity.y = 0;
				
				shootTimer = -100;
				liveTimer = 0;
				spawnTimer = .35;
				started = FlxPoint.get(X, Y);
				toSpawn = FlxG.random.int(3,6);
			
			
			case 3:
				
				health = 3;
				
				body.frames = tex;
				body.animation.addByIndices("body", "enemy_blob_orange_0", [0, 1, 2, 3], ".png", 12, true, false, false);
				body.animation.play("body");
				
				head.visible = false;
				
				wings.frames = tex;
				wings.animation.addByIndices("wings", "enemy_wing_0", [1, 2], ".png", 30, true);
				wings.animation.play("wings");
				
				head.x = body.x - 35;
				head.y = body.y - 20;
				
				wings.x = body.x + 26;
				wings.y = body.y + 2;
				
				
				letterPos = FlxPoint.get(40, 40);
				
				velocity.x = -60;
				velocity.y = 0;
				
				shootTimer = -100;
				spawnTimer = -100;
				liveTimer = 0;
				toSpawn = 0;
				
			case 4:
				isBoss = true;
				health = 50; 
				
				var bossTex = GraphicsCache.loadGraphicFromAtlas("boss-sprites", AssetPaths.boss_sprites__png, AssetPaths.boss_sprites__xml).atlasFrames;
				
				body.makeGraphic(360, 360, FlxColor.TRANSPARENT);
				body.isHitbox = false;
				body.parent = this;
				
				
				bossBody01 = new SpriteSegment();
				bossBody01.frames = bossTex;
				bossBody01.animation.addByIndices("body", "boss_body_0", [0, 0, 0, 1, 1, 0, 0, 1, 1, 1, 0, 0, 0, 0, 0, 1, 1, 0, 0, 1, 1, 1, 1], ".png", 12);
				bossBody01.animation.play("body");
				bossBody01.zOrder = 20;
				bossBody01.parent = this;
				bossBody01.isHitbox = true;
				add(bossBody01);
				
				wings.visible = false;
				
				bossBody00 = new SpriteSegment();
				bossBody00.frames = bossTex;
				bossBody00.animation.frameName = "boss_body_up.png";
				add(bossBody00);
				bossBody00.zOrder = 10;
				bossBody00.parent = this;
				bossBody00.isHitbox = true;
				
				head.frames = bossTex;
				head.animation.addByNames( "closed", ["boss_head_00.png"], 12, false);
				head.animation.addByNames( "open", ["boss_head_01.png"], 12, false);
				head.animation.addByNames( "open-close", ["boss_head_01.png","boss_head_01.png","boss_head_01.png","boss_head_01.png","boss_head_00.png"], 12, false);
				head.animation.play("closed");
				head.visible = true;
				head.zOrder = 0;
				head.parent = this;
				head.isHitbox = true;
				
				
				bossArmRight = new SpriteSegment();
				bossArmRight.frames = bossTex;
				bossArmRight.animation.addByIndices("arm-right", "boss_arm_0", [1, 1, 0, 1, 0, 0, 0, 1, 1, 0, 0, 0, 1, 1, 1, 1, 1, 0, 0, 0, 1, 1, 0, 0, 0, 0], ".png", 12, true, false);
				bossArmRight.zOrder = 7;
				bossArmRight.animation.play("arm-right");
				add(bossArmRight);
				bossArmRight.parent = this;
				bossArmRight.isHitbox = false;
				
				bossArmLeft = new SpriteSegment();
				bossArmLeft.frames = bossTex;
				bossArmLeft.animation.addByIndices("arm-left", "boss_arm_0", [0, 0, 0, 1, 0, 0, 0, 0, 1, 1, 0, 1, 1, 0, 0, 0, 1, 0, 1, 1, 1, 0, 0, 0, 1, 1], ".png", 12, true, true);
				bossArmLeft.animation.play("arm-left");
				bossArmLeft.zOrder = 8;
				bossArmLeft.facing = FlxObject.LEFT;
				add(bossArmLeft);
				bossArmLeft.parent = this;
				bossArmLeft.isHitbox = false;
				
				
				bossMound = new SpriteSegment();
				bossMound.frames = bossTex;
				bossMound.animation.frameName = "boss_mound.png";
				bossMound.zOrder = 1;
				add(bossMound);
				bossMound.parent = this;
				bossMound.isHitbox = false;
				
				sort(SortBoss, FlxSort.DESCENDING);
				
				body.x = 0;
				body.y = 0;
				
				bossBody01.x = body.x;
				bossBody01.y = body.y + 400;
				
				bossBody00.x = bossBody01.x + 90;
				bossBody00.y = bossBody01.y;
				
				head.x = bossBody01.x +28;
				head.y = bossBody01.y - 31;
				
				bossArmLeft.x = bossBody01.x - 18;
				bossArmLeft.y = bossBody01.y + 28;
				
				bossArmRight.x = bossBody01.x + 178;
				bossArmRight.y = bossBody01.y + 28;
				
				bossMound.x = bossBody01.x - 68;
				bossMound.y = bossBody01.y + bossBody01.height - 400;
				
				velocity.x = -90;
				velocity.y = 0;
				
				shootTimer = -100;
				spawnTimer =-100;
				liveTimer = 0;
				toSpawn = 0;
				bossTimer = -100;
				
				y = FlxG.height - bossMound.y - bossMound.height;
				x = FlxG.width + 120;
				
			default:
				
		}
		if (!isBoss)
			letter = ParentState.spawnLetter(this);
	}
	
	private function SortBoss(Order:Int, S1:SpriteSegment, S2:SpriteSegment):Int
	{
		return FlxSort.byValues(Order, S1.zOrder, S2.zOrder);
	}
	
	override function get_height():Float 
	{
		if (isBoss)
			return 320;
		else
			return 80;
	}
	
	override function get_width():Float
	{
		if (isBoss)
			return 320;
		else
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
		
		if (liveTimer != -100)
			liveTimer += elapsed;
		
		if (spawnTimer != -100 && toSpawn > 0)
		{
			spawnTimer -= elapsed;
			if (spawnTimer <= 0)
			{
				toSpawn--;
				if (isBoss)
				{
					spawnTimer += 2;
				}
				else
				{
					spawnTimer += .35;
				}
				parentState.spawnEnemy(3, started.x, started.y);
			}
		}
		
		switch(enemyType)
		{
			case 0:
				velocity.y = 80 * (Math.sin(FlxG.game.ticks / 500));
			case 1:
				velocity.y = -40 * (Math.sin(FlxG.game.ticks / 1000));
			case 2:
				velocity.y = -80 * (Math.sin(liveTimer));
			case 3:
				velocity.y = -80 * (Math.sin(liveTimer));
			
		}
		
		if (!isBoss)
		{
			if (shootTimer != -100)
			{
				shootTimer -= elapsed;
				if (shootTimer <= 0)
				{
					shootTimer += 1;
					velocity.x = 0;
					parentState.enemyShoot(this);
				}
				
			}
		}
		
		if (isBoss)
		{
			if (x <= FlxG.width - 300)
			{
				if (velocity.x != 0)
				{
					velocity.x = 0;
					FlxTween.linearMotion(body, body.x, body.y, body.x, bossMound.y - 230, 2, true, {type:FlxTween.ONESHOT, ease:FlxEase.sineOut, onComplete:function(_) {
						head.animation.play("open");
						FlxG.camera.shake(0.002, 1, function () {
							head.animation.play("closed");
							bossReady =  true;
							parentState.bossReady = true;
							bossTimer = .66;
						});	
					}});
					
				}
			}
			if (bossReady)
			{
				bossTimer -= elapsed;
				if (bossTimer <= 0)
				{
					bossTimer += .33 * FlxG.random.int(2,4);
					
					if (FlxG.random.bool(20))
					{
						// spawn enemies 
						parentState.spawnEnemy(FlxG.random.int(0,2));
					}
					else
					{
						// shoot
						parentState.enemyShoot(this);
						head.animation.play("open-close", true);
					}
				}
			}
			bossBody01.x = body.x;
			bossBody01.y = body.y;
			
			bossBody00.x = bossBody01.x + 90;
			bossBody00.y = bossBody01.y;
			
			head.x = bossBody01.x +28;
			head.y = bossBody01.y - 31;
			
			bossArmLeft.x = bossBody01.x - 18;
			bossArmLeft.y = bossBody01.y + 28;
			
			bossArmRight.x = bossBody01.x + 178;
			bossArmRight.y = bossBody01.y + 28;
		}
		super.update(elapsed);
	}
}