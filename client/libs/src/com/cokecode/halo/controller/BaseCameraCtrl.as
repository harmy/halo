package com.cokecode.halo.controller
{
	import de.nulldesign.nd2d.display.Node2D;
	
	import flash.geom.Point;

	public class BaseCameraCtrl extends Controller
	{
		/**
		 * 被跟踪的目标
		 */
		protected var mTargetNode:Node2D;
		
		/**
		 * 地图尺寸，限制相机不超出地图之外
		 */
		protected var mMapSize:Point = new Point(1000, 1000);
		
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
		
		override protected function step(elapsed:Number):void
		{
			super.step(elapsed);
			
			if(mTargetNode != null) {
				// 让相机跟踪目标
				var tempX:uint = camera.sceneWidth * 0.5;
				var tempY:uint = camera.sceneHeight * 0.5;
				camera.x = mTargetNode.x - tempX;
				camera.y = mTargetNode.y - tempY;
			}
			
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
		
	}
}


