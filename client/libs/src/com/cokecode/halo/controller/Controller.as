package com.cokecode.halo.controller
{
	import com.cokecode.halo.object.GameObject;
	
	import de.nulldesign.nd2d.display.Node2D;

	public class Controller extends Node2D
	{
		public function initAction():void
		{
			
		}
		
		override protected function step(elapsed:Number):void
		{
			// overwrite in extended classes
		}
		
		/**
		 * 获得控制器对应的对象
		 */
		public function get gameObject():GameObject
		{
			return null;
		}
		
		public function set gameObject(value:GameObject):void
		{
			return;
		}
	}
}