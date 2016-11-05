package;
import flixel.FlxBasic;
import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.FlxSubState;
import flixel.group.FlxGroup;
import flixel.group.FlxSpriteGroup;
import flixel.input.FlxInput.FlxInputState;
import flixel.input.gamepad.FlxGamepad;
import flixel.input.gamepad.FlxGamepadInputID;
import flixel.input.keyboard.FlxKey;
import flixel.math.FlxPoint;
import flixel.ui.FlxButton;
import flixel.util.FlxArrayUtil;
import flixel.util.FlxDestroyUtil;

class UIControl
{
	
	
	static public var DEFAULT_KEYS_JUMP:FlxKey = X;
	static public var DEFAULT_KEYS_SHOOT:FlxKey = C;
	static public var DEFAULT_KEYS_PAUSE:FlxKey = P;
	static public var DEFAULT_KEYS_VOL_UP:FlxKey = NUMPADPLUS;
	static public var DEFAULT_KEYS_VOL_DOWN:FlxKey = NUMPADMINUS;
	static public var DEFAULT_KEYS_VOL_MUTE:FlxKey = NUMPADZERO;
	static public var DEFAULT_KEYS_UP:FlxKey = UP;
	static public var DEFAULT_KEYS_DOWN:FlxKey = DOWN;
	static public var DEFAULT_KEYS_LEFT:FlxKey = LEFT;
	static public var DEFAULT_KEYS_RIGHT:FlxKey = RIGHT;
	
	static inline public var KEY_JUMP:Int = 0;
	static inline public var KEY_SHOOT:Int = 1;
	static inline public var KEY_PAUSE:Int =2;
	static inline public var KEY_VOL_UP:Int = 3;
	static inline public var KEY_VOL_DOWN:Int = 4;
	static inline public var KEY_VOL_MUTE:Int = 5;
	static inline public var KEY_UP:Int = 6;
	static inline public var KEY_DOWN:Int = 7;
	static inline public var KEY_LEFT:Int = 8;
	static inline public var KEY_RIGHT:Int = 9;
	
	static public var KEY_BINDS:Array<FlxKey>;
	
	static public var DEFAULT_BTNS_JUMP:FlxGamepadInputID = A;
	static public var DEFAULT_BTNS_SHOOT:FlxGamepadInputID = B;
	static public var DEFAULT_BTNS_PAUSE:FlxGamepadInputID = START;
	static public var DEFAULT_BTNS_VOL_UP:FlxGamepadInputID = NONE;
	static public var DEFAULT_BTNS_VOL_DOWN:FlxGamepadInputID = NONE;
	static public var DEFAULT_BTNS_VOL_MUTE:FlxGamepadInputID = NONE;
	static public var DEFAULT_BTNS_UP:FlxGamepadInputID = DPAD_UP;
	static public var DEFAULT_BTNS_DOWN:FlxGamepadInputID = DPAD_DOWN;
	static public var DEFAULT_BTNS_LEFT:FlxGamepadInputID = DPAD_LEFT;
	static public var DEFAULT_BTNS_RIGHT:FlxGamepadInputID = DPAD_RIGHT;
	
	static public var BTN_BINDS:Array<FlxGamepadInputID>;
	
	static public var keyDelay:Float = 0;
	
	static public inline var KEY_DELAY_BIG:Float = 0.5;
	static public inline var KEY_DELAY_SMALL:Float = 0.05;
	
	public static var controls:Array<FlxButton>;	
	public static var currentControl:Int = -1;
	private static var finger:FlxSprite;
	//private static var keyDelay:Float = 0;
	public static var mouseless:Bool = false;
	public static var hasGamepad:Bool = false;
	private static var triggered:Float = .66;
	private static var _group:FlxSpriteGroup;
	public static var initialized:Bool = false;
	#if !FLX_NO_GAMEPAD
	public static var gamepad:FlxGamepad = null;
	public static var analogPressed:Array<Bool>;
	#end
	#if !FLX_NO_MOUSE
	private static var mousePos:FlxPoint;
	#end
	
	static public function init(Controls:Array<FlxButton>, ?substate:FlxSubState, ?Group:FlxSpriteGroup):Void
	{
		if (initialized)
			return;
		
		controls = Controls;
		
		_group = Group;
		
		if (finger == null)
		{
			finger = new FlxSprite();
			//finger.loadGraphic(AssetPaths.ui_cursor__png, true, 5, 7);
			finger.makeGraphic(5, 7);
			finger.animation.add("blink", [0, 1], 5, true);
			finger.animation.play("blink");
			finger.setFacingFlip(FlxObject.LEFT, true, false);
			finger.setFacingFlip(FlxObject.RIGHT, false, false);
			finger.scrollFactor.set();
		}
		finger.visible = false;
		if (_group != null)
			_group.add(finger);
		else if (substate != null)
			substate.add(finger);
		else
			FlxG.state.add(finger);
			
		#if FLX_NO_MOUSE
		mouseless = true;
		#end
		
		#if !FLX_NO_GAMEPAD
		analogPressed = [false, false, false, false];
		#end
		
		
		keyDelay = 0;
		
		currentControl = -1;
		if (mouseless && controls.length > 0)
		{
			startMouselessControls(true);
		}
		else if (!mouseless)
		{
			#if !FLX_NO_MOUSE
			FlxG.mouse.visible = true;
			#end
		}
		initialized = true;
		
		
	}
	
	static public function startMouselessControls(force:Bool = false):Void
	{
		if (mouseless && !force)
			return;
		if (controls != null)
		{
			for (c in controls)
			{
				c.locked = true;
			}
		}
		#if !FLX_NO_MOUSE
		mousePos = FlxPoint.get(FlxG.mouse.x, FlxG.mouse.y);
		#end
		mouseless = true;
		nextControl();
		#if !FLX_NO_MOUSE
		FlxG.mouse.visible = false;
		#end
		
	}
	
	static public function stopMouselessControls():Void
	{
		#if FLX_NO_MOUSE
		mouseless = true;
		#else
		if (!mouseless)
			return;
		if (controls != null)
		{
			for (c in controls)
			{
				c.locked = false;
			}
		}
		mouseless = false;
		deselectControl();
		FlxG.mouse.visible = true;
		#end
		
	}
	
	static public function deselectControl():Void
	{
		if (currentControl > -1 && currentControl < controls.length)
		{		
			var c:FlxButton = controls[currentControl];
			if (c != null)
			{
				c.status = FlxButton.NORMAL;
			}
		}
		clearControl();
		
	}
	
	static public function selectControl(ID:Int):Void
	{
		deselectControl();
		if (ID <= -1 || ID >= controls.length)
			return;
		var c:FlxButton = controls[ID];
		if (c != null)
		{
			if (c.x < 10)
			{
				// right side
				finger.facing = FlxObject.LEFT;
				finger.x = Std.int(c.x + c.width + 1);
				finger.y = Std.int(c.y + (c.height / 2) - (finger.height / 2));
				finger.visible = true;
			}
			else
			{
				// left side
				finger.facing = FlxObject.RIGHT;
				finger.x = Std.int(c.x - finger.width - 1);
				finger.y = Std.int(c.y + (c.height / 2) - (finger.height / 2));
				finger.visible = true;
			}
			c.status = FlxButton.HIGHLIGHT;
			currentControl = ID;
			finger.visible = true;
			
		}
		else
		{
			finger.visible = false;
			currentControl = -1;
		}
	}
	
	static public function unload():Void
	{
		if (!initialized)
			return;
		controls = null;
		clearControl();
		finger = FlxDestroyUtil.destroy(finger);
		initialized = false;
	}
	
	static public function clearControl():Void
	{
		currentControl = -1;
		finger.visible = false;
	}
	
	static public function nextControl():Void
	{
		var startID:Int = currentControl;
		var cNo:Int = currentControl;
		var c:FlxButton = null;
		if (controls.length == 0)
		{
			clearControl();
		}
		else
		{
			do
			{
				cNo++;
				if (cNo >= controls.length)
				{
					cNo = 0;
				}
				if (cNo >= 0)
				{
					c = controls[cNo];
				}
				
			} while (cNo != startID && !(c.visible && c.alive && c.active && c.exists));
			if (cNo >= -1 && cNo < controls.length)
			{
				selectControl(cNo);
			}
			else if (startID >= 0 && startID < controls.length)
			{
				selectControl(startID);
			}
		}
	}
	
	static public function previousControl():Void
	{
		var startID:Int = currentControl;
		var cNo:Int = currentControl;
		var c:FlxButton = null;
		if (controls.length == 0)
		{
			clearControl();
		}
		else
		{
			do
			{
				cNo--;
				if (cNo < 0)
				{
					cNo = controls.length-1;
				}
				if (cNo < controls.length)
				{
					c = controls[cNo];
				}
				
			} while (cNo != startID && !(c.visible && c.alive && c.active && c.exists));
			if (cNo >= -1 && cNo < controls.length)
			{
				selectControl(cNo);
			}
			else if (startID >= 0 && startID < controls.length)
			{
				selectControl(startID);
			}
		}
	}
	
	static private function fixButtonStates():Void
	{
		for (c in 0...controls.length)
		{
			if (controls[c] != null)
			{
				if (controls[c].status == FlxButton.PRESSED)
				{
					if (c == currentControl)
					{
						controls[c].status = FlxButton.HIGHLIGHT;
					}
					else
					{
						controls[c].status = FlxButton.NORMAL;
					}
				}
			}
		}
	}
	
	static private function scroll():Void
	{
		if (_group != null && currentControl > -1 &&  currentControl < controls.length && controls[currentControl] != null)
		{
			var c:FlxButton = controls[currentControl];
			if (c.y+c.height >= FlxG.height-12)
				_group.y -= 2;
			else if (c.y <= 12)
				_group.y += 2;
		}
	}
	
	static public function getCurrentControl():FlxButton
	{
		if (currentControl < 0 || currentControl >= controls.length || !initialized)
			return null;
		return controls[currentControl];
	}
	
	static public function checkControls(elapsed:Float):Void
	{
		if (!initialized)
			return;
			
		if (keyDelay > 0)
		{
			keyDelay -= elapsed;
		}
		
		if (triggered > 0)
		{
			triggered -= elapsed;
		}
		scroll();
		
		checkSoundKeys(elapsed);
		
		checkGamepad();
		#if !FLX_NO_MOUSE
		if (mouseless)
		{
			if (mousePos.x != FlxG.mouse.x || mousePos.y != FlxG.mouse.y)
			{
				stopMouselessControls();
			}
		}
		#end
		var leftJPressed:Bool = wasJustPressed([KEY_LEFT, KEY_UP]); 
		var rightJPressed:Bool = wasJustPressed([KEY_RIGHT, KEY_DOWN]); 
		var leftPressed:Bool = isPressed([KEY_LEFT, KEY_UP]); 
		var rightPressed:Bool = isPressed([KEY_RIGHT, KEY_DOWN]);
	
		if (isPressed([KEY_SHOOT, KEY_JUMP]))
		{
			if (!mouseless)
				startMouselessControls();
			else
				pressButton();
			return;
		}
		if (wasJustReleased([KEY_SHOOT, KEY_JUMP]))
		{
			if (!mouseless)
				startMouselessControls();
			else
				triggerControl();
			return;
		}
		if (controls.length > 0 && mouseless)
		{
			fixButtonStates();
			
		}
		
		if ((leftPressed || leftJPressed) && (rightPressed || rightJPressed))
		{
			startMouselessControls();
			return;
		}
		else if (leftJPressed)
		{
			if (!mouseless)
				startMouselessControls();
			else
				previousControl();
			keyDelay = KEY_DELAY_BIG;
		}
		else if (leftPressed && keyDelay<=0)
		{
			if (!mouseless)
				startMouselessControls();		
			else
				previousControl();			
			keyDelay = KEY_DELAY_SMALL;
			
		}
		else if (rightJPressed)
		{
			if (!mouseless)
				startMouselessControls();
			else
				nextControl();
			keyDelay = KEY_DELAY_BIG;
		}
		else if (rightPressed && keyDelay<=0)
		{
			if (!mouseless)
				startMouselessControls();
			else
				nextControl();
			keyDelay = KEY_DELAY_SMALL;
		}
		
		
		
	}
	
	static public function checkGamepad():Bool
	{
		#if !FLX_NO_GAMEPAD
		if (!hasGamepad)
		{
			//gamepad = FlxG.gamepads.firstActive;
			for (g in FlxG.gamepads.getActiveGamepads())
			{
				if (g != null && g.anyInput())
				{
					gamepad = g;
					hasGamepad = true;
					break;
					
				}
			}
			
		}
		else if (gamepad == null)
		{
			hasGamepad = false;
		}
		else
		{
			if (FlxG.gamepads.getByID(gamepad.id) == null)
			{
				hasGamepad = false;
				gamepad = null;
			}
		}
		
		
		
		
		#else
		gamepad = null;
		hasGamepad = false;
		#end
		
		return hasGamepad;
	}
		
	static public function isPressed(Commands:Array<Int>):Bool
	{
		var p:Bool = false;
		for (i in Commands)
		{
			p = FlxG.keys.checkStatus(KEY_BINDS[i], FlxInputState.PRESSED);
			if (p)
				break;
		}
		if (!p && hasGamepad)
		{
			
			for (i in Commands)
			{
				p = gamepad.checkStatus(BTN_BINDS[i], FlxInputState.PRESSED);
				if (p)
					break;
				switch(i)
				{
					case KEY_UP:
						if (gamepad.getYAxis(LEFT_ANALOG_STICK) <= -gamepad.deadZone)
						{
							p = true;
							analogPressed[0] = true;
						}
					case KEY_DOWN:
						if (gamepad.getYAxis(LEFT_ANALOG_STICK) >= gamepad.deadZone)
						{
							p = true;
							analogPressed[1] = true;
						}
					case KEY_LEFT:
						if (gamepad.getXAxis(LEFT_ANALOG_STICK) <= -gamepad.deadZone)
						{
							p = true;
							analogPressed[2] = true;
						}
					case KEY_RIGHT:
						if (gamepad.getXAxis(LEFT_ANALOG_STICK) >= gamepad.deadZone)
						{
							p = true;
							analogPressed[3] = true;
						}
					default:
						
				}
			}
			
		}
		return p;
	}
	
	static public function wasJustPressed(Commands:Array<Int>):Bool
	{
		var p:Bool = false;
		for (i in Commands)
		{
			p = FlxG.keys.checkStatus(KEY_BINDS[i], FlxInputState.JUST_PRESSED);
			if (p)
				break;
		}
		if (!p && hasGamepad)
		{
			
			for (i in Commands)
			{
				p = gamepad.checkStatus(BTN_BINDS[i], FlxInputState.JUST_PRESSED);
				if (p)
					break;
				switch(i)
				{
					case KEY_UP:
						if (gamepad.getYAxis(LEFT_ANALOG_STICK) <= -gamepad.deadZone)
						{
							if (!analogPressed[0])
								p = true;
							analogPressed[0] = true;
						}
					case KEY_DOWN:
						if (gamepad.getYAxis(LEFT_ANALOG_STICK) >= gamepad.deadZone)
						{
							if (!analogPressed[1])
								p = true;
							analogPressed[1] = true;
						}
					case KEY_LEFT:
						if (gamepad.getXAxis(LEFT_ANALOG_STICK) <= -gamepad.deadZone)
						{
							if (!analogPressed[2])
								p = true;
							analogPressed[2] = true;
						}
					case KEY_RIGHT:
						if (gamepad.getXAxis(LEFT_ANALOG_STICK) >= gamepad.deadZone)
						{
							if (!analogPressed[3])
								p = true;
							analogPressed[3] = true;
						}
					default:
						
				}
			}
			
		}
		return p;
	}
	
	static public function wasJustReleased(Commands:Array<Int>):Bool
	{
		var p:Bool = false;
		for (i in Commands)
		{
			p = FlxG.keys.checkStatus(KEY_BINDS[i], FlxInputState.JUST_RELEASED);
			if (p)
				break;
		}
		if (!p && hasGamepad)
		{
			
			for (i in Commands)
			{
				p = gamepad.checkStatus(BTN_BINDS[i], FlxInputState.JUST_RELEASED);
				if (p)
					break;
				switch(i)
				{
					case KEY_UP:
						if (!(gamepad.getYAxis(LEFT_ANALOG_STICK) <= -gamepad.deadZone))
						{
							if (analogPressed[0])
								p = true;
							analogPressed[0] = false;
						}
					case KEY_DOWN:
						if (!(gamepad.getYAxis(LEFT_ANALOG_STICK) >= gamepad.deadZone))
						{
							if (analogPressed[1])
								p = true;
							analogPressed[1] = false;
						}
					case KEY_LEFT:
						if (!(gamepad.getXAxis(LEFT_ANALOG_STICK) <= -gamepad.deadZone))
						{
							if (analogPressed[2])
								p = true;
							analogPressed[2] = false;
						}
					case KEY_RIGHT:
						if (!(gamepad.getXAxis(LEFT_ANALOG_STICK) >= gamepad.deadZone))
						{
							if (analogPressed[3])
								p = true;
							analogPressed[3] = false;
						}
					default:
						
				}
			}
			
		}
		return p;
	}
	
	static public function pressButton():Void
	{
		if (currentControl != -1 && triggered <= 0)
		{
			var c:FlxButton = controls[currentControl];
			if (c.status == FlxButton.HIGHLIGHT && c.visible && c.active && c.exists && c.alive)
			{
				c.status = FlxButton.PRESSED;
				c.draw();
			}
		}
	}
	
	static public function triggerControl():Void
	{
		if (currentControl != -1 && triggered <= 0)
		{
			var c:FlxButton = controls[currentControl];
			if (c.status == FlxButton.PRESSED && c.visible && c.active && c.exists && c.alive)
			{
				c.status = FlxButton.HIGHLIGHT;
				c.draw();
				c.onUp.fire();
				
				triggered = KEY_DELAY_SMALL;
			}
		}
	}
	
	static public function initKeys():Void
	{
		KEY_BINDS = [];
		BTN_BINDS = [];
		
		if (Globals.Save.data.keys == null)
			Globals.Save.data.keys = new Array<FlxKey>();

		if (Globals.Save.data.keys.up != null)
			KEY_BINDS[KEY_UP] = Globals.Save.data.keys.up;
		else
			KEY_BINDS[KEY_UP] = DEFAULT_KEYS_UP;
			
		if (Globals.Save.data.keys.down!= null)
			KEY_BINDS[KEY_DOWN] = Globals.Save.data.keys.down;
		else
			KEY_BINDS[KEY_DOWN] = DEFAULT_KEYS_DOWN;
			
		if (Globals.Save.data.keys.left != null)
			KEY_BINDS[KEY_LEFT] = Globals.Save.data.keys.left;
		else
			KEY_BINDS[KEY_LEFT] = DEFAULT_KEYS_LEFT;
			
		if (Globals.Save.data.keys.right != null)
			KEY_BINDS[KEY_RIGHT] = Globals.Save.data.keys.right;
		else
			KEY_BINDS[KEY_RIGHT] = DEFAULT_KEYS_RIGHT;
		
		if (Globals.Save.data.keys.jump != null)
			KEY_BINDS[KEY_JUMP] = Globals.Save.data.keys.jump;
		else
			KEY_BINDS[KEY_JUMP] = DEFAULT_KEYS_JUMP;
			
		if (Globals.Save.data.keys.shoot != null)
			KEY_BINDS[KEY_SHOOT] = Globals.Save.data.keys.shoot;
		else
			KEY_BINDS[KEY_SHOOT] = DEFAULT_KEYS_SHOOT;
			
		if (Globals.Save.data.keys.pause != null)
			KEY_BINDS[KEY_PAUSE] = Globals.Save.data.keys.pause;
		else
			KEY_BINDS[KEY_PAUSE] = DEFAULT_KEYS_PAUSE;
		
		if (Globals.Save.data.keys.vol_up != null)
			KEY_BINDS[KEY_VOL_UP] = Globals.Save.data.keys.vol_up;
		else
			KEY_BINDS[KEY_VOL_UP] = DEFAULT_KEYS_VOL_UP;
			
		if (Globals.Save.data.keys.vol_down != null)
			KEY_BINDS[KEY_VOL_DOWN] = Globals.Save.data.keys.vol_down;
		else
			KEY_BINDS[KEY_VOL_DOWN] = DEFAULT_KEYS_VOL_DOWN;
			
		if (Globals.Save.data.keys.vol_mute != null)
			KEY_BINDS[KEY_VOL_MUTE] = Globals.Save.data.keys.vol_mute;
		else
			KEY_BINDS[KEY_VOL_MUTE] = DEFAULT_KEYS_VOL_MUTE;
		
		FlxG.sound.muteKeys = null;
		FlxG.sound.volumeDownKeys = null;
		FlxG.sound.volumeUpKeys = null;
		
		#if !FLX_NO_GAMEPAD
		if (Globals.Save.data.btns == null)
			Globals.Save.data.btns = new Array<FlxKey>();

		if (Globals.Save.data.btns.up != null)
			BTN_BINDS[KEY_UP] = Globals.Save.data.btns.up;
		else
			BTN_BINDS[KEY_UP] = DEFAULT_BTNS_UP;
			
		if (Globals.Save.data.btns.down!= null)
			BTN_BINDS[KEY_DOWN] = Globals.Save.data.btns.down;
		else
			BTN_BINDS[KEY_DOWN] = DEFAULT_BTNS_DOWN;
			
		if (Globals.Save.data.btns.left != null)
			BTN_BINDS[KEY_LEFT] = Globals.Save.data.btns.left;
		else
			BTN_BINDS[KEY_LEFT] = DEFAULT_BTNS_LEFT;
			
		if (Globals.Save.data.btns.right != null)
			BTN_BINDS[KEY_RIGHT] = Globals.Save.data.btns.right;
		else
			BTN_BINDS[KEY_RIGHT] = DEFAULT_BTNS_RIGHT;
		
		if (Globals.Save.data.btns.jump != null)
			BTN_BINDS[KEY_JUMP] = Globals.Save.data.btns.jump;
		else
			BTN_BINDS[KEY_JUMP] = DEFAULT_BTNS_JUMP;
			
		if (Globals.Save.data.btns.shoot != null)
			BTN_BINDS[KEY_SHOOT] = Globals.Save.data.btns.shoot;
		else
			BTN_BINDS[KEY_SHOOT] = DEFAULT_BTNS_SHOOT;
			
		if (Globals.Save.data.btns.pause != null)
			BTN_BINDS[KEY_PAUSE] = Globals.Save.data.btns.pause;
		else
			BTN_BINDS[KEY_PAUSE] = DEFAULT_BTNS_PAUSE;
		
		if (Globals.Save.data.btns.vol_up != null)
			BTN_BINDS[KEY_VOL_UP] = Globals.Save.data.btns.vol_up;
		else
			BTN_BINDS[KEY_VOL_UP] = DEFAULT_BTNS_VOL_UP;
			
		if (Globals.Save.data.btns.vol_down != null)
			BTN_BINDS[KEY_VOL_DOWN] = Globals.Save.data.btns.vol_down;
		else
			BTN_BINDS[KEY_VOL_DOWN] = DEFAULT_BTNS_VOL_DOWN;
			
		if (Globals.Save.data.btns.vol_mute != null)
			BTN_BINDS[KEY_VOL_MUTE] = Globals.Save.data.btns.vol_mute;
		else
			BTN_BINDS[KEY_VOL_MUTE] = DEFAULT_BTNS_VOL_MUTE;
		#end
		
	}
	
	
	static public function resetKeys():Void
	{
		KEY_BINDS[KEY_UP] = DEFAULT_KEYS_UP;
		KEY_BINDS[KEY_DOWN] = DEFAULT_KEYS_DOWN;
		KEY_BINDS[KEY_LEFT] = DEFAULT_KEYS_LEFT;
		KEY_BINDS[KEY_RIGHT] = DEFAULT_KEYS_RIGHT;
		KEY_BINDS[KEY_JUMP] = DEFAULT_KEYS_JUMP;
		KEY_BINDS[KEY_SHOOT] = DEFAULT_KEYS_SHOOT;
		KEY_BINDS[KEY_PAUSE] = DEFAULT_KEYS_PAUSE;
		KEY_BINDS[KEY_VOL_UP] = DEFAULT_KEYS_VOL_UP;
		KEY_BINDS[KEY_VOL_DOWN] = DEFAULT_KEYS_VOL_DOWN;
		KEY_BINDS[KEY_VOL_MUTE] = DEFAULT_KEYS_VOL_MUTE;
		
	}
	
	static public function saveKeys():Void
	{
		Globals.Save.data.keys.up = KEY_BINDS[KEY_UP];
		Globals.Save.data.keys.down = KEY_BINDS[KEY_DOWN];
		Globals.Save.data.keys.left = KEY_BINDS[KEY_LEFT];
		Globals.Save.data.keys.right = KEY_BINDS[KEY_RIGHT];
		Globals.Save.data.keys.jump = KEY_BINDS[KEY_JUMP];
		Globals.Save.data.keys.shoot = KEY_BINDS[KEY_SHOOT];
		Globals.Save.data.keys.pause = KEY_BINDS[KEY_PAUSE];
		Globals.Save.data.keys.vol_up = KEY_BINDS[KEY_VOL_UP];
		Globals.Save.data.keys.vol_down = KEY_BINDS[KEY_VOL_DOWN];
		Globals.Save.data.keys.vol_mute = KEY_BINDS[KEY_VOL_MUTE];
		Globals.flushSave();
	}
	
	static public function resetBtns():Void
	{
		BTN_BINDS[KEY_UP] = DEFAULT_BTNS_UP;
		BTN_BINDS[KEY_DOWN] = DEFAULT_BTNS_DOWN;
		BTN_BINDS[KEY_LEFT] = DEFAULT_BTNS_LEFT;
		BTN_BINDS[KEY_RIGHT] = DEFAULT_BTNS_RIGHT;
		BTN_BINDS[KEY_JUMP] = DEFAULT_BTNS_JUMP;
		BTN_BINDS[KEY_SHOOT] = DEFAULT_BTNS_SHOOT;
		BTN_BINDS[KEY_PAUSE] = DEFAULT_BTNS_PAUSE;
		BTN_BINDS[KEY_VOL_UP] = DEFAULT_BTNS_VOL_UP;
		BTN_BINDS[KEY_VOL_DOWN] = DEFAULT_BTNS_VOL_DOWN;
		BTN_BINDS[KEY_VOL_MUTE] = DEFAULT_BTNS_VOL_MUTE;
		
	}
	
	static public function saveBtns():Void
	{
		Globals.Save.data.btns.up = BTN_BINDS[KEY_UP];
		Globals.Save.data.btns.down = BTN_BINDS[KEY_DOWN];
		Globals.Save.data.btns.left = BTN_BINDS[KEY_LEFT];
		Globals.Save.data.btns.right = BTN_BINDS[KEY_RIGHT];
		Globals.Save.data.btns.jump = BTN_BINDS[KEY_JUMP];
		Globals.Save.data.btns.shoot = BTN_BINDS[KEY_SHOOT];
		Globals.Save.data.btns.pause = BTN_BINDS[KEY_PAUSE];
		Globals.Save.data.btns.vol_up = BTN_BINDS[KEY_VOL_UP];
		Globals.Save.data.btns.vol_down = BTN_BINDS[KEY_VOL_DOWN];
		Globals.Save.data.btns.vol_mute = BTN_BINDS[KEY_VOL_MUTE];
		Globals.flushSave();
	}
	
	static public function checkSoundKeys(elapsed:Float):Void
	{
		if (keyDelay > 0)
		{
			keyDelay -= elapsed;
		}
		
		if (wasJustReleased([KEY_VOL_MUTE])) 
			FlxG.sound.toggleMuted();
		
		if (wasJustPressed([KEY_VOL_DOWN])) 
		{
			keyDelay = KEY_DELAY_BIG;
			//volumeFX -= 0.1;
			//volumeMusic -= 0.1;
		}
		else if (isPressed([KEY_VOL_DOWN]))
		{
			if (keyDelay <= 0)
			{
				keyDelay = KEY_DELAY_SMALL;
				//volumeFX -= 0.1;
				//volumeMusic -= 0.1;
			}
		}
		else if (wasJustPressed([KEY_VOL_UP]))
		{
			keyDelay = KEY_DELAY_BIG;
			//volumeFX += 0.1;
			//volumeMusic += 0.1;
		}
		else if (isPressed([KEY_VOL_UP]))
		{
			if (keyDelay <= 0)
			{
				keyDelay = KEY_DELAY_SMALL;
				//volumeFX += 0.1;
				//volumeMusic += 0.1;
			}
		}
		
	}

	
}