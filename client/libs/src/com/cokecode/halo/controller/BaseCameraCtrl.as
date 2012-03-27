package com.cokecode.halo.controller
{
	import de.nulldesign.nd2d.display.Node2D;
	
	import flash.geom.Point;
	import flash.utils.getTimer;

	public class BaseCameraCtrl extends Controller
	{
		public static const SHAKE_X:uint = 1;		// X方向震动
		public static const SHAKE_Y:uint = 2;		// Y方向震动
		public static const SHAKE_XY:uint = 3;	// XY方向震动
		
		/**
		 * 被跟踪的目标
		 */
		protected var mTargetNode:Node2D;
		
		/**
		 * 地图尺寸，限制相机不超出地图之外
		 */
		protected var mMapSize:Point = new Point(1000, 1000);
		
		// 专门用于计算震屏效果
		protected var mShakeLastTick:uint;	
		protected var mShakeStartTick:uint;
		protected var mShakeCurSpan:Number;
		protected var mShakeOffset:Point = new Point;
		
		protected var mShakeDir:uint;			// 震动方向(SHAKE_X,SHAKE_Y,SHAKE_XY)
		protected var mShakeSpan:Number;		// 震动幅度(像素)
		protected var mShakeFrequency:Number;	// 震动频率(毫秒)
		protected var mShakeTime:uint;		// 持续时间(毫秒)
		
		public function BaseCameraCtrl()
		{
			super();
		}
		
		public function set target(value:Node2D):void
		{
			mTargetNode = value;
		}
		
		public function get target():Node2D
		{
			return mTargetNode;
		}
		
		public function set mapSize(value:Point):void
		{
			mMapSize = value;
		}
		
		public function get mapSize():Point
		{
			return mMapSize;
		}
		
		/**
		 * @param dir	震动方向(SHAKE_X,SHAKE_Y,SHAKE_XY)
		 * @param span	震动幅度(像素)
		 * @param time	持续时间(毫秒)
		 * @param frequency	震动频率(毫秒),表示多少时间处理一次
		 */
		public function shake(dir:uint, span:uint, time:uint, frequency:uint=100):void
		{
			mShakeOffset.x = mShakeOffset.y = 0;
			mShakeDir = dir;
			mShakeSpan = span;
			mShakeTime = time;
			mShakeFrequency = frequency;
			
			mShakeCurSpan = span;
			mShakeStartTick = getTimer();
			mShakeLastTick = getTimer();
		}
		
		protected function updateShake():void
		{
			// 处理震屏
			var curTick:uint = getTimer();
			if (curTick - mShakeLastTick > mShakeFrequency) {
				mShakeLastTick = curTick;
				
				if (curTick - mShakeStartTick < mShakeTime) {
					// 根据时间，计算出当前的振幅
					var percent:Number = 1 - (curTick - mShakeStartTick) / mShakeTime;
					//trace("percent: " + percent);
					mShakeCurSpan = mShakeSpan * percent;
					//trace("m_shakeCurSpan: " + m_shakeCurSpan);
					
					if (mShakeDir == SHAKE_X) {
						// 更新X轴振幅
						if (mShakeOffset.x >= 0) {
							mShakeOffset.x = uint(mShakeCurSpan);
						} else {
							mShakeOffset.x = -uint(mShakeCurSpan);
						}
						// 震动
						mShakeOffset.x = -mShakeOffset.x;
						mShakeOffset.y = 0;
					} else if (mShakeDir == SHAKE_Y) {
						// 更新Y轴振幅
						if (mShakeOffset.y >= 0) {
							mShakeOffset.y = uint(mShakeCurSpan);
						} else {
							mShakeOffset.y = -uint(mShakeCurSpan);
						}
						// 震动
						mShakeOffset.x = 0;
						mShakeOffset.y = -mShakeOffset.y;
						//trace("shakeOffsetY: " + mShakeOffset.y);
					} if (mShakeDir == SHAKE_XY) {
						// 更新X轴振幅
						if (mShakeOffset.x >= 0) {
							mShakeOffset.x = uint(mShakeCurSpan);
						} else {
							mShakeOffset.x = -uint(mShakeCurSpan);
						}
						// 震动
						mShakeOffset.x = -mShakeOffset.x;
						
						// 更新Y轴振幅
						if (mShakeOffset.y >= 0) {
							mShakeOffset.y = uint(mShakeCurSpan);
						} else {
							mShakeOffset.y = -uint(mShakeCurSpan);
						}
						// 震动
						mShakeOffset.y = -mShakeOffset.y;
					}
				} else {
					// 震动结束
					mShakeOffset.x = mShakeOffset.y = 0;
				}
			}
			
			// 计算震动效果的偏移
			camera.x = camera.x + mShakeOffset.x;
			camera.y = camera.y + mShakeOffset.y;
		}
		
		protected function updateTraceTarget():void
		{
			if(mTargetNode != null) {
				// 让相机跟踪目标
				var tempX:uint = camera.sceneWidth * 0.5;
				var tempY:uint = camera.sceneHeight * 0.5;
				camera.x = mTargetNode.x - tempX;
				camera.y = mTargetNode.y - tempY;
			}
		}
		
		public function updateLimitInMap():void
		{
			if (mMapSize != null) {
				// 限制在地图之内
				var right:uint = mMapSize.x - camera.sceneWidth;
				var bottom:uint = mMapSize.y - camera.sceneHeight;
				if (camera.x < 0) camera.x = 0;
				if (camera.y < 0) camera.y = 0;
				if (camera.x > right) camera.x = right;
				if (camera.y > bottom) camera.y = bottom;
			}
		}
		
		override protected function step(elapsed:Number):void
		{
			super.step(elapsed);
			
			updateTraceTarget();
			
			updateLimitInMap();
			
			// 震屏算法
			updateShake();
			
			
			
		}
		
	}
}


