package com.cokecode.halo.terrain
{
	import com.cokecode.halo.data.CoreConst;
	import com.cokecode.halo.resmgr.ResMgr;
	import com.cokecode.halo.terrain.layers.*;
	
	import de.nulldesign.nd2d.display.Node2D;
	
	import flash.media.Camera;
	import flash.utils.Dictionary;
	
	import net.manaca.loaderqueue.LoaderQueueEvent;

	public class Map extends Node2D
	{
		/**
		 * 地图单个格子的宽(像素)
		 */
		static public var TileWidth:uint = 64;
		
		/**
		 * 地图单个格子的高(像素)
		 */
		static public var TileHeight:uint = 32;
		
		
		/**
		 * 存放地图的路径
		 */
		private var mMapPath:String;
		
		private var mLayers:Vector.<Layer> = new Vector.<Layer>();
		private var mLayerDic:Dictionary = new Dictionary;	// Layer
		
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
		 * 设置地图文件的存放路径
		 */
		public function setMapPath(path:String):void
		{
			mMapPath = path;
		}
		
		private function cleanLayers():void
		{
			
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
			
			//创建人物前魔法层
			addLayer(new MagicLayer("magic_before", 0, 0));
			
			// 创建排序层
			layer = new SortLayer("sort",24,32);
			addLayer(layer);
			
			//创建人物后魔法层
			addLayer(new MagicLayer("magic_after", 0, 0));
			
			// 创建阻挡层
			layer = new BlockLayer("block",24,32);
			addLayer(layer);
			
			// 创建天空层
			layer = new SkyLayer("sky",24,32);
			addLayer(layer);
			
			// ------------------------------------			
		}
		
		public function load(url:String):void
		{
			var mapUrl:String = mMapPath + "/" + url;
			ResMgr.loadByURLLoader(mapUrl, onComplete, CoreConst.PRIORITY_MAP);
			
			// 测试代码
			mWidth = 7680;
			mHeight = 4096;			
		}
		
		private function onComplete(event:LoaderQueueEvent):void
		{
			cleanLayers();//清理之前的层数据
		}
		
//		public function update(elapse:uint):void
//		{
//			for (var i:uint=0; i<mLayers.length; ++i) {
//				mLayers[i].update(elapse);
//			}			
//		}
		
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
