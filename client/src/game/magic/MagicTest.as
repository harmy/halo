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
		
		[Embed(source="Z:/res/magic/test/mofadun1.png")]
		protected var mofadun1_png:Class;
		
		[Embed(source="Z:/res/magic/test/mofadun1.plist", mimeType="application/octet-stream")]
		protected var mofadun1_plist:Class;
		
		[Embed(source="Z:/res/magic/test/mofadun2.png")]
		protected var mofadun2_png:Class;
		
		[Embed(source="Z:/res/magic/test/mofadun2.plist", mimeType="application/octet-stream")]
		protected var mofadun2_plist:Class;
		
		[Embed(source="Z:/res/magic/test/binpaoxiao1.png")]
		protected var binpaoxiao1_png:Class;
		
		[Embed(source="Z:/res/magic/test/binpaoxiao1.plist", mimeType="application/octet-stream")]
		protected var binpaoxiao1_plist:Class;
		
		[Embed(source="Z:/res/magic/test/binpaoxiao2.png")]
		protected var binpaoxiao2_png:Class;
		
		[Embed(source="Z:/res/magic/test/binpaoxiao2.plist", mimeType="application/octet-stream")]
		protected var binpaoxiao2_plist:Class;
		
		[Embed(source="Z:/res/magic/test/binpaoxiao3.png")]
		protected var binpaoxiao3_png:Class;
		
		[Embed(source="Z:/res/magic/test/binpaoxiao3.plist", mimeType="application/octet-stream")]
		protected var binpaoxiao3_plist:Class;
		
		[Embed(source="Z:/res/magic/test/binpaoxiao4.png")]
		protected var binpaoxiao4_png:Class;
		
		[Embed(source="Z:/res/magic/test/binpaoxiao4.plist", mimeType="application/octet-stream")]
		protected var binpaoxiao4_plist:Class;
		
		[Embed(source="Z:/res/magic/test/binpaoxiao5.png")]
		protected var binpaoxiao5_png:Class;
		
		[Embed(source="Z:/res/magic/test/binpaoxiao5.plist", mimeType="application/octet-stream")]
		protected var binpaoxiao5_plist:Class;
		
		[Embed(source="Z:/res/magic/test/leiguang1.png")]
		protected var leiguang1_png:Class;
		
		[Embed(source="Z:/res/magic/test/leiguang1.plist", mimeType="application/octet-stream")]
		protected var leiguang1_plist:Class;
		
		[Embed(source="Z:/res/magic/test/leiguang2.png")]
		protected var leiguang2_png:Class;
		
		[Embed(source="Z:/res/magic/test/leiguang2.plist", mimeType="application/octet-stream")]
		protected var leiguang2_plist:Class;
		
		[Embed(source="Z:/res/magic/test/yumo1.png")]
		protected var yumo1_png:Class;
		
		[Embed(source="Z:/res/magic/test/yumo1.plist", mimeType="application/octet-stream")]
		protected var yumo1_plist:Class;
		
		[Embed(source="Z:/res/magic/test/yumo2.png")]
		protected var yumo2_png:Class;
		
		[Embed(source="Z:/res/magic/test/yumo2.plist", mimeType="application/octet-stream")]
		protected var yumo2_plist:Class;
		
		[Embed(source="Z:/res/magic/test/yumo3.png")]
		protected var yumo3_png:Class;
		
		[Embed(source="Z:/res/magic/test/yumo3.plist", mimeType="application/octet-stream")]
		protected var yumo3_plist:Class;
		
		
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
		
		public function init():void
		{
			MagicMgr.instance().loadConfig("Z:/res/magic/test/magic.xml");
			MagicMgr.instance().mAtlasDic[1] = new XML(new xhq_shifang_plist());
			MagicMgr.instance().mAtlasTexDic[1] = new xhq_shifang_png();
			MagicMgr.instance().mAtlasDic[2] = new XML(new xhq_feixing_plist());
			MagicMgr.instance().mAtlasTexDic[2] = new xhq_feixing_png();
			MagicMgr.instance().mAtlasDic[3] = new XML(new xhq_baozha_plist());
			MagicMgr.instance().mAtlasTexDic[3] = new xhq_baozha_png();
			MagicMgr.instance().mAtlasDic[4] = new XML(new jiguang_plist());
			MagicMgr.instance().mAtlasTexDic[4] = new jiguang_png;
			MagicMgr.instance().mAtlasDic[5] = new XML(new mofadun1_plist);
			MagicMgr.instance().mAtlasTexDic[5] = new mofadun1_png;
			MagicMgr.instance().mAtlasDic[6] = new XML(new mofadun2_plist);
			MagicMgr.instance().mAtlasTexDic[6] = new mofadun2_png;		
			MagicMgr.instance().mAtlasDic[7] = new XML(new binpaoxiao1_plist);
			MagicMgr.instance().mAtlasTexDic[7] = new binpaoxiao1_png;
			MagicMgr.instance().mAtlasDic[8] = new XML(new binpaoxiao2_plist);
			MagicMgr.instance().mAtlasTexDic[8] = new binpaoxiao2_png;
			MagicMgr.instance().mAtlasDic[9] = new XML(new binpaoxiao3_plist);
			MagicMgr.instance().mAtlasTexDic[9] = new binpaoxiao3_png;
			MagicMgr.instance().mAtlasDic[10] = new XML(new binpaoxiao4_plist);
			MagicMgr.instance().mAtlasTexDic[10] = new binpaoxiao4_png;
			MagicMgr.instance().mAtlasDic[11] = new XML(new binpaoxiao5_plist);
			MagicMgr.instance().mAtlasTexDic[11] = new binpaoxiao5_png;
			MagicMgr.instance().mAtlasDic[12] = new XML(new leiguang1_plist);
			MagicMgr.instance().mAtlasTexDic[12] = new leiguang1_png;
			MagicMgr.instance().mAtlasDic[13] = new XML(new leiguang2_plist);
			MagicMgr.instance().mAtlasTexDic[13] = new leiguang2_png;
			MagicMgr.instance().mAtlasDic[14] = new XML(new yumo1_plist);
			MagicMgr.instance().mAtlasTexDic[14] = new yumo1_png;
			MagicMgr.instance().mAtlasDic[15] = new XML(new yumo2_plist);
			MagicMgr.instance().mAtlasTexDic[15] = new yumo2_png;
			MagicMgr.instance().mAtlasDic[16] = new XML(new yumo3_plist);
			MagicMgr.instance().mAtlasTexDic[16] = new yumo3_png;
		}
		
		public function test_magic():void
		{
			
		}		
		
		public function update(elapsed:Number):void
		{			
		}
	}
}


