package com.cokecode.halo.pathfinder
{
	internal class TraversalNote
	{
		public var noteOpen : Boolean = true;//是否在开放列表
		public var noteClosed : Boolean = false;//是否在关闭列表
		public var cost:Number;//距离消耗
		public var score:Number;//节点得分
		public var parent:TraversalNote;//父节点
		public var point:*;//坐标
	}
}