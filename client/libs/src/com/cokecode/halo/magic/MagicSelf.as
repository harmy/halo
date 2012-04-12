package com.cokecode.halo.magic
{
	import com.cokecode.halo.object.CharMgr;
	import com.cokecode.halo.object.Charactor;
	
	import de.nulldesign.nd2d.display.Camera2D;

	/**
	 * 自身类魔法
	 * */
	internal class MagicSelf extends MagicBase
	{		
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
			
			var hero:Charactor = CharMgr.instance.getCharByStr(mSrcID);		
			
			if(hero == null)
			{
				return;
			}
			
			x = hero.x + mConfig.mOffx;
			y = hero.y + mConfig.mOffy;
		}
	}
}


