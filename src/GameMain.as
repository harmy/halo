package
{
	import flash.display.Sprite;
	
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
			addChild(new Main);				
		}
	}
}