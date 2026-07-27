# oklab-oklch-haxe

Haxe implementation of Oklab and Oklch color spaces

## Status
WIP - Wrote the README.md and setup the project folder.

## Purpose

This is a Haxe Oklab/Oklch utility conversion module/class.

## Inspiration

This project was inspired by Alexei Boronine's [hsluv-haxe](https://github.com/hsluv/hsluv-haxe/tree/main) project. I was looking for an open-source project to contribute to and a peer, Isaac or logoooo (Discord), on my unviersity's CIS discord channel proposed I build a oklab/oklch module/library for the haxe programming language. He is pretty involved with the Haxe and Ceramic community and suggeted I make the contribution.

Since I am an artist and have a fascination and appreciation for colors and color science, this was the perfect project for me. So here we are!

## General Conversion Projecess

The module simply streamline the process of transforming the standard RGB (sRGB) color space into the Oklab and Oklch color space. It just requires multiple steps. Bjorn Ottosson and Wikipedia, streamlined and merged the 2nd and 3rd steps together. So if you felt like a step was missing, that's why. I believe its to minimize rounding errors and improve rounding accuracy and precision and save time/steps. My code will account for all of the steps.

1. sRGB color space to linear sRGB color space
2. linear RGB color space to CIE-XYZ color space
3. CIE-XYZ color space to LMS color space
4. LMS color space to OkKlab color space
5. Oklab color space (cartesian) <--> Oklch color space (polar)

While most screen defaults to sRGB, different displays may use P3 Gamut or Rec2020 color spaces which interprets the RGB and its 0-255 color values differently, and provide a richer and wider range of colors. In this case, different transformation matrices is required for P3 Gamut ance Rec2020 to CIE-XYZ color space. Dan Bruzo provides those matrices.

## Resources / References

The science and math used to understand the Oklab and Oklch color space and implemented in this module was taken from:

- [Bjorn Ottosson - A perceptual color space for image processing (Oklab)](https://bottosson.github.io/posts/oklab/)
- [Image Engineering - How to convert between sRGB and CIEXYZ ](https://www.image-engineering.de/en/resources/tech-notes/convert-between-srgb-and-ciexyz/)

- [Wikipedia - Oklab Color Space](https://en.wikipedia.org/wiki/Oklab_color_space)
- [Bjorn Ottosson - How software gets color wrong](https://bottosson.github.io/posts/colorwrong/)
- [How to Multiply Matrices](https://www.mathsisfun.com/algebra/matrix-multiplying.html)

- [W3C - CSS Color Module Level 4](https://www.w3.org/TR/css-color-4/)
- [Wikipedia - International Commission on Illumination (CIE)](https://en.wikipedia.org/wiki/International_Commission_on_Illumination)
- [Wikipedia - CIE 1931 Color Space](https://en.wikipedia.org/wiki/CIE_1931_color_space)
- [W3C & Chris Lilley - better than Lab? Gamut reduction: CIE Lab & OKLab](https://www.w3.org/Graphics/Color/Workshop/slides/talk/lilley)
- [Bruce Lindbloom - RGB to XYZ](http://www.brucelindbloom.com/index.html?Eqn_RGB_to_XYZ.html)
- [Dan Burzo - Color matrix calculator](https://observablehq.com/@danburzo/color-matrix-calculator)
- [Bruce Lindbloom = RGB/XYZ Matrices](http://www.brucelindbloom.com/index.html?Eqn_RGB_to_XYZ.html)

Since I have never programmed or written in Haxe before. I used Alexei's hsluv-haxe as a resource to learn and understand how to setup project structure and write the language syntax for Haxe. Since it's the go-to module for the Haxe community, I know it'll be a reliable resource. There will be similarity when you compare the two projects, but luckily the math for the hsluv and oklab/oklch will be _mostly_ different! The process required to convert sRGB to sRGB' and sRGB' to CIEXYZ is the same for both color spaces.

- [Alexei Boronine's hsluv-haxe (Github)](https://github.com/hsluv/hsluv-haxe/tree/main)

## Disclaimer

I am not an expert in color science or color theory, but I do appreciate it and I enjoy learning. I don't have everything fully grasp but hopefully I will soon.
