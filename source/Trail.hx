package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.system.FlxAssets.FlxGraphicAsset;
import flixel.util.FlxColor;
import flixel.util.FlxSpriteUtil;
import openfl.display.BitmapData;
import openfl.display.BitmapDataChannel;
import openfl.geom.Point;
import openfl.geom.Rectangle;


class Trail extends FlxSprite
{

	public static inline var STYLE_NONE:Int = 0;
	public static inline var STYLE_RAINBOW:Int = 1;
	public static inline var STYLE_SCARY:Int = 2;
	
	private var target:FlxSprite;
	private var style:Int;
	private var hue:Float = 0;
	private var timer:Float = 0;
	private var alphaMod:Float = 1;
	private var added:Bool = false;
	
	public function new(Target:FlxSprite, Style:Int = STYLE_NONE, AlphaMod:Float = 1) 
	{
		super();
		target = Target;
		style = Style;
		hue = 0;
		timer = 0;
		alphaMod = AlphaMod;
		
		revive();
		
	}
	
	override public function updateFramePixels():BitmapData 
	{
		if (target != null && target.alive && target.exists)
		{

			var bmp:BitmapData;

			bmp = target.updateFramePixels().clone();
			if (bmp != null && bmp.width != 0 && bmp.height != 0)
			{
				
				var color:FlxColor=0x0;
				switch (style) 
				{
					case STYLE_SCARY:
						color = 0xff990000;
					case STYLE_RAINBOW:
						color = FlxColor.fromHSB(hue, 1, 1);
					case STYLE_NONE:
						color = 0x0;
				}
				
				var p:BitmapData = new BitmapData(bmp.width, bmp.height, true, 0);
				
				if (style == STYLE_NONE)
				{
					p.copyPixels(bmp, bmp.rect, _flashPointZero);
				}
				else
				{
					p.fillRect(p.rect, color);	
					p.copyChannel(bmp, new Rectangle(0, 0, p.width, p.height), new Point(), BitmapDataChannel.ALPHA, BitmapDataChannel.ALPHA);
				}
				
				return p;
				
			}
		}
		return null;
	}
	
	override public function update(elapsed:Float):Void 
	{
		
		if (!alive || !exists)
			return;
			
		if (!added)
		{
			cast(FlxG.state, PlayState).lyrTrails.add(this);
			//PlayState.lyrTrails.add(this);
			
			added = true;
		}
		if (style == STYLE_RAINBOW)
		{
			timer -= elapsed;
			if (timer <= 0)
			{
				timer = .012;
				hue+= elapsed * 200;
				if (hue > 360)
					hue-= 360;	
			}
		}
		
		if (target != null && target.alive && target.exists)
		{	
			alpha = alphaMod;
			x = target.x - target.offset.x;
			y = target.y - target.offset.y;
			super.update(elapsed);
		}
		else
			kill();
		
		
	}
	
	override public function revive():Void 
	{
		timer = 0;
		hue = 0;
		
		added = false;
		
		super.revive();
	}
	
}