package core.cursor
{
//	import Client.Setting;
//	
//	import Lib.Texture.SWFSafeLoader;
//	import Lib.Version.FileVersion;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.geom.Point;
	import flash.system.ApplicationDomain;
	import flash.ui.Mouse;
	import flash.ui.MouseCursor;
	import flash.ui.MouseCursorData;
	
	//import mx.managers.CursorManager;
	
	public class NativeCursor
	{
		public static const LEFT_TOP:uint = 0;	// 左上角
		public static const CENTER:uint = 1;		// 中心点
		public static const TOP_CENTER:uint = 2;	// 上面的中心
		
		//private static var m_safeLoader:SWFSafeLoader = new SWFSafeLoader(); 
		private static var mDomain:ApplicationDomain;
		private static var mIsLoaded:Boolean = false;
		
		public function NativeCursor()
		{
			
		}
		
		/**
		 * 加载并初始化鼠标文件
		 */
		public static function Init():void
		{
			// 加载新手引导的flash文件
			//var url:String = Setting.Assets_Path + "mouse.swf";
			//url = FileVersion.getFileName(url);
			//m_safeLoader = new SWFSafeLoader;
			//m_safeLoader.safeLoad(url, OnLoadSwfFinish, errorHandler);
		}
		
		private static function OnLoadSwfFinish(evt:Event):void
		{
//			if (m_safeLoader.contentLoaderInfo != null) {
//				m_domain = m_safeLoader.contentLoaderInfo.applicationDomain;
//				InitMouseCursor();
//				m_isLoaded = true;
//				UseNormalMouse();
//			}
		}
		
		private static function InitMouseCursor():void
		{
			createMouseData("nomove", "nomove");
			createMouseData("sell", "sell");
			createMouseData("talk", "talk");
			createMouseData("attack", "attack");
			createMouseData("noattack", "noattack");
			createMouseData("pick", "pick");
			createMouseData("nopick", "nopick");
			createMouseData("repair", "repair", TOP_CENTER);
			createMouseData("norepair", "norepair", TOP_CENTER);
			createMouseData("normal", "normal");
			createMouseData("splite", "splite");
			createMouseData("nosplite", "nosplite");
		}
		
		/**
		 * 通过名字指定当前鼠标
		 */
		public static function SetCursor(name:String):void
		{
			if (!mIsLoaded) return;
			
			Mouse.cursor = name;
		}
		
		/**
		 * 无法捡取
		 */
		public static function UseNoPickMouse():void
		{
			SetCursor("nopick");
		}
		
		/**
		 * 无法移动
		 */
		public static function UseNoMoveMouse():void
		{
			SetCursor("nomove");
		}
		
		/**
		 * 可以出售
		 */
		public static function UseSellMouse():void
		{
			SetCursor("sell");
		}
		
		/**
		 * NPC对话
		 */
		public static function UseTalkMouse():void
		{
			SetCursor("talk");
		}
		
		/**
		 * 可以攻击
		 */
		public static function UseAttackMouse():void
		{
			SetCursor("attack");
		}
		
		/**
		 * 可以捡取
		 */
		public static function UsePickMouse():void
		{
			SetCursor("pick");
		}
		
		/**
		 * 可以修理
		 */
		public static function UseRepairMouse():void
		{
			SetCursor("repair");
		}
		
		/**
		 * 无法修理
		 */
		public static function UseNoRepairMouse():void
		{
			SetCursor("norepair");
		}
		
		/**
		 * 正常鼠标
		 */
		public static function UseNormalMouse():void
		{
			//SetCursor(MouseCursor.AUTO);
			SetCursor("normal");
		}
		
		/**
		 * 拆分物品
		 */
		public static function UseSpliteMouse():void
		{
			SetCursor("splite");
		}
		
		/**
		 * 无法拆分物品
		 */
		public static function UseNoSpliteMouse():void
		{
			SetCursor("nosplite");
		}

		/**
		 * 创建鼠标动画组
		 */
		private static function createMouseData(name:String, className:String, hotSpot:uint = LEFT_TOP):void
		{
			var cursorData:MouseCursorData = new MouseCursorData();
			var vecBitmap:Vector.<BitmapData> = new Vector.<BitmapData>();
			var cursorClass:Class;
			var cursorBitmap:BitmapData;
			var classFullName:String;
			var imgW:uint;
			var imgH:uint;
			
			// 创建鼠标动画组
			for (var i:uint=1; i<=10; ++i) {
				classFullName = className + "_" + i;
				cursorClass = getClass(classFullName);
				if (cursorClass == null) break;
				cursorBitmap = new cursorClass();
				vecBitmap.push(cursorBitmap);
				imgW = cursorBitmap.width;
				imgH = cursorBitmap.height;
			}
			
			if (vecBitmap.length == 0) {
				cursorData = null;
				vecBitmap = null;
				return;
			}
			
			cursorData.data = vecBitmap;
			
			if (hotSpot == LEFT_TOP) {
				cursorData.hotSpot = new Point(0,0)
			} else if (hotSpot == CENTER) {
				cursorData.hotSpot = new Point(imgW/2,imgH/2)
			}
			
			Mouse.registerCursor(name, cursorData)
		}
		
		private static function errorHandler(evt:IOErrorEvent):void
		{
			
		}
		
		private static function getClass(name:String):Class
		{
			if(mDomain == null)
				return null;
			
			var assetClass:* = null;
			try {
				assetClass = mDomain.getDefinition(name);	
			} catch(error:Error) {
				trace(error.message);
				return null;
			}
			
			return assetClass;
		}
		
	}
}