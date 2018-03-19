package;

import h2d.Anim;
import h2d.Bitmap;
import h2d.Graphics;
import h2d.HtmlText;
import h2d.Interactive;
import h2d.Text;
import h2d.TextInput;
import h2d.Tile;
import h3d.Vector;
import h3d.prim.Cube;
import h3d.prim.ModelCache;
import h3d.scene.CameraController;
import h3d.scene.DirLight;
import h3d.scene.Mesh;
import h3d.scene.Object;
import hxd.Res;
import hxd.fmt.pak.FileSystem;
import hxd.fmt.pak.FileSystem.FileInput;
import hxd.res.DefaultFont;
import hxd.res.FontBuilder;
import hxsl.Shader;

import Data;

class SummitShader extends Shader {
	
	static var SRC = {
		@:import h3d.shader.BaseMesh;
		
		function fragment() {
			//output.color.r = 0.0;
		}
		
		function vertex() {
			//relativePosition.x += 2*fract(sin(dot(vec2(relativePosition.x, relativePosition.y) ,vec2(12.9898,78.233))) * 43758.5453);
			//relativePosition.y += 2*fract(sin(dot(vec2(relativePosition.x, relativePosition.y) ,vec2(12.9898,78.233))) * 43758.5453);
			//relativePosition.z += 2 * fract(sin(dot(vec2(relativePosition.x, relativePosition.y) , vec2(12.9898, 78.233))) * 43758.5453);
			
			//transformedPosition.x += sin(transformedPosition.y * 3 + global.time * 4) * 0.5;
		}
	}
}

// https://www.youtube.com/watch?v=6j2STxaVu0U
class Main extends hxd.App 
{
	var light : DirLight;
	var obj : Object;
	var cubeObj : Mesh;
	var rotation : Float = 0;
	
	override function init() {
		var cache = new ModelCache();
		//obj = cache.loadModel(Res.Model);
		//obj.scale(0.01);
		//s3d.addChild(obj);
		
		var anim = cache.loadAnimation(Res.Model);
		
		for (i in 0...30) {
			for (y in 0...30) {
				var objtemp = cache.loadModel(Res.Model);
				objtemp.x = i / 5;
				objtemp.y = y / 5;
				objtemp.scale(0.01);
				objtemp.playAnimation(anim);
				objtemp.currentAnimation.setFrame(Math.random() * 10);
				var range = 0.5;
				var min = 0.8;
				var scaleX = Math.random() * range + min;
				var scaleY = Math.random() * range + min;
				var scaleZ = Math.random() * range + min;
				objtemp.scaleX *= scaleX;
				objtemp.scaleY *= scaleY;
				objtemp.scaleZ *= scaleZ;
				//trace(anim.speed);
				var minSpeed = 0.7;
				var maxSpeed = 2;
				var speed = (scaleZ - min) / (min + range - min) * (minSpeed - maxSpeed) + maxSpeed;
				objtemp.currentAnimation.speed = speed;
				//anim.speed = (scaleX + scaleY + scaleZ) / 3;
				s3d.addChild(objtemp);
				//for (m in objtemp.getMeshes()) {
					//m.material.mainPass.enableLights = true;
					//m.material.shadows = true;
				//}
				for (m in objtemp.getMaterials()) {
					m.mainPass.addShader(new SummitShader());
				}
			}
		}
		var sphere = new h3d.prim.Sphere(1, 32, 24);
		sphere.addNormals();
		
		
		
		var p = new h3d.scene.Mesh(sphere, s3d);
			p.scale(0.5);
			p.x = 5;
			p.y = 1;
			p.z = 2;
			p.material.mainPass.enableLights = true;
			p.material.shadows = true;
			p.material.color.setColor(Std.random(0x1000000));
			
		s3d.camera.zNear = 1;
		s3d.camera.zFar = 30;
		s3d.lightSystem.ambientLight.set(0.5, 0.5, 0.5);

		for (i in Data.test.all) {
			trace(i.Text);
		}
		
		var cube = new Cube(7, 7, 0.1);
		//cube.unindex();
		cube.addNormals();
		//cube.addUVs();
		cube.translate(-0.5, -0.5, -0.1);
		
		cubeObj = new Mesh(cube, s3d);
		//cubeObj.material.color = new Vector(30, 30, 30);
		cubeObj.material.mainPass.enableLights = true;
		cubeObj.material.shadows = true;

		// On peut afficher par dessus oO
		//var ti = new TextInput(DefaultFont.get(), s2d);
		//ti.text = "Erase me!";
		//ti.scale(10);
		//ti.y = 300;
		
		light = new DirLight(new Vector( -0.1, 0.2, -0.2), s3d);
		light.enableSpecular = true;
		new CameraController(s3d).loadFromCamera();
		
		var shadow = cast(s3d.renderer.getPass("shadow"), h3d.pass.ShadowMap);
		shadow.blur.passes = 3;
		
		//new DirLight(new Vector(0.2, 0.2, -1));
		
		//engine.backgroundColor = 0xFF808080;
	}
	
	override function update(dt:Float) {
		//rotation += dt * 0.01;
		//if (rotation % Math.PI*2 < 1) {
			//obj.rotate(dt * 0.01, 0, 0);
		//} else if (rotation % Math.PI*2 < 2) {
			//obj.rotate(0, dt * 0.01, 0);
		//} else if(rotation % Math.PI*2 < 3) {
			//obj.rotate(0, 0, dt * 0.01);
		//} else {
			//rotation = 0;
		//}
		//obj.rotate(0, 0, dt * 0.1);
	}
	
	static function main() 
	{
		Res.initEmbed();
		Data.load(hxd.Res.data.entry.getText());
		
		//var p = new FileSystem();
		// ?
		//p.addPak("folder");
		//p.loadPak("file");
		new Main();
	}
	
}

// Télécharger HL https://hashlink.haxe.org/#download
// Décompresser hl_release à côté de haxe et neko, et ajouter au Path
// Faut haxe4 pour hashlink
// haxe -hl output.hl -lib heaps -lib hldx -cp src -main Main
// haxe -hl output.hl -lib heaps -lib hlsdl -cp src -main Main // build ok mais pas executable :/
// hl output.hl