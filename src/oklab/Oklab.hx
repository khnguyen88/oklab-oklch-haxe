package oklab;

class Oklab{
	// HEX
    public var hex:String;

    // RGB
	public var rgb_r:Float;
	public var rgb_g:Float;
	public var rgb_b:Float;

    // LINEAR RGB
	public var rgb_r_:Float;
	public var rgb_g_:Float;
	public var rgb_b_:Float;

	// CIE XYZ
	public var xyz_x:Float;
	public var xyz_y:Float;
	public var xyz_z:Float;

	// LMS
	public var lms_l:Float;
	public var lms_m:Float;
	public var lms_s:Float;

    // OKLAB
	private var oklab_l:Float;
	public var oklab_lr: Float;
	public var oklab_a:Float;
	public var oklab_b:Float;

    // OKLCH
	private var oklch_l:Float;
	public var oklch_lr: Float;
	public var oklch_a:Float;
	public var oklch_b:Float;

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

	private static var m_inv_b0:Float = 0.04143602416910443;
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

	private static function rgbChannelToLinear(channelVal: Int){
		return channelVal / 255.0;
	}

	private static function linearToRGBChannel(channelVal: Float){
		return Math.round(channelVal * 255.0);
	}
}