package com.cokecode.halo.magic
{
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
		
		public function addConfig(id:uint, cf:MagicConfig):void
		{
			mConfigMgr[id] = cf;
		}
		
		public function getConfig(id:uint):MagicConfig
		{
			return mConfigMgr[id];
		}
	}
}