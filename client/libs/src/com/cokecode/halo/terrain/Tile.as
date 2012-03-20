package com.cokecode.halo.terrain
{
	import com.cokecode.halo.object.GameObject;
	
	import de.nulldesign.nd2d.display.Camera2D;
	import de.nulldesign.nd2d.display.Sprite2D;
	import de.nulldesign.nd2d.materials.texture.Texture2D;
	import de.nulldesign.nd2d.materials.texture.TextureOption;

	/**
	 * 地表的一个格子
	 */
	public class Tile extends GameObject
	{
		protected var mSprite:Sprite2D;
		
		public function Tile(textureObject:Texture2D = null)
		{
			// 地表禁用纹理过滤
			textureObject.textureOptions = TextureOption.QUALITY_LOW;
			
			mSprite = new Sprite2D(textureObject);
			mSprite.pivot.x = -mSprite.width * 0.5;
			mSprite.pivot.y = -mSprite.height * 0.5;
			
			addChild(mSprite);
		}
		
		override public function get width():Number
		{
			return mSprite.width;
		}
		
		override public function get height():Number
		{
			return mSprite.height;
		}
		
		override public function isInViewport(camera:Camera2D):Boolean
		{
			if (x + width < camera.x)	// 图片移出相机左边
				return false;
			
			if (y + height < camera.y)	// 图片移出相机上边
				return false;
			
			if (x > camera.x + camera.sceneWidth)	// 图片移出相机右边
				return false;
			
			if (y > camera.y + camera.sceneHeight)	// 图片移出相机下边
				return false;
			
			return true;
		}
		
	}
}