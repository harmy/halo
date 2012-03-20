package game.magic
{
	import de.nulldesign.nd2d.display.Node2D;
	import de.nulldesign.nd2d.display.Scene2D;
	import de.nulldesign.nd2d.display.Sprite2D;
	import de.nulldesign.nd2d.display.Sprite2DBatch;
	import de.nulldesign.nd2d.materials.BlendModePresets;
	import de.nulldesign.nd2d.materials.texture.SpriteSheet;
	import de.nulldesign.nd2d.materials.texture.Texture2D;
	import de.nulldesign.nd2d.materials.texture.TextureAtlas;
	
	public final class MagicTest
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
		
		private static var sInstance:MagicTest;	
		private var mParent:Node2D;

		public function MagicTest()
		{			
		}		
		
		public static function instance():MagicTest
		{
			if(sInstance == null)
			{
				sInstance = new MagicTest;
			}
			
			return sInstance;
		}	
		
		public function parent(p:Node2D):void
		{
			mParent = p;
			test_magic();
		}
		
		public function init():void
		{
		}
		
		public function addMagic():void
		{
			
		}
		
		public function test_magic():void
		{
			var atlasTex_Jiguang:Texture2D = Texture2D.textureFromBitmapData(new jiguang_png().bitmapData);
			var atlas_Jiguang:TextureAtlas = new TextureAtlas(atlasTex_Jiguang.bitmapWidth, atlasTex_Jiguang.bitmapHeight, 
				new XML(new jiguang_plist()), TextureAtlas.XML_FORMAT_COCOS2D, 5, false);
			var sp:Sprite2D = new Sprite2D(atlasTex_Jiguang);
			sp.setSpriteSheet(atlas_Jiguang);
			var arr:Array = new Array;
			
			for(var id:uint = 0; id != 6; ++id)
			{
				var name:String = "2_0000";
				name += id;
				name += ".png";
				arr.push(name);
			}
			
			atlas_Jiguang.addAnimation("jiguang", arr, true);
			atlas_Jiguang.playAnimation("jiguang");
			mParent.addChild(sp);
			sp.y = 400;
			sp.x = 500;
			sp.scaleX = 2;
			sp.scaleY = 2;
			sp.blendMode = BlendModePresets.ADD_NO_PREMULTIPLIED_ALPHA;
		}		
		
		public function update(elapsed:Number):void
		{			
		}
	}
}


