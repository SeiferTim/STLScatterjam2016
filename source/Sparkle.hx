package;

import flixel.FlxG;
import flixel.effects.particles.FlxParticle;

class Sparkle extends FlxParticle 
{

	public function new() 
	{
		super();
		
		loadGraphic(AssetPaths.stars__png, true, 8,8);
		animation.frameIndex = FlxG.random.int(0, 5);
		
	}
	
	override public function onEmit():Void 
	{
		
		var s:Float = 1 + (FlxG.random.int(1, 10) * .25);
		scale.set(s, s);
		cast(FlxG.state, PlayState).lyrTopTrails.add(this);
		super.onEmit();
	}
	
	
}