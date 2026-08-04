package oklab;

class Run {
	static public function main() {
		trace("---- setHex('#FF0000') ----");
		var red = new Oklab();
		red.setHex("#FF0000");

		trace("---- setRgb(0, 128, 255) ----");
		var fromRgb = new Oklab();
		fromRgb.setRgb(0, 128, 255);

		trace("---- setOklab(0.7, 0.1, 0.1) ----");
		var fromOklab = new Oklab();
		fromOklab.setOklab(0.7, 0.1, 0.1);

		trace("---- setOklch(0.75, 0.15, 1.5) ----");
		var fromOklch = new Oklab();
		fromOklch.setOklch(0.75, 0.15, 1.5);

		trace("---- setOkLrch(0.8, 0.12, 2.0) ----");
		var fromOklrch = new Oklab();
		fromOklrch.setOkLrch(0.8, 0.12, 2.0);

		trace("---- setOkLrab(0.8, 0.1, 0.1) ----");
		var fromOklrab = new Oklab();
		fromOklrab.setOkLrab(0.8, 0.1, 0.1);
	}
}