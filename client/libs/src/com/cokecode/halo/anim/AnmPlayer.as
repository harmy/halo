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
	
	import flash.display.BitmapData;
	import flash.display.BlendMode;
	import flash.geom.ColorTransform;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;

	
	public class AnmPlayer
	{
		public static var FLANIMFPS:Number = 50;

		
		protected var mModel:Model;			//模型
		protected var mAnim:Animation;			//动画
		
		protected var mCurFrame:int;			//当前帧
		//protected var mCurFrameDelay:int;		//当前延迟
		protected var mCurDir:int;				//当前方向
		protected var mAnDelayFrame:Number;	//当前延迟
		
		protected var mLayerTex:Array;
		protected var mIsReload:Boolean;
		//protected var mTexDict:TbeImageDict;
		
		
		
		
		protected var mIsPlaying:Boolean;			//播放
		
		//public var mItemNo:Array = [1,1,1,1,1,0,0,0,0];
		public var mItemNo:Array = [-1,-1,-1,-1,-1,0,0,0,0];
		
		protected var mAnimCB:Function;		//动画回调函数
		// function(int)
		
		
		protected var mBoundBox:Rectangle=new Rectangle;
		
		public static var ENTER_FRAME:int = 0x1;
		public static var END_REACHED:int = 0x2;
		
		protected var mSrcRc:Rectangle = new Rectangle;
		protected var mDrc:Point= new Point;
		
		/**
		 * 绘制特效相关
		 */
		private var mEffectColor:ColorTransform;
		
		/**
		 * 换色区绘制优化
		 */
		private var mMatrix:Matrix = new Matrix;
		private var mClipRc:Rectangle = new Rectangle;
		
		/**
		 * 冲撞动作的残影数量 
		 */
		private static var mCollideNum:int = 2;
		private static var mOffPos:Point = new Point;
			
		public function AnmPlayer(/*itexDict:TbeImageDict*/)
		{
			mCurDir = 0;
			mCurFrame = 0;		//当前
			//mCurFrameDelay = 0;	//当前延迟
			mCurDir = 0;			//当前方向
			mAnDelayFrame = 0;		//当前延迟
			
			mIsReload = false;
			mLayerTex = [];
			
			//mTexDict = itexDict;
			
			mIsPlaying = false;		//停止
			mAnimCB = null;
		}
		
		public function setRenderEffect(colorTrans:ColorTransform):void
		{
			mEffectColor = colorTrans;
		}
		
		public function SetCallBack(cbFunc:Function):void
		{
			mAnimCB = cbFunc;
		}
		
		public function Stop():void
		{
			mIsPlaying = false;
		}
		public function SetAnimation(iAnim:Animation):void
		{
			mAnim = iAnim;
			mIsPlaying = true;
		}
		
		public function SetModel(iModel:Model):void
		{
			mModel=iModel;
		}
		
		public function SetDir(nDir:int):void
		{
			mCurDir = nDir;
		}
		
		public function GetDir():int
		{
			return mCurDir;
		}
		
		public function GetBoundBox():Rectangle
		{
			return mBoundBox;
		}
		
		public function SetCurFrame(iFrame:int,iLimit:int):int
		{
			if(iFrame > iLimit)
				iFrame = iLimit-1;
				
			if(iFrame<0)
				iFrame = 0;
				
			mCurFrame = iFrame;
			

			return mCurFrame;
		}
		
		public function ResetTime():void
		{
			mAnDelayFrame =0;
			mCurFrame = -1;
			
		}
		
		public function GetMaxFrameTime():int
		{
			return mAnim.MaxFrameTime;
		}
		
		public function AddDeltaTime(deltaTime:Number):void
		{
			if(mAnim==null)
				return;
				
			if(mAnim.IsLoad==false)
				return;
				
			if(mIsPlaying==false)
				return;
				
			var fDeltaTime:Number = deltaTime * AnmPlayer.FLANIMFPS;
			
			if(mAnDelayFrame<=0)
			{
				var m_AnCurFrame:int = mCurFrame;
				var nMaxFrame:int = mAnim.vSeqFrame[mCurDir].length;
				
//				while (mCurFrame < nMaxFrame) {
//					if (!IsEmptyFrame(mCurDir, mCurFrame+1)) {
//						break;
//					} 
//					
//					mCurFrame++;
//					// 如果下一帧是空帧，就直接跳过
//				}
					
				if(m_AnCurFrame>=nMaxFrame-1)
				{
					if(mAnimCB!=null)
					{
						mAnimCB(END_REACHED);
					}

					m_AnCurFrame = -1;
				}
				
				
				SetCurFrame(m_AnCurFrame+1 , nMaxFrame);
				
				if(mAnim.vSeqFrame==null)
					return;
					
				var pSeqFrame:AniSeqFrame = mAnim.vSeqFrame[mCurDir][mCurFrame];
				
				if(pSeqFrame)
				{
					mAnDelayFrame = pSeqFrame.iDelayFrame + 1;
				}
				else
				{
					mAnDelayFrame =0;
				}
			}
			else
			{
				mAnDelayFrame -=fDeltaTime;
			}
		}
		
		public function GetFrameCount():int
		{
			if(mAnim==null)
				return 0;
				
			if(mAnim.IsLoad==false)
				return 0;
				
			if(mCurDir<0)
				return 0;
				
			return mAnim.vSeqFrame[mCurDir].length;
		}
		
		public function GetCurFrame():int
		{
			return mCurFrame;
		}
		
		public function Update(deltaTime:Number):void
		{
			AddDeltaTime(deltaTime);
			
			if(mIsReload == false)
			{
				
				var bLoadAnim:Boolean = false;
				var bLoadModel:Boolean = false;
			
				if(mAnim)
				{
					if(mAnim.IsLoad==true)
					{
						bLoadAnim =true;
					}
				}
			
				if(mModel)
				{
					if(mModel.IsLoad==true)
					{
						bLoadModel = true;
					}	
				}

				if(bLoadAnim && bLoadModel)
				{
					ReloadTexture();
				}
			}
		}
		
		public function GenerateTexName(iLayerID:int,iItemID:int,iImgID:int,pExt:String=null):String
		{
			var ret:String = "";
			ret+=int(iLayerID/10);
			ret+=iLayerID%10;
			//ret+="_";
			ret+=int(iItemID/1000) % 10;
			ret+=int(iItemID/100) % 10;
			ret+=int(iItemID/10) % 10;
			ret+=iItemID % 10;
			//ret+="_";
			ret+=int(iImgID/100) % 10;
			ret+=int(iImgID/10) % 10;
			ret+=iImgID % 10;
			if(pExt!=null)
				ret+=pExt;
			return ret;
		}
	
		public function PreloadAllTexture():void
		{
			//var pImageName:String = GenerateTexName(mModel.vLayers[i].iLayer, mItemNo[i] ,mAnim.vTexId[i]);
			//mTexDict.LoadImage( mModel.Name+"/texcom/"+pImageName );
		}
		
		public function ReloadTexture():void
		{
			mLayerTex =null;
			if(mModel==null)
				return;
				
			if(mModel.IsLoad==false)
				return;
			
			if(mAnim==null)
				return;
				
			mLayerTex = [];
			var forlen:int = mModel.vLayers.length;
			for(var i:int = 0 ; i < forlen; i++)
			{
				if(mAnim.vTexId==null)
					return;
				
				if (mModel.vLayers[i].iLayer != 0 && mItemNo[i] == 0)
					continue;

				var pImageName:String = GenerateTexName(mModel.vLayers[i].iLayer, mItemNo[i] ,mAnim.vTexId[i]);
				mLayerTex[i] = mTexDict.LoadImage( mModel.Name+"/texcom/"+pImageName );
			}
			
			mIsReload = true;
		}
		
		public function GetLayerImage(nLayer:int):TbeImageLoader
		{
			return nLayer < mLayerTex.length?mLayerTex[nLayer]:null;
		}
		
		private function InitAnim():Boolean{
			if(mAnim==null)
				return false;
			
			if(mAnim.IsLoad==false)
				return false;
			
			if (this.mCurDir == -1){
				this.mCurDir = 4;
			}
			
			if (this.mCurDir > this.mAnim.vSeqFrame.length){
				this.mCurDir = 0;
			}
			
			if (this.mAnim.vSeqFrame[this.mCurDir].length == 0){
				return false;
			}
			
			if (this.mCurFrame >= this.mAnim.vSeqFrame[this.mCurDir].length){
				this.mCurFrame = (this.mAnim.vSeqFrame[this.mCurDir].length - 1);
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
		
		public function RenderCollide(target:BitmapData,cx:int,cy:int):void{
			if(!InitAnim())
				return;
			
			mCurFrame = mAnim.vSeqFrame[mCurDir].length - 2;
			var vFramePartList:AniSeqFrame = mAnim.vSeqFrame[mCurDir][mCurFrame];
			if(vFramePartList==null)
			{
				Render(target, cx, cy);
				return;
			}
			
			var genBoundBox:Boolean = true;
			var alpha:Array = [1, 0.8, 0.5];
			for(var i:int=0; i<=mCollideNum; i++)
			{
				RenderChar(target, cx, cy, vFramePartList, genBoundBox, alpha[i]);
				if(genBoundBox)
				{
					genBoundBox = false;
					GetCollideOffsetPos();
				}
				cx += mOffPos.x + i*3;
				cy += mOffPos.y + i*2;
			}
			
		}
		
		/**
		 * 由于图片问题，不同方向上需要偏移一定距离，
		 * 以免各个方向上的影子间距不一样
		 * 
		 */		
		private function GetCollideOffsetPos():void{
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
		
		private function RenderChar(target:BitmapData,cx:int,cy:int, vFramePartList:AniSeqFrame, genBoundBox:Boolean, alpha:Number):void{
			//将透明度换算成16进制的字符
			var alphaValue:int =alpha*255;
//			var alphaStr:String = alphaValue.toString(16);
//			alphaStr = "0x"+alphaStr+"000000";
			
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
				if(pSurface.Img.GetBitmapData()) {
					var colorTrans:ColorTransform;
					var colorTransTemp:ColorTransform = new ColorTransform;
					if(layNo == 3) continue;
					mMatrix.identity();
					mMatrix.tx = (-(mSrcRc.x) + mDrc.x);
					mMatrix.ty = (-(mSrcRc.y) + mDrc.y);
					mClipRc.x = mDrc.x;
					mClipRc.y = mDrc.y;
					mClipRc.width = mSrcRc.width;
					mClipRc.height = mSrcRc.height;
					if (layNo == 1 || layNo == 2) {
						// 头发和衣服设置颜色调制
						if (layNo == 1) {
							colorTrans = GameDefine.COLOR_TABLE.GetHairColor(5);
						} else if (layNo == 2) {
							colorTrans = GameDefine.COLOR_TABLE.GetBodyColor(0, 5);
						}
						colorTransTemp.alphaMultiplier = colorTrans.alphaMultiplier;// * alpha;
						colorTransTemp.redMultiplier = colorTrans.redMultiplier;
						colorTransTemp.greenMultiplier = colorTrans.greenMultiplier;
						colorTransTemp.blueMultiplier = colorTrans.blueMultiplier; 
					} 
					var alphaOffset:Number = 255 - alphaValue;	// 设置透明度偏移值
					colorTransTemp.alphaOffset = -alphaOffset;
					if (mEffectColor != null) {
						// 使用特效绘制
						colorTransTemp.redOffset = mEffectColor.redOffset;
						colorTransTemp.greenOffset = mEffectColor.greenOffset;
						colorTransTemp.blueOffset = mEffectColor.blueOffset;
						colorTransTemp.alphaOffset = mEffectColor.alphaOffset - alphaOffset;
					}
					target.draw(pSurface.Img.GetBitmapData(), mMatrix, colorTransTemp, BlendMode.NORMAL, mClipRc, false);
				}
				
				if(genBoundBox)
				{
					mBoundBox.x 		= Math.min(mBoundBox.x,mDrc.x);
					mBoundBox.y 		= Math.min(mBoundBox.y,mDrc.y);	
					mBoundBox.right	= Math.max(mBoundBox.right,mDrc.x+mSrcRc.width);
					mBoundBox.bottom	= Math.max(mBoundBox.bottom,mDrc.y+mSrcRc.height);
				}
			}
		}
		
		// 判断贴图是否已加载完成
		public function IsTextureLoaded():Boolean
		{
			var pSurface:TbeImageLoader = GetLayerImage(0);
			if (pSurface == null)
				return false;
			if (pSurface.Img == null)
				return false;
			if (pSurface.Img.GetBitmapData() == null)
				return false;
			
			return true;
		}
		
		
		// 是否是空的帧
		public function IsEmptyFrame(dir:uint, frame:uint):Boolean
		{
			if(!InitAnim())
				return true;
			
			var isEmpty:Boolean = true;			
			var vFramePartList:AniSeqFrame = mAnim.vSeqFrame[dir][frame];
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
			
			return isEmpty;
		}
		
		
		static private var colorTransTemp:ColorTransform = new ColorTransform;
		
		public function Render(target:BitmapData,cx:int,cy:int):void
		{
			if(!InitAnim())
				return;
		
			var vFramePartList:AniSeqFrame = mAnim.vSeqFrame[mCurDir][mCurFrame];

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
				
				if(pSurface.Img && pSurface.Img.GetBitmapData()) {
					mMatrix.identity();
					mMatrix.tx = (-(mSrcRc.x) + mDrc.x);
					mMatrix.ty = (-(mSrcRc.y) + mDrc.y);
					mClipRc.x = mDrc.x;
					mClipRc.y = mDrc.y;
					mClipRc.width = mSrcRc.width;
					mClipRc.height = mSrcRc.height;
					var useDraw:Boolean = false;
					var colorTrans:ColorTransform;
					// 初始化数据
					colorTransTemp.redMultiplier = 1;
					colorTransTemp.greenMultiplier = 1;
					colorTransTemp.blueMultiplier = 1;
					colorTransTemp.alphaMultiplier = 1;
					colorTransTemp.redOffset = 0;
					colorTransTemp.greenOffset = 0;
					colorTransTemp.blueOffset = 0;
					colorTransTemp.alphaOffset = 0;
					if (layNo == 1 || layNo == 2) {
						// 头发和衣服设置颜色调制
						if (layNo == 1) {
							colorTrans = GameDefine.COLOR_TABLE.GetHairColor(5);
						} else if (layNo == 2) {
							colorTrans = GameDefine.COLOR_TABLE.GetBodyColor(0, 5);
						}
						colorTransTemp.redMultiplier = colorTrans.redMultiplier;
						colorTransTemp.greenMultiplier = colorTrans.greenMultiplier;
						colorTransTemp.blueMultiplier = colorTrans.blueMultiplier; 
						useDraw = true;
					}
					if (mEffectColor != null) {
						// 使用特效绘制
						colorTransTemp.redOffset = mEffectColor.redOffset;
						colorTransTemp.greenOffset = mEffectColor.greenOffset;
						colorTransTemp.blueOffset = mEffectColor.blueOffset;
						colorTransTemp.alphaOffset = mEffectColor.alphaOffset;
						useDraw = true;
					}
					
					if (useDraw) {
						target.draw(pSurface.Img.GetBitmapData(), mMatrix, colorTransTemp, BlendMode.NORMAL, mClipRc, false);	
					} else {
						target.copyPixels(pSurface.Img.GetBitmapData(), mSrcRc, mDrc, null, null, true);
					}
				}
				
				mBoundBox.x 		= Math.min(mBoundBox.x,mDrc.x);
				mBoundBox.y 		= Math.min(mBoundBox.y,mDrc.y);	
				mBoundBox.right	= Math.max(mBoundBox.right,mDrc.x+mSrcRc.width);
				mBoundBox.bottom	= Math.max(mBoundBox.bottom,mDrc.y+mSrcRc.height);
			}
		}
		
		public function GetClipRect(outrc:Rectangle,pSurface:TexInstance,nClipW:int,nClipH:int,inno:int):void
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

		public function MouseIntersect2(rx:int,ry:int,cx:int,cy:int):Boolean
		{
			if (mAnim.vSeqFrame == null) return false;
			
			var vFramePartList:AniSeqFrame = mAnim.vSeqFrame[mCurDir][mCurFrame];
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
		
		public function MouseIntersect(rx:int,ry:int):Boolean
		{
			if(mAnim==null)
				return false;
				
			if(mAnim.IsLoad==false)
				return false;
			
			if(mCurDir==-1)
				mCurDir=4;
			
			if(mCurFrame >= mAnim.vSeqFrame[mCurDir].length || mCurFrame < 0)
				return false;

			var vFramePartList:AniSeqFrame = mAnim.vSeqFrame[mCurDir][mCurFrame];

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
	}
	
	
}
