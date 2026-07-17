// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "TV_Screen_Effect"
{
	Properties
	{
		_BodyTex("_BodyTex", 2D) = "white" {}
		_ScreenTex("_ScreenTex", 2D) = "white" {}
		_NoiseAmount("_NoiseAmount", Float) = 0.15
		_Flicker("Flicker", Float) = 0.05
		_ScanlineCount("_ScanlineCount  ", Float) = 120
		_ScanlineStrength("_ScanlineStrength ", Float) = 0.25
		_CurveAmount("_CurveAmount  ", Float) = 0.15
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Opaque"  "Queue" = "Geometry+0" "IsEmissive" = "true"  }
		Cull Back
		CGPROGRAM
		#include "UnityShaderVariables.cginc"
		#pragma target 3.0
		#pragma surface surf Standard keepalpha addshadow fullforwardshadows 
		struct Input
		{
			float2 uv_texcoord;
		};

		uniform sampler2D _BodyTex;
		uniform float4 _BodyTex_ST;
		uniform sampler2D _ScreenTex;
		uniform float4 _ScreenTex_ST;
		uniform float _NoiseAmount;
		uniform float _Flicker;
		uniform float _CurveAmount;
		uniform float _ScanlineCount;
		uniform float _ScanlineStrength;


		float3 mod2D289( float3 x ) { return x - floor( x * ( 1.0 / 289.0 ) ) * 289.0; }

		float2 mod2D289( float2 x ) { return x - floor( x * ( 1.0 / 289.0 ) ) * 289.0; }

		float3 permute( float3 x ) { return mod2D289( ( ( x * 34.0 ) + 1.0 ) * x ); }

		float snoise( float2 v )
		{
			const float4 C = float4( 0.211324865405187, 0.366025403784439, -0.577350269189626, 0.024390243902439 );
			float2 i = floor( v + dot( v, C.yy ) );
			float2 x0 = v - i + dot( i, C.xx );
			float2 i1;
			i1 = ( x0.x > x0.y ) ? float2( 1.0, 0.0 ) : float2( 0.0, 1.0 );
			float4 x12 = x0.xyxy + C.xxzz;
			x12.xy -= i1;
			i = mod2D289( i );
			float3 p = permute( permute( i.y + float3( 0.0, i1.y, 1.0 ) ) + i.x + float3( 0.0, i1.x, 1.0 ) );
			float3 m = max( 0.5 - float3( dot( x0, x0 ), dot( x12.xy, x12.xy ), dot( x12.zw, x12.zw ) ), 0.0 );
			m = m * m;
			m = m * m;
			float3 x = 2.0 * frac( p * C.www ) - 1.0;
			float3 h = abs( x ) - 0.5;
			float3 ox = floor( x + 0.5 );
			float3 a0 = x - ox;
			m *= 1.79284291400159 - 0.85373472095314 * ( a0 * a0 + h * h );
			float3 g;
			g.x = a0.x * x0.x + h.x * x0.y;
			g.yz = a0.yz * x12.xz + h.yz * x12.yw;
			return 130.0 * dot( m, g );
		}


		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float2 uv_BodyTex = i.uv_texcoord * _BodyTex_ST.xy + _BodyTex_ST.zw;
			float2 uv_ScreenTex = i.uv_texcoord * _ScreenTex_ST.xy + _ScreenTex_ST.zw;
			float4 tex2DNode2 = tex2D( _ScreenTex, uv_ScreenTex );
			float dotResult21 = dot( tex2DNode2 , float4( float3(0.3,0.59,0.11) , 0.0 ) );
			float simplePerlin2D25 = snoise( ( ( i.uv_texcoord * 500.0 ) + _Time.y ) );
			simplePerlin2D25 = simplePerlin2D25*0.5 + 0.5;
			float2 break19_g12 = float2( -0.5,0.5 );
			float temp_output_1_0_g12 = ( _Time.y * 20.0 );
			float sinIn7_g12 = sin( temp_output_1_0_g12 );
			float sinInOffset6_g12 = sin( ( temp_output_1_0_g12 + 1.0 ) );
			float lerpResult20_g12 = lerp( break19_g12.x , break19_g12.y , frac( ( sin( ( ( sinIn7_g12 - sinInOffset6_g12 ) * 91.2228 ) ) * 43758.55 ) ));
			float4 temp_cast_1 = (( ( dotResult21 + ( ( simplePerlin2D25 - 0.5 ) * _NoiseAmount ) ) * ( 1.0 - ( ( lerpResult20_g12 + sinIn7_g12 ) * _Flicker ) ) )).xxxx;
			float temp_output_41_0 = (i.uv_texcoord).x;
			float temp_output_42_0 = (i.uv_texcoord).y;
			float temp_output_49_0 = ( ( step( 0.03 , temp_output_41_0 ) * step( temp_output_41_0 , 0.34 ) ) * ( step( 0.72 , temp_output_42_0 ) * step( temp_output_42_0 , 1.0 ) ) );
			float4 lerpResult134 = lerp( tex2D( _BodyTex, uv_BodyTex ) , temp_cast_1 , temp_output_49_0);
			float2 break19_g13 = float2( -0.5,0.5 );
			float2 temp_output_92_0 = ( i.uv_texcoord - float2( 0.5,0.5 ) );
			float temp_output_93_0 = (temp_output_92_0).x;
			float temp_output_94_0 = (temp_output_92_0).y;
			float temp_output_98_0 = ( ( ( temp_output_93_0 * temp_output_93_0 ) + ( temp_output_94_0 * temp_output_94_0 ) ) * _CurveAmount );
			float2 appendResult101 = (float2(( temp_output_93_0 + temp_output_98_0 ) , ( temp_output_98_0 + temp_output_94_0 )));
			float2 temp_output_102_0 = ( appendResult101 + float2( 0.5,0.5 ) );
			float temp_output_1_0_g13 = ( (temp_output_102_0).y * _ScanlineCount );
			float sinIn7_g13 = sin( temp_output_1_0_g13 );
			float sinInOffset6_g13 = sin( ( temp_output_1_0_g13 + 1.0 ) );
			float lerpResult20_g13 = lerp( break19_g13.x , break19_g13.y , frac( ( sin( ( ( sinIn7_g13 - sinInOffset6_g13 ) * 91.2228 ) ) * 43758.55 ) ));
			float lerpResult121 = lerp( 1.0 , ( ( ( lerpResult20_g13 + sinIn7_g13 ) * 0.5 ) + 0.5 ) , _ScanlineStrength);
			float2 temp_cast_2 = (0.006).xx;
			float4 appendResult110 = (float4(tex2DNode2.r , tex2DNode2.g , (( temp_output_102_0 - temp_cast_2 ))));
			float temp_output_73_0 = (i.uv_texcoord).x;
			float temp_output_67_0 = (i.uv_texcoord).y;
			float temp_output_79_0 = ( ( step( 0.16 , temp_output_73_0 ) * step( temp_output_73_0 , 0.3864706 ) ) * ( step( 0.2223529 , temp_output_67_0 ) * step( temp_output_67_0 , 0.3639491 ) ) );
			float4 lerpResult82 = lerp( lerpResult134 , ( lerpResult121 * appendResult110 ) , temp_output_79_0);
			o.Albedo = lerpResult82.rgb;
			o.Emission = ( lerpResult82 * ( temp_output_49_0 + temp_output_79_0 ) ).rgb;
			o.Alpha = 1;
		}

		ENDCG
	}
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=18900
171.2;113.6;984.8;532.6;1130.134;-1842.895;2.835236;True;False
Node;AmplifyShaderEditor.CommentaryNode;103;-2882.573,1987.396;Inherit;False;1340.104;309.7947;Curvatura;13;98;97;100;99;101;102;85;96;95;93;94;92;91;;1,1,1,1;0;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;91;-2832.573,2084.183;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleSubtractOpNode;92;-2631.289,2085.887;Inherit;False;2;0;FLOAT2;0,0;False;1;FLOAT2;0.5,0.5;False;1;FLOAT2;0
Node;AmplifyShaderEditor.ComponentMaskNode;94;-2510.599,2129.913;Inherit;False;False;True;True;True;1;0;FLOAT2;0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ComponentMaskNode;93;-2510.574,2057.835;Inherit;False;True;False;True;True;1;0;FLOAT2;0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;96;-2331.807,2139.913;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;95;-2330.807,2045.913;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;85;-2213.167,2181.191;Inherit;False;Property;_CurveAmount;_CurveAmount  ;7;0;Create;True;0;0;0;False;0;False;0.15;0.15;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;97;-2178.647,2081.497;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;98;-2058.121,2091.62;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;104;-508.9103,2994.189;Inherit;False;1442.966;918.3984;GrayScale;5;38;39;36;35;105;;1,1,1,1;0;0
Node;AmplifyShaderEditor.SimpleAddOpNode;99;-1934.202,2037.396;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;100;-1937.021,2134.386;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;38;-451.3611,3359.69;Inherit;False;979.3526;282.0205;Ruido;9;17;15;14;27;13;25;26;28;8;;1,1,1,1;0;0
Node;AmplifyShaderEditor.RangedFloatNode;27;-357.179,3522.989;Inherit;False;Constant;_Float0;Float 0;2;0;Create;True;0;0;0;False;0;False;500;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;101;-1823.847,2078.723;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;14;-401.3611,3409.69;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleAddOpNode;102;-1694.47,2088.875;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0.5,0.5;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;15;-185.5358,3416.874;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.CommentaryNode;122;-2620.896,2434.046;Inherit;False;944.2539;312.5066;ScanLines;8;119;120;86;115;116;117;87;121;;1,1,1,1;0;0
Node;AmplifyShaderEditor.SimpleTimeNode;13;-199.3549,3530.711;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;39;54.43958,3652.454;Inherit;False;639.1426;258.6241;Titileo;5;33;32;34;31;9;;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;64;-615.3804,1664.492;Inherit;False;1023.288;559.7637;Mascara1;14;40;42;4;5;46;45;48;41;3;6;44;43;47;49;;1,1,1,1;0;0
Node;AmplifyShaderEditor.ComponentMaskNode;115;-2570.896,2484.046;Inherit;False;False;True;True;True;1;0;FLOAT2;0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;17;-68.65588,3415.486;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;86;-2569.47,2573.49;Inherit;False;Property;_ScanlineCount;_ScanlineCount  ;5;0;Create;True;0;0;0;False;0;False;120;120;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.NoiseGeneratorNode;25;54.26276,3410.372;Inherit;False;Simplex2D;True;False;2;0;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;116;-2394.051,2510.47;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;31;104.4396,3702.454;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;20;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;118;-1623.733,2363.388;Inherit;False;780.6312;256.6877;Aberracion cromatica;6;107;88;108;110;114;106;;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;65;-615.0786,2346.792;Inherit;False;1023.288;559.7637;Mascara2;14;79;78;77;76;74;73;72;71;70;69;68;67;80;84;;1,1,1,1;0;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;40;-565.3804,1886.603;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.CommentaryNode;105;-322.1298,3028.423;Inherit;False;678.3602;310.0527;Blanco y negro;3;21;2;23;;1,1,1,1;0;0
Node;AmplifyShaderEditor.RangedFloatNode;9;181.4247,3795.078;Inherit;False;Property;_Flicker;Flicker;3;0;Create;True;0;0;0;False;0;False;0.05;0.05;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;108;-1388.046,2504.076;Inherit;False;Constant;_Float1;Float 1;2;0;Create;True;0;0;0;False;0;False;0.006;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;5;-319.6806,1974.952;Float;False;Constant;_MinY1;MinY1;2;0;Create;True;0;0;0;False;0;False;0.72;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;84;-583.4182,2510.533;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.FunctionNode;117;-2281.051,2512.47;Inherit;False;Noise Sine Wave;-1;;13;a6eff29f739ced848846e3b648af87bd;0;2;1;FLOAT;0;False;2;FLOAT2;-0.5,0.5;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;6;-336.5331,1714.492;Inherit;False;Constant;_MinX1;MinX1;2;0;Create;True;0;0;0;False;0;False;0.03;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.ComponentMaskNode;41;-335.1639,1784.049;Inherit;False;True;False;True;True;1;0;FLOAT2;0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;8;187.2988,3514.526;Inherit;False;Property;_NoiseAmount;_NoiseAmount;2;0;Create;True;0;0;0;False;0;False;0.15;0.15;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.Vector3Node;23;11.22986,3150.476;Inherit;False;Constant;_Vector0;Vector 0;2;0;Create;True;0;0;0;False;0;False;0.3,0.59,0.11;0,0,0;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.RangedFloatNode;4;-317.0078,2108.255;Inherit;False;Constant;_MaxY1;MaxY1;2;0;Create;True;0;0;0;False;0;False;1;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.ComponentMaskNode;42;-319.5608,2041.141;Inherit;False;False;True;True;True;1;0;FLOAT2;0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;3;-331.6249,1857.703;Inherit;False;Constant;_MaxX1;MaxX1;2;0;Create;True;0;0;0;False;0;False;0.34;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;26;231.651,3411.372;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0.5;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;2;-272.1298,3078.423;Inherit;True;Property;_ScreenTex;_ScreenTex;1;0;Create;True;0;0;0;False;0;False;-1;28b346f0ac0872242ad3ef291a71bdf4;28b346f0ac0872242ad3ef291a71bdf4;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.FunctionNode;32;227.4125,3705.211;Inherit;False;Noise Sine Wave;-1;;12;a6eff29f739ced848846e3b648af87bd;0;2;1;FLOAT;0;False;2;FLOAT2;-0.5,0.5;False;1;FLOAT;0
Node;AmplifyShaderEditor.StepOpNode;44;-56.23383,1813.399;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ComponentMaskNode;73;-334.8622,2466.349;Inherit;False;True;False;True;True;1;0;FLOAT2;0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.DotProductOpNode;21;204.2305,3089.476;Inherit;False;2;0;COLOR;0,0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.StepOpNode;43;-53.18481,1724.434;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.StepOpNode;46;-11.8363,2061.234;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;28;365.9916,3412.432;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;36;439.1393,3101.071;Inherit;False;202;185;imagen con ruido;1;29;;1,1,1,1;0;0
Node;AmplifyShaderEditor.RangedFloatNode;74;-331.3232,2540.003;Inherit;False;Constant;_Float10;Float 10;2;0;Create;True;0;0;0;False;0;False;0.3864706;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;69;-319.3789,2657.252;Float;False;Constant;_Float9;Float 9;2;0;Create;True;0;0;0;False;0;False;0.2223529;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;119;-2099.106,2511.813;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0.5;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;33;398.1273,3707.474;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;107;-1355.069,2416.75;Inherit;False;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;68;-316.706,2790.555;Inherit;False;Constant;_Float8;Float 8;2;0;Create;True;0;0;0;False;0;False;0.3639491;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.StepOpNode;45;-8.729368,1966.889;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;80;-338.0179,2387.03;Inherit;False;Constant;_Float7;Float 7;2;0;Create;True;0;0;0;False;0;False;0.16;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.ComponentMaskNode;67;-319.2591,2723.441;Inherit;False;False;True;True;True;1;0;FLOAT2;0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;87;-2036.975,2630.552;Inherit;False;Property;_ScanlineStrength;_ScanlineStrength ;6;0;Create;True;0;0;0;False;0;False;0.25;0.25;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;48;129.698,1996.355;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.StepOpNode;71;-8.427366,2649.189;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.StepOpNode;76;-55.93182,2495.699;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;47;81.05433,1752.695;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;34;514.5825,3720.795;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;120;-1979.107,2512.813;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0.5;False;1;FLOAT;0
Node;AmplifyShaderEditor.StepOpNode;77;-52.88287,2406.734;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.StepOpNode;70;-11.5343,2743.534;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;29;489.1393,3151.071;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ComponentMaskNode;114;-1186.886,2415.539;Inherit;False;False;False;True;False;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.DynamicAppendNode;110;-1005.102,2417.153;Inherit;False;COLOR;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT2;0,0;False;3;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;35;772.0558,3144.077;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;121;-1858.642,2493.312;Inherit;False;3;0;FLOAT;1;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;1;876.2131,2099.675;Inherit;True;Property;_BodyTex;_BodyTex;0;0;Create;True;0;0;0;False;0;False;-1;7051c15489f463d47b35213b0c0fcabc;7051c15489f463d47b35213b0c0fcabc;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;78;81.35639,2434.995;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;72;130.0001,2678.655;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;49;245.9072,1807.317;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;132;-1252.342,2082.422;Inherit;False;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.LerpOp;134;1006.695,2428.207;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;79;246.2092,2489.617;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;135;804.3445,2585.533;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;82;1271.771,2161.858;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;88;-1573.733,2503.335;Inherit;False;Property;_ChromaAmount;_ChromaAmount;4;0;Create;True;0;0;0;False;0;False;0.006;0.006;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;131;-1148.087,2923.126;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.FunctionNode;126;-1943.066,2949.234;Inherit;False;Noise Sine Wave;-1;;14;a6eff29f739ced848846e3b648af87bd;0;2;1;FLOAT;0;False;2;FLOAT2;-0.5,0.5;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;89;-1932.827,3039.887;Inherit;False;Constant;_ShakeAmount;_ShakeAmount ;2;0;Create;True;0;0;0;False;0;False;0.004;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;128;-1592.622,2930.239;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleTimeNode;124;-2218.065,2942.234;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;106;-1522.341,2413.388;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;90;-2216.195,3008.672;Inherit;False;Constant;_ShakeSpeed;_ShakeSpeed;2;0;Create;True;0;0;0;False;0;False;10;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;83;1340.272,2372.549;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.ComponentMaskNode;130;-1341.782,2901.834;Inherit;False;False;True;True;True;1;0;FLOAT2;0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;127;-1762.066,2948.234;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;125;-2063.065,2952.234;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;1527.486,2176.865;Float;False;True;-1;2;ASEMaterialInspector;0;0;Standard;TV_Screen_Effect;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Opaque;0.5;True;True;0;False;Opaque;;Geometry;All;14;all;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;True;0;0;False;-1;0;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;False;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;92;0;91;0
WireConnection;94;0;92;0
WireConnection;93;0;92;0
WireConnection;96;0;94;0
WireConnection;96;1;94;0
WireConnection;95;0;93;0
WireConnection;95;1;93;0
WireConnection;97;0;95;0
WireConnection;97;1;96;0
WireConnection;98;0;97;0
WireConnection;98;1;85;0
WireConnection;99;0;93;0
WireConnection;99;1;98;0
WireConnection;100;0;98;0
WireConnection;100;1;94;0
WireConnection;101;0;99;0
WireConnection;101;1;100;0
WireConnection;102;0;101;0
WireConnection;15;0;14;0
WireConnection;15;1;27;0
WireConnection;115;0;102;0
WireConnection;17;0;15;0
WireConnection;17;1;13;0
WireConnection;25;0;17;0
WireConnection;116;0;115;0
WireConnection;116;1;86;0
WireConnection;31;0;13;0
WireConnection;117;1;116;0
WireConnection;41;0;40;0
WireConnection;42;0;40;0
WireConnection;26;0;25;0
WireConnection;32;1;31;0
WireConnection;44;0;41;0
WireConnection;44;1;3;0
WireConnection;73;0;84;0
WireConnection;21;0;2;0
WireConnection;21;1;23;0
WireConnection;43;0;6;0
WireConnection;43;1;41;0
WireConnection;46;0;42;0
WireConnection;46;1;4;0
WireConnection;28;0;26;0
WireConnection;28;1;8;0
WireConnection;119;0;117;0
WireConnection;33;0;32;0
WireConnection;33;1;9;0
WireConnection;107;0;102;0
WireConnection;107;1;108;0
WireConnection;45;0;5;0
WireConnection;45;1;42;0
WireConnection;67;0;84;0
WireConnection;48;0;45;0
WireConnection;48;1;46;0
WireConnection;71;0;69;0
WireConnection;71;1;67;0
WireConnection;76;0;73;0
WireConnection;76;1;74;0
WireConnection;47;0;43;0
WireConnection;47;1;44;0
WireConnection;34;0;33;0
WireConnection;120;0;119;0
WireConnection;77;0;80;0
WireConnection;77;1;73;0
WireConnection;70;0;67;0
WireConnection;70;1;68;0
WireConnection;29;0;21;0
WireConnection;29;1;28;0
WireConnection;114;0;107;0
WireConnection;110;0;2;1
WireConnection;110;1;2;2
WireConnection;110;2;114;0
WireConnection;35;0;29;0
WireConnection;35;1;34;0
WireConnection;121;1;120;0
WireConnection;121;2;87;0
WireConnection;78;0;77;0
WireConnection;78;1;76;0
WireConnection;72;0;71;0
WireConnection;72;1;70;0
WireConnection;49;0;47;0
WireConnection;49;1;48;0
WireConnection;132;0;121;0
WireConnection;132;1;110;0
WireConnection;134;0;1;0
WireConnection;134;1;35;0
WireConnection;134;2;49;0
WireConnection;79;0;78;0
WireConnection;79;1;72;0
WireConnection;135;0;49;0
WireConnection;135;1;79;0
WireConnection;82;0;134;0
WireConnection;82;1;132;0
WireConnection;82;2;79;0
WireConnection;131;0;127;0
WireConnection;131;1;130;0
WireConnection;126;1;125;0
WireConnection;128;0;102;0
WireConnection;128;1;127;0
WireConnection;106;0;102;0
WireConnection;106;1;88;0
WireConnection;83;0;82;0
WireConnection;83;1;135;0
WireConnection;130;0;102;0
WireConnection;127;0;126;0
WireConnection;127;1;89;0
WireConnection;125;0;124;0
WireConnection;125;1;90;0
WireConnection;0;0;82;0
WireConnection;0;2;83;0
ASEEND*/
//CHKSM=3323F4FCA7D5E97767BD8E32653F70D44370AF36