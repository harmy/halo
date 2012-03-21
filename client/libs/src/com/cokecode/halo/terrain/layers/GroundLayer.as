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
	
	import flashx.textLayout.elements.BreakElement;

	/**
	 * 地表层
	 */
	public class GroundLayer extends Layer
	{
		static public const LOAD_RANGE_CONST:uint = 1;	// 加载范围的系数
		
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
			
			var tile:Tile;
			var key:String;
			var nGrid:uint = 0;
			
			var viewSizeX:uint = camera.sceneWidth * LOAD_RANGE_CONST;
			var viewSizeY:uint = camera.sceneHeight * LOAD_RANGE_CONST;
			
			worldRect.x = int( (camera.x - viewSizeX)  / mTMX.tileWidth );
			worldRect.y = int( (camera.y - viewSizeY) / mTMX.tileHeight );
			worldRect.right = int( (camera.x + viewSizeX + camera.sceneWidth) / mTMX.tileWidth );
			worldRect.bottom = int( (camera.y + viewSizeY + camera.sceneHeight) / mTMX.tileHeight );
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
					tile = mTileDic[key];
					if ( tile != null ) {
						// 更新运用
						tile.updateRefTime();
						continue;
					}
					
					// 创建地表
					var url:String = mTMX.makeImgPath(nGrid);
					tile = new Tile(url);
					tile.x = nx * mTMX.tileWidth;
					tile.y = ny * mTMX.tileHeight;
					addChild(tile);
					
					mTileDic[key] = tile;
					//trace("x: " + nx + "," + ny + "," + nGrid);
				}
			}
		}
		
		// 删除屏幕外的地表贴图
		protected function deleteTexture():void
		{
			var tile:Tile;
			for (var key:String in mTileDic) {
				tile = mTileDic[key];
				if ( !tile.isInViewport(camera) ) {
					if (tile.canDispose()) {
						// 不在屏幕内
						tile.dispose();
						removeChild(tile);
						delete mTileDic[key];
						//trace("删除屏幕外的贴图");
						break;	// 一次只删除一个贴图
					}
				} else {
					// 更新引用
					tile.updateRefTime();
				}
			}
		}
		
		// 处理地图元素加载和释放
		override protected function step(elapsed:Number):void 
		{
			// 进行裁剪
			super.step(elapsed);
			
			// 删除屏幕之外的贴图
			deleteTexture();
			
			// 加载屏幕内的贴图
			loadTexture();
		}
		
	}
}


