package game
{
	import com.cokecode.halo.object.Charactor;
	import com.cokecode.halo.terrain.Map;
	import com.cokecode.halo.terrain.layers.SortLayer;
	
	import de.nulldesign.nd2d.display.Node2D;
	import de.nulldesign.nd2d.display.Scene2D;
	import de.nulldesign.nd2d.display.Sprite2D;
	
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.ui.Keyboard;
	
	public class GameScene extends Scene2D
	{
		protected var mHero:Charactor;
		protected var mTargetNode:Node2D;
		protected var mMap:Map;
		
		public function GameScene()
		{
			super();
			
			addEventListener(Event.ADDED_TO_STAGE, onAddToStage);
			
			GameAssets.initGameRes();
			
			// 创建测试地图
			mMap = new Map();
			addChild(mMap);
			
			// 创建测试角色			
			for (var i:uint=0; i<1000 * 1; ++i) {
				var char:Charactor = new Charactor(null);
				char.charView = GameAssets.createChar(0);
				char.x = int(Math.random() * 1280 * 2);
				char.y = int(Math.random() * 700 * 2);
				
				var layer:SortLayer = mMap.getLayer("sort") as SortLayer;
				
				
				if (i == 0) {
//					// shadow
//					var charShadow:Charactor = new Charactor(null);
//					charShadow.charView = GameAssets.createChar(0);
//					//charShadow.scaleX = 1.5;
//					charShadow.alpha = 0.5;
//					charShadow.x = char.x;
//					charShadow.y = char.y;
//					charShadow.tint = 0x000000;
//					charShadow.rotationX = 60;
//					//charShadow.rotationZ = -5;
//					layer.addChild( charShadow );
//					
//					// mirror
//					var char2:Charactor = new Charactor(null);
//					char2.charView = GameAssets.createChar(0);
//					char2.charView.scaleY = -0.8;
//					char2.alpha = 0.4;
//					char2.x = char.x;
//					char2.y = char.y + 20;
//					layer.addChild( char2 );
					
					char.charView.tint = 0x00FF00;
					mTargetNode = mHero = char;
					//mTargetNode = char;
				}
				
				layer.addChild( char );
			}
			
		}
		
		public function onAddToStage(evt:Event):void
		{
			stage.addEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
		}
		
		public function onKeyDown(evt:KeyboardEvent):void
		{
			var STEP:Number = 20;
			if (evt.keyCode == Keyboard.LEFT) {
				if (mHero) mHero.x -= STEP;
			} else if (evt.keyCode == Keyboard.RIGHT) {
				if (mHero) mHero.x += STEP;
			} else if (evt.keyCode == Keyboard.UP) {
				if (mHero) mHero.y -= STEP;
			} else if (evt.keyCode == Keyboard.DOWN) {
				if (mHero) mHero.y += STEP;
			} else if (evt.keyCode == Keyboard.SPACE) {
				//camera.shake(Camera.SHAKE_Y, 6, 700, 100);
				if (mTargetNode == null) mTargetNode = mHero;
				else mTargetNode = null;
			}
			
//			var right:uint = mMap.mapWidth - mHero.width;
//			var bottom:uint = mMap.mapHeight - mHero.height;
//			if (mHero.x < 0) mHero.x = 0;
//			if (mHero.y < 0) mHero.y = 0;
//			if (mHero.x > right) mHero.x = right;
//			if (mHero.y > bottom) mHero.y = bottom;
		}
		
		override protected function step(elapsed:Number):void 
		{
			if(mTargetNode) {
				var tempX:uint = camera.sceneWidth * 0.5;
				var tempY:uint = camera.sceneHeight * 0.5;
				//camera.x += ((mTargetNode.x - tempX) - camera.x) * 0.5;
				//camera.y += ((mTargetNode.y - tempY) - camera.y) * 0.5;
				camera.x = mTargetNode.x - tempX;
				camera.y = mTargetNode.y - tempY;
				
				// 限制在地图之内
				var right:uint = mMap.mapWidth - camera.sceneWidth;
				var bottom:uint = mMap.mapHeight - camera.sceneHeight;
				if (camera.x < 0) camera.x = 0;
				if (camera.y < 0) camera.y = 0;
				if (camera.x > right) camera.x = right;
				if (camera.y > bottom) camera.y = bottom;
			}
			
			
			//trace("相机位置：" + camera.x + "," + camera.y);
		}
		
	}
}