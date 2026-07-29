# oklab-oklch-haxe

Haxe implementation of Oklab and Oklch color spaces

## Status

WIP - Wrote the README.md and setup the project folder.

## Purpose

This is a Haxe Oklab/Oklch utility conversion module/class.

## Inspiration

This project was inspired by Alexei Boronine's [hsluv-haxe](https://github.com/hsluv/hsluv-haxe/tree/main) project. I was looking for an open-source project to contribute to and a peer, Isaac or logoooo (Discord), on my unviersity's CIS discord channel proposed I build a oklab/oklch module/library for the haxe programming language. He is pretty involved with the Haxe and Ceramic community and suggeted I make the contribution.

Since I am an artist and have a fascination and appreciation for colors and color science, this was the perfect project for me. So here we are!

## Module Details

### General Conversion Process

The module simply streamline the process of transforming the standard RGB (sRGB) color space into the Oklab and Oklch color space. It just requires multiple steps. Bjorn Ottosson and Wikipedia, streamlined and merged the 2nd and 3rd steps together. So if you felt like a step was missing, that's why. I believe its to minimize rounding errors and improve rounding accuracy and precision and save time/steps. My code will account for all of the steps.

1. sRGB color space to linear sRGB color space
2. linear RGB color space to CIE-XYZ color space
3. CIE-XYZ color space to LMS color space
4. LMS color space to linear LMS color space
5. linear LMS color space to OkKlab color space
6. Oklab color space (cartesian) <--> Oklch color space (polar)

While most screen defaults to sRGB, different displays may use P3 Gamut or Rec2020 color spaces which interprets the RGB and its 0-255 color values differently, and provide a richer and wider range of colors. In this case, different transformation matrices is required for P3 Gamut ance Rec2020 to CIE-XYZ color space. Dan Bruzo provides those matrices.

### Oklab and Oklch's L and Lr

If you look at my source code you will notice that the Oklab and Oklch variables will have a "l" property and a "lr" property. These two properties refer to the "lightness" and "reference-white lightness".

- Oklab L = The lightness the color looks to humans, no matter the physical brightness. Lightness is the precieved brightness

- Oklab Lr = The lightness adjusted to behave like CIELab inside a color picker.”

This decision was made after reading one of Bjorn Ottosson's blog on color picker and it's section on a [new way to estimate lightness "L" for Oklab](https://bottosson.github.io/posts/colorpicker/#intermission---a-new-lightness-estimate-for-oklab)

From what understand, in references to the sRGB conversion to RGB

### Whitepoint is not related to Lightness

In one of Bjorn Ottosson's [Oklab blog](https://bottosson.github.io/posts/oklab/), he stated that "Oklab uses a D65 whitepoint, since this is what other common color spaces, like sRGB, uses". D65 and D50, refers to the hue of tint of white given the precieve temperture value of the light source. For example D65 means what is the precieved white at 6500K and D50 means what is the precieved what at 5000K. So depending on the white reference point we use, color values will shift slightly. It does not have anything to do with the precieve brightness or lightness of a color, including white.

### Transformation Matrices (M1, M2, M3) and Precision

Bjorn Ottosson and Wikipedia provided the steps, formulas, and transformation matrices (M1, M2) needed to convert the CIE-XYZ color space to the LMS color space and then to the OKLAB color space. The information specified by these two sources are used in the code.

To get to the CIE-XYZ color space from the sRGB color space, a transformation matrix, M, is required. This tranformation matrix, M, is standard and readily avaliable online, but varies in the level of precision depending on the source it was retrieved from.

The transformation matrix, M, used in the code is derived from Bjorn Ottosson's other transformation matrices.

In the [source code](https://bottosson.github.io/posts/oklab/#converting-from-linear-srgb-to-oklab) that Bjorn Ottosson provided, he streamlined two conversion steps from linear RGB color space to CIE-XYZ color space and CIE-XYZ color space to LMS color space, by doing the product of the two tranformation matrices, M1_M. So,

|     |     |     |     |     |
| --- | --- | --- | --- | --- |
| X   |     |     |     | R'  |
| Y   | =   | M   | \*  | G'  |
| Z   |     |     |     | B'  |

---

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

The issue is that Bjorn Ottosson never provided never provided the transformation matrix, M, that he used in his calculations or formula, but have stated his matrix have been dervied using a higher precision sRGB (transformation) matrix and exact matching D65.

Attempts to create values in Bjorn Ottosson's M_M1 transformation matrices, could not be replicated with other existing transformation matrix, M, found from other sources like **Alexi Boronine's hsluv-haxe**, **Imaging-Engineering** and **Wikipedia**, due to the differences in precision of the values in the matrix. Effectively, no two source for the sRGB to CIE-XYZ transformation matrix, M, with a standard illuminant of D65 will be the same. It appears to be very subjective based on who estimated it.

To best accurately obtain the transformation matrix M that Bjorn Ottosson would have used, it was simply derived using the known matrices, M1_M and M1 by multiplying the inverse of the M1 matrix with M1_M. Both M1_M and M1 matrices comes from Bjorn Ottosson and wikipedia. The [formula to find the unknown matrix of a given matrix multiplication equation](https://math.stackexchange.com/questions/350463/find-matrix-a-if-ab-c-and-b-and-c-are-known) comes from a Math Stack Exchange discussion. Note the order of matrices matter in matrix multiplication.

Given A, B, C are matrices with the same dimension...

`A * B = C`

`A = C * B^-1` _(Note: The order of matrix multiplication when finding A)_

`B = A^-1 * C` _(Note: The order of matrix multiplication when finding B)_

or...

`M1 * M = M1_M`

`M = M1^-1 * M_M1`

The inverse matrix of M1 and M2 and the various matrices multiplication were calculated using [high precision matrix calculators developed and provided reshish](https://matrix.reshish.com/).

Values from the computed matrices were verified using Wolfram Alpha's calculator. Wolfram Alpha's estimate was not used because the results provided rounded and lower precision estimates.

## Resources / References

### Color Science

The science and math used to understand the Oklab and Oklch color space and implemented in this module was taken from:

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

### Reference Project

In addition to Haxe's own documentation, I used Alexei's hsluv-haxe as a resource to learn and understand how to setup project structure and write the language syntax for Haxe. Since it's the go-to module for the Haxe community, I know it'll be a reliable resource. There will be similarity when you compare the two projects, but luckily the math for the hsluv and oklab/oklch will be _mostly_ different! The process required to convert sRGB to sRGB' and sRGB' to CIEXYZ is the same for both color spaces.

- [Alexei Boronine's hsluv-haxe (Github)](https://github.com/hsluv/hsluv-haxe/tree/main)

## Disclaimer

I am not an expert in color science or color theory, but I do appreciate it and I enjoy learning. I don't have everything fully grasp but I'm doing my best to get there. If you spot anything factually in correct
