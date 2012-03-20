package com.cokecode.halo.magic
{
	import de.nulldesign.nd2d.display.Camera2D;

	/**
	 * 自身类魔法
	 * */
	public class MagicSelf extends MagicBase
	{	
		private var mSrcID:uint				= 0;		//释放者id
		private var mSrcX:uint					= 0;		//释放点x
		private var mSrcY:uint					= 0;		//释放点y
		
		public function MagicSelf(srcID:uint, srcX:uint, srcY:uint)
		{
			super();
			mSrcID = srcID;
			mSrcX = srcX;
			mSrcY = srcY;
		}
		
		protected override function isEnd():Boolean
		{
			return false;
		}
	}
}