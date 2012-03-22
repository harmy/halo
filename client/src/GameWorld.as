package 
{

	import com.cokecode.halo.terrain.layers.Layer;
	import com.cokecode.halo.ui.Console;
	import com.sociodox.theminer.TheMiner;
	
	import de.nulldesign.nd2d.display.World2D;
	
	import flash.display.Scene;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.display3D.Context3DRenderMode;
	import flash.events.Event;
	import flash.geom.Rectangle;

	
	import game.GameScene;
	
	import net.hires.debug.Stats;
	
	/**
	 * 游戏世界类
	 * */
	public final class GameWorld extends World2D
	{
		private static var sInstance:GameWorld;
		
		protected var mStats:Stats = new Stats();
		public var mConsole:Console = new Console;
	
		
		public function GameWorld()
		{			
			super(Context3DRenderMode.AUTO, 60);
			setActiveScene( new GameScene() );
			
			// 添加性能分析图
			addChild(mStats);
			//mStats.visible =false;
			
			// 添加性能分析工具
			var miner:TheMiner = new TheMiner;
			//addChild(miner);

			addChild(mConsole);
			//mConsole.showConsole();
			mConsole.addCommand("block", blockCommand);

			
			if(sInstance != null)
			{
				throw new Error("this class should be instantiated only one time");
			}
			
			sInstance = this;
		}
		
		public function blockCommand(objectName:String, paramName:String, paramValue:String):void
		{
			var gamescene:GameScene = scene as GameScene;
			var layer:Layer = gamescene.map.getLayer("block");
			if (layer) layer.visible = !layer.visible;
		}
		
		public static function instance():World2D
		{
			return sInstance;
		}
		
		override protected function addedToStage(event:Event):void
		{
			super.addedToStage(event);
			
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.align = StageAlign.TOP_LEFT;
			enableErrorChecking = false;
		
			start();
		}
		
		override protected function context3DCreated(e:Event):void
		{
			
			super.context3DCreated(e);
			
			if (context3D)
			{
				mStats.driverInfo = context3D.driverInfo;
			}
		}
		
		override protected function mainLoop(e:Event):void
		{
			super.mainLoop(e);
			mStats.update(statsObject.totalDrawCalls, statsObject.totalTris);
		}
		
	}
}


