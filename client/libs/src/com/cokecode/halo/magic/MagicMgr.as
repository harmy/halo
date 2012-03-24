package com.cokecode.halo.magic
{
	import com.bit101.components.Label;
	import com.cokecode.halo.materials.texture.AnimationAtlas;
	import com.cokecode.halo.object.Charactor;
	import com.cokecode.halo.terrain.layers.Layer;
	
	import de.nulldesign.nd2d.materials.texture.Texture2D;
	import de.nulldesign.nd2d.materials.texture.TextureAtlas;
	
	import flash.display.Bitmap;
	import flash.display3D.textures.Texture;
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
		public var mAtlasTexDic:Dictionary 	= new Dictionary;
		private var mLayer_before:Layer;
		private var mLayer_after:Layer;
		internal var mSelf:Charactor;
		
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
		
		public function register(layer1:Layer, layer2:Layer, obj:Charactor):void
		{
			mLayer_before = layer1;
			mLayer_after = layer2;
			mSelf = obj;
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
		
		private function getAtlasTex(id:uint):Texture2D
		{
			
			return Texture2D.textureFromBitmapData((mAtlasTexDic[id] as Bitmap).bitmapData.clone(), true);
		}
		
		private function getAtlas(id:uint):AnimationAtlas
		{
			return new AnimationAtlas((mAtlasTexDic[id] as Bitmap).bitmapData.width, 
				(mAtlasTexDic[id] as Bitmap).bitmapData.height, mAtlasDic[id], TextureAtlas.XML_FORMAT_COCOS2D, 5, false);			
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
			else if(config.mType == MagicConst.TYPE_DESTINATION)
			{
				magic = new MagicDest;
			}
			else
			{
				magic = new MagicMouse;
			}
			
			magic.id = allocID();
			magic.mConfig = config;
			mMagicDict[magic.id] = magic;
			magic.setParam(dir, srcID, srcX, srcY, targetID, targetX, targetY);
			var magicLayer:Layer;
			
			if(config.mLayer == MagicConst.LAYER_BEFORE_PLAYER)
			{
				magicLayer = mLayer_before;				
			}
			else
			{
				magicLayer = mLayer_after;
			}
			
			var nextConfig:MagicConfig = magic.init(getAtlas(config.mTexID), getAtlasTex(config.mTexID), magicLayer);
			
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




























