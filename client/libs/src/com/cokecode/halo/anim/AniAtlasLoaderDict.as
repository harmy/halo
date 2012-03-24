package com.cokecode.halo.anim
{
	import flash.utils.Dictionary;

	public class AniAtlasLoaderDict
	{
		protected var mRootPath:String;
		protected var mAtlasDic:Dictionary = new Dictionary;
		
		public function AniAtlasLoaderDict(rootPath:String = null)
		{
			mRootPath = rootPath;
		}
		
		public function loadAniAtlas(url:String):AniAtlasLoader
		{
			var fullPath:String = mRootPath + url;
			var aniLoader:AniAtlasLoader = mAtlasDic[fullPath];
			if (aniLoader == null) {
				aniLoader = new AniAtlasLoader(fullPath);
				mAtlasDic[fullPath] = aniLoader;
			}
			
			return aniLoader;
		}
		
	}
}