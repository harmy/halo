package game
{
	import com.cokecode.halo.object.Charactor;
	import com.cokecode.halo.terrain.Map;
	import com.cokecode.halo.terrain.layers.SortLayer;
	
	import de.nulldesign.nd2d.display.Scene2D;
	import de.nulldesign.nd2d.display.Sprite2D;
	
	import game.magic.MagicTest;
	
	public class GameScene extends Scene2D
	{
		protected var mMap:Map;
		
		public function GameScene()
		{
			super();
			MagicTest.instance().init();
			
			GameAssets.initGameRes();
			
			// 创建测试地图
			mMap = new Map();
			addChild(mMap);
			MagicTest.instance().parent(mMap.getLayer("magic_after"));
			
			// 创建测试角色			
			for (var i:uint=0; i<200 * 1; ++i) {
				var char:Charactor = new Charactor(null);
				char.charView = GameAssets.createChar();
				char.x = Math.random() * 1280;
				char.y = Math.random() * 700;
				
				var layer:SortLayer = mMap.getLayer("sort") as SortLayer;
				layer.addChild( char );
				//addChild( char );
				
				if (i == 0) {
					//char.charView.color = 0x00FF00;
					//camera.traceObject = char;
				}
			}
		}
		
		protected override function step(elapsed:Number):void
		{	
			MagicTest.instance().update(elapsed);
		}
	}
}




