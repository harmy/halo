package com.cokecode.halo.terrain.layers
{
	
	import de.nulldesign.nd2d.display.Sprite2D;
	import de.nulldesign.nd2d.materials.texture.Texture2D;
	import de.nulldesign.nd2d.materials.texture.TextureOption;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.utils.Dictionary;
	
	import flashx.textLayout.elements.BreakElement;
	import com.cokecode.halo.terrain.Tile;

	/**
	 * 地表层
	 */
	public class GroundLayer extends Layer
	{
		public static const LOAD_RANGE_CONST:uint = 1;	// 加载范围的系数
		
		private var mLastCameraPt:Point = new Point(-1000, -1000);	// -1000 初始值为的是loadTexture必定执行一次
		private var mWorldRect:Rectangle = new Rectangle;
		
		protected var mTileDic:Dictionary = new Dictionary;	// tile
		
		
		public function GroundLayer(name:String, width:uint, height:uint)
		{
			//TODO: implement function
			super(name, width, height);
		}
		
		override public function clear():void
		{
			super.clear();
			mTileDic = new Dictionary;
		}
		
		// 预加载屏幕内的地表贴图
		protected function loadTexture():void
		{
			if (mTMX == null) return;
			
			if ( Math.abs(mLastCameraPt.x - camera.x) < mTMX.tileWidth &&  
				Math.abs(mLastCameraPt.y - camera.y) < mTMX.tileHeight) {
				// 变化不超过1个格子，不处理
				return;
			}
			
			mLastCameraPt.x = camera.x;
			mLastCameraPt.y = camera.y;
			
			var tile:Tile;
			var key:String;
			var nGrid:uint = 0;
			
			var viewSizeX:uint = camera.sceneWidth * LOAD_RANGE_CONST;
			var viewSizeY:uint = camera.sceneHeight * LOAD_RANGE_CONST;
			
			mWorldRect.x = int( (camera.x - viewSizeX)  / mTMX.tileWidth );
			mWorldRect.y = int( (camera.y - viewSizeY) / mTMX.tileHeight );
			mWorldRect.right = int( (camera.x + viewSizeX + camera.sceneWidth) / mTMX.tileWidth );
			mWorldRect.bottom = int( (camera.y + viewSizeY + camera.sceneHeight) / mTMX.tileHeight );
			if (mWorldRect.x < 0) mWorldRect.x = 0;
			if (mWorldRect.y < 0) mWorldRect.y = 0;
			if (mWorldRect.x > mTMX.width) mWorldRect.x = mTMX.width;
			if (mWorldRect.y > mTMX.height) mWorldRect.y = mTMX.height;
			
			for (var ny:uint=mWorldRect.top; ny<mWorldRect.bottom; ++ny) {
				for (var nx:uint=mWorldRect.left; nx<mWorldRect.right; ++nx) {
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
					var url:String = mTMX.getGroundImgSrc(nGrid);
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


