package game
{
	import com.cokecode.halo.anim.ActionParam;
	import com.cokecode.halo.anim.AnimMgr;
	import com.cokecode.halo.anim.Animation;
	import com.cokecode.halo.anim.AnmPlayer;
	import com.cokecode.halo.anim.Model;
	import com.cokecode.halo.controller.BaseCameraCtrl;
	import com.cokecode.halo.events.MapEvent;
	import com.cokecode.halo.magic.MagicConst;
	import com.cokecode.halo.magic.MagicMgr;
	import com.cokecode.halo.object.CharLooks;
	import com.cokecode.halo.object.CharMgr;
	import com.cokecode.halo.object.Charactor;
	import com.cokecode.halo.terrain.Map;
	import com.cokecode.halo.terrain.layers.Layer;
	import com.cokecode.halo.terrain.layers.ParallaxLayer;
	import com.cokecode.halo.terrain.layers.SortLayer;
	
	import de.nulldesign.nd2d.display.Node2D;
	import de.nulldesign.nd2d.display.Scene2D;
	import de.nulldesign.nd2d.display.Sprite2D;
	
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.ui.Keyboard;
	
	import game.magic.MagicTest;

	
	public class GameScene extends Scene2D
	{
		protected var mHero:Charactor;
		//protected var mTargetNode:Node2D;
		protected var mMap:Map;
		protected var mParLayer:ParallaxLayer;
		protected var mAniMgr:AnimMgr;
		protected var mCameraCtrl:BaseCameraCtrl;
		
		public function GameScene()
		{
			super();
			addEventListener(Event.ADDED_TO_STAGE, onAddToStage);
			
			AnimMgr.sInstance.init("Z:/res/charactor/");
			
			// 相机要第一个加入节点
			mCameraCtrl = new BaseCameraCtrl();
			addChild( mCameraCtrl ); 
			
			// 创建测试地图
			mMap = new Map();
			mMap.addEventListener(MapEvent.LOAD_COMPLETE, onMapLoad);
			mMap.setMapPath("Z:/res/maps/");
			mMap.load("1.tmx");
			addChild(mMap);			
			mParLayer = mMap.getLayer("parallax") as ParallaxLayer;
			
			// 创建测试角色
			var uid:uint = 0;
			for (var i:uint=0; i<100 * 1; ++i) {
				var char:Charactor = new Charactor(null);
				//char.charView = GameAssets.createChar();
				char.x = int(Math.random() * 40);
				char.y = int(Math.random() * 44);
				
				char.x = char.x * 64;
				char.y = char.y * 32;
				
				char.dir = 1;
				
				
				var anmPlayer:AnmPlayer = char.getAnmPlayer();
				var model:Model = AnimMgr.sInstance.getModel("human");
				var anim:Animation = AnimMgr.sInstance.getAnim("human", "attack", null);
				anmPlayer.setModel(model);
				anmPlayer.setAnimation(anim);
				char.setNameText("我是玩家");
				char.id = ++uid;
				
				//char.x = char.y = 0;
				
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
					
					//char.charView.tint = 0x00FF00;
					//char.alpha = 0.3;
					mHero = char;
					mCameraCtrl.target = mHero;
					CharMgr.instance.hero = char;
				}
				
				if ( CharMgr.instance.addChar(char, CharLooks.HUMAN) ) {
					layer.addChild( char );	
				} else {
					// 释放角色数据
				}
				
				
			}
			
			MagicTest.instance().init();	
			
			//注册到魔法管理器
			MagicMgr.instance().register(mMap.getLayer(MagicConst.STR_LAYER_BEFOR), 
				mMap.getLayer(MagicConst.STR_LAYER_AFTER), mHero);		
		}
		
		public function onMapLoad(evt:MapEvent):void
		{
			mCameraCtrl.mapSize.x = evt.width;
			mCameraCtrl.mapSize.y = evt.height;
		}
		
		public function get map():Map
		{
			return mMap;
		}

		public function set map(value:Map):void
		{
			mMap = value;
		}

		public function onAddToStage(evt:Event):void
		{
			stage.addEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
		}
		
		public function onKeyDown(evt:KeyboardEvent):void
		{
			var STEPX:Number = 64;
			var STEPY:Number = 32;
			if (evt.keyCode == Keyboard.LEFT) {
				if (mHero) {
					mHero.dir = 6;
					mHero.x -= STEPX;
				}
			} else if (evt.keyCode == Keyboard.RIGHT) {
				if (mHero) {
					mHero.dir = 2;
					mHero.x += STEPX;
				}
			} else if (evt.keyCode == Keyboard.UP) {
				if (mHero) {
					mHero.dir = 0;
					mHero.y -= STEPY;
				}
			} else if (evt.keyCode == Keyboard.DOWN) {
				if (mHero) {
					mHero.dir = 4;
					mHero.y += STEPY;
				}
			} else if (evt.keyCode == Keyboard.SPACE) {
				// 模拟震屏效果
				//camera.shake(Camera.SHAKE_Y, 6, 700, 100);
				if (mCameraCtrl.target == null) mCameraCtrl.target = mHero;
				else mCameraCtrl.target = null;
			} else if(evt.keyCode == Keyboard.NUMBER_1) {
				MagicMgr.instance().addMagic(1, 8 * Math.random(), "src", mHero.x, mHero.y, "dest", mHero.x + 500, mHero.y - 100);	
			} else if(evt.keyCode == Keyboard.NUMBER_2) {
				MagicMgr.instance().addMagic(2, 8 * Math.random(), "src", mHero.x, mHero.y, "dest", mHero.x + 500, mHero.y - 100);	
			} else if(evt.keyCode == Keyboard.NUMBER_3) {
				MagicMgr.instance().addMagic(3, 8 * Math.random(), "src", mHero.x, mHero.y, "dest", mHero.x + 500, mHero.y - 100);	
			} else if(evt.keyCode == Keyboard.NUMBER_4) {
				MagicMgr.instance().addMagic(4, 8 * Math.random(), "src", mHero.x, mHero.y, "dest", mHero.x + 500, mHero.y - 100);	
			} else if(evt.keyCode == Keyboard.NUMBER_5) {
				MagicMgr.instance().addMagic(5, 8 * Math.random(), "src", mHero.x, mHero.y, "dest", mHero.x + 500, mHero.y - 100);	
			} else if(evt.keyCode == Keyboard.NUMBER_6) {
				MagicMgr.instance().addMagic(6, 8 * Math.random(), "src", mHero.x, mHero.y, "dest", mHero.x + 500, mHero.y - 100);	
			} else if(evt.keyCode == Keyboard.NUMBER_7) {
				MagicMgr.instance().addMagic(7, 8 * Math.random(), "src", mHero.x, mHero.y, "dest", mHero.x + 500, mHero.y - 100);	
			} else if(evt.keyCode == Keyboard.NUMBER_8) {
				MagicMgr.instance().addMagic(8, 8 * Math.random(), "src", mHero.x, mHero.y, "dest", mHero.x + 500, mHero.y - 100);	
			} else if(evt.keyCode == Keyboard.NUMBER_9) {
				MagicMgr.instance().addMagic(9, 8 * Math.random(), "src", mHero.x, mHero.y, "dest", mHero.x + 500, mHero.y - 100);	
			} else if(evt.keyCode == Keyboard.NUMBER_0) {
				MagicMgr.instance().addMagic(0, 8 * Math.random(), "src", mHero.x, mHero.y, "dest", mHero.x + 500, mHero.y - 100);	
			} else if(evt.keyCode == Keyboard.Q) {
				// 切换主角方向
				if (mHero) {
					mHero.dir++;
					if (mHero.dir >= 8) mHero.dir = 0;
				}
			} else if(evt.keyCode == Keyboard.W) {
				// 切换主角到跑步动作
				var anim:Animation = AnimMgr.sInstance.getAnim("human", "run", null);
				mHero.getAnmPlayer().setAnimation(anim);
			}
			

			if (mHero.x < 0) mHero.x = 0;
			if (mHero.y < 0) mHero.y = 0;
			if (mHero.x > mMap.mapWidth) mHero.x = mMap.mapWidth;
			if (mHero.y > mMap.mapHeight) mHero.y = mMap.mapHeight;
			
			var cellX:uint = mHero.x / Map.sTileWidth;
			var cellY:uint = mHero.y / Map.sTileHeight;
			if ( mMap.getBlock(cellX, cellY) == 1 ) {
				// 阻挡信息
				mHero.charView.tint = 0xFF0000;
				mHero.charView.alpha = 1;
			} else if ( mMap.getBlock(cellX, cellY) == 2 ) {
				// 透明信息
				mHero.charView.tint = 0xFFFFFF;
				mHero.charView.alpha = 0.5;
			} else {
				// 可走信息
				mHero.charView.tint = 0xFFFFFF;
				mHero.charView.alpha = 1;
			}
		}
		
		override protected function step(elapsed:Number):void
		{
//			trace("------------- begin -----------");
//			trace("角色位置：" + mHero.x + "," + mHero.y);
//			trace("相机位置：" + camera.x + "," + camera.y);
//			trace("------------- end -----------");
		}
	}
}




