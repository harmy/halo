package com.cokecode.halo.magic
{
	/**
	 * 目标类魔法
	 * */
	public class MagicDest extends MagicBase
	{
		private var mTargetX:uint				= 0;		//目标x
		private var mTargetY:uint				= 0;		//目标y
		private var mTargetID:uint				= 0;		//目标id
		
		public function MagicDest(targetID:uint, targetX:uint, targetY:uint)
		{
			super();
			mTargetID = targetID;
			mTargetX = targetX;
			mTargetY = targetY;
		}
		
		protected override function isEnd():Boolean
		{
			return false;			
		}
	}
}