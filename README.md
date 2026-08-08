# oklab-oklch-haxe

Haxe implementation of Oklab and Oklch color spaces

## Purpose

This is a Haxe Oklab Oklch utility conversion module/class. It also includes methods to convert to/from OkLrab and OkLrch.

## How to use

### STEPS

1. IMPORT MODULE

1. SET THE INITIAL COLOR VALUES
    - CONVERSION IS AUTOMATED UNDER THE HOOD

1. PULLOUT INDIVIDUAL VALUES

### Import the `oklab` module

```hx
package oklab;
```

### Set the HEX value

```hx
var red = new Oklab();
red.setHex("#FF0000");

//Output
// [setHex] hex=#FF0000 rgb=(255,0,0)
// [setHex] oklab=(0.628, 0.225, 0.126) oklch=(0.628, 0.258, 29.234)
```

### Set the RGB values

```hx
var fromRgb = new Oklab();
fromRgb.setRgb(0, 128, 255);

//Output
// [setRgb] rgb=(0,128,255) hex=#0080FF
// [setRgb] oklab=(0.615, -0.051, -0.205) oklch=(0.615, 0.211, 256.099)
```

### Set the Oklab values

```hx
var fromOklab = new Oklab();
    fromOklab.setOklab(0.7, 0.1, 0.1);

//Output
// [setOklab] oklab=(0.7, 0.1, 0.1) oklch=(0.7, 0.141, 45)
// [setOklab] hex=#E57F4E rgb=(229,127,78)
```

### Set the Oklch values

```hx
var fromOklch = new Oklab();
fromOklch.setOklch(0.75, 0.15, 1.5);

//Output
// [setOklch] oklch=(0.75, 0.15, 1.5) oklab=(0.75, 0.15, 0.004)
// [setOklch] hex=#F982A7 rgb=(249,130,167)
```

### Set the Oklrch values

```hx
var fromOklch = new Oklab();
fromOklch.setOklch(0.75, 0.15, 1.5);

//Output
// [setOkLrch] oklab=(0.828, 0.12, 0.004) oklch=(0.828, 0.12, 2)
// [setOkLrch] The existing chroma is outside the sRGB Gamut. Will adjust chroma to the nearest sRGB.
// [setOkLrch] bounded_oklab=(0.828, 0.102, 0.004) bounded_oklch=(0.828, 0.102, 2)
// [setOkLrch] hex=#FFABC1 rgb=(255,171,193)
```

### Set the Oklrab values

```hx
var fromOklrab = new Oklab();
fromOklrab.setOkLrab(0.8, 0.1, 0.1);

//Output
// [setOkLrab] oklab=(0.828, 0.1, 0.1) oklch=(0.828, 0.141, 45)
// [setOkLrab] The existing chroma is outside the sRGB Gamut. Will adjust chroma to nearest sRGB.
// [setOkLrab] bounded_oklab=(0.828, 0.072, 0.072) bounded_oklch=(0.828, 0.102, 45)
// [setOkLrab] hex=#FFB28F rgb=(255,178,143)
```

### Pull out individual values

```hx
trace("---- getHex() ----");
var hex = fromOklrch.getHex();
trace("hex: " + hex);

trace("---- getRgb() ----");
var rgb = fromOklrch.getRgb();
trace("rgb: " +rgb);

trace("---- getLinRgb() ----");
var rgb_lin = fromOklrch.getLinRgb();
trace("rgb_lin: " + rgb_lin);

trace("---- getOklab() ----");
var oklab = fromOklrch.getOklab();
trace("oklab: " + oklab);

trace("---- getOklch() ----");
var oklch = fromOklrch.getOklch();
trace("oklch: " + oklch);


//Output
// ---- getHex() ----
// hex: #FFABC1

// ---- getRgb() ----
// rgb: {g: 171, b: 193, r: 255}

// ---- getLinRgb() ----
// rgb_lin: {g: 0.40563235477248683, b: 0.53571915944501358, r: 0.99992863463377935}

// ---- getOklab() ----
// oklab: {lr: 0.8, l: 0.828132430218386, a: 0.10235948236109645, b: 0.0035744718888264665}

// ---- getOklch() ----
// oklch: {lr: 0.8, l: 0.828132430218386, c: 0.102421875, h: 0.034906585039886591}
```

## Inspiration

This project was inspired by Alexei Boronine's [hsluv-haxe](https://github.com/hsluv/hsluv-haxe/tree/main) project. I was looking for an open-source project to contribute to, and a peer, **logoooo**, I met on discord proposed that I build an oklab/oklch module/library for the Haxe programming language. He is pretty involved with the Haxe and Ceramic community and suggested I contribute.

Since I am an artist and have a fascination and appreciation for colors and color science, this was the perfect project for me. So here we are!

## Status

WIP - Testing and validatiing.

## Module Details

### General Conversion Process

The module streamlines the process of converting the standard RGB (sRGB) color space to the Oklab and Oklch color spaces. It just requires multiple steps. Bjorn Ottosson and Wikipedia streamlined and merged the 2nd and 3rd steps. So if you felt like a step was missing, that's why. I believe it's to minimize rounding errors, improve rounding accuracy and precision, and save time/steps. My code will account for all of the steps.

1. sRGB color space to linear sRGB color space
2. linear RGB color space to CIE-XYZ color space
3. CIE-XYZ color space to LMS color space
4. LMS color space to non-linear LMS color space (by applying cubic function, relates to )
5. non-linear LMS color space to OkKlab color space
6. Oklab color space (cartesian) <--> Oklch color space (polar)

While most screens default to sRGB, different displays may use P3 Gamut or Rec2020 color spaces, which interpret RGB and its 0-255 color values differently and provide a richer, wider range of colors. In this case, different transformation matrices are required for P3 Gamut and Rec2020 to the CIE-XYZ color space. Dan Bruzo provides those matrices.

### Oklab and Oklch's L and Lr

If you look at my source code, you will notice that the Oklab and Oklch variables will have an "l" property and a "lr" property. These two properties refer to the "lightness" and "reference-white lightness".

- Oklab L = The lightness the color looks to humans, no matter the physical brightness. Lightness is the perceived brightness

- Oklab Lr = The lightness adjusted to behave like CIELab inside a color picker.

The relationship between L and Lr in Oklab/Oklch is an algberic formula used to shift the raw Oklab cublic relationship to match that of CIELAB'S L\* / 100.

This decision was made after reading one of Bjorn Ottosson's blogs on color pickers, and its section on a [new way to estimate lightness "L" for Oklab](https://bottosson.github.io/posts/colorpicker/#intermission---a-new-lightness-estimate-for-oklab)

### Whitepoint is not related to Lightness

In one of Bjorn Ottosson's [Oklab blog](https://bottosson.github.io/posts/oklab/), he stated that "Oklab uses a D65 whitepoint, since this is what other common color spaces, like sRGB, use". D65 and D50 refer to the hue of tint of white given the perceived temperature value of the light source. For example, D65 means what the perceived white is at 6500K, and D50 means what the perceived white is at 5000K. So depending on the white reference point we use, color values will shift slightly. It does not have anything to do with the perceived brightness or lightness of a color, including white.

### Transformation Matrices (M1, M2, M3) and Precision

Bjorn Ottosson and Wikipedia provided the steps, formulas, and transformation matrices (M1, M2) needed to convert the CIE-XYZ color space to the LMS color space and then to the OKLAB color space. The information specified by these two sources is used in the code.

To get to the CIE-XYZ color space from the sRGB color space, a transformation matrix, M, is required. This transformation matrix, M, is standard and readily available online, but its precision varies depending on the source it was retrieved from.

The transformation matrix, M, used in the code is derived from Bjorn Ottosson's other transformation matrices.

In the [source code](https://bottosson.github.io/posts/oklab/#converting-from-linear-srgb-to-oklab) that Bjorn Ottosson provided, he streamlined two conversion steps from linear RGB color space to the CIE-XYZ color space and from the CIE-XYZ color space to the LMS color space by multiplying the two transformation matrices, M1_M. So,

|     |     |     |     |     |
| --- | --- | --- | --- | --- |
| X   |     |     |     | R'  |
| Y   | =   | M   | \*  | G'  |
| Z   |     |     |     | B'  |

and

|     |     |     |     |     |
| --- | --- | --- | --- | --- |
| l   |     |     |     | X   |
| m   | =   | M1  | \*  | Y   |
| s   |     |     |     | Z   |

**becomes**

|     |     |     |     |     |     |     |
| --- | --- | --- | --- | --- | --- | --- |
| l   |     |     |     |     |     | R'  |
| m   | =   | M1  | \*  | M   | \*  | G'  |
| s   |     |     |     |     |     | B'  |

**or**

|     |     |      |     |     |     |
| --- | --- | ---- | --- | --- | --- |
| l   |     |      |     |     | R'  |
| m   | =   | M1_M | \*  |     | G'  |
| s   |     |      |     |     | B'  |

The issue is that Bjorn Ottosson never provided the transformation matrix, M, that he used in his calculations or formula. Still, he stated his matrix was derived using a higher-precision RGB (transformation) matrix and exact matching D65.

Attempts to create values in Bjorn Ottosson’s M_M1 transformation matrices could not be replicated with other existing transformation matrices, M, found from other sources like Alexi Boronine’s hsluv-haxe, Imaging-Engineering, and Wikipedia, due to the differences in precision of the values in the matrix. Effectively, no two sources for the sRGB to CIE-XYZ transformation matrix, M, with a standard illuminant of D65 will be the same. It appears to be very subjective based on who estimated it.

To best accurately obtain the transformation matrix M that Bjorn Ottosson would have used, it was derived using the known matrices, M1_M and M1, by multiplying the inverse of the M1 matrix with M1_M. Both M1_M and M1 matrices come from Bjorn Ottosson and Wikipedia. The formula to find the unknown matrix of a given matrix multiplication equation comes from a Math Stack Exchange discussion. Note that the order of matrices matters in matrix multiplication.

Given that A, B, and C are matrices with the same dimension…

`A * B = C`

`A = C * B^-1` _(Note: The order of matrix multiplication when finding A)_

`B = A^-1 * C` _(Note: The order of matrix multiplication when finding B)_

or...

`M1 * M = M1_M`

`M = M1^-1 * M_M1`

The inverse matrices of M1 and M2 and the various matrix multiplications were calculated using [high-precision matrix calculators developed and provided by Reshish](https://matrix.reshish.com/).

Values from the computed matrices were verified using Wolfram Alpha's calculator. Wolfram Alpha's estimate was not used because the results provided rounded, lower-precision estimates.

### Normalized sRGB and Linear sRGB, Apply Gamma vs Linearlize

The most common representation of color is sRGB, or standard RGB. It is an additive color model. Starting from black, as you increase the value of each color channel, it gets closer to white.

sRGB colors are represented as non-linear 8-bit color depth, with values ranging from 0-255. sRGB colors naturally come with the gamma function applied, making it nonlinear. Each channel can range from a 0-255 color value. Non-linear in terms of sRGB is the approximate human brightness perception of colors. It does not actually represent the actual physical light intensity; it is how we perceive it, which is skewed.

Gamma is a curve function applied to linear light, and intended to represent how humans perceive the brightness of colors and thus different color channels. Human perception of brightness tends to curve color towards dark tones or values since we're more sensitive to differences there. Gamma values tend to range from 0 to 1, hence why we need to remove the color bit depth by normalizing it or dividing each color channel by 255. The gamma curve function is the observed byproduct of how CRT screens physically work and how the human eye perceives and responds to it. Brightness is a power law of voltage, hence non-linear.

Linear light basically the physical intensity of light, relative to photon count or amount of light available (of each color channel). Aka photon count/amount of light available, per color channel. This conversion is needed before applying matrix computation with a transformation matrix to change it to a different color space. Aka sRGB -> CIE-XYZ.

CIE-XYZ color space is important because it is designed to match human vision and describes how humans see color by observing and recording how they matched colors. Where Y represents brightness, and X and Z represent the red/green/blue responses. It is used as the base and intermediate color space before we shift to a different color space. It requires the sRGB color channels to be linearized.

"Removing gamma from the sRGB data" or "linearizing the sRGB data" means the same thing. We remove the gamma curve function from the color channel and transform it into what it physically represents.

"Applying gamma" means simply using the gamma curve function to adjust the color channel values to match how people perceive them.

### Lightness (L) and Luminance (Y)

Lightness (L) is the human-visually perceived value of luminance of an object. This measurement is always relative to a reference white.

Luminance (Y) is the true physical measured value of luminous intensity/brightness to an object.

They share a cube-root relationship. Effectively, humans perceive the intensity of light as the power to the (1/3)—something 8 times the luminance is seen as twice as bright to us.

This holds exactly for Oklab: for neutral grays, Oklab’s LMS-cube-root collapses cleanly to L = Y^(1/3), no offset or extra scaling — by design.

It does NOT hold for CIE L\* and it’s color spaces and other which adds an offset or scaling to it.

- CIE L* uses L* = 116·f(Y/Yn) − 16, f being a cube root above a small threshold (linear below it, near black).

- Oklab’s L is the cube root of the LMS cone responses (post cone-space conversion), then recombined — not a direct cube root of Y. Hence why Oklab feels more naturally close to what we perceive.

### Chroma (c) and Lightness (L) and Saturation (s)

Chroma is the colorfulness or richeness of color. Chroma measures color's differences from a gray of the same lightness.

Saturation is the ratio of Colorfulness divided by brightness or "Colorfulness of an area judged in proportion to its brightness."

Chroma and Lightness shares a wedge relationship.

Chroma converges to 0 when L = 0 (white) or L = 0 (black).

As lightness on either end, L = 1 for pure white or L = 0 for pure black, approaches the cusp or peak, it increases in chroma. Max chroma/ peak varies and shifts depending on the hue.

The peak shifts by hue. Yellow cusps near white (L≈0.97), blue cusps well below center (L≈0.45). Red, green, cyan, magenta all land somewhere between.

### Respecting the sRGB Gamut

Oklch and Oklab have a wider color gamut (color boundary) and a wider range of colors than sRGB.

When converting Oklch/Oklab back to sRGB, we need to ensure we preserve the sRGB values. Chroma (c) and Lightness (l) are the parameters are the main drivers that changes the sRGB and linear RGB values. Chroma being the primary driver.

To ensure we do, if a chroma value results in a linear sRGB value less than zero or greater than one for any of the channels, it means it is outside of the gamut; too keep the adjustment process simple, we ignore lightness and adjust the chroma so that it stays within the boundary.

We achieve this with a binary recursive search, iterating through the Oklch/Oklab to linear sRGB color space, and reducing or increasing the c value until all linear sRGB channels are bounded within the sRGB gamut.

### Cartesian coordinates vs Polar Coordinates

- Oklch is effective polar coordinates, why Oklab is cartesian coordinates

## Resources / References

### Color Science

The science and math used to understand the Oklab and Oklch color space and implemented in this module was taken from the following sources. The main source being Bjorn Ottoson:

- [Bjorn Ottosson - A perceptual color space for image processing (Oklab)](https://bottosson.github.io/posts/oklab/)
- [Image Engineering - How to convert between sRGB and CIEXYZ ](https://www.image-engineering.de/en/resources/tech-notes/convert-between-srgb-and-ciexyz/)

- [Wikipedia - Oklab Color Space](https://en.wikipedia.org/wiki/Oklab_color_space)
- [Bjorn Ottosson - How software gets color wrong](https://bottosson.github.io/posts/colorwrong/)

- [W3C - CSS Color Module Level 4](https://www.w3.org/TR/css-color-4/)
- [Wikipedia - International Commission on Illumination (CIE)](https://en.wikipedia.org/wiki/International_Commission_on_Illumination)
- [Wikipedia - CIE 1931 Color Space](https://en.wikipedia.org/wiki/CIE_1931_color_space)
- [W3C & Chris Lilley - better than Lab? Gamut reduction: CIE Lab & OKLab](https://www.w3.org/Graphics/Color/Workshop/slides/talk/lilley)
- [Bruce Lindbloom - RGB to XYZ](http://www.brucelindbloom.com/index.html?Eqn_RGB_to_XYZ.html)
- [Dan Burzo - Color matrix calculator](https://observablehq.com/@danburzo/color-matrix-calculator)
- [Bruce Lindbloom = RGB/XYZ Matrices](http://www.brucelindbloom.com/index.html?Eqn_RGB_to_XYZ.html)

- [Wikipedia - From sRGB to CIE-XYZ](https://en.wikipedia.org/wiki/SRGB#From_sRGB_to_CIE_XYZ)

- [Cambridge in Colour](https://www.cambridgeincolour.com/tutorials/gamma-correction.htm)
- [Charles Poynton - Frequently Asked Questions about Gamma](https://www.poynton.ca/faq/gammafaq/GammaFAQ.pdf)

- [Wikipedia - Colorfulness](https://en.wikipedia.org/wiki/Colorfulness)

- [Peter Donahue - Saturation vs Chroma](https://petertdonahue.com/Saturation-vs-Chroma.html)

### Programming Language

- [Haxe Introduction ](https://haxe.org/documentation/introduction/)

- [Haxe Code Cookbook](https://code.haxe.org/)

- [Haxe Code Cookbook - Beginner ](https://code.haxe.org/category/beginner/)

- [Haxe Manual - Standard Unit Test](https://haxe.org/manual/std-unit-testing.html)

- [Haxe UTest](https://github.com/haxe-utest/utest)

### Math

- [How to Multiply Matrices](https://www.mathsisfun.com/algebra/matrix-multiplying.html)

- [Professor Dave Explains - Inverse Matrices and their properties](https://www.youtube.com/watch?v=kWorj5BBy9k)

- [bprp math basics - Inverse Matrices](https://www.youtube.com/watch?v=p8VnTCfJHAo)

- [Wolfram Alpha - Matrix Inverse Calculator](https://www.wolframalpha.com/calculators/matrix-inverse-calculator)

- [Reshish - Matrix Inverse Calculator](https://matrix.reshish.com/inverse-matrix/)

- [Math Stack Exchange - Find Missing Matrix A, Given A \* B = C](https://math.stackexchange.com/questions/350463/find-matrix-a-if-ab-c-and-b-and-c-are-known)

- [Omni Calculator - How to Convert Number to Hexadecimal](https://www.omnicalculator.com/conversion/decimal-to-hexadecimal)

### Sanity Checks / Tests

The Oklch online converter was used as an independent source of truth for sanity spot checks and debugging purposes to compare and evalute the conversion between OKLCH <-> HEX.

- [Oklch - Color Picker & Converter](https://oklch.com)

An XYZ and Oklab pair table for in Bjorn's Ottosson was used to check the intermediate steps and their output when converting from the CIE-XYZ color space to the Oklab color space.

- [Table of example XYZ and Oklab pairs](https://bottosson.github.io/posts/oklab/#table-of-example-xyz-and-oklab-pairs)

Mirror tests were used to see if there were any issue in the color space conversion process, aka. matrices transformations. For example if we used output from an HEX to OKLCH conversion as input for the OKLCH to HEX conversion, the mirrored input/output values should be the same. If not, there is a bug or issue somewhere in one of the steps.

Edge cases at or near the sRGB Gamut are tested, as any Oklab or Oklch values that exceeds the rgbGamu this can easily evaluated in the linear sRGB color space, where colors need to be within

### Reference Project

In addition to Haxe's own documentation, I used Alexei's hsluv-haxe as a resource to learn and understand how to setup project structure and write the language syntax for Haxe. Since it's the go-to module for the Haxe community, I know it'll be a reliable resource. There will be similarity when you compare the two projects, but luckily the math for the hsluv and oklab/oklch will be _mostly_ different! The process required to convert sRGB to sRGB' and sRGB' to CIEXYZ is the same for both color spaces.

- [Alexei Boronine's hsluv-haxe (Github)](https://github.com/hsluv/hsluv-haxe/tree/main)

## Disclaimer

I am not an expert in color science or color theory, but I do appreciate it and I enjoy learning. I don't have everything fully grasp but I'm doing my best to get there. If you spot anything factually in correct.

A LLM (GLM 5.1) was used sparingly towards the end to generate the build filesa and the snapshot and test files and convert all my variables to snake_case in order to save time. The other time the LLM was used was to help pinpoint one bug, the negative cubic root error , that I could not figure out on my own. That's it.

I wrote everything else.
