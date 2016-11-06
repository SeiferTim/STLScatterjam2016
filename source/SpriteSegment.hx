package;

import flixel.FlxSprite;
import flixel.group.FlxSpriteGroup;
import flixel.system.FlxAssets.FlxGraphicAsset;

class SpriteSegment extends FlxSprite 
{

	public var parent:FlxTypedSpriteGroup<SpriteSegment>;
	public var isHitbox:Bool = false;
	public var zOrder:Float = 0;
	
}