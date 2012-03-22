package com.cokecode.halo.magic
{
	import de.nulldesign.nd2d.materials.BlendModePresets;
	
	import flash.utils.Dictionary;

	/**
	 * 魔法配置管理
	 * */
	internal final class MagicConfigMgr
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
			if(sInstance == null)
			{
				sInstance = new MagicConfigMgr;
			}
			
			return sInstance;
		}
		
		internal function loadConfig(path:String):void
		{
			var arr:Array = new Array;
			
			//释放
			var cf1:MagicConfig = new MagicConfig;
			cf1.mRootID = 1;
			cf1.mTexDirCount = 1;
			cf1.mTexID = 1;
			cf1.mScale = 1;
			cf1.mTexDirCount = 1;
			cf1.mLayer = MagicConst.LAYER_AFTER_PLAYER;
			cf1.mType = MagicConst.TYPE_SELF;
			cf1.mEndType = MagicConst.END_TYPE_ANIMATION_OVER;
			cf1.mAniSpeed = 500;
			arr.push(cf1);
			
			//飞行
			var cf2:MagicConfig = new MagicConfig;
			cf2.mRootID = 1;
			cf2.mTexDirCount = 8;
			cf2.mTexID = 2;
			cf2.mScale = 1;
			cf2.mLayer = MagicConst.LAYER_AFTER_PLAYER;
			cf2.mType = MagicConst.TYPE_FLY;
			cf2.mEndType = MagicConst.END_TYPE_MANUAL;
			cf2.mFlySpeed = 60;
			cf1.mAniSpeed = 500;
			arr.push(cf2);
			
			//爆炸
			var cf3:MagicConfig = new MagicConfig;
			cf3.mRootID = 1;
			cf3.mTexDirCount = 1;
			cf3.mTexID = 3;
			cf3.mScale = 1;
			cf3.mBlend = MagicConst.BLEND_ADD;
			cf1.mAniSpeed = 500;
			cf3.mLayer = MagicConst.LAYER_AFTER_PLAYER;
			cf3.mType = MagicConst.TYPE_DESTINATION;
			cf3.mEndType = MagicConst.END_TYPE_ANIMATION_OVER;
			arr.push(cf3);
			
			cf1.mChild = cf2;
			cf2.mChild = cf3;
			addConfig(1, arr);
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


