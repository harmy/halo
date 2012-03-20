package com.cokecode.halo.display
{
	import de.nulldesign.nd2d.display.TextField2D;
	import de.nulldesign.nd2d.materials.texture.TextureOption;
	
	public class TextField extends TextField2D
	{
		public function TextField()
		{
			super();
		}
		
		override protected function redraw():void
		{
			super.redraw();
			texture.textureOptions = TextureOption.QUALITY_LOW;
		}
		
		public function get filter():Array
		{
			return _nativeTextField.filters;
		}
		
		public function set filter(value:Array):void
		{
			_nativeTextField.filters = value;
		}
		
	}
}