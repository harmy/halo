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
		
		public function get gameObject():GameObject
		{
			return null;
		}
	}
}