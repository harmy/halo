package com.cokecode.halo.magic
{
	import com.cokecode.halo.resmgr.ResMgr;
	import com.cokecode.halo.terrain.layers.Layer;
	import com.sociodox.theminer.Options;
	
	import de.nulldesign.nd2d.materials.BlendModePresets;
	
	import flash.display.BlendMode;
	import flash.events.Event;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.utils.Dictionary;
	
	import net.manaca.loaderqueue.LoaderQueueEvent;
	
	import org.osmf.elements.DurationElement;
	import org.osmf.layout.ScaleMode;

	/**
	 * 魔法配置管理
	 * */
	internal final class MagicConfigMgr
	{
		private var mConfigMgr:Dictionary = new Dictionary;
		private static var sInstance:MagicConfigMgr;
	
		public static function get instance():MagicConfigMgr
		{
			if(sInstance == null)
			{
				sInstance = new MagicConfigMgr;
			}
			
			return sInstance;
		}
		
		private function parseXml(evt:LoaderQueueEvent):void
		{
			var xml:XML = new XML(evt.target.data);
			var texDic:Dictionary = new Dictionary;
			var id:uint = 0;
			
			for each(var texUnit:XML in xml.texture.unit)
			{
				id = texUnit.@id;
				var dir:uint = texUnit.@dir;
				texDic[id] = dir;
			}
			
			for each(var magic:XML in xml.magic)
			{
				id = magic.@id;
				var arr:Array = new Array;
				var haveChild:Boolean = false;
				var haveSibling:Boolean = false;
				
				for each(var node:XML in magic.node)
				{
					var cf:MagicConfig = new MagicConfig;
					cf.mRootID = id;
					cf.mTexID = node.@tex;
					cf.mTexDirCount = texDic[cf.mTexID];
					cf.mLayer = node.@layer;
					cf.mType = node.@type;
					cf.mEndType = node.@end;
					cf.mOffx = node.@offx;
					cf.mOffy = node.@offy;
					cf.mScale = node.@scale;
					cf.mBlend = node.@blend;
					cf.mDuration = node.@dur;
					cf.mSound = node.@sound;
					cf.mAniSpeed = node.@speed;
					cf.mFlySpeed = node.@flyspeed;
					cf.mOption = node.@opt;	
					
					if(haveSibling)
					{
						if(arr.length != 0)
						{
							(arr[arr.length - 1] as MagicConfig).mSibling = cf;
						}						
					}
					else if(haveChild)
					{
						if(arr.length != 0)
						{
							(arr[arr.length - 1] as MagicConfig).mChild = cf;
						}						
					}
					
					if(node.@sibling > 0)
					{
						haveSibling = true;
					}
					else if(node.@child > 0)
					{
						haveChild = true;
					}
					
					arr.push(cf);
				}
				
				if(arr.length != 0)
				{
					addConfig(id, arr);
				}
			}
		}
		
		internal function loadConfig(path:String):void
		{
			ResMgr.instance.loadByURLLoader(path, parseXml);
		}		
		
		private function addConfig(id:uint, arr:Array):void
		{
			mConfigMgr[id] = arr;
		}
		
		public function getConfig(id:uint):Array
		{
			return mConfigMgr[id];
		}
	}
}


