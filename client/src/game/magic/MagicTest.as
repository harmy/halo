package game.magic
{
	import com.cokecode.halo.magic.MagicMgr;
	import com.cokecode.halo.materials.texture.AnimationAtlas;
	
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
			MagicMgr.instance().mAtlasDic[1] = new XML(new xhq_shifang_plist());
			MagicMgr.instance().mAtlasTexDic[1] = new xhq_shifang_png();
			MagicMgr.instance().mAtlasDic[2] = new XML(new xhq_feixing_plist());
			MagicMgr.instance().mAtlasTexDic[2] = new xhq_feixing_png();
			MagicMgr.instance().mAtlasDic[3] = new XML(new xhq_baozha_plist());
			MagicMgr.instance().mAtlasTexDic[3] = new xhq_baozha_png();
			MagicMgr.instance().mAtlasDic[4] = new XML(new jiguang_plist());
			MagicMgr.instance().mAtlasTexDic[4] = new jiguang_png;
			MagicMgr.instance().loadConfig("");
		}
		
		public function test_magic():void
		{
			
		}		
		
		public function update(elapsed:Number):void
		{			
		}
	}
}


