package com.cokecode.halo.magic
{
	internal class MagicMouse extends MagicBase
	{
		/**
		 * 鼠标阵法类效果
		 * */
		public function MagicMouse()
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
			var mouseX:uint;
			var mouseY:uint;
			
			if((mConfig.mOption & MagicConst.OPT_FOLLOW_TARGET) == 0)
			{
				return;
			}
			
			x = mouseX + mConfig.mOffx;
			y = mouseY + mConfig.mOffy;			
		}
	}
}