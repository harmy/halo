package game
{
	import de.nulldesign.nd2d.display.Scene2D;
	
	import game.magic.*;
	
	public class GameScene extends Scene2D
	{
		public function GameScene()
		{
			super();			
			MagicMgr.instance().parent(this);
			MagicMgr.instance().init();
		}
		
		protected override function step(elapsed:Number):void
		{		
			MagicMgr.instance().update(elapsed);
		}
	}
}


