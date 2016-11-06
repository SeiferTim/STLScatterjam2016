package;

import flixel.FlxSprite;
import flixel.system.FlxAssets.FlxGraphicAsset;

class HealthIcon extends FlxSprite 
{

	public function new(?X:Float=0, ?Y:Float=0) 
	{
		super(X, Y);
		loadGraphic(AssetPaths.health__png, true, 48, 48);
		width = 44;
		offset.x = 2;
		animation.add("full", [0]);
		animation.add("empty", [1]);
		animation.play("full");
		
	}
	
}