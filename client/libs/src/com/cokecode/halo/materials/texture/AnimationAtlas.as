package com.cokecode.halo.materials.texture
{	
	import de.nulldesign.nd2d.materials.texture.TextureAtlas;

	public class AnimationAtlas extends TextureAtlas
	{
		public function AnimationAtlas(sheetWidth:Number, sheetHeight:Number, xmlData:XML, xmlFormat:String, fps:uint, spritesPackedWithoutSpace:Boolean=false)
		{
			super(sheetWidth, sheetHeight, xmlData, xmlFormat, fps, spritesPackedWithoutSpace);
		}
		
		public function setFPS(val:uint):void
		{
			fps = val;
		}
	}
}