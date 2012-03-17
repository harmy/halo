package game
{
	import de.nulldesign.nd2d.display.World2D;
	
	import flash.geom.Rectangle;
	
	/**
	 * 游戏世界类
	 * */
	public final class GameWorld extends World2D
	{
		private static var sInstance:GameWorld;
		
		public function GameWorld(renderMode:String, frameRate:uint=60, bounds:Rectangle=null, stageID:uint=0)
		{			
			super(renderMode, frameRate, bounds, stageID);
			
			if(sInstance != null)
			{
				throw new Error("this class should be instantiated only one time");
			}
			
			sInstance = this;
		}
		
		public static function instance():World2D
		{
			return sInstance;
		}
	}
}


