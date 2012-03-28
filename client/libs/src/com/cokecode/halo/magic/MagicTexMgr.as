package com.cokecode.halo.magic
{
	import com.cokecode.halo.materials.texture.AnimationAtlas;
	
	import de.nulldesign.nd2d.materials.texture.Texture2D;
	
	import flash.utils.Dictionary;

	/**
	 * 魔法贴图配置管理
	 * */
	public final class MagicTexMgr
	{
		private var mRootPath:String;											//魔法加载根目录
		private var mTexUnitDic:Dictionary						= new Dictionary;	//贴图字典
		private static var sInstance:MagicTexMgr				= new MagicTexMgr;
		internal var tmpDic:Dictionary							= new Dictionary;
		
		public function MagicTexMgr()
		{
			tmpDic[1] = "xhq_shifang";
			tmpDic[2] = "xhq_feixing";
			tmpDic[3] = "xhq_baozha";
			tmpDic[4] = "jiguang";
			tmpDic[5] = "mofadun1";
			tmpDic[6] = "mofadun2";
			tmpDic[7] = "binpaoxiao1";
			tmpDic[8] = "binpaoxiao2";
			tmpDic[9] = "binpaoxiao3";
			tmpDic[10] = "binpaoxiao4";
			tmpDic[11] = "binpaoxiao5";
			tmpDic[12] = "leiguang1";
			tmpDic[13] = "leiguang2";
			tmpDic[14] = "yumo1";
			tmpDic[15] = "yumo2";
			tmpDic[16] = "yumo3";			
		}
		
		public static function get instance():MagicTexMgr
		{			
			return sInstance;
		}
		
		public function set path(str:String):void
		{
			mRootPath = str;
		}
		
		public function get path():String
		{
			return mRootPath;
		}
		
		public function getTexture(id:uint):Texture2D
		{
			if(mTexUnitDic[id] == null)
			{
				mTexUnitDic[id] = new MagicTexUnit(id);
			}	
			
			return (mTexUnitDic[id] as MagicTexUnit).texture();
		}
		
		public function getAtlas(id:uint):AnimationAtlas
		{
			if(mTexUnitDic[id] == null)
			{
				mTexUnitDic[id] = new MagicTexUnit(id);
			}	
			
			return (mTexUnitDic[id] as MagicTexUnit).atlas();	
		}
	}
}