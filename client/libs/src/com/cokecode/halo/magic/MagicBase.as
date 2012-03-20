package com.cokecode.halo.magic
{
	import com.cokecode.halo.object.GameObject;

	/**
	 * 魔法基类
	 * */
	public class MagicBase extends GameObject;
	{
		private var curDir:uint				= 0;		//当前方向
		private var targetX:uint				= 0;		//目标x
		private var targetY:uint				= 0;		//目标y
		private var targetID:uint				= 0;		//目标id
		private var selfID:uint				= 0;		//释放者
		private var startTime:uint				= 0;		//魔法开始时间
		protected var mConfig:MagicConfig;
		
		public function MagicBase()
		{
		}
		
		public function update():void
		{			
		}
		
		public function isEnd():Boolean
		{
			
		}
	}
}