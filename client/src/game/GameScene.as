package game
{
	import com.cokecode.halo.anim.ActionParam;
	import com.cokecode.halo.anim.AnimMgr;
	import com.cokecode.halo.anim.Animation;
	import com.cokecode.halo.anim.AnmPlayer;
	import com.cokecode.halo.anim.Model;
	import com.cokecode.halo.controller.BaseCameraCtrl;
	import com.cokecode.halo.controller.BasePlayerCtrl;
	import com.cokecode.halo.data.EACTION;
	import com.cokecode.halo.events.MapEvent;
	import com.cokecode.halo.magic.MagicConst;
	import com.cokecode.halo.magic.MagicMgr;
	import com.cokecode.halo.object.CharLooks;
	import com.cokecode.halo.object.CharMgr;
	import com.cokecode.halo.object.Charactor;
	import com.cokecode.halo.terrain.Map;
	import com.cokecode.halo.terrain.layers.GroundLayer;
	import com.cokecode.halo.terrain.layers.Layer;
	import com.cokecode.halo.terrain.layers.ParallaxLayer;
	import com.cokecode.halo.terrain.layers.SortLayer;
	import com.furusystems.dconsole2.DConsole;
	
	import de.nulldesign.nd2d.display.Node2D;
	import de.nulldesign.nd2d.display.Scene2D;
	import de.nulldesign.nd2d.display.Sprite2D;
	
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.ui.Keyboard;
	
	import game.magic.MagicTest;

	
	public class GameScene extends Scene2D
	{
		protected var mHero:Charactor;
		protected var mHeroCtrl:BasePlayerCtrl;
		protected var mMap:Map;
		protected var mCameraCtrl:BaseCameraCtrl;
		
		public function GameScene()
		{
			super();
			addEventListener(Event.ADDED_TO_STAGE, onAddToStage);
			
			// 初始化一些控制命令
			DConsole.createCommand("move", moveCommand, "halo", "主角移动到某个坐标");
			DConsole.createCommand("magic", magicCommand, "halo", "魔法测试");
			DConsole.createCommand("delmagic", delMagic, "halo", "主角手动删除魔法测试");
			DConsole.createCommand("speed", speedCommand, "halo", "调整主角移动速度");
			DConsole.createCommand("action", actionCommand, "halo", "播放主角指定动作");
			
			AnimMgr.instance.init("Z:/res/charactor/");
			
			// 主角第一个加入节点(必须先更新主角)
			mHeroCtrl = new BasePlayerCtrl(null);
			addChild( mHeroCtrl ); 
			
			// 相机要第二个加入节点
			mCameraCtrl = new BaseCameraCtrl();
			addChild( mCameraCtrl ); 
			
			// 创建测试地图
			mMap = Map.instance;
			mMap.addEventListener(MapEvent.LOAD_COMPLETE, onMapLoad);
			mMap.setMapPath("Z:/res/maps/");
			mMap.load("1.tmx");
			addChild(mMap);		
			
			MagicTest.instance().init();	
			
			//注册层到魔法管理器
			MagicMgr.instance.registerLayer(mMap.getLayer(MagicConst.STR_LAYER_BEFOR), 
				mMap.getLayer(MagicConst.STR_LAYER_AFTER));		
		}
		
		
		public function onMapLoad(evt:MapEvent):void
		{
			mCameraCtrl.mapSize.x = evt.width;
			mCameraCtrl.mapSize.y = evt.height;
			
			// 创建测试角色
			var uid:uint = 0;
			for (var i:uint=0; i<200 * 1; ++i) {
				var char:Charactor = new Charactor(new CharLooks);
				char.x = int(Math.random() * 120);
				char.y = int(Math.random() * 120);
				
				char.x = char.x * 64;
				char.y = char.y * 32;
				
				char.dir = 1;
				
				var anmPlayer:AnmPlayer = char.anmPlayer;
				var model:Model = AnimMgr.instance.getModel("human");
				anmPlayer.model = model;
				anmPlayer.playAnim(EACTION.ATTACK);
				char.setNameText("我是玩家");
				char.id = ++uid;
				
				//char.x = char.y = 0;
				
				var layer:SortLayer = mMap.getLayer("sort") as SortLayer;
				
				
				if (i == 0) {
					// 主角
					char.x = 100 * 64;
					char.y = 100 * 32;
					
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
					mHero.playAnim(EACTION.STAND);
					mHero.controller = mHeroCtrl;
					mHeroCtrl.gameObject = mHero;
				} else {
					// 其他玩家
					char.controller = new BasePlayerCtrl(char);
					char.controller.initAction();
				}
				
				if ( CharMgr.instance.addChar(char, CharLooks.HUMAN) ) {
					layer.addChild( char );	
				} else {
					// 释放角色数据
				}
			}
		}
		
		
		
		// ------------------ 调试用的命令 ------------------
		
		public function speedCommand(speed:uint):void
		{
			mHero.moveSpeed = speed;
			//AnmPlayer.FLANIMFPS = speed;
			//trace("设置主角速度: " + speed);
		}
		
		public function magicCommand(magicId:uint, num:uint = 1):void
		{
			for (var i:uint = 0; i<num; ++i) {
				MagicMgr.instance.addMagic(magicId, 8 * Math.random(), mHero.getStr(), 
					mHero.x, mHero.y, "dest", mHero.x + 500, mHero.y - 100);
			}
		}
		
		public function delMagic(magicId:uint, num:uint = 1):void
		{
			mHero.delMagic(magicId);
		}
		
		public function moveCommand(targetX:Number, targetY:Number):void
		{
			var ctrl:BasePlayerCtrl = mHero.controller as BasePlayerCtrl;
			ctrl.gotoPosByAutoPath(targetX, targetY);
		}
		
		public function actionCommand(actionName:String):void
		{
			mHero.playAnim(actionName);
		}
		
		
		
		// -----------------------------------------------------
		
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
			stage.addEventListener(MouseEvent.MOUSE_UP, onMouseUp);
		}
		
		public function onMouseUp(evt:MouseEvent):void
		{
			var worldX:Number = (evt.stageX + camera.x) / Map.sTileWidth;
			var worldY:Number = (evt.stageY + camera.y) / Map.sTileHeight;
			mHeroCtrl.gotoPosByAutoPath(worldX, worldY);
			//trace("鼠标: " + worldX + "," + worldY);
		}
		
		public function onKeyDown(evt:KeyboardEvent):void
		{
			var STEPX:Number = 64;
			var STEPY:Number = 32;
			if (evt.keyCode == Keyboard.SPACE) {
				// 模拟震屏效果
				mCameraCtrl.shake(BaseCameraCtrl.SHAKE_Y, 6, 700, 100);
			} else if(evt.keyCode == Keyboard.C) {
				// 切换相机跟踪目标
				if (mCameraCtrl.target == null) mCameraCtrl.target = mHero;
				else mCameraCtrl.target = null;
			} else if(evt.keyCode == Keyboard.Q) {
				// 切换主角方向
				if (mHero) {
					mHero.dir++;
					if (mHero.dir >= 8) mHero.dir = 0;
				}
			} 

			if (mHero.x < 0) mHero.x = 0;
			if (mHero.y < 0) mHero.y = 0;
			if (mHero.x > mMap.mapWidth) mHero.x = mMap.mapWidth;
			if (mHero.y > mMap.mapHeight) mHero.y = mMap.mapHeight;
			
			/*var cellX:uint = mHero.x / Map.sTileWidth;
			var cellY:uint = mHero.y / Map.sTileHeight;
			if ( mMap.getBlock(cellX, cellY) == 1 ) {
				// 阻挡信息
				mHero.anmPlayer.tint = 0xFF0000;
				mHero.anmPlayer.alpha = 1;
			} else if ( mMap.getBlock(cellX, cellY) == 2 ) {
				// 透明信息
				mHero.anmPlayer.tint = 0xFFFFFF;
				mHero.anmPlayer.alpha = 0.5;
			} else {
				// 可走信息
				mHero.anmPlayer.tint = 0xFFFFFF;
				mHero.anmPlayer.alpha = 1;
			}*/
		}
		
		override protected function step(elapsed:Number):void
		{
			var ground:GroundLayer = mMap.getLayer("ground") as GroundLayer;
			
			if (ground == null) return;
			
//			trace("------------- begin -----------");
			//trace("角色位置: " + mHero.x/64 + "," + mHero.y/32);
			//trace("相机位置: " + camera.x + "," + camera.y);
			//trace("地图位置: " + mMap.x + "," + mMap.y);
			//trace("地表位置: " + ground.x + "," + ground.y);
//			trace("------------- end -----------");
		}
	}
}




