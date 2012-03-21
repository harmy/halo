package com.cokecode.halo.magic
{
	import com.cokecode.halo.materials.texture.AnimationAtlas;
	import com.cokecode.halo.terrain.layers.Layer;
	
	import flash.utils.Dictionary;

	/**
	 * 魔法管理器
	 * */
	public final class MagicMgr
	{
		private static var sInstance:MagicMgr;
		private var mMagicDict:Dictionary		= new Dictionary;
		private var mCurAllocID:uint 			= 0;
		public var mAtlasDic:Dictionary 		= new Dictionary;
		public var mTexDic:Dictionary 			= new Dictionary;
		public var magicLayer:Layer;
		
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
		
		public function allocID():uint
		{
			return ++mCurAllocID;
		}
		
		public function loadConfig(path:String):void
		{
			MagicConfigMgr.instance().loadConfig(path);
		}
		
		internal function erase(id:uint):void
		{
			mMagicDict[id] = null;
		}
		
		public function delMagic(id:uint):void
		{
			var elem:MagicBase = mMagicDict[id];
			
			if(elem != null)
			{
				elem.clean();				
			}
		}
		
		internal function doMagic(config:MagicConfig, dir:uint, srcID:String, srcX:uint, srcY:uint, 
								targetID:String, targetX:uint, targetY:uint):void
		{
			var magic:MagicBase;
			
			if(config.mType == MagicConst.TYPE_SELF)
			{
				magic = new MagicSelf;
			}	
			else if(config.mType == MagicConst.TYPE_FLY)
			{
				magic = new MagicFly;
			}
			else
			{
				magic = new MagicDest;
			}
			
			magic.id = allocID();
			magic.mConfig = config;
			mMagicDict[magic.id] = magic;
			magic.setParam(dir, srcID, srcX, srcY, targetID, targetX, targetY);
			var nextConfig:MagicConfig = magic.init(mAtlasDic[config.mTexID], mTexDic[config.mTexID], magicLayer);
			
			//如果弟兄节点存在，递归
			if(nextConfig != null)
			{
				doMagic(nextConfig, dir, srcID, srcX, srcY, targetID, targetX, targetY);
			}
		}
		
		//触发一个新魔法
		public function addMagic(id:uint, dir:uint, srcID:String, srcX:uint, srcY:uint, 
								 targetID:String, targetX:uint, targetY:uint):void
		{
			var cfArr:Array = MagicConfigMgr.instance().getConfig(id);
			
			if(cfArr == null || cfArr.length == 0)
			{
				return;
			}
			
			var config:MagicConfig = cfArr[0];
			doMagic(config, dir, srcID, srcX, srcY, targetID, targetX, targetY);
		}
	}
}




























