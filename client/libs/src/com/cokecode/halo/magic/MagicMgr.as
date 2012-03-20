package com.cokecode.halo.magic
{
	import flash.utils.Dictionary;

	/**
	 * 魔法管理器
	 * */
	public final class MagicMgr
	{
		private static var sInstance:MagicMgr;
		private var mMagicDict:Dictionary;
		
		public function MagicMgr()
		{
			if(sInstance != null)
			{
				throw new Error("this class should be instantiated only one time");
			}
			
			sInstance = this;
		}
		
		public static function instance():MagicMgr
		{
			if(sInstance == null)
			{
				sInstance = new MagicMgr;
			}
			
			return sInstance;
		}
		
		public function loadConfig(path:String):void
		{
			MagicConfigMgr.instance().loadConfig(path);
		}
		
		//触发一个新魔法
		public function addMagic(id:uint, dir:uint, srcID:uint, srcX:uint, srcY:uint, 
								 targetID:uint, targetX:uint, targetY:uint):void
		{
			var cfArr:Array = MagicConfigMgr.instance().getConfig(id);
			
			if(cfArr == null || cfArr.length() == 0)
			{
				return;
			}
			
			var config:MagicConfig = cfArr[0];
			var magic:MagicBase;
			
			if(config.mType == MagicConst.TYPE_SELF)
			{
				magic = new MagicSelf(srcID, srcX, srcY);
			}	
			else if(config.mType == MagicConst.TYPE_FLY)
			{
				magic = new MagicFly(targetID, targetX, targetY);
			}
			else
			{
				magic = new MagicDest(targetID, targetX, targetY);
			}
			
			magic.id = 2;
			magic.dir = dir;
			mMagicDict[magic.id] = magic;
		}
	}
}




























