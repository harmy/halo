package com.cokecode.halo.terrain.layers
{
	import de.nulldesign.nd2d.display.Sprite2D;
	import de.nulldesign.nd2d.materials.texture.Texture2D;
	import de.nulldesign.nd2d.materials.texture.TextureOption;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.geom.Point;
	import flash.geom.Rectangle;

	/**
	 * 地表层
	 */
	public class GroundLayer extends Layer
	{
		[Embed(source='Z:/res/maps/wangcheng.jpg')]
		private static const mapTex:Class;
		
		static public const GROUND_TILE_WIDTH:uint = 512;
		static public const GROUND_TILE_HEIGHT:uint = 512;
		
		public function GroundLayer(name:String, width:uint, height:uint)
		{
			//TODO: implement function
			super(name, width, height);
			
			var mapBmp:Bitmap = new mapTex();
			for (var y:uint=0; y<mapBmp.height; y+=GROUND_TILE_HEIGHT) {
				for (var x:uint=0; x<mapBmp.width; x+=GROUND_TILE_WIDTH) {
					var tileBmp:BitmapData = new BitmapData(GROUND_TILE_WIDTH, GROUND_TILE_HEIGHT, true, 0x00FF00);
					var rectSrc:Rectangle = new Rectangle;
					rectSrc.x = x;
					rectSrc.y = y;
					rectSrc.width = GROUND_TILE_WIDTH;
					rectSrc.height = GROUND_TILE_HEIGHT;
					var ptDest:Point = new Point(0, 0);
					tileBmp.copyPixels(mapBmp.bitmapData, rectSrc, ptDest, null, null, true);
					var tex:Texture2D = Texture2D.textureFromBitmapData(tileBmp);
					tex.textureOptions = TextureOption.QUALITY_LOW;
					var spr:Sprite2D = new Sprite2D(tex);
					spr.x = x;
					spr.y = y;
					this.addChild(spr);					
				}	
			}
			
			//flatten();
			
		}
		
		override public function clip():void
		{
		}
		
	}
}