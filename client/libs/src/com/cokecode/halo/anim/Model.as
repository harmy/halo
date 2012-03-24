package com.cokecode.halo.anim
{	
	import com.cokecode.halo.resmgr.ResMgr;
	
	import net.manaca.loaderqueue.LoaderQueueEvent;

	/**
	 * 一个角色用到的模型
	 * 模型有一个名称
	 * 一个模型会包含很多个部件，比如衣服，武器，盾，等。这个就是mLayers
	 */
	public class Model
	{
		public var mName:String;
		public var mAtlasTexType:uint;
		public var mLayers:Vector.<AniLayer> = new Vector.<AniLayer>();
		public var mActionParam:ActionParam = new ActionParam;
		public var mIsLoad:Boolean = false;
		
		function Model(url:String, name:String)
		{
			mName = name;
			ResMgr.loadByURLLoader(url, onComplete);
		}
		
		protected function onComplete(event:LoaderQueueEvent):void
		{
			mLayers.length = 0;
	
			var xmldata:XMLList = new XMLList(event.target.data);
			
			mAtlasTexType = xmldata.textype.@type;
			
			var lay:XMLList = xmldata.charactor.layer;
			for each( var lid:XML in lay) 	{
				mLayers.push(new AniLayer(lid.@id,lid.@name,lid.@texwidth,lid.@texheight));
			}
			
			mActionParam.clear();
			var action:XMLList = xmldata.action.param;
			for each( var param:XML in action) 	{
				mActionParam.addAction(param.@name, param.@id, param.@frames, param.@dirs);
			}
			
			mIsLoad = true;
		}
		
	}
	
	
}