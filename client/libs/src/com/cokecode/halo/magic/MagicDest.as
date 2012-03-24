package com.cokecode.halo.magic
{
	import flash.utils.getTimer;

	/**
	 * 目标类魔法
	 * */
	internal class MagicDest extends MagicBase
	{		
		public function MagicDest()
		{	
			super();
		}
		
		protected override function doInit():void
		{
			x = mTargetX + mConfig.mOffx;
			y = mTargetY + mConfig.mOffy;
		}
		
		protected override function update(elapsed:Number):void
		{			
			if((mConfig.mOption & MagicConst.OPT_FOLLOW_TARGET) == 0)
			{
				return;
			}
			
			x = mTargetX + mConfig.mOffx;
			y = mTargetY + mConfig.mOffy;			
		}
	}
}


