package;

import flixel.FlxSprite;
import flixel.system.FlxAssets.FlxGraphicAsset;
import flixel.util.FlxColor;
import flixel.util.FlxDestroyUtil;

class EBullet extends FlxSprite 
{
	public var trail:Trail;
	public function new() 
	{
		super();
		
		var tex = GraphicsCache.loadGraphicFromAtlas("ebullet", AssetPaths.ebullet_sprites__png, AssetPaths.ebullet_sprites__xml).atlasFrames;
		frames = tex;
		animation.addByIndices("shoot", "enemy_bullet_0", [0, 1, 2, 3], ".png", 12, true);
		
		
		//makeGraphic(20, 20, FlxColor.GREEN);
		//loadGraphic(AssetPaths.player_bullet__png, true, 24, 24);
		//offset.set(2, 2);
		//width = 20;
		//height = 20;
		//animation.add("spin", [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11], 24, true);
		
		
		kill();
	}
	
	override public function update(elapsed:Float):Void 
	{
		if (!alive || !exists)
			return;
		
		if (!isOnScreen())
		{
			kill();
			return;
		}
		
		super.update(elapsed);
		trail.update(elapsed);
	}
	
	public function shoot(X:Float = 0, Y:Float = 0,  XVelocity:Float = 0, YVelocity:Float = 0, Angle:Float = 0 ):Void
	{
		reset(X, Y);
		//bulletType = BulletType;
		animation.play("shoot");
		velocity.set(XVelocity, YVelocity);
		angle = Angle;
		//animation.play("spin");
		if (trail == null)
			trail = new Trail(this, Trail.STYLE_NONE, .4);
		
		trail.revive();
	}
	
	
	override public function kill():Void 
	{
		if (!alive)
			return;
		if (trail != null)
			trail.kill();
		super.kill();
	}
	
	override public function destroy():Void 
	{
		trail = FlxDestroyUtil.destroy(trail);
		super.destroy();
	}
	
}