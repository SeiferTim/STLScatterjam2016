package;

import flixel.FlxG;
import flixel.effects.particles.FlxEmitter;
import flixel.effects.particles.FlxParticle;

class Burst extends FlxTypedEmitter<Sparkle> 
{

	public function new() 
	{
		super(0, 0, 20);
		
		launchMode = FlxEmitterMode.CIRCLE;
		speed.set(100, 600);
		lifespan.set(.05, .25);
		angle.set(0, 360);
		alpha.set(.33, .8);
		for (i in 0...20)
		{
			add(new Sparkle());
		}
		
	}

}