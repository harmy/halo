package com.cokecode.halo.terrain.layers
{
	import com.cokecode.halo.terrain.Block;
	
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.utils.Dictionary;

	/**
	 * 游戏逻辑格子层(包含阻挡信息、角色透明处理信息)
	 */
	public class BlockLayer extends Layer
	{
		public static const LOAD_RANGE_CONST:uint = 1;	// 加载范围的系数
		
		private var mLastCameraPt:Point = new Point(-1000, -1000);	// -1000 初始值为的是loadTexture必定执行一次
		private var mWorldRect:Rectangle = new Rectangle;
		
		protected var mBlockDic:Dictionary = new Dictionary;	// block
		
		public function BlockLayer(name:String, width:uint, height:uint)
		{
			//TODO: implement function
			super(name, width, height);
		}
		
		override public function clear():void
		{
			super.clear();
			mBlockDic = new Dictionary;
		}
		
		/**
		 * 输出阻挡信息数组(给寻路用,0表示可走，1表示不可走)
		 * @return	返回处理过的阻挡信息
		 */
		public function get blockArray():Array
		{
			// 设置寻路数据
			var nx:uint = mTMX.width;
			var ny:uint = mTMX.height;
			var nBlock:uint;
			var blockArr:Array = new Array;
			blockArr.length = ny;
			for (y=0; y<ny; ++y) {
				blockArr[y] = new Array;
				(blockArr[y] as Array).length = nx;
			}
			for (x=0; x<nx; ++x) {
				for (y = 0; y < ny; ++y) {
					nBlock = getBlock(x, y);
					// 1 - 不可走, other - 可走
					if (nBlock == 1) {
						// 不可走
						blockArr[y][x] = true;
					} else {
						// 可走
						blockArr[y][x] = false;
					}
				}
			}
			
			return blockArr;
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
			
			var tile:Block;
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
					tile = mBlockDic[key];
					if ( tile != null ) {
						// 更新运用
						tile.updateRefTime();
						continue;
					}
					
					// 创建地表
					var url:String = mTMX.getImgSrc(nGrid);
					tile = new Block(url);
					tile.mSpriteWidth = mTMX.tileWidth;
					tile.mSpriteHeight = mTMX.tileHeight;
					tile.mFrame = mTMX.getImgFrame(nGrid);
					tile.x = nx * mTMX.tileWidth;
					tile.y = ny * mTMX.tileHeight;
					addChild(tile);
					
					mBlockDic[key] = tile;
					//trace("x: " + nx + "," + ny + "," + nGrid);
				}
			}
		}
		
		// 删除屏幕外的地表贴图
		protected function deleteTexture():void
		{
			var tile:Block;
			for (var key:String in mBlockDic) {
				tile = mBlockDic[key];
				if ( !tile.isInViewport(camera) ) {
					if (tile.canDispose()) {
						// 不在屏幕内
						tile.dispose();
						removeChild(tile);
						delete mBlockDic[key];
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