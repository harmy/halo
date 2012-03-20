package com.cokecode.halo.magic
{
	import com.cokecode.halo.materials.texture.AnimationAtlas;
	import com.cokecode.halo.object.GameObject;
	import com.cokecode.halo.object.IClip;
	import com.cokecode.halo.terrain.layers.Layer;
	
	import de.nulldesign.nd2d.display.Camera2D;
	import de.nulldesign.nd2d.display.Node2D;
	import de.nulldesign.nd2d.display.Sprite2D;
	import de.nulldesign.nd2d.materials.texture.Texture2D;
	
	import flash.utils.getTimer;

	/**
	 * 魔法基类
	 * */
	public class MagicBase extends Node2D implements IClip
	{
		private var mCurDir:uint				= 0;		//当前方向	
		private var mID:uint					= 0;		//标识id
		private var mStartTime:uint			= 0;		//魔法开始时间
		protected var mConfig:MagicConfig;
		protected var mSprite:Sprite2D;
		protected var mStart:Boolean			= false;	//魔法是否已开始
		
		public function MagicBase()
		{
		}
		
		protected function isEnd():Boolean
		{			
			return false;
		}
		
		protected function updatePosition():void
		{			
		}
		
		public function get id():uint
		{
			return mID;
		}
		
		public function set id(id:uint):void
		{
			mID = id;
		}
		
		public function init(atlas:AnimationAtlas, atlasTex:Texture2D, layer:Layer):void
		{
			mSprite = new Sprite2D(atlasTex);
			mSprite.setSpriteSheet(atlas);
			addChild(mSprite);
			layer.addChild(this);
			mStart = true;
			mStartTime = getTimer();			
		}		
		
		public function get dir():uint
		{
			return mCurDir;
		}
		
		public function set dir(dir:uint):void
		{
			mCurDir = dir;
		}
		
		protected override function step(elapsed:Number):void
		{
			if(isEnd())
			{
				//魔法已结束
				return;
			}
			
			updatePosition();
		}
		
		public function isInViewport(camera:Camera2D):Boolean
		{			
			var halfW:Number = mSprite.width * 0.5;
			var halfH:Number = mSprite.height * 0.5;
			
			//图片移出相机左边
			if(x + halfW < camera.x)
			{
				return false;
			}
			
			//图片移出相机上边
			if(y + halfH < camera.y)
			{
				return false;
			}
			
			//图片移出相机右边
			if(x - halfW > camera.x + camera.sceneWidth)
			{
				return false;
			}
			
			//图片移出相机下边
			if(y - halfH > camera.y + camera.sceneHeight)
			{
				return false;
			}
			
			return true;
		}
	}
}