package;

import h2d.Anim;
import h2d.Bitmap;
import h2d.Graphics;
import h2d.HtmlText;
import h2d.Interactive;
import h2d.Text;
import h2d.TextInput;
import h2d.Tile;
import hxd.Event;
import hxd.Res;
import hxd.res.DefaultFont;
import hxd.res.FontBuilder;

// https://www.youtube.com/watch?v=6j2STxaVu0U
class Main2D extends hxd.App 
{
	var bmps : Array<Bitmap>;
	
	override function init() {
		bmps = [];
		var tile = Tile.fromColor(0xFF0000, 300, 300);
		var tile = Res.hxlogo.toTile();
		tile.dx  = -150;
		tile.dy  = -150;
		for (i in 0...1000) {
			var bmp = new Bitmap(tile, s2d);
			bmp.x = s2d.width * Math.random();
			bmp.y = s2d.height * Math.random();
			bmp.alpha = 0.2;
			bmp.rotation = Math.random() * Math.PI * 2;
			bmp.scale(0.2);
			bmps.push(bmp);
			bmp.colorKey = 0xFFFFFF;
			bmp.adjustColor({hue : Math.random()});
		}
		
		//var a = new Anim([], 2, s2d);
		var tf = new HtmlText(DefaultFont.get(), s2d);
		tf.text = "Haxe <font color='#ff0000'>Rocks!</font>";
		tf.scale(20);
		//t.smooth = true;
		
		// Green Pacman
		var g  = new Graphics(s2d);
		g.beginFill(0x00FF00, 0.4);
		g.drawPie(500, 500, 100, 0, 5);
		
		// Pour interagir avec des éléments
		var i = new Interactive(tf.textWidth, tf.textHeight, tf);
		i.onOver = function(_) { tf.alpha = 0.5; }
		i.onOut = function(_) { tf.alpha = 1; }
		i.onClick = function(event:Event) {trace(event); };
		i.onWheel = function(event:Event) trace(event);
		i.onKeyDown = function(event:Event) tf.text = String.fromCharCode(event.keyCode);
		
		//i.backgroundColor = 0x800000FF;
		
		var ti = new TextInput(DefaultFont.get(), s2d);
		ti.text = "Erase me!";
		ti.scale(10);
		ti.y = 300;
	}
	
	override function update(dt:Float) {
		for (b in bmps) {
			b.rotate(dt * Math.random() / 100);
			//b.move(Math.random(), Math.random());
			b.x += Math.random();
			if (b.x > s2d.width + 10) {
				b.x = -10;
			}
			//b.y++;
		}
	}
	
	static function main() 
	{
		Res.initEmbed();
		#if debug
		trace('debug mode');
		#end
		new Main2D();
	}
	
}

// Télécharger HL https://hashlink.haxe.org/#download
// Décompresser hl_release à côté de haxe et neko, et ajouter au Path
// Faut haxe4 pour hashlink

// Export JS : 
// Garder export/index.html
// # haxe --connect 6000 -lib heaps -lib castle -D debug -cp src -main Main2D -js export/js/HeapsTest.js

// Export HL DirectX
// Build ok, exe ok, pas avec le connect (à tester après redémarrage ou redémarrage du server)
// # haxe -lib heaps -lib hldx -lib castle -cp src -main Main2D -hl export/hldx/output.hl
// # haxe --connect 6000 -lib heaps -lib hldx -lib castle -cp src -main Main2D -hl export/hldx/output.hl
// # hl export\hldx\output.hl

// Export HL SDL
// Build ok, exe pas ok
// # haxe -lib heaps -lib hlsdl -lib castle -cp src -main Main2D -hl export/hlsdl/output.hl
// # haxe --connect 6000 -lib heaps -lib hlsdl -lib castle -cp src -main Main2D -hl export/hlsdl/output.hl
// # hl export\hlsdl\output.hl