package openfl.display;

import flixel.FlxG;
import openfl.display.Shader;
import openfl.filters.ShaderFilter;
import openfl.system.System;
import openfl.text.TextField;
import openfl.text.TextFormat;
import flixel.FlxState;
import song.Conductor;

class FPS extends TextField
{
	/**
		The current frame rate, expressed using frames-per-second
	**/
	public var currentFPS(default, null):UInt;

	var peak:UInt = 0;

	@:noCompletion private var cacheCount:Int;
	@:noCompletion private var currentTime:Float;
	@:noCompletion private var times:Array<Float>;

	public function new(x:Float = 10, y:Float = 10, color:Int = 0x000000)
	{
		super();

		this.x = x;
		this.y = y;

		currentFPS = 0;
		selectable = false;
		mouseEnabled = false;
		defaultTextFormat = new TextFormat("_sans", 16, color);
		text = "FPS: ";

		cacheCount = 0;
		currentTime = 0;
		times = [];

		autoSize = LEFT;
		backgroundColor = 0;

		#if flash
		addEventListener(Event.ENTER_FRAME, function(e)
		{
			var time = Lib.getTimer();
			__enterFrame(time - currentTime);
		});
		#end

		width = 350;
	}

	// Event Handlers
	@:noCompletion
	private #if !flash override #end function __enterFrame(deltaTime:Float):Void
	{
		currentTime += deltaTime;
		times.push(currentTime);

		while (times[0] < currentTime - 1000)
		{
			times.shift();
		}

		var currentCount = times.length;
		currentFPS = Math.round((currentCount + cacheCount));

		text = "";

		text += "FPS: " + currentFPS + "\n";

		var mem = System.totalMemory;
		if (mem > peak)
			peak = mem;

		text += "MEM: " + getSizeLabel(System.totalMemory) + "\n";
		text += "MEM Peak: " + getSizeLabel(peak) + "\n";
		text += 'Current BPM: ${Conductor.bpm}' + "\n";
        text += 'Current state: ${Type.getClassName(Type.getClass(FlxG.state))}' + "\n";
		text += 'Nb Cameras: ${FlxG.cameras.list.length}' + "\n";
		text += 'System: ${lime.system.System.platformLabel} ${lime.system.System.platformVersion}' + "\n";
        text += 'Objs in State: ${FlxG.state.members.length}' + "\n";
	}

	final dataTexts = ["B", "KB", "MB", "GB", "TB", "PB"];

	function getSizeLabel(num:UInt):String
	{
		var size:Float = num;
		var data = 0;
		while (size > 999 && data < dataTexts.length - 1)
		{
			data++;
			size = size / 999;
		}

		size = Math.round(size * 100) / 100;

		if (data <= 2)
			size = Math.round(size);

		return size + " " + dataTexts[data];
	}
}
