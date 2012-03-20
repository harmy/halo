package com.cokecode.halo.terrain.layers
{
	import com.cokecode.halo.terrain.Tile;
	
	import de.nulldesign.nd2d.display.Sprite2D;
	import de.nulldesign.nd2d.materials.texture.Texture2D;
	import de.nulldesign.nd2d.materials.texture.TextureOption;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.utils.Dictionary;

	/**
	 * 地表层
	 */
	public class GroundLayer extends Layer
	{
		protected var mTileDic:Dictionary = new Dictionary;	// tile
		
		public function GroundLayer(name:String, width:uint, height:uint)
		{
			//TODO: implement function
			super(name, width, height);
		}
		
		
		// 预加载屏幕内的地表贴图
		private var lastCameraPt:Point = new Point;
		private var worldRect:Rectangle = new Rectangle;
		protected function loadTexture():void
		{
			if (mTMX == null) return;
			
			if ( Math.abs(lastCameraPt.x - camera.x) < mTMX.tileWidth &&  
				Math.abs(lastCameraPt.y - camera.y) < mTMX.tileHeight) {
				// 变化不超过1个格子，不处理
				return;
			}
			
			lastCameraPt.x = camera.x;
			lastCameraPt.y = camera.y;
			
			var key:String;
			var nGrid:uint = 0;
			
			worldRect.x = int( (camera.x - camera.sceneWidth)  / mTMX.tileWidth );
			worldRect.y = int( (camera.y - camera.sceneHeight) / mTMX.tileHeight );
			worldRect.right = int( (camera.x + camera.sceneWidth * 2) / mTMX.tileWidth );
			worldRect.bottom = int( (camera.y + camera.sceneHeight * 2) / mTMX.tileHeight );
			if (worldRect.x < 0) worldRect.x = 0;
			if (worldRect.y < 0) worldRect.y = 0;
			if (worldRect.x > mTMX.width) worldRect.x = mTMX.width;
			if (worldRect.y > mTMX.height) worldRect.y = mTMX.height;
			
			for (var ny:uint=worldRect.top; ny<worldRect.bottom; ++ny) {
				for (var nx:uint=worldRect.left; nx<worldRect.right; ++nx) {
					nGrid = mTMXLayer.getCell(nx, ny);
					
					// 没有贴图直接跳过
					if (nGrid == 0) continue;	
					
					key = nx + "," + ny;
					
					// 已经加载，直接跳过
					if ( mTileDic[key] != null ) continue;
					
					// 创建地表
					var url:String = mTMX.makeImgPath(nGrid);
					var tile:Tile = new Tile(url);
					tile.x = nx * mTMX.tileWidth;
					tile.y = ny * mTMX.tileHeight;
					addChild(tile);
					
					mTileDic[key] = tile;
					trace("x: " + nx + "," + ny + "," + nGrid);
				}
			}
		}
		
		// 删除屏幕外的地表贴图
		protected function deleteTexture():void
		{
			// TODO
		}
		
		// 处理地图元素加载和释放
		override protected function step(elapsed:Number):void 
		{
			// 删除屏幕之外的贴图
			deleteTexture();
			
			// 加载屏幕内的贴图
			loadTexture();
		}
		
	}
}


