package com.cokecode.halo.pathfinder
{
	import flash.geom.Point;
	
	/**
	 * 自动寻路功能
	 */
	public class PathFinder
	{
		private static var sInstance:PathFinder = new PathFinder;
		
		private var mAstar:Astar;
		private var mMapMode:MapModel;
		
		public static function get instance():PathFinder
		{
			return sInstance;
		}
		
		public function PathFinder()
		{
			mMapMode = new MapModel();
			mAstar = new Astar(mMapMode);
		}
		
		/**
		 * 设置地图的阻挡信息
		 * @param	map	地图阻挡信息(0表示可走，1表示不可走)
		 */
		public function setBlockData(map:Array):void
		{
			mMapMode.map = map;
		}
		
		/**
		 * 执行寻路
		 * @param	start	开始点(逻辑格坐标)
		 * @param	end		结束点(逻辑格坐标)
		 * @return	寻路结果节点
		 */
		public function findByPoint(start:Point, end:Point) : Array
		{
			if ( mMapMode.isBlock(end, start) ) {
				return null;
			}
			
			return mAstar.find(start, end);
		}	
		
		/**
		 * 执行寻路
		 * @param	startX	开始点(逻辑格坐标)
		 * @param	startY
		 * @param	endX	结束点(逻辑格坐标)
		 * @param	endY
		 * @return
		 */
		public function find(startX:Number, startY:Number, endX:Number, endY:Number) : Array
		{
			var startPt:Point = new Point(startX, startY);
			var endPt:Point = new Point(endX, endY);
			return findByPoint(startPt, endPt);
		}	
		
	}
}
