package com.cokecode.halo.anim
{	
	import com.cokecode.halo.resmgr.ResMgr;
	
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.utils.ByteArray;
	import flash.utils.Endian;
	
	import net.manaca.loaderqueue.LoaderQueueEvent;
	
	public class Animation	extends EventDispatcher
	{		
		public var mSeqFrame:Array;		//帧
		public var mName:String;			//动作名称
		public var mTexId:Array;			//动作编号
		public var mIsLoad:Boolean;
		public var mMaxFrameTime:uint;

		function Animation(url:String, actName:String)
		{
			mIsLoad = false;
			mName = actName;
			mMaxFrameTime = 0;
			
			ResMgr.instance.loadByURLLoader(url, onLoadXmlFinish);
		}
		
		protected function onLoadXmlFinish(event:LoaderQueueEvent):void
		{
			var xmldata:XML = new XML(event.target.data);
			var texLayerList:XMLList = xmldata.Texture.Layer;
			mTexId=[];
			
			for each(var tlidx:XML in texLayerList) {
				mTexId.push(tlidx.@TexID);
			}
			
			var AnmList:XMLList = xmldata.Animation;
			
			mSeqFrame=[];
			var nLen:int = AnmList.length();
			var aidx:int = 0;
			while( aidx < nLen) {
				mSeqFrame[aidx]=[];
				
				var Frmlist:XMLList = xmldata.Animation[aidx].Frame;
				var DelayFrm:int = Frmlist.@DelayFrame;
				
				for each(var fidx:XML in Frmlist) 	{
					var AniSeqFrm:AniSeqFrame = new AniSeqFrame;
					AniSeqFrm.mDelayFrame = fidx.@DelayFrame;
					var FrmClplist:XMLList = fidx.Part;
					
					for each(var fcidx:XML in FrmClplist) 	{
						AniSeqFrm.append(fcidx.@Layers,	fcidx.@Resource,fcidx.@PosX,fcidx.@PosY);
					}

					mSeqFrame[aidx].push(AniSeqFrm);
				}
				aidx++;
			}
			
			mIsLoad=true;
			dispatchEvent(new Event(Event.COMPLETE));
		}
	}
}