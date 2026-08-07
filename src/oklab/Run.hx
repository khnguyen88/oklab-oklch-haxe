package oklab;

class Run {
	static public function main() {
		trace("---- setHex('#FF0000')  / oklch.com match check ----");
		var red = new Oklab();
		red.setHex("#FF0000");
		trace("");

		trace("---- setRgb(0, 128, 255) / oklch.com match check  ----");
		var fromRgb = new Oklab();
		fromRgb.setRgb(0, 128, 255);
		trace("");

		trace("---- setOklab(0.7, 0.1, 0.1) / oklch.com match check  ----");
		var fromOklab = new Oklab();
		fromOklab.setOklab(0.7, 0.1, 0.1);
		trace("");

		trace("---- setOklch(0.75, 0.15, 1.5) / oklch.com match check --------");
		var fromOklch = new Oklab();
		fromOklch.setOklch(0.75, 0.15, 1.5);
		trace("");

		trace("---- setOkLrch(0.8, 0.12, 2.0)  / oklch.com match check ----");
		var fromOklrch = new Oklab();
		fromOklrch.setOkLrch(0.8, 0.12, 2.0);
		trace("");

		trace("---- setOkLrab(0.8, 0.1, 0.1)  / oklch.com match check ----");
		var fromOklrab = new Oklab();
		fromOklrab.setOkLrab(0.8, 0.1, 0.1);
		trace("");

		trace("---- setOklch(0.74, 0.1, 188) / oklch.com match check ----");
		var fromOklch = new Oklab();
		fromOklch.setOklch(0.74, 0.1, 188);
		trace("");

		trace("---- setOklch(0.4837, 0.0516, 274.54) / oklch.com match check ----");
		var fromOklch = new Oklab();
		fromOklch.setOklch(0.4837, 0.0516, 274.54);
		trace("");
	}
}