package com.cokecode.halo.terrain
{
	import com.cokecode.halo.data.CoreConst;
	import com.cokecode.halo.events.MapEvent;
	import com.cokecode.halo.magic.MagicConst;
	import com.cokecode.halo.resmgr.ResMgr;
	import com.cokecode.halo.terrain.layers.*;
	import com.cokecode.halo.terrain.tmx.TMX;
	import com.cokecode.halo.terrain.tmx.TMXLayer;
	
	import de.nulldesign.nd2d.display.Node2D;
	
	import flash.media.Camera;
	import flash.utils.Dictionary;
	
	import net.manaca.loaderqueue.LoaderQueueEvent;

	public class Map extends Node2D
	{
		/**
		 * 地图单个格子的宽(像素)
		 */
		public static var sTileWidth:uint = 64;
		
		/**
		 * 地图单个格子的高(像素)
		 */
		public static var sTileHeight:uint = 32;
		
		/**
		 * 存放解析出来的地图数据
		 */
		private var mTmx:TMX;
		
		private var mLayers:Vector.<Layer> = new Vector.<Layer>();
		private var mLayerDic:Dictionary = new Dictionary;	// Layer
		
		private var mMapPath:String;
		private var mMapId:uint;	// 地图ID
		
		/**
		 * 地图的跟节点
		 */
		private var mWidth:uint;
		private var mHeight:uint;
		
		public function Map()
		{
			initLayers();			
		}
		
		public function get mapWidth():uint
		{
			return mWidth;
		}
		
		public function get mapHeight():uint
		{
			return mHeight;
		}
		
		/**
		 * 清理所有的层
		 */
		private function cleanLayers():void
		{
			for (var i:uint=0; i<mLayers.length; ++i) {
				mLayers[i].clear();
			}
		}
		
		private function initLayers():void
		{
			// --------- 创建测试用的图层 ----------
			
			var layer:Layer;
			
			// 创建悬空地表
			layer = new ParallaxLayer("parallax",24,32);
			addLayer(layer);
			
			// 创建地表
			layer = new GroundLayer("ground",24,32);
			addLayer(layer);
			
			// 创建阻挡层
			layer = new BlockLayer("block",24,32);
			addLayer(layer);
			
			//创建人物前魔法层
			addLayer(new MagicLayer(MagicConst.STR_LAYER_BEFOR, 0, 0));
			
			// 创建排序层
			layer = new SortLayer("sort",24,32);
			addLayer(layer);
			
			//创建人物后魔法层
			addLayer(new MagicLayer(MagicConst.STR_LAYER_AFTER, 0, 0));
			
			// 创建天空层
			layer = new SkyLayer("sky",24,32);
			addLayer(layer);
			
			// ------------------------------------			
		}
		
		public function setMapPath(path:String):void
		{
			mMapPath = path;
		}
		
		public function getBlock(x:int, y:int):int
		{
			var layer:Layer = getLayer("block");
			if (layer == null) return 0;
			return layer.getBlock(x, y);
		}
		
		public function load(url:String):void
		{
			var s1:int = url.lastIndexOf("/") + 1;
			var s2:int = url.lastIndexOf(".");
			var sid:String = url.substr(s1, s2 - s1); 
			mMapId = uint(sid);
			
			ResMgr.instance.loadByURLLoader(mMapPath + url, onComplete, CoreConst.PRIORITY_MAP);
			
			// 测试代码
			mWidth = 7680;
			mHeight = 4096;			
		}
		
		
		
		private function onComplete(event:LoaderQueueEvent):void
		{
			// cleanLayers();//清理之前的层数据
			
			// 读取tmx地图文件
			mTmx = new TMX( new XML(event.target.data),  mMapPath, mMapId );
			sTileWidth = mTmx.tileWidth;
			sTileHeight = mTmx.tileHeight;
			mWidth = mTmx.width * mTmx.tileWidth;
			mHeight = mTmx.height * mTmx.tileHeight;
			
			// 设置地图层的数据
			var layer:Layer;
			var tmxLayer:TMXLayer;
			for (var i:uint=0; i<mTmx.layersArray.length; ++i) {
				tmxLayer = mTmx.layersArray[i];
				layer = getLayer(tmxLayer.name);
				if (layer != null) {
					layer.setTMXData(mTmx, tmxLayer);
					layer.initData();
				} else {
					trace("不存在的层: " + tmxLayer.name);
				}
			}
			
			dispatchEvent( new MapEvent(MapEvent.LOAD_COMPLETE, mMapId, mWidth, mHeight) );
		}
		
		public function addLayer(layer:Layer):void
		{
			this.addChild(layer);
			mLayers.push(layer);
			mLayerDic[layer.layerName] = layer;
		}
		
		public function getLayer(name:String):Layer
		{
			return mLayerDic[name];
		}
		
		override protected function step(elapsed:Number):void {
//			for (var i:uint=0; i<mLayers.length; ++i) {
//				mLayers[i].updateCamera(camera);
//			}
			
			
		}
		
		
	}
}
