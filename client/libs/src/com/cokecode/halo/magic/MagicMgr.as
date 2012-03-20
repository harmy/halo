package com.cokecode.halo.magic
{
	/**
	 * 魔法管理器
	 * */
	public final class MagicMgr
	{
		private static var sInstance:MagicMgr;
		
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
			return sInstance;
		}
		
		public function loadConfig(path:String):void
		{
			MagicConfigMgr.instance().loadConfig(path);
		}
		
		//触发一个新技能
		public function addMagic(id:uint, srcID:uint, srcX:uint, srcY:uint, dir:uint, 
								 targetID:uint, targetX:uint, targetY:uint):void
		{			
		}
	}
}