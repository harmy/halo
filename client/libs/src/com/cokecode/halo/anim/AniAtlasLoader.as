package com.cokecode.halo.anim
{
	import com.cokecode.halo.materials.texture.AnimationAtlas;
	import com.cokecode.halo.resmgr.ResMgr;
	
	import de.nulldesign.nd2d.materials.texture.Texture2D;
	import de.nulldesign.nd2d.materials.texture.TextureAtlas;
	import de.nulldesign.nd2d.materials.texture.TextureOption;
	
	import flash.display.Bitmap;
	import flash.utils.getTimer;
	
	import net.manaca.loaderqueue.LoaderQueueEvent;

	public class AniAtlasLoader
	{
		protected var mTexUrl:String;
		protected var mSheetUrl:String;
		protected var mSpriteSheet:AnimationAtlas;
		protected var mTexture:Texture2D;
		protected var mTimeTick:uint;
		
		// url - 不包含扩展名
		public function AniAtlasLoader(url:String)
		{
			mTexUrl = url + ".jxr";
			mSheetUrl = url + ".plist";
			
			// 先读取贴图
			ResMgr.loadByLoader(mTexUrl, onTextureComplete, 5);
			
			mTimeTick = getTimer();
		}
		
		public function get texture():Texture2D
		{
			return mTexture;
		}
		
		public function get spriteSheet():AnimationAtlas
		{
			return mSpriteSheet;
		}
		
		protected function onTextureComplete(evt:LoaderQueueEvent):void
		{
			trace( "Tex Time: " + (getTimer() - mTimeTick) );
			
			var bmp:Bitmap = evt.target.context as Bitmap;
			mTexture = Texture2D.textureFromBitmapData(bmp.bitmapData, true);
			mTexture.textureOptions = TextureOption.QUALITY_LOW;
			
			// 再读取配置
			ResMgr.loadByURLLoader(mSheetUrl, onSpriteSheetComplete, 10);
			
			mTimeTick = getTimer();
		}
		
		protected function onSpriteSheetComplete(evt:LoaderQueueEvent):void
		{
			trace( "Data Time: " + (getTimer() - mTimeTick) );
			
			var xmlData:XML = new XML(evt.target.data);
			mSpriteSheet = new AnimationAtlas(mTexture.bitmapWidth, mTexture.bitmapHeight, xmlData, TextureAtlas.XML_FORMAT_COCOS2D, 1);
		}
		
	}
}


