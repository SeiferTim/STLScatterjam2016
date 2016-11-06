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
import flixel.util.FlxSpriteUtil;

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
	
	public var flickering:Bool = false;
	
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
		
		var tex = GraphicsCache.loadGraphicFromAtlas("bee-body", AssetPaths.bee_sprites__png, AssetPaths.bee_sprites__xml).atlasFrames;
		
		body = new SpriteSegment(0, 0);
		body.frames = tex;
		body.animation.frameName = "bee_body.png";
		//body.animation.addByIndices("body", "bee_body", [0, 1, 2, 3], ".png", 12, true, true, false);
		//body.animation.play("body");
		//body.setFacingFlip(FlxObject.LEFT, true, false);
		body.parent = this;
		
		
		head = new SpriteSegment(0, 0);
		head.frames = tex;
		head.animation.frameName = "bee_head.png";
		//head.animation.addByIndices("head", "sp_bee_head_", [0, 1, 2, 3], ".png", 12, true, true, false);
		//head.animation.play("head");
		//head.setFacingFlip(FlxObject.LEFT, true, false);
		head.parent = this;
		
		tail = new SpriteSegment(0, 0);
		tail.frames = tex;
		tail.animation.frameName = "bee_butt.png";
		//tail.animation.addByIndices("tail", "sp_bee_tail_", [0], ".png", 12, true, true, false);
		//tail.animation.play("tail");
		//tail.setFacingFlip(FlxObject.LEFT, true, false);
		tail.parent = this;
		
		wings = new SpriteSegment(0, 0);
		wings.frames = tex;
		wings.animation.addByIndices("wings", "bee_wing_0", [1, 2], ".png", 30, true,false, false);
		wings.animation.play("wings");
		//wings.setFacingFlip(FlxObject.LEFT, true, false);
		wings.parent = this;
		
		body.x = hitbox.x + (hitbox.width / 2) - (body.width / 2);
		body.y = hitbox.y + (hitbox.height / 2) - (body.height / 2);
		
		tail.x = body.x - 4;
		tail.y = body.y + 11;
		
		head.x = body.x - 16;
		head.y = body.y - 21;
		
		wings.x = body.x - 13;
		wings.y = body.y - 5;
		
		baseHead = FlxPoint.get(-16, -21);
		baseTail = FlxPoint.get( -4, 11);
		
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
	
	public function flicker(Duration:Float):Void
	{
		FlxSpriteUtil.flicker(this, Duration, 0.02, true, true, function(_)
		{
			flickering = false;
		});
		flickering = true;
	}
}