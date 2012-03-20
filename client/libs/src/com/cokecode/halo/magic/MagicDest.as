package com.cokecode.halo.magic
{
	/**
	 * 目标类魔法
	 * */
	public class MagicDest extends MagicBase
	{		
		public function MagicDest()
		{
			
		}
		
		protected override function isEnd():Boolean
		{
			if(!mStart)
			{
				return false;
			}
			
			if(mConfig.mEndType == MagicConst.END_TYPE_ANIMATION_OVER)
			{
				//动画播放完结束
				
			}
			
			return false;			
		}
	}
}