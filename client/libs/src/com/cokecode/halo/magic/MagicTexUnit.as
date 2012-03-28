package com.cokecode.halo.magic
{
	import com.cokecode.halo.materials.texture.AnimationAtlas;
	import com.cokecode.halo.resmgr.ResMgr;
	import com.furusystems.logging.slf4as.global.fatal;
	
	import de.nulldesign.nd2d.materials.texture.Texture2D;
	import de.nulldesign.nd2d.materials.texture.TextureAtlas;
	import de.nulldesign.nd2d.materials.texture.TextureOption;
	
	import flash.display.Bitmap;
	import flash.events.Event;
	
	import net.manaca.loaderqueue.LoaderQueueEvent;

	/**
	 * 魔法单个贴图与配置
	 * */
	internal final class MagicTexUnit
	{
		private var mID:uint					= 0;
		private var mTex:Texture2D;
		private var mTexConf:XML;
		private var mAtlas:AnimationAtlas;
		
		public function MagicTexUnit(id:uint)
		{
			mID = id;
			load();
		}
		
		public function texture():Texture2D
		{
			return mTex;
		}
		
		public function atlas():AnimationAtlas
		{
			if(mAtlas == null)
			{
				return null;
			}
			
			return (mAtlas.clone() as AnimationAtlas);
		}
		
		private function texPath():String
		{
			var str:String = MagicTexMgr.instance.path + MagicTexMgr.instance.tmpDic[mID] + ".png";
			
			return str;			
		}
		
		private function texConfPath():String
		{
			var str:String = MagicTexMgr.instance.path + MagicTexMgr.instance.tmpDic[mID] + ".plist";
			
			return str;				
		}
		
		private function onLoadTex(event:LoaderQueueEvent):void
		{
			var bmp:Bitmap = event.target.context as Bitmap;	
			mTex = Texture2D.textureFromBitmapData(bmp.bitmapData, true);
			mTex.textureOptions = TextureOption.QUALITY_LOW;	
			
			if(mTexConf != null)
			{
				mAtlas = new AnimationAtlas(mTex.bitmapWidth, mTex.bitmapHeight, mTexConf, 
					TextureAtlas.XML_FORMAT_COCOS2D, 5, false);				
			}
		}
		
		private function onLoadTexConf(event:LoaderQueueEvent):void
		{
			mTexConf = new XML(event.target.data);	
			
			if(mTex != null)
			{
				mAtlas = new AnimationAtlas(mTex.bitmapWidth, mTex.bitmapHeight, mTexConf, 
					TextureAtlas.XML_FORMAT_COCOS2D, 5, false);
			}
		}
		
		private function load():void
		{
			ResMgr.instance.loadByLoader(texPath(), onLoadTex);	
			ResMgr.instance.loadByURLLoader(texConfPath(), onLoadTexConf);
		}
	}
}


