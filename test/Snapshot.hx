package;

import oklab.Oklab;
import haxe.Json;

// Regenerates test/snapshot.json.
// Run:  haxe snapshot.hxml
class Snapshot {
    static function main() {
        var out:Dynamic = {
            rgbToOklab: [],
            oklchToRgb: [],
            roundTrips: [],
            edgeCases: []
        };

        // 1. RGB -> OKLAB/OKLCH over a coarse grid + named anchors.
        var anchors = [
            [255, 0, 0], [0, 255, 0], [0, 0, 255],
            [255, 255, 255], [0, 0, 0], [128, 128, 128],
            [1, 1, 1], [254, 254, 254]
        ];
        var grid = [];
        for (r in [0, 64, 128, 192, 255]) {
            for (g in [0, 64, 128, 192, 255]) {
                for (b in [0, 64, 128, 192, 255]) {
                    grid.push([r, g, b]);
                }
            }
        }
        var allRgb = anchors.concat(grid);
        for (rgb in allRgb) {
            var o = new Oklab();
            o.setRgb(rgb[0], rgb[1], rgb[2]);
            out.rgbToOklab.push({
                rgb: rgb,
                oklab: [round(o.oklab_l), round(o.oklab_a), round(o.oklab_b)],
                oklch: [round(o.oklch_l), round(o.oklch_c), round(o.oklch_h)],
                oklch_h_deg: round(o.oklch_h_deg),
                hex: o.hex
            });
        }

        // 2. OKLCH -> RGB over a grid of L, C, H (hue in degrees, matching setOklch API).
        var lVals = [0.0, 0.25, 0.5, 0.75, 1.0];
        var cVals = [0.0, 0.1, 0.2, 0.3];
        var hVals = [0.0, 45.0, 90.0, 135.0, 180.0, 225.0, 270.0, 315.0, 360.0];
        for (l in lVals) {
            for (c in cVals) {
                for (h in hVals) {
                    var o = new Oklab();
                    o.setOklch(l, c, h);
                    out.oklchToRgb.push({
                        oklch: [round(l), round(c), round(h)],
                        rgb: [o.rgb_r, o.rgb_g, o.rgb_b],
                        hex: o.hex
                    });
                }
            }
        }

        // 3. Round-trips: RGB -> OKLCH -> RGB. setOklch takes hue in degrees.
        for (rgb in allRgb) {
            var o = new Oklab();
            o.setRgb(rgb[0], rgb[1], rgb[2]);
            var l = o.oklch_l, c = o.oklch_c, hDeg = o.oklch_h_deg;
            o.setOklch(l, c, hDeg);
            var maxErr = Math.max(Math.max(
                Math.abs(o.rgb_r - rgb[0]),
                Math.abs(o.rgb_g - rgb[1])),
                Math.abs(o.rgb_b - rgb[2])
            );
            out.roundTrips.push({
                rgb: rgb,
                rgbBack: [o.rgb_r, o.rgb_g, o.rgb_b],
                maxErr: round(maxErr)
            });
        }

        // 4. Edge cases: invalid hex, empty hex, hex without #, lowercase hex.
        var edgeHexes = ["FF0000", "#ff0000", "#000000", "", "G00000", "#12345Z"];
        for (hex in edgeHexes) {
            var o = new Oklab();
            o.setHex(hex);
            out.edgeCases.push({
                input: hex,
                sanitized: o.hex,
                rgb: [o.rgb_r, o.rgb_g, o.rgb_b]
            });
        }

        sys.io.File.saveContent("test/snapshot.json", Json.stringify(out, "    "));
        trace("snapshot written to test/snapshot.json");
    }

    static function round(v:Float):Float {
        return Math.round(v * 1e6) / 1e6;
    }
}