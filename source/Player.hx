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

class Player extends FlxTypedSpriteGroup<SpriteSegment> 
{

	public var hitbox:SpriteSegment;
	public var body:SpriteSegment;
	public var head:SpriteSegment;
	public var wings:SpriteSegment;
	public var tail:SpriteSegment;
	
	public var trails:Array<Trail>;
	
	private var baseHead:FlxPoint;
	private var baseTail:FlxPoint;
	
	public function new() 
	{
		super();
		hitbox = new SpriteSegment(0);
		hitbox.makeGraphic(8, 8, FlxColor.BLUE);
		hitbox.isHitbox = true;
		hitbox.parent = this;
		add(hitbox);
		
		width = 8;
		height = 8;
		
		drag.set(1600, 1600);
		maxVelocity.set(400, 400);
		
		body = new SpriteSegment(0, 0);
		
		body.frames = GraphicsCache.loadGraphicFromAtlas("bee-body", AssetPaths.bee_body__png, AssetPaths.bee_body__xml).atlasFrames;
		body.animation.addByIndices("body", "sp_bee_body_", [0, 1, 2, 3], ".png", 12, true, true, false);
		body.animation.play("body");
		body.setFacingFlip(FlxObject.LEFT, true, false);
		body.parent = this;
		
		
		head = new SpriteSegment(0, 0);
		head.frames = GraphicsCache.loadGraphicFromAtlas("bee-head", AssetPaths.bee_head__png, AssetPaths.bee_head__xml).atlasFrames;
		head.animation.addByIndices("head", "sp_bee_head_", [0, 1, 2, 3], ".png", 12, true, true, false);
		head.animation.play("head");
		head.setFacingFlip(FlxObject.LEFT, true, false);
		head.parent = this;
		
		tail = new SpriteSegment(0, 0);
		tail.frames = GraphicsCache.loadGraphicFromAtlas("bee-tail", AssetPaths.bee_tail__png, AssetPaths.bee_tail__xml).atlasFrames;
		tail.animation.addByIndices("tail", "sp_bee_tail_", [0], ".png", 12, true, true, false);
		tail.animation.play("tail");
		tail.setFacingFlip(FlxObject.LEFT, true, false);
		tail.parent = this;
		
		wings = new SpriteSegment(0, 0);
		wings.frames = GraphicsCache.loadGraphicFromAtlas("bee-wings", AssetPaths.bee_wing__png, AssetPaths.bee_wing__xml).atlasFrames;
		wings.animation.addByIndices("wings", "sp_bee_wing_", [0, 1], ".png", 30, true, true, false);
		wings.animation.play("wings");
		wings.setFacingFlip(FlxObject.LEFT, true, false);
		wings.parent = this;
		
		body.x = hitbox.x + (hitbox.width / 2) - (body.width / 2);
		body.y = hitbox.y + (hitbox.height / 2) - (body.height / 2);
		
		tail.x = body.x - 6;
		tail.y = body.y + 2;
		
		head.x = body.x + 0;
		head.y = body.y - 5;
		
		wings.x = body.x + 3;
		wings.y = body.y - 4;
		
		baseHead = FlxPoint.get(1, -7);
		baseTail = FlxPoint.get( -6, 2);
		
		trails = [];
		trails.push( new Trail(tail, Trail.STYLE_RAINBOW, .33));
		trails.push( new Trail(body, Trail.STYLE_RAINBOW, .33));
		trails.push( new Trail(head, Trail.STYLE_RAINBOW, .33));
		
		cast(FlxG.state, PlayState).lyrTrails.add(trails[0]);
		cast(FlxG.state, PlayState).lyrTrails.add(trails[1]);
		cast(FlxG.state, PlayState).lyrTrails.add(trails[2]);
		
		add(tail);
		add(body);
		add(wings);
		add(head);
		
		//FlxTween.linearMotion(head, head.x, head.y, head.x + 2, head.y - 4, .5, true, {type:FlxTween.PINGPONG, ease:FlxEase.sineInOut});
		FlxTween.num(0, 1, .33, {type:FlxTween.PINGPONG, ease:FlxEase.sineInOut}, bounce);
	}
	
	private function bounce(Value:Float):Void
	{
		head.x = body.x +  baseHead.x + ((2 * Value)-1) + ((velocity.x / maxVelocity.x)* 2);
		head.y = body.y + baseHead.y + Math.abs(( -3 * Value) + 1.5) + ((velocity.y / maxVelocity.y)*3);
		
		tail.x = body.x + baseTail.x + (( -2 * Value) + 1) - ((velocity.x / maxVelocity.x)*2);
		tail.y = body.y + baseTail.y + -Math.abs(( 3 * Value) - 1.5) - ((velocity.y / maxVelocity.y)*3);
	}
	
	override public function update(elapsed:Float):Void 
	{
		
		super.update(elapsed);/*
		head.x = body.x + baseHead.x - ((velocity.x / maxVelocity.x) * 4);
		head.y = body.y + baseHead.y - ((velocity.y / maxVelocity.y) * 4);
*/		
		for (t in trails)
			t.update(elapsed);
		
	}
	
	override function get_height():Float 
	{
		return 8;
	}
	
	override function get_width():Float
	{
		return 8;
	}
}