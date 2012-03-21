package
{
	import com.cokecode.halo.materials.texture.AnimationAtlas;
	
	import de.nulldesign.nd2d.display.Sprite2D;
	import de.nulldesign.nd2d.display.Sprite2DBatch;
	import de.nulldesign.nd2d.materials.texture.Texture2D;
	import de.nulldesign.nd2d.materials.texture.TextureAtlas;
	import de.nulldesign.nd2d.materials.texture.TextureOption;
	
	import flash.display.Bitmap;

	/**
	 * 测试数据
	 */
	
	public class GameAssets
	{
		[Embed(source='Z:/res/charactor/human/texcom/c_0_0.plist', mimeType='application/octet-stream')]
		private static const sprXML1:Class;
		[Embed(source='Z:/res/charactor/human/texcom/c_0_0.png')]
		private static const sprTexture1:Class;
		
		[Embed(source='Z:/res/charactor/human/texcom/c_0_1.plist', mimeType='application/octet-stream')]
		private static const sprXML2:Class;
		[Embed(source='Z:/res/charactor/human/texcom/c_0_1.png')]
		private static const sprTexture2:Class;
		
		[Embed(source='Z:/res/charactor/human/texcom/c_1_0.plist', mimeType='application/octet-stream')]
		private static const sprXML3:Class;
		[Embed(source='Z:/res/charactor/human/texcom/c_1_0.png')]
		private static const sprTexture3:Class;
		
		[Embed(source='Z:/res/charactor/human/texcom/c_1_1.plist', mimeType='application/octet-stream')]
		private static const sprXML4:Class;
		[Embed(source='Z:/res/charactor/human/texcom/c_1_1.png')]
		private static const sprTexture4:Class;
		
		[Embed(source='Z:/res/charactor/human/texcom/c_101_0.plist', mimeType='application/octet-stream')]
		private static const sprXML5:Class;
		[Embed(source='Z:/res/charactor/human/texcom/c_101_0.png')]
		private static const sprTexture5:Class;
		
		[Embed(source='Z:/res/charactor/human/texcom/c_101_1.plist', mimeType='application/octet-stream')]
		private static const sprXML6:Class;
		[Embed(source='Z:/res/charactor/human/texcom/c_101_1.png')]
		private static const sprTexture6:Class;
		
		
		// 粒子系统测试
		[Embed(source="Z:/res/particle/Particle.pex", mimeType="application/octet-stream")]
		private static const _particleConfig:Class;
		
		[Embed(source="Z:/res/particle/ParticleTexture.png")]
		private static const _particlePng:Class;
		
		
		private static var sprTexs:Array = [];
		private static var sprXmls:Array = [];
		
		private static var vecTex2d:Vector.<Texture2D> = new Vector.<Texture2D>();
		private static var vecTexAtlas:Vector.<AnimationAtlas> = new Vector.<AnimationAtlas>();
		private static var vecSpr2d:Vector.<Sprite2D> = new Vector.<Sprite2D>();
		
		static public function initGameRes():void
		{
			// 创建图片和配置文件
			sprXmls.push( new XML(new sprXML1()) );
			sprTexs.push( new sprTexture1() );
			sprXmls.push( new XML(new sprXML2()) );
			sprTexs.push( new sprTexture2() );
			sprXmls.push( new XML(new sprXML3()) );
			sprTexs.push( new sprTexture3() );
			sprXmls.push( new XML(new sprXML4()) );
			sprTexs.push( new sprTexture4() );
			sprXmls.push( new XML(new sprXML5()) );
			sprTexs.push( new sprTexture5() );
			sprXmls.push( new XML(new sprXML6()) );
			sprTexs.push( new sprTexture6() );
			
			// 创建资源
			for (var i:uint=0; i<sprXmls.length; ++i) {
				var bmp:Bitmap = sprTexs[i];
				var xmlData:XML = sprXmls[i];
				
				var tex2d:Texture2D = Texture2D.textureFromBitmapData(bmp.bitmapData, true);
				tex2d.textureOptions = TextureOption.QUALITY_LOW;
				var texAtlas:AnimationAtlas = new AnimationAtlas(tex2d.bitmapWidth, tex2d.bitmapHeight, xmlData, 
					TextureAtlas.XML_FORMAT_COCOS2D, 8);
				
				var key:Array = [];
				for (var k:int = 0; k < 6; k++) {
					//key.push("attack_0000" + k + ".png");
					key.push(k);
				}
				texAtlas.addAnimation('attack', key, true);
				
				var spr2d:Sprite2D = new Sprite2D(tex2d);
				spr2d.setSpriteSheet(texAtlas);
				
				//spr2d.spriteSheet.playAnimation('attack', Math.random() * 30);
				
				vecTex2d.push(tex2d);
				vecTexAtlas.push(texAtlas);
				vecSpr2d.push(spr2d);
			}
			
		}
		
		static public function createChar(texIndex:uint = 0xFFFFFFFF):Sprite2D
		{
			var index:uint = Math.random() * 6;
			if (texIndex != 0xFFFFFFFF)
				index = texIndex;
			
			var tex:Texture2D = vecTex2d[index];
			var texAtlas:AnimationAtlas = vecTexAtlas[index];
			
			var charSpr:Sprite2D = new Sprite2D(tex);
			charSpr.setSpriteSheet(texAtlas);
			charSpr.spriteSheet.playAnimation('attack');
			
			charSpr.pivot.x = -32;
			charSpr.pivot.y = -16;
			
			return charSpr;
		}
		
		/*
		static public function createParticle():ParticleSystem
		{
			// 创建粒子
			var psconfig:XML = new XML(new _particleConfig());
			var psTexture:Texture = Texture.fromBitmap(new _particlePng());
			var _particleSystem:ParticleDesignerPS = new ParticleDesignerPS(psconfig, psTexture);
			_particleSystem.start();
			//_particleSystem.x = Math.random() * 1280;
			//_particleSystem.y = Math.random() * 700;
			
			//addChild(_particleSystem);
			//Starling.juggler.add(_particleSystem);
			return _particleSystem;
		}
		*/
		
	}
}


