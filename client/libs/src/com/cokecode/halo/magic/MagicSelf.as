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
		
		protected override function isEnd():Boolean
		{
			return false;
		}
	}
}