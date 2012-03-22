package com.cokecode.halo.magic
{
	import de.nulldesign.nd2d.display.Camera2D;

	/**
	 * 自身类魔法
	 * */
	internal class MagicSelf extends MagicBase
	{
		public function MagicSelf()
		{			
			super();
		}
		
		protected override function doInit():void
		{
			x = mSrcX + mConfig.mOffx;
			y = mSrcY + mConfig.mOffy;
		}	
		
		protected override function update(elapsed:Number):void
		{	
			if((mConfig.mOption & MagicConst.OPT_FOLLOW_TARGET) == 0)
			{
				return;
			}		
			
			x = MagicMgr.instance().mSelf.x + mConfig.mOffx;
			y = MagicMgr.instance().mSelf.y + mConfig.mOffy;
		}
	}
}


