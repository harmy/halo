package game.magic
{	
	import de.nulldesign.nd2d.display.Node2D;
	import de.nulldesign.nd2d.display.Scene2D;
	import de.nulldesign.nd2d.display.Sprite2D;
	import de.nulldesign.nd2d.display.Sprite2DBatch;
	import de.nulldesign.nd2d.materials.texture.SpriteSheet;
	import de.nulldesign.nd2d.materials.texture.Texture2D;
	import de.nulldesign.nd2d.materials.texture.TextureAtlas;
	
	/**
	 *魔法管理器，对外提供调用接口
	 */	
	public final class MagicMgr
	{		
		[Embed(source="Z:/res/magic/test/jiguang.png")]
		protected var jiguang_png:Class;
		
		[Embed(source="Z:/res/magic/test/jiguang.plist", mimeType="application/octet-stream")]
		protected var jiguang_plist:Class;
		
		[Embed(source="Z:/res/magic/test/xhq_shifang.png")]
		protected var xhq_shifang_png:Class;
		
		[Embed(source="Z:/res/magic/test/xhq_shifang.plist", mimeType="application/octet-stream")]
		protected var xhq_shifang_plist:Class;
		
		[Embed(source="Z:/res/magic/test/xhq_feixing.png")]
		protected var xhq_feixing_png:Class;
		
		[Embed(source="Z:/res/magic/test/xhq_feixing.plist", mimeType="application/octet-stream")]
		protected var xhq_feixing_plist:Class;
		
		[Embed(source="Z:/res/magic/test/xhq_baozha.png")]
		protected var xhq_baozha_png:Class;
		
		[Embed(source="Z:/res/magic/test/xhq_baozha.plist", mimeType="application/octet-stream")]
		protected var xhq_baozha_plist:Class;

		private static var sInstance:MagicMgr;	
		private var mParent:Node2D;
		
		public static function instance():MagicMgr
		{
			if(sInstance == null)
			{
				sInstance = new MagicMgr;
			}
			
			return sInstance;
		}	
		
		public function parent(p:Node2D):void
		{
			mParent = p;
		}
		
		public function init():void
		{
			test_magic();
		}
		
		public function MagicMgr()
		{
			if(sInstance != null)
			{
				throw new Error("this class should be instantiated only one time");
			}
		}		
		
		public function test_magic():void
		{
			var atlasTex:Texture2D = Texture2D.textureFromBitmapData(new jiguang_png().bitmapData);
			var atlas:TextureAtlas = new TextureAtlas(atlasTex.bitmapWidth, atlasTex.bitmapHeight, 
				new XML(new jiguang_plist()), TextureAtlas.XML_FORMAT_COCOS2D, 5, false);
			var sp:Sprite2D = new Sprite2D(atlasTex);
			sp.setSpriteSheet(atlas);
			var arr:Array = new Array;
			
			for(var id:uint = 0; id != 6; ++id)
			{
				var name:String = "2_0000";
				name += id;
				name += ".png";
				arr.push(name);
			}
			
			atlas.addAnimation("jiguang", arr, false);
			atlas.playAnimation("jiguang");
			mParent.addChild(sp);
			sp.y = 400;
			sp.x = 500;
		}		
		
		public function update(elapsed:Number):void
		{			
		}
	}
}


