package com.cokecode.halo.magic
{
	import com.bit101.components.Label;
	import com.cokecode.halo.object.CharMgr;
	import com.cokecode.halo.object.Charactor;
	import com.cokecode.halo.terrain.layers.Layer;
	import com.furusystems.dconsole2.plugins.dialog.DialogDesc;
	
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
		private static var sInstance:MagicMgr				= new MagicMgr;
		private var mMagicDict:Dictionary					= new Dictionary;
		private var mCurAllocID:uint 						= 0;
		private var mLayer_before:Layer;
		private var mLayer_after:Layer;
		
		public static function get instance():MagicMgr
		{			
			return sInstance;
		}
		
		public function registerLayer(layer1:Layer, layer2:Layer):void
		{
			mLayer_before = layer1;
			mLayer_after = layer2;
		}
		
		public function allocID():uint
		{
			return ++mCurAllocID;
		}
		
		public function loadConfig(path:String):void
		{
			MagicConfigMgr.instance.loadConfig(path);
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
			
			var tex:Texture2D = MagicTexMgr.instance.getTexture(config.mTexID);
			var atlas:TextureAtlas = MagicTexMgr.instance.getAtlas(config.mTexID);
			
			if(tex == null || atlas == null)
			{
				var cfArr:Array = MagicConfigMgr.instance.getConfig(config.mRootID);
				var texArr:Array = new Array;
				
				for each(var cf:MagicConfig in cfArr)
				{
					texArr.push(cf.mTexID);					
				}
				
				MagicTexMgr.instance.loadMany(texArr);
				
				return;				
			}
			
			var char:Charactor = CharMgr.instance.getCharByStr(srcID);
			
			if(char != null)
			{
				char.addMagic(config.mRootID, magic.id);
			}
			
			var nextConfig:MagicConfig = magic.init(tex, atlas, magicLayer);
			
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
			var cfArr:Array = MagicConfigMgr.instance.getConfig(id);
			
			if(cfArr == null || cfArr.length == 0)
			{
				return;
			}
			
			var config:MagicConfig = cfArr[0];
			doMagic(config, dir, srcID, srcX, srcY, targetID, targetX, targetY);
		}
	}
}




























