package;

import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.group.FlxSpriteGroup;
import flixel.util.FlxColor;

class Player extends FlxSpriteGroup 
{

	public var hitbox:FlxSprite;
	public var body:FlxSprite;
	public var head:FlxSprite;
	public var wings:FlxSprite;
	public var tail:FlxSprite;
	
	public function new() 
	{
		super();
		hitbox = new FlxSprite(0);
		hitbox.makeGraphic(8, 8, FlxColor.BLUE);
		add(hitbox);
		
		width = 8;
		height = 8;
		
		drag.set(800, 800);
		maxVelocity.set(200, 200);
		
		body = new FlxSprite(0, 0);
		
		body.frames = GraphicsCache.loadGraphicFromAtlas("bee-body", AssetPaths.bee_body__png, AssetPaths.bee_body__xml).atlasFrames;
		body.animation.addByIndices("body", "sp_bee_body_", [0, 1, 2, 3], ".png", 12, true, true, false);
		body.animation.play("body");
		body.setFacingFlip(FlxObject.LEFT, true, false);
		
		
		head = new FlxSprite(0, 0);
		head.frames = GraphicsCache.loadGraphicFromAtlas("bee-head", AssetPaths.bee_head__png, AssetPaths.bee_head__xml).atlasFrames;
		head.animation.addByIndices("head", "sp_bee_head_", [0, 1, 2, 3], ".png", 12, true, true, false);
		head.animation.play("head");
		head.setFacingFlip(FlxObject.LEFT, true, false);
		
		tail = new FlxSprite(0, 0);
		tail.frames = GraphicsCache.loadGraphicFromAtlas("bee-tail", AssetPaths.bee_tail__png, AssetPaths.bee_tail__xml).atlasFrames;
		tail.animation.addByIndices("tail", "sp_bee_tail_", [0], ".png", 12, true, true, false);
		tail.animation.play("tail");
		tail.setFacingFlip(FlxObject.LEFT, true, false);
		
		wings = new FlxSprite(0, 0);
		wings.frames = GraphicsCache.loadGraphicFromAtlas("bee-wings", AssetPaths.bee_wing__png, AssetPaths.bee_wing__xml).atlasFrames;
		wings.animation.addByIndices("wings", "sp_bee_wing_", [0, 1], ".png", 30, true, true, false);
		wings.animation.play("wings");
		wings.setFacingFlip(FlxObject.LEFT, true, false);
		
		
		body.x = hitbox.x + (hitbox.width / 2) - (body.width / 2);
		body.y = hitbox.y + (hitbox.height / 2) - (body.height / 2);
		
		tail.x = body.x - 6;
		tail.y = body.y + 2;
		
		head.x = body.x + 2;
		head.y = body.y - 6;
		
		wings.x = body.x + 3;
		wings.y = body.y - 4;
		
		
		add(tail);
		add(body);
		add(wings);
		add(head);
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