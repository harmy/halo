package 
{

	import com.cokecode.halo.resmgr.ResMgr;
	import com.cokecode.halo.terrain.layers.Layer;
	import com.furusystems.dconsole2.DConsole;
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
	
		
		public function GameWorld()
		{			
			super(Context3DRenderMode.AUTO, 60);
			
			// 设置资源加载器的参数
			ResMgr.instance.init(5, 10);
			
			setActiveScene( new GameScene() );
			
			// 添加性能分析图
			addChild(mStats);
			
			// 添加性能分析工具
			var miner:TheMiner = new TheMiner;
			//addChild(miner);
			
			//ResMgr.addInspector(stage);
			
			addChild(DConsole.view);
			DConsole.console.createCommand("block", blockCommand, "halo", "显示/隐藏阻挡信息");


			
			if(sInstance != null)
			{
				throw new Error("this class should be instantiated only one time");
			}
			
			sInstance = this;
		}
		
		public function blockCommand():void
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


