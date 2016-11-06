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
	public var wand:SpriteSegment;
	public var trails:Array<Trail>;
	
	private var baseHead:FlxPoint;
	private var baseTail:FlxPoint;
	private var baseWand:FlxPoint;
	
	public var flickering:Bool = false;
	
	public var shootFrom:FlxPoint;
	
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
		body.parent = this;
		
		
		head = new SpriteSegment(0, 0);
		head.frames = tex;
		head.animation.addByNames("head",[ "bee_head.png"], 12, false, false, false);
		head.animation.addByIndices("hurt", "bee_head_hurt_0", [0, 1, 2, 3, 4], ".png", 8, false, false, false);
		head.animation.play("head");
		head.parent = this;
		
		tail = new SpriteSegment(0, 0);
		tail.frames = tex;
		tail.animation.frameName = "bee_butt.png";
		tail.parent = this;
		
		wings = new SpriteSegment(0, 0);
		wings.frames = tex;
		wings.animation.addByIndices("wings", "bee_wing_0", [1, 2], ".png", 30, true,false, false);
		wings.animation.play("wings");
		wings.parent = this;
		
		wand = new SpriteSegment(0, 0);
		wand.frames = tex;
		wand.animation.frameName = "bee_wand.png";
		wand.isHitbox = false;
		wand.parent = this;
		
		
		body.x = hitbox.x + (hitbox.width / 2) - (body.width / 2);
		body.y = hitbox.y + (hitbox.height / 2) - (body.height / 2);
		
		tail.x = body.x - 4;
		tail.y = body.y + 11;
		
		head.x = body.x - 16;
		head.y = body.y - 21;
		
		wings.x = body.x - 13;
		wings.y = body.y - 5;
		
		wand.x = body.x + 30;
		wand.y = body.y - 11;
		
		baseHead = FlxPoint.get(-16, -21);
		baseTail = FlxPoint.get( -4, 11);
		baseWand = FlxPoint.get( 30, -11);
		
		trails = [];
		trails.push( new Trail(tail, Trail.STYLE_RAINBOW, .33));
		trails.push( new Trail(body, Trail.STYLE_RAINBOW, .33));
		trails.push( new Trail(head, Trail.STYLE_RAINBOW, .33));
		trails.push( new Trail(wand, Trail.STYLE_RAINBOW, .33));
		
		cast(FlxG.state, PlayState).lyrTrails.add(trails[0]);
		cast(FlxG.state, PlayState).lyrTrails.add(trails[1]);
		cast(FlxG.state, PlayState).lyrTrails.add(trails[2]);
		cast(FlxG.state, PlayState).lyrTrails.add(trails[3]);
		
		add(tail);
		add(wand);
		add(body);
		add(wings);
		add(head);
		
		shootFrom = FlxPoint.get(wand.x + 12, wand.y + 7);
		
		//FlxTween.linearMotion(head, head.x, head.y, head.x + 2, head.y - 4, .5, true, {type:FlxTween.PINGPONG, ease:FlxEase.sineInOut});
		FlxTween.num(0, 1, .33, {type:FlxTween.PINGPONG, ease:FlxEase.sineInOut}, bounce);
	}
	
	public function hit():Void
	{
		if (flickering)
			return;
		flicker(1);
		head.animation.play("hurt", true);
	}
	
	private function bounce(Value:Float):Void
	{
		head.x = body.x +  baseHead.x + ((2 * Value)-1) + ((velocity.x / maxVelocity.x)* 2);
		head.y = body.y + baseHead.y + Math.abs(( -3 * Value) + 1.5) + ((velocity.y / maxVelocity.y)*3);
		
		tail.x = body.x + baseTail.x + (( -2 * Value) + 1) - ((velocity.x / maxVelocity.x)*2);
		tail.y = body.y + baseTail.y + -Math.abs(( 3 * Value) - 1.5) - ((velocity.y / maxVelocity.y) * 3);
		
		wand.x = body.x + baseWand.x + (( -2 * Value) + 1) - ((velocity.x / maxVelocity.x) * 2);
		wand.y = body.y + baseWand.y + -Math.abs(( 3 * Value) - 1.5) - ((velocity.y / maxVelocity.y) * 3);
		
	}
	
	override public function update(elapsed:Float):Void 
	{
		
		super.update(elapsed);
		
		if (head.animation.name != "head" && head.animation.finished)
			head.animation.play("head");

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