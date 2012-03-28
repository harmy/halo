package game.magic
{
	import com.cokecode.halo.magic.MagicMgr;
	import com.cokecode.halo.magic.MagicTexMgr;
	import com.cokecode.halo.materials.texture.AnimationAtlas;
	import com.cokecode.halo.resmgr.ResMgr;
	
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
		private static var sInstance:MagicTest = new MagicTest;
		private var mParent:Node2D;
		
		public static function instance():MagicTest
		{			
			return sInstance;
		}
		
		public function init():void
		{			
			MagicMgr.instance.loadConfig("Z:/res/magic/test/magic.xml");	
			MagicTexMgr.instance.path = "Z:/res/magic/test/";
		}
		
		public function test_magic():void
		{
			
		}		
		
		public function update(elapsed:Number):void
		{			
		}
	}
}


