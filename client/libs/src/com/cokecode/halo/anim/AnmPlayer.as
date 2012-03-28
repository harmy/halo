package com.cokecode.halo.anim
{
	/*
		动画播放
	*/
//	import Client.Define.GameDefine;
//	
//	import Lib.Texture.TbeFrameInfo;
//	import Lib.Texture.TbeImageDict;
//	import Lib.Texture.TbeImageLoader;
//	import Lib.Texture.TexInstance;
	
	import com.cokecode.halo.data.CoreConst;
	import com.cokecode.halo.terrain.Map;
	
	import de.nulldesign.nd2d.display.Node2D;
	import de.nulldesign.nd2d.display.Sprite2D;
	import de.nulldesign.nd2d.materials.texture.ASpriteSheetBase;
	
	import flash.display.BitmapData;
	import flash.display.BlendMode;
	import flash.geom.ColorTransform;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;

	
	public class AnmPlayer extends Node2D
	{
		public static var FLANIMFPS:Number = 1;
		public static var ENTER_FRAME:int = 0x1;
		public static var END_REACHED:int = 0x2;
		
		protected var mFpsRate:Number = 1;	// 动画帧数的倍率

		protected var mLayerAtlas:Array;		// 每一层的贴图 (AniAtlasLoader)
		protected var mLayerSprite:Array;		// 每一层的Sprite2D
		
		protected var mModel:Model;				//模型
		protected var mAnim:Animation;			//动画
		protected var mCurFrame:int;			//当前帧
		protected var mCurDir:int;				//当前方向
		protected var mAnDelayFrame:Number;		//当前延迟
		
		protected var mIsReload:Boolean;		//是否已加载
		protected var mIsPlaying:Boolean;		//播放状态
		public var mItemNo:Array = [303,0,0,104,0,0,0,0,0];
		//public var mItemNo:Array = [-1,-1,-1,-1,-1,0,0,0,0];
		protected var mAnimCB:Function;		//动画回调函数
		// function(int)
		private static var mOffPos:Point = new Point;
		protected var mBoundBox:Rectangle=new Rectangle;
		
		/**
		 * 动画贴图和切割信息集合
		 */
		protected var mAniAtlasDict:AniAtlasLoaderDict;
		
		public function AnmPlayer(atlasTexDict:AniAtlasLoaderDict)
		{
			mCurDir = 0;
			mCurFrame = 0;		//当前
			mCurDir = 0;			//当前方向
			mAnDelayFrame = 0;		//当前延迟
			
			mIsReload = false;
			mLayerAtlas = [];
			mLayerSprite = [];
			
			mAniAtlasDict = atlasTexDict;
			
			mIsPlaying = false;		//停止
			mAnimCB = null;
		}
		
		public function set fpsRate(value:Number):void
		{
			mFpsRate = value;
		}
		
		public function get fpsRate():Number
		{
			return mFpsRate;
		}
		
		// 设置颜色
		public function setColorTransform(colorTrans:ColorTransform):void
		{
			
		}
		
		public function setCallBack(cbFunc:Function):void
		{
			mAnimCB = cbFunc;
		}
		
		public function stop():void
		{
			mIsPlaying = false;
		}
		
		/**
		 * 播放动画
		 * @param	aniName	如果是null表示播放当前的动画, 否则表示播放指定名字的动画
		 */
		public function playAnim(aniName:String = null):void
		{
			if (aniName != null) {
				var anim:Animation = AnimMgr.instance.getAnim(mModel.mName, aniName);
				animation = anim;
			}
			
			mIsPlaying = true;
		}
		
		public function set animation(value:Animation):void
		{
			mAnim = value;
		}
		
		public function get animation():Animation
		{
			return mAnim;
		}
		
		public function set model(value:Model):void
		{
			mModel = value;
		}
		
		public function get model():Model
		{
			return mModel;
		}
		
		public function set dir(value:int):void
		{
			mCurDir = value;
		}
		
		public function get dir():int
		{
			return mCurDir;
		}
		
		public function getBoundBox():Rectangle
		{
			return mBoundBox;
		}
		
		public function setCurFrame(iFrame:int,iLimit:int):int
		{
			if(iFrame > iLimit)
				iFrame = iLimit-1;
				
			if(iFrame<0)
				iFrame = 0;
				
			mCurFrame = iFrame;

			return mCurFrame;
		}
		
		public function setResourceFrame(resFrame:Array, start:uint = 0):void
		{
			// 设置每一层的动画当前帧
			for(var i:uint=0 ; i<mLayerAtlas.length; i++) {
				if (mLayerSprite[i] == null) continue;
				var sprite:Sprite2D = mLayerSprite[i] as Sprite2D; 
				sprite.spriteSheet.frame = start + resFrame[i];
			}
		}
		
		public function resetTime():void
		{
			mAnDelayFrame =0;
			mCurFrame = -1;
		}
		
		public function getMaxFrameTime():uint
		{
			return mAnim.mMaxFrameTime;
		}
		
		
		public function addDeltaTime(elapsed:Number):void
		{
			if(mAnim==null)
				return;
				
			if(mAnim.mIsLoad==false)
				return;
				
			if(mIsPlaying==false)
				return;
				
			//转到毫秒
			elapsed = elapsed * 1000;
			
			var tempFPS:Number = AnmPlayer.FLANIMFPS / mFpsRate;
			//trace(tempFPS);
			var fDeltaTime:Number = elapsed * tempFPS;
			var pSeqFrame:AniSeqFrame;
			
			if(mAnDelayFrame<=0) {
				var aniCurFrame:int = mCurFrame;
				var nMaxFrame:int = mAnim.mSeqFrame[mCurDir].length;
				
				if(aniCurFrame>=nMaxFrame-1) {
					if(mAnimCB!=null) {
						mAnimCB(END_REACHED);
					}

					aniCurFrame = -1;
				}
				
				
				setCurFrame(aniCurFrame+1 , nMaxFrame);
				
				//trace("当前帧：" + getCurFrame());
				
				if(mAnim.mSeqFrame==null)
					return;
					
				pSeqFrame = mAnim.mSeqFrame[mCurDir][mCurFrame];
				if(pSeqFrame) {
					mAnDelayFrame = pSeqFrame.mDelayFrame + 1;
				} else {
					mAnDelayFrame =0;
				}
			} else {
				mAnDelayFrame -=fDeltaTime;
			}
			
			// 实时更新动画的当前帧
			pSeqFrame = mAnim.mSeqFrame[mCurDir][mCurFrame];
			if(pSeqFrame) {
				var frameStart:uint;
				if (mModel.mAtlasTexType == CoreConst.ACTION_ONE_TEX) {
					// 通过动作名称索引出贴图下标
					frameStart = mModel.mActionParam.getActionIndex(mAnim.mName);
				} else if (mModel.mAtlasTexType == CoreConst.ACTION_MORE_TEX) {
					frameStart = 0;
				}
				setResourceFrame(pSeqFrame.mResource, frameStart);
			}
		}
		
		public function getFrameCount():int
		{
			if(mAnim==null)
				return 0;
				
			if(mAnim.mIsLoad==false)
				return 0;
				
			if(mCurDir<0)
				return 0;
				
			return mAnim.mSeqFrame[mCurDir].length;
		}
		
		public function getCurFrame():int
		{
			return mCurFrame;
		}
		
		public function update(elapsed:Number):void
		{
			addDeltaTime(elapsed);
			
			if(!mIsReload) {
				
				var bLoadAnim:Boolean = false;
				var bLoadModel:Boolean = false;
			
				if(mAnim)
				{
					if(mAnim.mIsLoad==true)
					{
						bLoadAnim =true;
					}
				}
			
				if(mModel)
				{
					if(mModel.mIsLoad==true)
					{
						bLoadModel = true;
					}	
				}

				if(bLoadAnim && bLoadModel)
				{
					reloadTexture();
				}
			}
			
			// 创建处理动画
			updateLayerSprite();
			
			// 更新图层顺序
			updateLayerOrder();
		}
		
		
		// 创建处理动画
		public function updateLayerSprite():void
		{
			for(var i:uint=0; i<mLayerAtlas.length; i++) {
				if (mLayerSprite[i] != null) continue;
				var aniAtlasLoader:AniAtlasLoader = mLayerAtlas[i];
				if (aniAtlasLoader == null) continue;
				if (aniAtlasLoader.spriteSheet == null) continue;
				
				var spriteSheet:ASpriteSheetBase = aniAtlasLoader.spriteSheet.clone();
				var sprite:Sprite2D = new Sprite2D(aniAtlasLoader.texture); 
				sprite.setSpriteSheet( spriteSheet );
				mLayerSprite[i] = sprite;
				sprite.pivot.x = -(Map.sTileWidth >> 1);
				sprite.pivot.y = -(Map.sTileHeight >> 1);
				addChild(mLayerSprite[i]);
			}
		}
		
		// 根据配置更新层的顺序和坐标偏移
		public function updateLayerOrder():void
		{
			if (mAnim == null || mAnim.mSeqFrame == null) return;
			
			var pSeqFrame:AniSeqFrame = mAnim.mSeqFrame[mCurDir][mCurFrame];
			if (pSeqFrame == null) return;
			
			removeAllChildren();
			
			var index:uint;
			var posX:int;
			var posY:int;
			for(var i:uint=0; i<pSeqFrame.mLayer.length; i++) {
				index = pSeqFrame.mLayer[i];
				posX = pSeqFrame.mPosX[i];
				posY = pSeqFrame.mPosY[i];
				if (mLayerSprite[index] != null) {
					mLayerSprite[index].x = posX;
					mLayerSprite[index].y = posY;
					addChild( mLayerSprite[index] );
				}
			}
		}
		
		
		public function generateTexName(iLayerID:int,iItemID:int,iImgID:int=-1,pExt:String=null):String
		{
			var ret:String = "";
			ret+=int(iLayerID/10);
			ret+=iLayerID%10;
			//ret+="_";
			ret+=int(iItemID/1000) % 10;
			ret+=int(iItemID/100) % 10;
			ret+=int(iItemID/10) % 10;
			ret+=iItemID % 10;
			
			if (iImgID >= 0) {
				//ret+="_";
				ret+=int(iImgID/100) % 10;
				ret+=int(iImgID/10) % 10;
				ret+=iImgID % 10;
			}
			
			if(pExt!=null)
				ret+=pExt;
			return ret;
		}
	
		public function preloadAllTexture():void
		{
			//var pImageName:String = GenerateTexName(mModel.vLayers[i].iLayer, mItemNo[i] ,mAnim.vTexId[i]);
			//mTexDict.LoadImage( mModel.Name+"/texcom/"+pImageName );
		}
		
		public function reloadTexture():void
		{
			mLayerAtlas =null;
			if(mModel==null)
				return;
				
			if(mModel.mIsLoad==false)
				return;
			
			if(mAnim==null)
				return;
				
			mLayerAtlas = [];
			var forlen:int = mModel.mLayers.length;
			for(var i:int = 0 ; i < forlen; i++)
			{
				if(mAnim.mTexId==null)
					return;
				
				if (mModel.mLayers[i].mLayer != 0 && mItemNo[i] == 0)
					continue;

				var pImageName:String;
				if (mModel.mAtlasTexType == CoreConst.ACTION_ONE_TEX) {
					pImageName = generateTexName(mModel.mLayers[i].mLayer, mItemNo[i], 0);
				} else if (mModel.mAtlasTexType == CoreConst.ACTION_MORE_TEX) {
					pImageName = generateTexName(mModel.mLayers[i].mLayer, mItemNo[i], mAnim.mTexId[i]);
				}
				mLayerAtlas[i] = mAniAtlasDict.loadAniAtlas( mModel.mName+"/texcom/"+pImageName );
			}
			
			mIsReload = true;
		}
		
//		public function getLayerImage(nLayer:int):TbeImageLoader
//		{
//			return nLayer < mLayerTex.length?mLayerTex[nLayer]:null;
//		}
		
		private function initAnim():Boolean{
			if(mAnim==null)
				return false;
			
			if(mAnim.mIsLoad==false)
				return false;
			
			if (this.mCurDir == -1){
				this.mCurDir = 4;
			}
			
			if (this.mCurDir > this.mAnim.mSeqFrame.length){
				this.mCurDir = 0;
			}
			
			if (this.mAnim.mSeqFrame[this.mCurDir].length == 0){
				return false;
			}
			
			if (this.mCurFrame >= this.mAnim.mSeqFrame[this.mCurDir].length){
				this.mCurFrame = (this.mAnim.mSeqFrame[this.mCurDir].length - 1);
			}
			
			if (this.mCurFrame < 0){
				this.mCurFrame = 0;
			}
			
			mBoundBox.x=0xffff;
			mBoundBox.y=0xffff;
			mBoundBox.width=0;
			mBoundBox.height=0;
			
			return true;
		}
		
		/**
		 * 由于图片问题，不同方向上需要偏移一定距离，
		 * 以免各个方向上的影子间距不一样
		 * 
		 */		
		private function getCollideOffsetPos():void{
			switch(mCurDir)
			{
				case 0:
				{
					mOffPos.x = 0;
					mOffPos.y = mBoundBox.height - 10;
					break;
				}
				case 1:
				{
					mOffPos.x = -mBoundBox.width;
					mOffPos.y = mBoundBox.height / 2;
					break;
				}
				case 2:
				{
					mOffPos.x = -mBoundBox.width - 10;
					mOffPos.y = 0;
					break;
				}
				case 3:
				{
					mOffPos.x = -mBoundBox.width + 10;
					mOffPos.y = -mBoundBox.height / 2;
					break;
				}
				case 4:
				{
					mOffPos.x = 0;
					mOffPos.y = -mBoundBox.height / 2 - 15;
					break;
				}
				case 5:
				{
					mOffPos.x = mBoundBox.width;
					mOffPos.y = -mBoundBox.height / 2 - 15;
					break;
				}
				case 6:
				{
					mOffPos.x = mBoundBox.width;
					mOffPos.y = 0;
					break;
				}
				case 7:
				{
					mOffPos.x = mBoundBox.width - 10;
					mOffPos.y = mBoundBox.height / 2;
					break;
				}
			}
		}
		
		// 判断贴图是否已加载完成
		public function isTextureLoaded():Boolean
		{
//			var pSurface:TbeImageLoader = getLayerImage(0);
//			if (pSurface == null)
//				return false;
//			if (pSurface.Img == null)
//				return false;
//			if (pSurface.Img.GetBitmapData() == null)
//				return false;
			
			return true;
		}
		
		
		// 是否是空的帧
		public function isEmptyFrame(dir:uint, frame:uint):Boolean
		{
			if(!initAnim())
				return true;
			
			var isEmpty:Boolean = true;			
			/*
			var vFramePartList:AniSeqFrame = mAnim.mSeqFrame[dir][frame];
			if (vFramePartList == null) return true;
			var forlen:int = vFramePartList.nLen;
			for(var i:int=0; i < forlen ; i+=1 )
			{
				var pSurface:TbeImageLoader = GetLayerImage(vFramePartList.iLayer[i]);
				
				if(pSurface == null)
					continue;
				
				if(pSurface.IsLoad==false)
					continue;
				
				var info:TbeFrameInfo = pSurface.GetInfo(vFramePartList.iResource[i]);
				var Lay:AniLayer = mModel.vLayers[vFramePartList.iLayer[i]];
				
				if(info==null)
					continue;
				
				if (info.width > 1 && info.height > 1)
					isEmpty = false;
			}
			*/
			
			return isEmpty;
		}
		
		/*
		public function getClipRect(outrc:Rectangle,pSurface:TexInstance,nClipW:int,nClipH:int,inno:int):void
		{
			var nx:int = pSurface.GetBitmapData().width  / nClipW;
			var ny:int = pSurface.GetBitmapData().height / nClipH;
			
			var cx:int = inno % nx;
			var cy:int = inno / nx % ny;

			outrc.left=cx * nClipW;
			outrc.top=cy * nClipH;

			outrc.right=outrc.left + nClipW;
			outrc.bottom = outrc.top + nClipH;
		}
		*/

		/*
		public function mouseIntersect2(rx:int,ry:int,cx:int,cy:int):Boolean
		{
			if (mAnim.mSeqFrame == null) return false;
			
			var vFramePartList:AniSeqFrame = mAnim.mSeqFrame[mCurDir][mCurFrame];
			if(vFramePartList==null)
				return false;
			
			var forlen:int = vFramePartList.nLen;
			for(var i:int=0; i < forlen ; i+=1 )
			{
				var pSurface:TbeImageLoader = GetLayerImage(vFramePartList.iLayer[i]);
				
				if(pSurface == null)
					continue;
				
				if(pSurface.IsLoad==false)
					continue;
				
				var info:TbeFrameInfo = pSurface.GetInfo(vFramePartList.iResource[i]);
				var Lay:AniLayer = mModel.vLayers[vFramePartList.iLayer[i]];
				
				if(info==null)
					continue;
				
				mSrcRc.x = info.x;
				mSrcRc.y = info.y;
				mSrcRc.width = info.width;
				mSrcRc.height = info.height;
				
				mDrc.x=vFramePartList.iPosX[i] - (Lay.iTexW >>1) + cx + info.iOffsetX;
				mDrc.y=vFramePartList.iPosY[i] - (Lay.iTexH >>1) + cy + info.iOffsetY;
				
				var layNo:int = Lay.iLayer;
				
				var bmd:BitmapData =pSurface.Img.GetBitmapData();
				if(bmd ==null) continue;
				var tu:int = rx - mDrc.x + mSrcRc.x;
				var tv:int = ry - mDrc.y + mSrcRc.y;
				var pixelValue:uint = bmd.getPixel32(tu,tv);
				var alphaValue:uint = pixelValue >> 24 & 0xFF;
				
				if(alphaValue!=0)
					return true;
			}
			
			return false;
		}
		
		public function mouseIntersect(rx:int,ry:int):Boolean
		{
			if(mAnim==null)
				return false;
				
			if(mAnim.IsLoad==false)
				return false;
			
			if(mCurDir==-1)
				mCurDir=4;
			
			if(mCurFrame >= mAnim.mSeqFrame[mCurDir].length || mCurFrame < 0)
				return false;

			var vFramePartList:AniSeqFrame = mAnim.mSeqFrame[mCurDir][mCurFrame];

			var forlen:int = vFramePartList.nLen;
			for(var i:int=0; i < forlen ; i+=1 )
			{
				var pSurface:TbeImageLoader = GetLayerImage(vFramePartList.iLayer[i]);
				
				if(pSurface == null)
					continue;
					
				if(pSurface.IsLoad==false)
					continue;
		
				var info:TbeFrameInfo = pSurface.GetInfo(vFramePartList.iResource[i]);
				var Lay:AniLayer = mModel.vLayers[vFramePartList.iLayer[i]];
				
				if(info==null)
					continue;
					
				mSrcRc.x = info.x;
				mSrcRc.y = info.y;
				mSrcRc.width = info.width;
				mSrcRc.height = info.height;

				mDrc.x=vFramePartList.iPosX[i] - (Lay.iTexW >>1) + info.iOffsetX;
				mDrc.y=vFramePartList.iPosY[i] - (Lay.iTexH >>1) + info.iOffsetY;

				var bmd:BitmapData =pSurface.Img.GetBitmapData();
				
				if(bmd ==null)
					continue;
				
				var tu:int = rx - mDrc.x + mSrcRc.x;
				var tv:int = ry - mDrc.y + mSrcRc.y;
				
				if(mSrcRc.width < rx)
					continue;
				
				if(mSrcRc.height < ry)
					continue;
				
				var pixelValue:uint = bmd.getPixel32(tu,tv);
				var alphaValue:uint = pixelValue >> 24 & 0xFF;
				
				if(alphaValue!=0)
					return true;

			}
			
			
			return false;
		}
		*/
		
	}
	
	
}
