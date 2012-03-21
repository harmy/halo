package com.cokecode.halo.terrain.layers
{
	import com.cokecode.halo.resmgr.ResMgr;
	
	import de.nulldesign.nd2d.display.Sprite2D;
	import de.nulldesign.nd2d.materials.texture.Texture2D;
	import de.nulldesign.nd2d.materials.texture.TextureOption;
	
	import flash.display.Bitmap;
	
	import net.manaca.loaderqueue.LoaderQueueEvent;

	/**
	 * 悬空地表（视差地表）
	 */
	public class ParallaxLayer extends Layer
	{
		protected var mImageName:String;	// 贴图名称
		protected var mSpeedX:Number;		// X轴移动速度
		protected var mSpeedY:Number;		// Y轴移动速度
		protected var mSprite:Sprite2D;
		
		public function ParallaxLayer(name:String, width:uint, height:uint)
		{
			//TODO: implement function
			super(name, width, height);
		}
		
		override public function clear():void
		{
			super.clear();
			mSprite = null;
		}
		
		override public function initData():void
		{
			var prop:Object = mTMXLayer.getProps();
			mImageName = prop["image"];
			mSpeedX = prop["speedx"];
			mSpeedY = prop["speedy"];
			var url:String = mTMX.getParallaxImgSrc( mImageName );
			ResMgr.loadByLoader( url, onCompleteCB );
		}
		
		protected function onCompleteCB(evt:LoaderQueueEvent):void
		{
			// 从bitmap中创建贴图
			var bmp:Bitmap = evt.target.context as Bitmap;
			var tex:Texture2D = Texture2D.textureFromBitmapData(bmp.bitmapData, true);
			tex.textureOptions = TextureOption.QUALITY_LOW;
			
			// 创建精灵
			mSprite = new Sprite2D(tex);
			mSprite.pivot.x = -mSprite.width * 0.5;
			mSprite.pivot.y = -mSprite.height * 0.5;
			
			addChild(mSprite);
		}
		
		override public function update(elapsed:Number):void
		{
			if (mSprite == null) return;
			
			mSprite.x = camera.x;
			mSprite.y = camera.y;
			
			// 计算悬空地表和整个地图的缩放比
			var xScal:Number = mSprite.width / (mTMX.width * mTMX.tileWidth);
			var yScal:Number = mSprite.height / (mTMX.height * mTMX.tileHeight);
			
			// 计算相机在悬空地表中的位置
			var parX:Number = camera.x * xScal;
			var parY:Number = camera.y * yScal;
			
			// 换算到0-1之间(调整速度)
			var matX:Number = parX / mSprite.width / mSpeedX;
			var matY:Number = parY / mSprite.height / mSpeedY;
			
			mSprite.material.uvOffsetX = matX; //camera.x * xScal / 20000;
			mSprite.material.uvOffsetY = matY; //camera.y * yScal / 20000;
			
			//trace("matX: " + matX);
		}
		
		override protected function step(elapsed:Number):void 
		{
		}
	}
}