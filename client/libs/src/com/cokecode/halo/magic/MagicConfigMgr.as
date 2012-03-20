package com.cokecode.halo.magic
{
	import de.nulldesign.nd2d.materials.BlendModePresets;
	
	import flash.utils.Dictionary;

	/**
	 * 魔法配置管理
	 * */
	public final class MagicConfigMgr
	{
		private var mConfigMgr:Dictionary = new Dictionary;
		private static var sInstance:MagicConfigMgr;
		
		public function MagicConfigMgr()
		{
			if(sInstance != null)
			{
				throw new Error("this class should be instantiated only one time");
			}
			
			sInstance = this;
		}
		
		public static function instance():MagicConfigMgr
		{
			return sInstance;
		}
		
		internal function loadConfig(path:String):void
		{
			var arr:Array = new Array;
			var cf1:MagicConfig = new MagicConfig;
			cf1.mRootID = 1;
			cf1.mAniSpeed = 100;
			cf1.mBlend = BlendModePresets.ADD_NO_PREMULTIPLIED_ALPHA;
			cf1.mDuration = 30000;
			cf1.mEndType = MagicConst.END_TYPE_DURATION;
			cf1.mFlySpeed = 0;
			cf1.mLayer = MagicConst.LAYER_BEFORE_PLAYER;
			cf1.mOffx = 50;
			cf1.mOffy = 60;
			cf1.mOption = MagicConst.OPT_FOLLOW_TARGET;
			cf1.mScale = 2;
			cf1.mType = MagicConst.TYPE_SELF;
			arr.push(cf1);
			addConfig(cf1.mRootID, arr);
		}
		
		private function addConfig(id:uint, arr:Array):void
		{
			mConfigMgr[id] = arr;
		}
		
		public function getConfig(id:uint):Array
		{
			return mConfigMgr[id];
		}
	}
}


