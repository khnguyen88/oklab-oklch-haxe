package;

import oklab.Oklab;
import haxe.Json;

// Runs the snapshot test suite.
// Run:  haxe test.hxml
class RunTests {
    static var failures = 0;
    static var passed = 0;

    static function main() {
        var raw = haxe.Resource.getString("snapshot");
        if (raw == null) {
            trace("ERROR: snapshot resource missing. Run 'haxe snapshot.hxml' first.");
            Sys.exit(1);
        }
        var snap:Dynamic = Json.parse(raw);

        testRgbToOklab(snap.rgbToOklab);
        testOklchToRgb(snap.oklchToRgb);
        testRoundTrips(snap.roundTrips);
        testEdgeCases(snap.edgeCases);

        trace('--- ${passed} passed, ${failures} failed ---');
        Sys.exit(failures == 0 ? 0 : 1);
    }

    static function approxEq(a:Float, b:Float, eps:Float = 1e-5):Bool {
        return Math.abs(a - b) <= eps;
    }

    static function rgbEq(a:Array<Int>, b:Array<Int>, tol:Int = 1):Bool {
        return Math.abs(a[0] - b[0]) <= tol
            && Math.abs(a[1] - b[1]) <= tol
            && Math.abs(a[2] - b[2]) <= tol;
    }

    static function check(label:String, ok:Bool, detail:String = ""):Void {
        if (ok) {
            passed++;
        } else {
            failures++;
            trace('FAIL: ${label} ${detail}');
        }
    }

    static function testRgbToOklab(cases:Array<Dynamic>) {
        for (c in cases) {
            var o = new Oklab();
            o.setRgb(c.rgb[0], c.rgb[1], c.rgb[2]);
            var ok = approxEq(o.oklab_l, c.oklab[0])
                && approxEq(o.oklab_a, c.oklab[1])
                && approxEq(o.oklab_b, c.oklab[2])
                && approxEq(o.oklch_l, c.oklch[0])
                && approxEq(o.oklch_c, c.oklch[1])
                && approxEq(o.oklch_h, c.oklch[2]);
            check('rgbToOklab ${c.rgb}', ok,
                'got oklab=(${o.oklab_l},${o.oklab_a},${o.oklab_b}) oklch=(${o.oklch_l},${o.oklch_c},${o.oklch_h})');
        }
    }

    static function testOklchToRgb(cases:Array<Dynamic>) {
        for (c in cases) {
            var o = new Oklab();
            o.setOklch(c.oklch[0], c.oklch[1], c.oklch[2]);
            var ok = rgbEq([o.rgb_r, o.rgb_g, o.rgb_b], c.rgb, 2);
            check('oklchToRgb ${c.oklch}', ok,
                'got rgb=(${o.rgb_r},${o.rgb_g},${o.rgb_b}) expected ${c.rgb}');
        }
    }

    static function testRoundTrips(cases:Array<Dynamic>) {
        for (c in cases) {
            var o = new Oklab();
            o.setRgb(c.rgb[0], c.rgb[1], c.rgb[2]);
            var l = o.oklch_l, ch = o.oklch_c, h = o.oklch_h;
            o.setOklch(l, ch, h);
            var ok = rgbEq([o.rgb_r, o.rgb_g, o.rgb_b], c.rgb, 2);
            check('roundTrip ${c.rgb} (maxErr=${c.maxErr})', ok,
                'got back (${o.rgb_r},${o.rgb_g},${o.rgb_b})');
        }
    }

    static function testEdgeCases(cases:Array<Dynamic>) {
        for (c in cases) {
            var o = new Oklab();
            o.setHex(c.input);
            var ok = o.hex == c.sanitized
                && o.rgb_r == c.rgb[0]
                && o.rgb_g == c.rgb[1]
                && o.rgb_b == c.rgb[2];
            check('edgeCase "${c.input}"', ok,
                'sanitized=${o.hex} rgb=(${o.rgb_r},${o.rgb_g},${o.rgb_b})');
        }
    }
}