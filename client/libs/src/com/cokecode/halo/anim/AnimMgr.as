package com.cokecode.halo.anim
{	
//	import Lib.LibSetting;
//	import Lib.Texture.TbeImageDict;
//	import Lib.Texture.TexDict;
	
	import flash.events.Event;
	import flash.utils.Dictionary;
	// 动画管理器
	// 
	public class AnimMgr 
	{	
		private var mRootPath:String = "";					// 动画资源的根目录
		private var mModelDict:Dictionary;				//专门管理模型(Model)
		private var mAnimDict:Dictionary;				//专门管理动画(Animation)
		private var mAniLoaderDict:AniAtlasLoaderDict;	//贴图和切分信息
		
		static public var sInstance:AnimMgr = new AnimMgr;
		
		public function AnimMgr()
		{
			
		}
		
		public function init(rootPath:String):void
		{
			mRootPath = rootPath;
			
			mModelDict = new Dictionary;
			mAnimDict = new Dictionary;		//专门管理动画
			
			mAniLoaderDict = new AniAtlasLoaderDict(mRootPath);
		}
		
		public function getAtlasTexMgr():AniAtlasLoaderDict
		{
			return mAniLoaderDict;
		}
		
		// name - exp. human, monster, npc, pet
		public function getModel(name:String):Model
		{
			var model:Model;
			if (mModelDict[name] == null) {
				var url:String = mRootPath + name + ".xml";
				mModelDict[name] = new Model(url, name);
			}
			
			return mModelDict[name];
		}
	
		// name - exp. stand, run, attack
		public function getAnim(model:String, name:String,onLoadFinishCB:Function = null):Animation
		{
			if (name == null) return null;
			
			name = name.toLocaleLowerCase();
			if(	mAnimDict[name]==null ) {
				var url:String = mRootPath + model + "/animation/" + name + ".xml";
				mAnimDict[name] = new Animation(url, name);
				if (onLoadFinishCB != null) {
					mAnimDict[name].addEventListener(Event.COMPLETE,onLoadFinishCB);
				}
				return mAnimDict[name];
			}
			
			if(onLoadFinishCB!=null) {
				onLoadFinishCB(new Event(Event.COMPLETE));
			}
				
			return mAnimDict[name];
		}
		
		
		
	}
	
	
}