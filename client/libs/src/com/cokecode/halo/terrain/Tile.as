package com.cokecode.halo.terrain
{
	import com.cokecode.halo.object.GameObject;
	import com.cokecode.halo.object.IClip;
	import com.cokecode.halo.resmgr.ResMgr;
	
	import de.nulldesign.nd2d.display.Camera2D;
	import de.nulldesign.nd2d.display.Node2D;
	import de.nulldesign.nd2d.display.Sprite2D;
	import de.nulldesign.nd2d.materials.texture.Texture2D;
	import de.nulldesign.nd2d.materials.texture.TextureOption;
	
	import flash.display.Bitmap;
	import flash.utils.getTimer;
	
	import net.manaca.loaderqueue.LoaderQueueEvent;

	/**
	 * 地表的一个格子
	 */
	public class Tile extends Node2D implements IClip
	{
		public static const FREE_TIME:uint = 60 * 1000;	// 释放的时间(毫秒)
		
		protected var mSprite:Sprite2D;
		// 最后一次被引用的时间
		protected var mLastRefTime:uint;
		
		public function Tile(url:String)
		{
			ResMgr.instance.loadByLoader(url, onComplete);
		}
		
		public function canDispose():Boolean
		{
			if (mSprite == null)
				return false;
			
			if ( getTimer() - mLastRefTime > FREE_TIME ) {
				return true;
			}
			
			return false;
		}
		
		override public function get width():Number {
			return mSprite.width;
		}
		
		override public function get height():Number {
			return mSprite.height;
		}
		
		public function updateRefTime():void
		{
			mLastRefTime = getTimer();
		}

		public function onComplete(evt:LoaderQueueEvent):void
		{
			// 从bitmap中创建贴图
			var bmp:Bitmap = evt.target.context as Bitmap;
			var tex:Texture2D = Texture2D.textureFromBitmapData(bmp.bitmapData, true);
			tex.textureOptions = TextureOption.QUALITY_LOW;
			
			// 创建精灵
			mSprite = new Sprite2D(tex);
			mSprite.pivot.x = -mSprite.width * 0.5;
			mSprite.pivot.y = mSprite.height * 0.5;
			
			addChild(mSprite);
		}
		
		public function isInViewport(camera:Camera2D):Boolean
		{
			if (mSprite == null) return  false;
			
			var nx:Number = x;
			var ny:Number = y - mSprite.height;
			
			if (nx + width < camera.x)	// 图片移出相机左边
				return false;
			
			if (ny + height < camera.y)	// 图片移出相机上边
				return false;
			
			if (nx > camera.x + camera.sceneWidth)	// 图片移出相机右边
				return false;
			
			if (ny > camera.y + camera.sceneHeight)	// 图片移出相机下边
				return false;
			
			return true;
		}
		
	}
}