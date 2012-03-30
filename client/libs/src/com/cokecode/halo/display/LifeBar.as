package com.cokecode.halo.display 
{
	import de.nulldesign.nd2d.display.Node2D;
	import de.nulldesign.nd2d.display.Sprite2D;
	import de.nulldesign.nd2d.materials.texture.Texture2D;
	import flash.display.BitmapData;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	
	/**
	 * 生命条(包含血条和数字)
	 * @author halo
	 */
	public class LifeBar extends Node2D 
	{
		protected static const BAR_Y:uint = 17;
		protected static const BAR_TEX_W:uint = 128;
		protected static const BAR_TEX_H:uint = 32;
		protected static const BAR_W:uint = 64;
		protected static const BAR_H:uint = 3;
		
		protected static var sTextFmt:TextFormat;
		protected static var sBarBitmap:BitmapData;
		protected static var sLifeText:flash.text.TextField;	// 显示生命数字
		
		protected var mCurValue:uint = 0;
		protected var mMaxValue:uint = 0;
		
		protected var mBarTexture:Texture2D;			// 血条贴图(包含数字)
		protected var mBarSprite:Sprite2D;				// 血条精灵
			
		public function LifeBar() 
		{
			super();
			
			if (sBarBitmap == null) {
				sBarBitmap = new BitmapData(BAR_TEX_W, BAR_TEX_H);
			}
			
			if (sTextFmt == null) {
				sTextFmt = new TextFormat("Arial", 12, 0xFFFFFF);
				sTextFmt.align = TextFormatAlign.CENTER;
			}
			
			if (sLifeText == null) {
				sLifeText = new flash.text.TextField();
				sLifeText.defaultTextFormat = sTextFmt;
				sLifeText.width = sBarBitmap.width;
			}
			
			setValue(0, 100);
		}
		
		/**
		 * 设置数据
		 * @param	cur	当前数值
		 * @param	max	最大数值
		 */
		public function setValue(cur:uint, max:uint):void
		{
			if (mCurValue == cur && mMaxValue == max) return;
			
			mCurValue = cur;
			mMaxValue = max;
			
			var rate:Number = Number(mCurValue) / Number(mMaxValue);
			var hpX:uint = BAR_W * rate;
			var offsetX:uint = (BAR_TEX_W >> 1) - (BAR_W >> 1);
			
			// 清除背景
			sBarBitmap.fillRect(new Rectangle(0, 0, sBarBitmap.width, sBarBitmap.height), 0x00ffffff);
			
			// 绘制当前血条和最大血条
			sBarBitmap.fillRect( new Rectangle(offsetX, BAR_Y, BAR_W+2, BAR_H+2), 0xFF000000 );	// 黑框
			sBarBitmap.fillRect( new Rectangle(offsetX+1, BAR_Y+1, BAR_W, BAR_H), 0xFF808080 );	// 灰底
			sBarBitmap.fillRect( new Rectangle(offsetX+1, BAR_Y+1, hpX, BAR_H), 0xFFFF0000 );	// 红条
			
			// 设置当前血量和最大血量文字
			sLifeText.text = mCurValue + "/" + mMaxValue;
			
			// 设置
			//mLifeText.border = true;
			//mLifeText.borderColor = 0x00FF00;
			sBarBitmap.draw(sLifeText);
			
			// 先清除贴图，然后通过bitmapdata创建贴图
			if (mBarTexture != null) mBarTexture.dispose();
			mBarTexture = Texture2D.textureFromBitmapData( sBarBitmap );
			if (mBarSprite == null) {
				mBarSprite = new Sprite2D(mBarTexture);
				addChild(mBarSprite);
			}
			mBarSprite.setTexture(mBarTexture);
		}
		
		
		
	}

}

