package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.system.FlxAssets.FlxGraphicAsset;

class Death extends FlxSprite 
{

	public function new() 
	{
		super();
		
		var tex = GraphicsCache.loadGraphicFromAtlas("enemy-death", AssetPaths.death_sprites__png, AssetPaths.death_sprites__xml).atlasFrames;
		frames = tex;
		
		animation.addByIndices("gray", "enemy_blob_death_gray_0", [0, 1, 2, 3, 4], ".png", 12, false, false, false);
		animation.addByIndices("green", "enemy_blob_death_green_0", [0, 1, 2, 3, 4], ".png", 12, false, false, false);
		animation.addByIndices("orange", "enemy_blob_death_orange_0", [0, 1, 2, 3, 4], ".png", 12, false, false, false);
		
		//kill();
	}
	
	public function spawn(X:Float, Y:Float, EnemyType:Int):Void
	{
		reset(X - (width / 2), Y - (height / 2));
		if (EnemyType == 4)
			EnemyType = FlxG.random.int(0, 3);
		switch (EnemyType) 
		{
			case 0:
				animation.play("gray",true);
			case 1:
				animation.play("green",true);
			case 2:
				animation.play("orange",true);
			case 3:
				animation.play("orange",true);
				
		}
	}
	
	override public function update(elapsed:Float):Void 
	{
		if (!alive || !exists)
			return;
		if (animation.finished)
			kill();
		super.update(elapsed);
	}
}