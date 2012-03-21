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
		private var mID:uint					= 0;		//标识id
		private var mStartTime:uint			= 0;		//魔法开始时间		
		protected var mCurDir:uint				= 0;		//当前方向		
		protected var mSrcID:uint				= 0;		//释放者id
		protected var mSrcX:uint				= 0;		//释放点x
		protected var mSrcY:uint				= 0;		//释放点y
		protected var mTargetX:uint			= 0;		//目标x
		protected var mTargetY:uint			= 0;		//目标y
		protected var mTargetID:uint			= 0;		//目标id				
		protected var mSprite:Sprite2D;
		protected var mStart:Boolean			= false;	//魔法是否已开始
		protected var mLayer:Layer;
		public var mConfig:MagicConfig;
		
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
		
		public function setParam(dir:uint, srcID:uint, srcX:uint, srcY:uint, 
								 targetID:uint, targetX:uint, targetY:uint):void
		{
			mCurDir = dir;
			mSrcID = srcID;
			mSrcX = srcX;
			mSrcY = srcY;
			mTargetID = targetID;
			mTargetX = targetX;
			mTargetY = targetY;			
		}
		
		//清理分配的资源
		public override function dispose():void
		{
			mLayer.removeChild(this);
			removeChild(mSprite);
			mSprite = null;
			MagicMgr.instance().delMagic(id);			
		}
		
		public function init(atlas:AnimationAtlas, atlasTex:Texture2D, layer:Layer):MagicConfig
		{
			mSprite = new Sprite2D(atlasTex);
			mSprite.setSpriteSheet(atlas);
			addChild(mSprite);
			layer.addChild(this);
			mLayer = layer;
			mStart = true;
			mStartTime = getTimer();
			
			return mConfig.mSibling;
		}
		
		protected override function step(elapsed:Number):void
		{
			if(isEnd())
			{
				//魔法已结束, 检查子节点				
				if(mConfig.mChild != null)
				{
					MagicMgr.instance().doMagic(mConfig.mChild, mCurDir, mSrcID, mSrcX, mSrcY, mTargetID, mTargetX, mTargetY);
				}
				
				dispose();
				
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