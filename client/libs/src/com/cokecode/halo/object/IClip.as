package com.cokecode.halo.object
{
	import de.nulldesign.nd2d.display.Camera2D;
	
	/**
	 * 裁剪接口
	 * */
	public interface IClip
	{		
		function isInViewport(camera:Camera2D):Boolean;
	}
}