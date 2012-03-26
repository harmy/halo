package com.cokecode.halo.magic
{
	import com.cokecode.halo.materials.texture.AnimationAtlas;
	import com.cokecode.halo.object.GameObject;
	import com.cokecode.halo.object.IClip;
	import com.cokecode.halo.terrain.layers.Layer;
	
	import de.nulldesign.nd2d.display.Camera2D;
	import de.nulldesign.nd2d.display.Node2D;
	import de.nulldesign.nd2d.display.Sprite2D;
	import de.nulldesign.nd2d.materials.BlendModePresets;
	import de.nulldesign.nd2d.materials.texture.Texture2D;
	import de.nulldesign.nd2d.materials.texture.TextureOption;
	
	import flash.utils.getTimer;

	/**
	 * 魔法基类
	 * */
	internal class MagicBase extends Node2D implements IClip
	{		
		protected var mID:uint					= 0;		//标识id
		protected var mStartTime:uint			= 0;		//魔法开始时间		
		protected var mCurDir:uint				= 0;		//当前方向	
		protected var mCurTexDir:uint			= 0;		//当前贴图方向
		protected var mSrcID:String						//释放者id
		protected var mSrcX:int				= 0;		//释放点x
		protected var mSrcY:int				= 0;		//释放点y
		protected var mTargetX:int				= 0;		//目标x
		protected var mTargetY:int				= 0;		//目标y
		protected var mTargetID:String						//目标id			
		protected var mFramesPerDir:uint		= 0;		//每个方向的帧数
		protected var mSprite:Sprite2D;
		protected var mLayer:Layer;
		public var mConfig:MagicConfig;
		
		public function MagicBase()
		{
		}
		
		protected function isEnd():Boolean
		{	
			if(mConfig.mEndType == MagicConst.END_TYPE_ANIMATION_OVER)
			{
				//动画播放完结束
				return isLastFrame();
			}
			
			if(mConfig.mEndType == MagicConst.END_TYPE_DURATION)
			{
				var now:uint = getTimer();
				
				return now - mStartTime >= mConfig.mDuration;
			}
			
			return false;
		}
		
		public function set id(id:uint):void
		{
			mID = id;
		}
		
		public function get id():uint
		{
			return mID;
		}
		
		//判断动画是否为最后一帧
		protected function isLastFrame():Boolean
		{
			return mSprite.spriteSheet.frame == (mCurTexDir + 1) * mFramesPerDir - 1;
		}
		
		public function setParam(dir:uint, srcID:String, srcX:uint, srcY:uint, 
								 targetID:String, targetX:uint, targetY:uint):void
		{
			mCurDir = dir;
			mSrcID = srcID;
			mSrcX = srcX;
			mSrcY = srcY;
			mTargetID = targetID;
			mTargetX = targetX;
			mTargetY = targetY;			
		}
		
		//清理
		public function clean():void
		{
			dispose();
			mLayer.removeChild(this);			
		}
		
		public override function dispose():void
		{
//			mSprite.dispose();
			removeChild(mSprite);
			mSprite = null;
			MagicMgr.instance().erase(id);			
		}
		
		protected function doInit():void
		{			
		}
		
		public function init(atlasTex:Texture2D, atlas:AnimationAtlas, layer:Layer):MagicConfig
		{
			atlasTex.textureOptions = TextureOption.QUALITY_LOW;
			atlas.setFPS(1000/mConfig.mAniSpeed);
			mSprite = new Sprite2D(atlasTex);
			mSprite.setSpriteSheet(atlas);
			addChild(mSprite);
			mLayer = layer;
			layer.addChild(this);		
			scaleX = mConfig.mScale;
			scaleY = mConfig.mScale;
			
			if(mConfig.mBlend == MagicConst.BLEND_ADD)
			{
				mSprite.blendMode = BlendModePresets.ADD_NO_PREMULTIPLIED_ALPHA;				
			}
			else if(mConfig.mBlend == MagicConst.BLEND_MODULATE)
			{
				blendMode = BlendModePresets.MODULATE;				
			}
			
			mStartTime = getTimer();
			mFramesPerDir = mSprite.spriteSheet.totalFrames / mConfig.mTexDirCount;	
			
			if(mConfig.mTexDirCount == 8 || mConfig.mTexDirCount == 16)
			{
				mCurTexDir = mCurDir % mConfig.mTexDirCount;
			}
			
			var startFrame:uint = mCurTexDir * mFramesPerDir;
			var endFrame:uint = startFrame + mFramesPerDir;
			var frameArr:Array = new Array;
			var frame:uint = 0;
			
			
			if(mConfig.mEndType == MagicConst.END_TYPE_ANIMATION_OVER) //动画播放完类型，不循环
			{
				for(frame = startFrame; frame != endFrame; ++frame)
				{
					frameArr.push(frame);
				}
				
				mSprite.spriteSheet.addAnimation(MagicConst.STR_ANIMATION_NAME + mCurTexDir, frameArr, false);				
			}
			else //其他情况，循环播放
			{
				for(frame = startFrame; frame != endFrame; ++frame)
				{
					frameArr.push(frame);
				}
				
				mSprite.spriteSheet.addAnimation(MagicConst.STR_ANIMATION_NAME + mCurTexDir, frameArr, true);				
			}
			
			mSprite.spriteSheet.playAnimation(MagicConst.STR_ANIMATION_NAME + mCurTexDir);
			
			doInit();
			
			return mConfig.mSibling;
		}
		
		protected function update(elapsed:Number):void
		{
			
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
				
				clean();
				
				return;
			}
			
			update(elapsed);
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


