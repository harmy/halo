package com.cokecode.halo.terrain
{
	import com.cokecode.halo.object.GameObject;
	import com.cokecode.halo.resmgr.ResMgr;
	
	import de.nulldesign.nd2d.display.Camera2D;
	import de.nulldesign.nd2d.display.Sprite2D;
	import de.nulldesign.nd2d.materials.texture.Texture2D;
	import de.nulldesign.nd2d.materials.texture.TextureOption;
	
	import flash.display.Bitmap;
	import flash.utils.getTimer;
	
	import net.manaca.loaderqueue.LoaderQueueEvent;

	/**
	 * 地表的一个格子
	 */
	public class Tile extends GameObject
	{
		// 精灵
		protected var mSprite:Sprite2D;
		
		// 最后一次被引用的时间
		protected var mLastRefTime:uint;
		
		public function Tile(url:String)
		{
			ResMgr.loadByLoader(url, onComplete);
		}
		
		public function get lastRefTime():uint
		{
			return mLastRefTime;
		}

		public function set lastRefTime(value:uint):void
		{
			mLastRefTime = value;
		}
		
		public function updateRefTime():void
		{
			mLastRefTime = getTimer();
		}

		public function onComplete(evt:LoaderQueueEvent):void
		{
			// 从bitmap中创建贴图
			var bmp:Bitmap = evt.target.context as Bitmap;
			var tex:Texture2D = Texture2D.textureFromBitmapData(bmp.bitmapData);
			tex.textureOptions = TextureOption.QUALITY_LOW;
			
			// 创建精灵
			mSprite = new Sprite2D(tex);
			mSprite.pivot.x = -mSprite.width * 0.5;
			mSprite.pivot.y = mSprite.height * 0.5;
			
			// 加入显示
			addChild(mSprite);
		}
		
		override public function get width():Number
		{
			return mSprite.width;
		}
		
		override public function get height():Number
		{
			return mSprite.height;
		}
		
		override public function isInViewport(camera:Camera2D):Boolean
		{
			if (x + width < camera.x)	// 图片移出相机左边
				return false;
			
			if (y + height < camera.y)	// 图片移出相机上边
				return false;
			
			if (x > camera.x + camera.sceneWidth)	// 图片移出相机右边
				return false;
			
			if (y > camera.y + camera.sceneHeight)	// 图片移出相机下边
				return false;
			
			return true;
		}
		
	}
}