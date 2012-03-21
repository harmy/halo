package com.cokecode.halo.magic
{
	import de.nulldesign.nd2d.display.Camera2D;

	/**
	 * 自身类魔法
	 * */
	public class MagicSelf extends MagicBase
	{
		public function MagicSelf()
		{			
		}
		
		protected override function doInit():void
		{
			super.doInit();
			x = mSrcX + mConfig.mOffx;
			y = mSrcY + mConfig.mOffy;
		}	
		
		protected override function update(elapsed:Number):void
		{	
			if((mConfig.mOption & MagicConst.OPT_FOLLOW_TARGET) == 0)
			{
				return;
			}		
			
			x = mSrcX + mConfig.mOffx;
			y = mSrcY + mConfig.mOffy;
		}
	}
}


