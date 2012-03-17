package
{
	import flash.display.Sprite;
	import flash.display3D.Context3DRenderMode;	
	import game.GameWorld;
	
	/**
	 * 游戏入口
	 * */
	public class GameMain extends Sprite
	{
		public function GameMain()
		{			
			init();
		}		
		
		/**
		 * 建立游戏世界
		 * */
		private function init():void
		{
			addChild(new GameWorld(Context3DRenderMode.AUTO, 60));
		}
	}
}