package;

import openfl.display.Sprite;
import openfl.Lib;
import openfl.geom.Rectangle;
import starling.core.Starling;

/**
 * ...
 * @author andrew
 */
class Main extends Sprite 
{
	private var _starling: Starling;

	public function new() 
	{
		super();
		
		init();
	}
	
	function init() 
	{
		_starling = new Starling(SimpleGame, stage, new Rectangle(0, 0, Lib.current.stage.stageWidth, Lib.current.stage.stageHeight));
		_starling.showStats = true;
		_starling.start();
	}

}
