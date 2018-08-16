package;

import com.catalystapps.gaf.core.ZipToGAFAssetConverter;
import com.catalystapps.gaf.data.GAFBundle;
import com.catalystapps.gaf.data.GAFTimeline;
import com.catalystapps.gaf.display.GAFMovieClip;
import openfl.events.ErrorEvent;
import openfl.events.Event;
import openfl.net.URLLoader;
import openfl.net.URLRequest;
import openfl.utils.ByteArray;
import starling.display.Sprite;
import starling.events.Touch;
import starling.events.TouchEvent;
import starling.events.TouchPhase;

/**
 * ...
 * @author andrew
 */
class SimpleGame extends Sprite 
{

	public function new() 
	{
		super();
		
		init();
	}
	
	function init() 
	{
		var file:String = "mini_game.zip";
		var path:String = "assets/" + file;
		
		var loader = new URLLoader();
		loader.dataFormat = "binary";
		loader.addEventListener(Event.COMPLETE, onComplete);
#if flash
		loader.load(new URLRequest(path));
#else
		loader.load(new URLRequest("http://localhost:2000/" + path));
#end
	}
	
	function onComplete(e:Event)
	{
		var byteArray:ByteArray = cast(cast(e.target, URLLoader).data, ByteArray);
		
		convert(byteArray);
	}
	
	function convert(zip:ByteArray) 
	{
        var converter : ZipToGAFAssetConverter = new ZipToGAFAssetConverter();
        converter.addEventListener(Event.COMPLETE, onConverted);
        converter.addEventListener(ErrorEvent.ERROR, onError);
		
		converter.convert(zip, 1, 1);
	}
	
	function onConverted(event:Event)
	{
		trace("onConverted");
		
		var gafBundle: GAFBundle = cast(event.target, ZipToGAFAssetConverter).gafBundle;
		var gafTimeline: GAFTimeline = gafBundle.getGAFTimeline("mini_game");
		var mc: GAFMovieClip = new GAFMovieClip(gafTimeline);
		
		addChild(mc);
		mc.play(true);
		
		initController(mc);
	}
	
	function initController(mc:GAFMovieClip)
	{
		var rocket: GAFMovieClip;
		var rocketAnimation: GAFMovieClip;
		for (i in 0...4) 
		{
			rocketAnimation = cast(mc.get("Rocket_with_guide" + (i + 1)));
			rocket = cast(rocketAnimation.get("Rocket" + (i + 1)));
			
			rocket.addEventListener(TouchEvent.TOUCH, onTouch);
			rocket.setSequence("idle");
		}
	}
	
	function onTouch(event:TouchEvent)
	{
		var touch: Touch = event.getTouch(this, TouchPhase.BEGAN);
		if (touch != null)
		{
			var rocket: GAFMovieClip = cast(event.currentTarget, GAFMovieClip);
			rocket.setSequence("explode");
			rocket.touchable = false;
			rocket.addEventListener(GAFMovieClip.EVENT_TYPE_SEQUENCE_END, onRocketExploded);
			
			cast(rocket.parent, GAFMovieClip).stop();
		}
	}

	function onRocketExploded(event: Dynamic)
	{
		var rocket: GAFMovieClip = Reflect.field(event, "currentTarget");
		rocket.removeEventListener(GAFMovieClip.EVENT_TYPE_SEQUENCE_END, onRocketExploded);
		rocket.setSequence("idle");
		rocket.touchable = true;
		
		cast(rocket.parent, GAFMovieClip).gotoAndPlay(1);
	}
	
	
	function onError(event:ErrorEvent)
	{
		trace("GAF Error:" + event);
	}
}