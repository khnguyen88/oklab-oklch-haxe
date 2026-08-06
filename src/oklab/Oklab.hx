package oklab;

class Oklab{
	// HEX
    public var hex:String;

    // RGB
	public var rgb_r:Int;
	public var rgb_g:Int;
	public var rgb_b:Int;

    // NORMALIZED RGB (W/ GAMMA)
	public var rgb_r_norm:Float;
	public var rgb_g_norm:Float;
	public var rgb_b_norm:Float;

    // LINEAR RGB (W/O GAMMA)
	public var rgb_r_lin:Float;
	public var rgb_g_lin:Float;
	public var rgb_b_lin:Float;

	// CIE XYZ (LINEAR)
	public var xyz_x:Float;
	public var xyz_y:Float;
	public var xyz_z:Float;

	// LMS (LINEAR)
	public var lms_l:Float;
	public var lms_m:Float;
	public var lms_s:Float;

	// LMS' (NON_LINEAR)
	public var lms_l_nl:Float;
	public var lms_m_nl:Float;
	public var lms_s_nl:Float;

    // OKLAB
	public var oklab_l:Float;
	public var oklab_lr: Float;
	public var oklab_a:Float;
	public var oklab_b:Float;

    // OKLCH
	public var oklch_l:Float;
	public var oklch_lr: Float;
	public var oklch_c:Float;
	public var oklch_h:Float;
	public var oklch_h_deg:Float;


	// TRACE OUTPUT
    // OKLAB
	public var trace_oklab_l:Float;
	public var trace_oklab_lr: Float;
	public var trace_oklab_a:Float;
	public var trace_oklab_b:Float;

    // OKLCH
	public var trace_oklch_l:Float;
	public var trace_oklch_lr: Float;
	public var trace_oklch_c:Float;
	public var trace_oklch_h:Float;
	public var trace_oklch_h_deg:Float;

	public function new() {
		this.hex="#FFFFFF";
		this.hexToOklab();
	}

    // Transformation Matrices
	// Transformation matrix, M1_M. For conversion from RGB' (Linear RGB) to OKLAB. Source Ottoson.
    private static var m1_m_r0:Float = 0.4122214708;
	private static var m1_m_r1:Float = 0.5363325363;
	private static var m1_m_r2:Float = 0.0514459929;

	private static var m1_m_g0:Float = 0.2119034982;
	private static var m1_m_g1:Float = 0.6806995451;
	private static var m1_m_g2:Float = 0.1073969566;

	private static var m1_m_b0:Float = 0.0883024619;
	private static var m1_m_b1:Float = 0.2817188376;
	private static var m1_m_b2:Float = 0.6299787005;

	// Transformation matrix, M. For conversion from RGB' (Linear RGB) to CIE-XYZ. Source: Calculated w/ Reshish's Calculator (higher precision), M = M1^-1 * M1_M
    private static var m_r0:Float = 0.4124372975761045;
	private static var m_r1:Float = 0.35762841310578364;
	private static var m_r2:Float = 0.18040430879205863;

	private static var m_g0:Float = 0.21263387354682864;
	private static var m_g1:Float = 0.7151556045685596;
	private static var m_g2:Float = 0.0722105343013342;

	private static var m_b0:Float = 0.019262606244585038;
	private static var m_b1:Float = 0.11898369968466631;
	private static var m_b2:Float = 0.9500536516299719;

    // Transformation matrix, M1. For conversion from CIE-XYZ to LMS. Source: Ottoson.
    private static var m1_x0:Float = 0.8189330101;
	private static var m1_x1:Float = 0.3618667424;
	private static var m1_x2:Float = -0.1288597137;

	private static var m1_y0:Float = 0.0329845436;
	private static var m1_y1:Float = 0.9293118715;
	private static var m1_y2:Float = 0.0361456387;

	private static var m1_z0:Float = 0.0482003018;
	private static var m1_z1:Float = 0.2643662691;
	private static var m1_z2:Float = 0.6338517070;

    // Transformation matrix, M2. For conversion from LMS' (Linear LMS) to OKLAB. Source: Ottoson.
    private static var m2_l0:Float = 0.2104542553;
	private static var m2_l1:Float = 0.7936177850;
	private static var m2_l2:Float = -0.0040720468;

	private static var m2_m0:Float = 1.9779984951;
	private static var m2_m1:Float = -2.4285922050;
	private static var m2_m2:Float = 0.4505937099;

	private static var m2_s0:Float = 0.0259040371;
	private static var m2_s1:Float = 0.7827717662;
	private static var m2_s2:Float = -0.8086757660;


    // Inverse Transformation Matrices
    // Transformation matrix, Inverse M2, M2^-1. For conversion from OKLAB to LMS' (Linear LMS). Source: Ottoson.
    private static var m2_inv_l0:Float = 1.0;
	private static var m2_inv_l1:Float = 0.3963377774;
	private static var m2_inv_l2:Float = 0.2158037573;

	private static var m2_inv_m0:Float = 1.0;
	private static var m2_inv_m1:Float = -0.1055613458;
	private static var m2_inv_m2:Float = -0.0638541728;

	private static var m2_inv_s0:Float = 1.0;
	private static var m2_inv_s1:Float = -0.0894841775;
	private static var m2_inv_s2:Float = -1.2914855480;

    // Transformation matrix, Inverse M1, M1^-1. For conversion from LMS to CIE-XYZ. Source: Calculated from M1 w/ Reshish's Calculator (higher precision).
    private static var m1_inv_x0:Float = 1.2270138511035211;
	private static var m1_inv_x1:Float = -0.5577999806518222;
	private static var m1_inv_x2:Float = 0.28125614896646783;

	private static var m1_inv_y0:Float = -0.04058017842328059;
	private static var m1_inv_y1:Float = 1.11225686961683;
	private static var m1_inv_y2:Float = -0.0716766786656012;

	private static var m1_inv_z0:Float = -0.07638128450570689;
	private static var m1_inv_z1:Float = -0.4214819784180127;
	private static var m1_inv_z2:Float = 1.5861632204407947;

    // Transformation matrix, Inverse M, M^-1. For conversion from CIE-XYZ to RGB' (Linear RGB). Source: Calculated from M1 w/ Reshish's Calculator (higher precision).
    private static var m_inv_r0:Float = 3.240607783229226;
	private static var m_inv_r1:Float = -1.537597765533626;
	private static var m_inv_r2:Float = -0.4984864277900457;

	private static var m_inv_g0:Float = -0.9691357939611848;
	private static var m_inv_g1:Float = 1.8760396703202629;
	private static var m_inv_g2:Float = 0.04143602416910443;

	private static var m_inv_b0:Float = 0.05566928820295223;
	private static var m_inv_b1:Float = -0.20377796567354506;
	private static var m_inv_b2:Float = 1.0574896845007096;

	//Parser Functions
	private static function parseHexByChannel(hex: String, channel: String = ''){
		var hexWithoutPound = hex;
		var hashIndex = hex.indexOf('#');
		if(hashIndex != -1){
			hexWithoutPound = hex.substring(hashIndex + 1);
		}
		if(hexWithoutPound.length != 6){
			return '';
		}

		switch(channel){
			case 'r', 'R', 'red', 'Red':
				return hexWithoutPound.substring(0, 2);
			case 'g', 'G', 'green', 'Green':
				return hexWithoutPound.substring(2, 4);
			case 'b', 'B', 'blue', 'Blue':			
				return hexWithoutPound.substring(4, 6);
			case _:
				return '';
		}
	}

	//Conversion Functions
	private static inline final HEX_CHAR = '0123456789ABCDEF';

	public function isStartingCharPound(s:String): Bool{
		if(s.length > 0 && s.charAt(0) == "#"){
			return true;
		}
		else{
			return false;
		}
	}

	public function isValidHexAfterHash(hex:String):Bool {
		for (i in 1 ... hex.length) {
			var c = hex.charAt(i);
			if (HEX_CHAR.indexOf(c) == -1) return false;
		}
		return true;
	}

	public function sanitizeHex(hex: String): String{
		var sanitizedHex: String = hex;
		if(!this.isStartingCharPound(hex)){
			sanitizedHex = "#" + hex;
		}

		if(!this.isValidHexAfterHash(sanitizedHex)){
			sanitizedHex = '#000000';
		}
		return sanitizedHex;
	}

	private static function rgbChannelToHex(channelVal: Int){
		var firstHexCharInd = Std.int(Math.floor(channelVal / 16));
		var secondHexCharInd = channelVal % 16;
		var hexVal = HEX_CHAR.charAt(firstHexCharInd) + HEX_CHAR.charAt(secondHexCharInd);
		return hexVal;
	}

	private static function hexToRGBChannel(hexVal: String){
		var firstHexChar = hexVal.charAt(0);
		var firstHexCharInd = HEX_CHAR.indexOf(firstHexChar); 
		var secondHexChar = hexVal.charAt(1);
		var secondHexCharInd = HEX_CHAR.indexOf(secondHexChar);
		var rgbChannelVal = firstHexCharInd * 16 + secondHexCharInd;
		return rgbChannelVal;
	}

	private static function rgbChannelToNormialized(channelVal: Int){
		return channelVal / 255.0;
	}

	private static function normalizedToRgbChannel(channelVal: Float){
		return Math.round(channelVal * 255.0);
	}

	private static function normalizedRgbChannelToLinear(normVal: Float){
		var linVal: Float;

		if(normVal <= 0.0405){
			linVal = normVal / 12.92;
		}
		else{
			linVal = Math.pow(((normVal + 0.055)/1.055), 2.4);
		}

		return linVal;
	}

	private static function linearRgbChannelToNormalized(linVal: Float){
		var normVal: Float;

		if(linVal <= 0.0031308){
			normVal = linVal * 12.92;
		}
		else{
			normVal = 1.055 * Math.pow(linVal, (1/2.4)) - 0.055;
		}
	
		return normVal;
	}

	private static function linearLmsConeToNonLinear(cone: Float){
		//Cubic root of negative X is equal to negative cubic root of X
		return cone < 0 ? -Math.pow(-cone, (1/3)) : Math.pow(cone, (1/3));
	}

	private static function nonLinearLmsConeToLinear(nonLinCone: Float){
		return nonLinCone * nonLinCone * nonLinCone;
	}

	private static function noWhiteRefOkLightToWhiteRefOkLight(l: Float){
		var k1: Float = 0.206;
		var k2: Float = 0.03;
		var k3: Float = (1 + k1) / (1 + k2);
		var eqSegment1: Float = k3 * l - k1;
		var eqSegment2a: Float = Math.pow((k3 * l) - k1, 2);
		var eqSegment2b: Float = 4 * k2 * k3 * l;
		var eqSegment2: Float = Math.sqrt (eqSegment2a + eqSegment2b);
		var lr = (eqSegment1 + eqSegment2) / 2;
		return lr;
	}

	private static function whiteRefOkLightToNoWhiteRefOkLight(lr: Float){
		var k1: Float = 0.206;
		var k2: Float = 0.03;
		var k3: Float = (1 + k1) / (1 + k2);
		var eqSegment1: Float = lr * (lr + k1);
		var eqSegment2: Float = k3 * (lr + k2);
		var l = eqSegment1 / eqSegment2;
		return l;
	}

	private function inGamut(r_lin: Float, g_lin: Float, b_lin: Float){
		return (r_lin >= 0 && r_lin <= 1 && g_lin >= 0 && g_lin <=1 && b_lin >= 0 && b_lin <= 1);
	}

	private function boundChromaToRgbGamutRecursive(l: Float, h: Float, c_low: Float = 0.0, c_high: Float = 0.0, recDepth: Int = 20): Float{
		this.oklch_l = l; this.oklch_h = h; this.oklch_c = c_high;
		this.oklchToLinearRGB();
		if (this.inGamut(this.rgb_r_lin, this.rgb_g_lin, this.rgb_b_lin)){
			return c_high;
		} 

		if (recDepth <= 0 || (c_high - c_low) < 1e-4){
			return c_low;
		}

		var c_mid = (c_low + c_high) * 0.5;
		this.oklch_l = l;
		this.oklch_h = h;
		this.oklch_c = c_mid;
		this.oklchToLinearRGB();

		if(this.inGamut(rgb_r_lin, rgb_g_lin, rgb_b_lin)){
			return this.boundChromaToRgbGamutRecursive(l, h, c_mid, c_high, recDepth - 1);
		}
		else{
			return this.boundChromaToRgbGamutRecursive(l, h, c_low, c_mid, recDepth - 1);
		}
	}

	private function hexToRgb(){
		this.rgb_r = hexToRGBChannel(parseHexByChannel(this.hex, 'r'));
		this.rgb_g = hexToRGBChannel(parseHexByChannel(this.hex, 'g'));
		this.rgb_b = hexToRGBChannel(parseHexByChannel(this.hex, 'b'));
	}
	private function rgbToHex(){
		this.hex = "#";
		this.hex += rgbChannelToHex(this.rgb_r);
		this.hex += rgbChannelToHex(this.rgb_g);
		this.hex += rgbChannelToHex(this.rgb_b);
	}

	private function rgbToNormalized(){
		this.rgb_r_norm = rgbChannelToNormialized(this.rgb_r);
		this.rgb_g_norm = rgbChannelToNormialized(this.rgb_g);
		this.rgb_b_norm = rgbChannelToNormialized(this.rgb_b);
	}
	
	private function normalizedToRgb(){
		this.rgb_r = normalizedToRgbChannel(this.rgb_r_norm);
		this.rgb_g = normalizedToRgbChannel(this.rgb_g_norm);
		this.rgb_b = normalizedToRgbChannel(this.rgb_b_norm);
	}

	private function normalizedRgbToLinear(){
		this.rgb_r_lin = normalizedRgbChannelToLinear(this.rgb_r_norm);
		this.rgb_g_lin = normalizedRgbChannelToLinear(this.rgb_g_norm);
		this.rgb_b_lin = normalizedRgbChannelToLinear(this.rgb_b_norm);
	}

	public function linearRgbToNormalized(){		
		this.rgb_r_norm = linearRgbChannelToNormalized(this.rgb_r_lin);
		this.rgb_g_norm = linearRgbChannelToNormalized(this.rgb_g_lin);
		this.rgb_b_norm = linearRgbChannelToNormalized(this.rgb_b_lin);
	}

	private function linearRgbToXyz(){
		this.xyz_x = m_r0 * this.rgb_r_lin + m_r1 * this.rgb_g_lin + m_r2 * this.rgb_b_lin;
		this.xyz_y = m_g0 * this.rgb_r_lin + m_g1 * this.rgb_g_lin + m_g2 * this.rgb_b_lin;
		this.xyz_z = m_b0 * this.rgb_r_lin + m_b1 * this.rgb_g_lin + m_b2 * this.rgb_b_lin;
	}

	private function xyzToLinearRgb(){
		this.rgb_r_lin = m_inv_r0 * this.xyz_x + m_inv_r1 * this.xyz_y + m_inv_r2 * this.xyz_z;
		this.rgb_g_lin = m_inv_g0 * this.xyz_x + m_inv_g1 * this.xyz_y + m_inv_g2 * this.xyz_z;
		this.rgb_b_lin = m_inv_b0 * this.xyz_x + m_inv_b1 * this.xyz_y + m_inv_b2 * this.xyz_z;
	}

	private function xyzToLms(){
		this.lms_l = m1_x0 * this.xyz_x + m1_x1 * this.xyz_y + m1_x2 * this.xyz_z;
		this.lms_m = m1_y0 * this.xyz_x + m1_y1 * this.xyz_y + m1_y2 * this.xyz_z;
		this.lms_s = m1_z0 * this.xyz_x + m1_z1 * this.xyz_y + m1_z2 * this.xyz_z;
	}

	public function xyzToOklab(){
		this.xyzToLms();
		this.lmsToNonLinearLms();
		this.nonLinearLmsToOklab();
		this.oklabToOklch();
	}

	private function lmsToXyz(){
		this.xyz_x = m1_inv_x0 * this.lms_l + m1_inv_x1 * this.lms_m + m1_inv_x2 * this.lms_s;
		this.xyz_y = m1_inv_y0 * this.lms_l + m1_inv_y1 * this.lms_m + m1_inv_y2 * this.lms_s;
		this.xyz_z = m1_inv_z0 * this.lms_l + m1_inv_z1 * this.lms_m + m1_inv_z2 * this.lms_s;
	}

	private function lmsToNonLinearLms(){
		this.lms_l_nl = linearLmsConeToNonLinear(this.lms_l);
		this.lms_m_nl = linearLmsConeToNonLinear(this.lms_m);
		this.lms_s_nl = linearLmsConeToNonLinear(this.lms_s);
	}

	private function nonLinearLmsToLms(){
		this.lms_l = nonLinearLmsConeToLinear(this.lms_l_nl);
		this.lms_m = nonLinearLmsConeToLinear(this.lms_m_nl);
		this.lms_s = nonLinearLmsConeToLinear(this.lms_s_nl);
	}

	private function nonLinearLmsToOklab(){
		this.oklab_l = m2_l0 * this.lms_l_nl + m2_l1 * this.lms_m_nl + m2_l2 * this.lms_s_nl;
		this.oklab_lr = noWhiteRefOkLightToWhiteRefOkLight(this.oklab_l);
		this.oklab_a = m2_m0 * this.lms_l_nl + m2_m1 * this.lms_m_nl + m2_m2 * this.lms_s_nl;
		this.oklab_b = m2_s0 * this.lms_l_nl + m2_s1 * this.lms_m_nl + m2_s2 * this.lms_s_nl;
	}

	private function oklabToNonLinearLms(){
		this.lms_l_nl = m2_inv_l0 * this.oklab_l + m2_inv_l1 * this.oklab_a + m2_inv_l2 * this.oklab_b;
		this.lms_m_nl = m2_inv_m0 * this.oklab_l + m2_inv_m1 * this.oklab_a + m2_inv_m2 * this.oklab_b;
		this.lms_s_nl = m2_inv_s0 * this.oklab_l + m2_inv_s1 * this.oklab_a + m2_inv_s2 * this.oklab_b;
	}

	private function oklabToOklch(){
		this.oklch_l = this.oklab_l;
		this.oklch_lr = this.oklab_lr;
		this.oklch_c = Math.sqrt(Math.pow(this.oklab_a, 2) + Math.pow(this.oklab_b, 2));
		this.oklch_h = Math.atan2(this.oklab_b, this.oklab_a);
		this.oklch_h_deg = this.oklch_h * (180 / Math.PI);
	}

	private function oklchToOklab(){
		this.oklab_l = this.oklch_l;
		this.oklab_lr = this.oklch_lr;
		this.oklch_h = this.oklch_h_deg * Math.PI / 180;
		this.oklab_a = this.oklch_c * Math.cos(this.oklch_h);
		this.oklab_b = this.oklch_c * Math.sin(this.oklch_h);
	}


	public function hexToOklab(){
		this.hexToOklch();
	}

	public function hexToOklch(){
		this.hexToRgb();
		this.rgbToOklch();
	}

	public function rgbToOklab(){
		this.rgbToOklch();
	}

	public function rgbToOklch(){
		this.rgbToHex();
		this.rgbToNormalized();
		this.normalizedRgbToLinear();
		this.linearRgbToXyz();
		this.xyzToLms();
		this.lmsToNonLinearLms();
		this.nonLinearLmsToOklab();
		this.oklabToOklch();
	}

	public function oklchToRgb(){
		this.oklchToHex();
	}

	public function oklchToHex(){
		this.oklchToOklab();
		this.oklabToHex();
	}

	public function oklabToRgb(){
		this.oklabToHex();
	}

	public function oklabToHex(){
		this.oklabToOklch();

		this.oklabToNonLinearLms();
		this.nonLinearLmsToLms();
		this.lmsToXyz();
		this.xyzToLinearRgb();
		this.linearRgbToNormalized();
		this.normalizedToRgb();
		this.rgbToHex();
	}


	public function oklchToLinearRGB(){
		this.oklchToOklab();
		this.oklabToNonLinearLms();
		this.nonLinearLmsToLms();
		this.lmsToXyz();
		this.xyzToLinearRgb();
	}

	public function oklabToLinearRgb(){
		this.oklabToOklch();
		this.oklchToLinearRGB();
	}

	public function roundToDecimal(val: Float, decimalPlaces: Int = 3): Float{
		var factOfTen = Math.pow(10, decimalPlaces);
		return Math.round(val * factOfTen) / factOfTen;
	}

	public function update_trace_var(){

		this.trace_oklab_l = roundToDecimal(this.oklab_l);
		this.trace_oklab_lr = roundToDecimal(this.oklab_lr);
		this.trace_oklab_a = roundToDecimal(this.oklab_a);
		this.trace_oklab_b = roundToDecimal(this.oklab_b);

		this.trace_oklch_l = roundToDecimal(this.oklch_l);
		this.trace_oklch_lr = roundToDecimal(this.oklch_lr);
		this.trace_oklch_c = roundToDecimal(this.oklch_c);
		this.trace_oklch_h = roundToDecimal(this.oklch_h);
		this.trace_oklch_h_deg = roundToDecimal(this.oklch_h_deg);
	}

	public function setRgb(r: Int = 0, g: Int = 0, b: Int = 0){
		this.rgb_r = r;
		this.rgb_g = g;
		this.rgb_b = b;
		this.rgbToOklab();
		this.update_trace_var();
		trace('[setRgb] rgb=(${this.rgb_r},${this.rgb_g},${this.rgb_b}) hex=${this.hex}');
		trace('[setRgb] oklab=(${this.trace_oklab_l}, ${this.trace_oklab_a}, ${this.trace_oklab_b}) oklch=(${this.trace_oklch_l}, ${this.trace_oklch_c}, ${this.trace_oklch_h_deg})');
	};


	public function setHex(hex: String = "#000000"){
		this.hex = this.sanitizeHex(hex);
		this.hexToOklab();
		this.update_trace_var();
		trace('[setHex] hex=${this.hex} rgb=(${this.rgb_r},${this.rgb_g},${this.rgb_b})');
		trace('[setHex] oklab=(${this.trace_oklab_l}, ${this.trace_oklab_a}, ${this.trace_oklab_b}) oklch=(${this.trace_oklch_l}, ${this.trace_oklch_c}, ${this.trace_oklch_h_deg}})');
	};

	public function setOklch(l: Float = 1.000, c: Float = 0.000, h: Float = 0.000){
		this.oklch_l = l;
		this.oklch_lr = noWhiteRefOkLightToWhiteRefOkLight(l);
		this.oklch_c = c;
		this.oklch_h_deg = h;
		this.oklchToOklab();
		this.update_trace_var();
		trace('[setOklch] oklch=(${this.trace_oklch_l}, ${this.trace_oklch_c}, ${this.trace_oklch_h_deg}) oklab=(${this.trace_oklab_l}, ${this.trace_oklab_a}, ${this.trace_oklab_b})');
		this.oklch_c = this.boundChromaToRgbGamutRecursive(this.oklch_l, this.oklch_h, 0, c, 20);
		this.oklchToHex();
		trace('[setOklch] hex=${this.hex} rgb=(${this.rgb_r},${this.rgb_g},${this.rgb_b})');
	};

	public function setOklab(l: Float = 1.000, a: Float = 0.000, b: Float = 0.000){
		this.oklab_l = l;
		this.oklab_lr = noWhiteRefOkLightToWhiteRefOkLight(this.oklab_l);
		this.oklab_a = a;
		this.oklab_b = b;
		this.oklabToOklch();
		this.update_trace_var();
		trace('[setOklab] oklab=(${this.trace_oklab_l}, ${this.trace_oklab_a}, ${this.trace_oklab_b}) oklch=(${this.trace_oklch_l}, ${this.trace_oklch_c}, ${this.trace_oklch_h_deg})');
		this.oklch_c = this.boundChromaToRgbGamutRecursive(this.oklch_l, this.oklch_h, 0, this.oklch_c, 20);
		this.oklchToHex();
		trace('[setOklab] hex=${this.hex} rgb=(${this.rgb_r},${this.rgb_g},${this.rgb_b})');
	}

public function setOkLrch(lr: Float = 1.000, c: Float = 0.000, h: Float = 0.000){
		this.oklch_l = whiteRefOkLightToNoWhiteRefOkLight(lr);
		this.oklch_lr = lr;
		this.oklch_c = c;
		this.oklch_h_deg = h;
		this.oklchToOklab();
		this.update_trace_var();
		trace('[setOklch] oklch=(${this.trace_oklch_l}, ${this.trace_oklch_c}, ${this.trace_oklch_h_deg}) oklab=(${this.trace_oklab_l}, ${this.trace_oklab_a}, ${this.trace_oklab_b})');
		this.oklch_c = this.boundChromaToRgbGamutRecursive(this.oklch_l, this.oklch_h, 0, c, 20);
		this.oklchToHex();
		trace('[setOklch] hex=${this.hex} rgb=(${this.rgb_r},${this.rgb_g},${this.rgb_b})');
	};

	public function setOkLrab(lr: Float = 1.000, a: Float = 0.000, b: Float = 0.000){
		this.oklab_l = whiteRefOkLightToNoWhiteRefOkLight(lr);
		this.oklab_lr = lr;
		this.oklab_a = a;
		this.oklab_b = b;
		this.oklabToOklch();
		this.update_trace_var();
		trace('[setOklab] oklab=(${this.trace_oklab_l}, ${this.trace_oklab_a}, ${this.trace_oklab_b}) oklch=(${this.trace_oklch_l}, ${this.trace_oklch_c}, ${this.trace_oklch_h_deg})');
		this.oklch_c = this.boundChromaToRgbGamutRecursive(this.oklch_l, this.oklch_h, 0, this.oklch_c, 20);
		this.oklchToHex();
		trace('[setOklab] hex=${this.hex} rgb=(${this.rgb_r},${this.rgb_g},${this.rgb_b})');
	}

}