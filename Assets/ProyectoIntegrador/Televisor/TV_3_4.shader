// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "TV_3_4"
{
	Properties
	{
		_TextureSample0("Texture Sample 0", 2D) = "white" {}
		_GlitchSpeed("_GlitchSpeed", Float) = 6
		_BlockCount("_BlockCount ", Float) = 8
		_GlitchChance("_GlitchChance ", Float) = 0.3
		_BloomStrength("_BloomStrength ", Float) = 1.6
		_BloomThreshold("_BloomThreshold ", Float) = 0.6
		_Saturation("_Saturation", Float) = 1.8
		_BurnPulseSpeed("_BurnPulseSpeed ", Float) = 1.5
		_TextureSample2("Texture Sample 2", 2D) = "white" {}
		_TextureSample1("Texture Sample 1", 2D) = "white" {}
		_TextureSample3("Texture Sample 3", 2D) = "white" {}
		_Tv_1_2_diff("Tv_1_2_diff", 2D) = "white" {}
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

		uniform sampler2D _Tv_1_2_diff;
		uniform float4 _Tv_1_2_diff_ST;
		uniform sampler2D _TextureSample0;
		uniform float _GlitchChance;
		uniform float _GlitchSpeed;
		uniform float _BlockCount;
		uniform sampler2D _TextureSample1;
		uniform sampler2D _TextureSample2;
		uniform float _BloomThreshold;
		uniform sampler2D _TextureSample3;
		uniform float4 _TextureSample3_ST;
		uniform float _Saturation;
		uniform float _BloomStrength;
		uniform float _BurnPulseSpeed;


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
			float2 uv_Tv_1_2_diff = i.uv_texcoord * _Tv_1_2_diff_ST.xy + _Tv_1_2_diff_ST.zw;
			float temp_output_27_0 = (i.uv_texcoord).y;
			float2 appendResult33 = (float2(( floor( ( _Time.y * _GlitchSpeed ) ) + floor( ( temp_output_27_0 * _BlockCount ) ) ) , 0.0));
			float simplePerlin2D34 = snoise( appendResult33 );
			simplePerlin2D34 = simplePerlin2D34*0.5 + 0.5;
			float temp_output_36_0 = step( _GlitchChance , simplePerlin2D34 );
			float temp_output_53_0 = ( temp_output_36_0 * 0.02 );
			float2 appendResult50 = (float2(temp_output_27_0 , 0.0));
			float temp_output_56_0 = (appendResult50).x;
			float temp_output_63_0 = (appendResult50).y;
			float2 appendResult62 = (float2(( temp_output_53_0 + temp_output_56_0 ) , temp_output_63_0));
			float2 appendResult67 = (float2(( temp_output_56_0 - temp_output_53_0 ) , temp_output_63_0));
			float4 appendResult70 = (float4(tex2D( _TextureSample0, appendResult62 ).r , tex2D( _TextureSample1, appendResult50 ).g , tex2D( _TextureSample2, appendResult67 ).b , 0.0));
			float temp_output_119_0 = (i.uv_texcoord).x;
			float temp_output_120_0 = (i.uv_texcoord).y;
			float temp_output_114_0 = ( ( step( 0.38 , temp_output_119_0 ) * step( temp_output_119_0 , 0.86 ) ) * ( step( 0.33 , temp_output_120_0 ) * step( temp_output_120_0 , 0.6 ) ) );
			float4 lerpResult122 = lerp( tex2D( _Tv_1_2_diff, uv_Tv_1_2_diff ) , appendResult70 , temp_output_114_0);
			float2 uv_TextureSample3 = i.uv_texcoord * _TextureSample3_ST.xy + _TextureSample3_ST.zw;
			float4 tex2DNode72 = tex2D( _TextureSample3, uv_TextureSample3 );
			float dotResult74 = dot( tex2DNode72 , float4( 0.3,0.59,0.11,0 ) );
			float4 temp_cast_0 = (dotResult74).xxxx;
			float4 lerpResult77 = lerp( temp_cast_0 , tex2DNode72 , _Saturation);
			float dotResult80 = dot( lerpResult77 , float4( 0.3,0.59,0.11,0 ) );
			float smoothstepResult82 = smoothstep( _BloomThreshold , ( _BloomThreshold + 0.2 ) , dotResult80);
			float4 color20 = IsGammaSpace() ? float4(1,0.1960784,0.01960784,0) : float4(1,0.03189602,0.001517635,0);
			float2 break19_g1 = float2( -0.5,0.5 );
			float temp_output_1_0_g1 = ( _Time.y * _BurnPulseSpeed );
			float sinIn7_g1 = sin( temp_output_1_0_g1 );
			float sinInOffset6_g1 = sin( ( temp_output_1_0_g1 + 1.0 ) );
			float lerpResult20_g1 = lerp( break19_g1.x , break19_g1.y , frac( ( sin( ( ( sinIn7_g1 - sinInOffset6_g1 ) * 91.2228 ) ) * 43758.55 ) ));
			float4 lerpResult99 = lerp( ( ( smoothstepResult82 * _BloomStrength ) + lerpResult77 ) , color20 , ( ( ( ( lerpResult20_g1 + sinIn7_g1 ) * 0.5 ) + 0.5 ) * 0.3 ));
			float temp_output_110_0 = (i.uv_texcoord).x;
			float temp_output_111_0 = (i.uv_texcoord).y;
			float temp_output_108_0 = ( ( step( 0.0 , temp_output_110_0 ) * step( temp_output_110_0 , 0.27 ) ) * ( step( 0.21 , temp_output_111_0 ) * step( temp_output_111_0 , 0.47 ) ) );
			float4 lerpResult125 = lerp( lerpResult122 , lerpResult99 , temp_output_108_0);
			o.Albedo = lerpResult125.rgb;
			o.Emission = ( lerpResult125 * max( temp_output_114_0 , temp_output_108_0 ) ).rgb;
			o.Alpha = 1;
		}

		ENDCG
	}
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=18900
171.2;113.6;984.8;532.6;1072.573;-1731.651;1.995347;True;False
Node;AmplifyShaderEditor.CommentaryNode;30;-1250.935,680.7415;Inherit;False;694.8223;239.1039;franja_id;5;26;27;28;29;2;;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;8;-1083.735,440.9589;Inherit;False;472.6461;226.7994;tiempo_glitch;4;5;1;6;7;;1,1,1,1;0;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;26;-1200.935,730.7415;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleTimeNode;5;-1033.735,490.9589;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.ComponentMaskNode;27;-1004.889,731.5716;Inherit;False;False;True;True;True;1;0;FLOAT2;0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;1;-1030.248,551.7583;Inherit;False;Property;_GlitchSpeed;_GlitchSpeed;1;0;Create;True;0;0;0;False;0;False;6;6;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;2;-978.139,803.8454;Inherit;False;Property;_BlockCount;_BlockCount ;2;0;Create;True;0;0;0;False;0;False;8;8;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;6;-881.0889,503.2398;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;28;-822.8892,732.5716;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.FloorOpNode;29;-706.1124,735.4766;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;35;-586.4612,469.9026;Inherit;False;500;190;random_franja;3;34;33;31;;1,1,1,1;0;0
Node;AmplifyShaderEditor.FloorOpNode;7;-761.0889,512.2398;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;31;-536.4617,522.9033;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;52;152.6615,940.4376;Inherit;False;386.9999;185;UV_glitch;2;49;50;;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;37;-38.78271,466.2859;Inherit;False;365.7181;185;activo;2;36;4;;1,1,1,1;0;0
Node;AmplifyShaderEditor.DynamicAppendNode;33;-423.4623,522.9033;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;4;12.21729,517.8201;Inherit;False;Property;_GlitchChance;_GlitchChance ;3;0;Create;True;0;0;0;False;0;False;0.3;0.3;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.NoiseGeneratorNode;34;-301.4623,519.9033;Inherit;False;Simplex2D;True;False;2;0;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;75;-1214.015,1266.819;Inherit;False;370;280;imagen;1;72;;1,1,1,1;0;0
Node;AmplifyShaderEditor.ComponentMaskNode;49;202.6615,993.4376;Inherit;False;False;True;True;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.StepOpNode;36;174.9354,516.2859;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;54;405.6626,484.1938;Inherit;False;212;185;corrimiento_extra;1;53;;1,1,1,1;0;0
Node;AmplifyShaderEditor.DynamicAppendNode;50;378.6614,990.4376;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.CommentaryNode;68;581.395,668.4675;Inherit;False;681.5493;353.0645;canal r;5;55;22;62;56;63;;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;78;-833.8497,1475.198;Inherit;False;371.139;248.8848;imagen saturada;2;77;17;;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;76;-811.7107,1277.198;Inherit;False;202;185;gris;1;74;;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;95;-255.3963,1935.601;Inherit;False;792.5785;264.3799;pulso;6;90;91;92;94;89;21;;1,1,1,1;0;0
Node;AmplifyShaderEditor.SamplerNode;72;-1164.015,1316.819;Inherit;True;Property;_TextureSample3;Texture Sample 3;11;0;Create;True;0;0;0;False;0;False;-1;28b346f0ac0872242ad3ef291a71bdf4;28b346f0ac0872242ad3ef291a71bdf4;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;17;-783.8497,1608.082;Inherit;False;Property;_Saturation;_Saturation;6;0;Create;True;0;0;0;False;0;False;1.8;1.8;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.ComponentMaskNode;56;631.395,831.4675;Inherit;False;True;False;True;True;1;0;FLOAT2;0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;21;-205.3963,2083.98;Inherit;False;Property;_BurnPulseSpeed;_BurnPulseSpeed ;7;0;Create;True;0;0;0;False;0;False;1.5;1.5;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;123;170.4066,-899.5856;Inherit;False;1093.431;588.444;mask1;14;11;9;119;120;12;118;117;113;112;116;114;115;102;13;;1,1,1,1;0;0
Node;AmplifyShaderEditor.DotProductOpNode;74;-761.7107,1327.198;Inherit;False;2;0;COLOR;0,0,0,0;False;1;COLOR;0.3,0.59,0.11,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;53;455.6626,534.1938;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0.02;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;84;-212.7298,1307.287;Inherit;False;428.1683;304.1477;mask_brillo;3;18;83;82;;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;69;753.426,453.9531;Inherit;False;502.8817;186.5266;canal b;3;61;66;67;;1,1,1,1;0;0
Node;AmplifyShaderEditor.SimpleTimeNode;89;-200.968,2012.46;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;77;-644.7109,1525.198;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;61;803.426,503.9531;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;124;75.75879,-247.0983;Inherit;False;1146.468;641;mask2;14;10;108;101;103;16;109;104;107;14;111;15;105;106;110;;1,1,1,1;0;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;102;220.4066,-619.0309;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.CommentaryNode;81;-442.5615,1305.287;Inherit;False;202;185;brillo;1;80;;1,1,1,1;0;0
Node;AmplifyShaderEditor.RangedFloatNode;18;-164.0298,1405.844;Inherit;False;Property;_BloomThreshold;_BloomThreshold ;5;0;Create;True;0;0;0;False;0;False;0.6;0.6;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;90;-39.63989,1986.744;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.DotProductOpNode;80;-392.5615,1355.287;Inherit;False;2;0;COLOR;0,0,0,0;False;1;COLOR;0.3,0.59,0.11,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;12;503.8095,-427.1415;Inherit;False;Constant;_MaxY1;_MaxY1;0;0;Create;True;0;0;0;False;0;False;0.6;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.ComponentMaskNode;120;534.1401,-510.6229;Inherit;False;False;True;True;True;1;0;FLOAT2;0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;13;469.811,-849.5857;Inherit;False;Constant;_MinX1;_MinX1;0;0;Create;True;0;0;0;False;0;False;0.38;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.ComponentMaskNode;66;914.3077,507.4797;Inherit;False;True;False;True;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;91;82.55334,1985.601;Inherit;False;Noise Sine Wave;-1;;1;a6eff29f739ced848846e3b648af87bd;0;2;1;FLOAT;0;False;2;FLOAT2;-0.5,0.5;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;11;481.3393,-584.7901;Inherit;False;Constant;_MinY1;_MinY1;0;0;Create;True;0;0;0;False;0;False;0.33;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.ComponentMaskNode;63;641.7177,905.532;Inherit;False;False;True;True;True;1;0;FLOAT2;0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;55;722.395,718.4675;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;83;-94.9259,1476.435;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0.2;False;1;FLOAT;0
Node;AmplifyShaderEditor.ComponentMaskNode;119;498.7468,-759.2286;Inherit;False;True;False;True;True;1;0;FLOAT2;0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;86;283.1525,1402.139;Inherit;False;276.7467;281.5087;extra;2;85;19;;1,1,1,1;0;0
Node;AmplifyShaderEditor.RangedFloatNode;9;488.6625,-681.4069;Inherit;False;Constant;_MaxX1;_MaxX1;0;0;Create;True;0;0;0;False;0;False;0.86;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;101;125.7587,16.00793;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;14;396.5752,-15.09779;Inherit;False;Constant;_MaxX2;_MaxX2;0;0;Create;True;0;0;0;False;0;False;0.27;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;19;333.1525,1567.648;Inherit;False;Property;_BloomStrength;_BloomStrength ;4;0;Create;True;0;0;0;False;0;False;1.6;1.6;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.StepOpNode;118;774.3278,-512.3354;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SmoothstepOpNode;82;26.43861,1357.287;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;15;409.2759,106.1021;Inherit;False;Constant;_MinY2;_MinY2;0;0;Create;True;0;0;0;False;0;False;0.21;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;10;387.5751,-197.0983;Inherit;False;Constant;_MinX2;_MinX2;0;0;Create;True;0;0;0;False;0;False;0;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.StepOpNode;113;778.7162,-734.4713;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;62;828.7177,742.532;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.ComponentMaskNode;110;426.2266,-115.579;Inherit;False;True;False;True;True;1;0;FLOAT2;0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;92;258.4205,1991.313;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0.5;False;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;67;1095.308,505.4797;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.CommentaryNode;60;592.426,1051.953;Inherit;False;370;280;canal g;1;59;;1,1,1,1;0;0
Node;AmplifyShaderEditor.ComponentMaskNode;111;406.2266,188.4215;Inherit;False;False;True;True;True;1;0;FLOAT2;0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.StepOpNode;112;769.0993,-842.3163;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.StepOpNode;117;779.0209,-622.6421;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;16;398.5752,277.9023;Inherit;False;Constant;_MaxY2;_MaxY2;0;0;Create;True;0;0;0;False;0;False;0.47;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.StepOpNode;106;709.3264,253.2695;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;22;942.9443,748.9754;Inherit;True;Property;_TextureSample0;Texture Sample 0;0;0;Create;True;0;0;0;False;0;False;-1;28b346f0ac0872242ad3ef291a71bdf4;28b346f0ac0872242ad3ef291a71bdf4;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;116;938.3056,-799.7844;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.StepOpNode;103;689.3264,-172.7311;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;71;1463.429,775.3192;Inherit;False;211;233;efecto glitch;1;70;;1,1,1,1;0;0
Node;AmplifyShaderEditor.StepOpNode;105;710.3264,139.2697;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.StepOpNode;104;690.3264,-58.73034;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;85;397.8992,1452.139;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;88;8.358704,1699.098;Inherit;False;202;185;imagen con bloom;1;87;;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;100;-17.73872,2306.778;Inherit;False;419.3315;262;efecto burn;2;99;20;;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;98;477.9312,2258.785;Inherit;False;212;185;pulso suave;1;97;;1,1,1,1;0;0
Node;AmplifyShaderEditor.SamplerNode;64;1307.152,472.8305;Inherit;True;Property;_TextureSample2;Texture Sample 2;9;0;Create;True;0;0;0;False;0;False;-1;28b346f0ac0872242ad3ef291a71bdf4;28b346f0ac0872242ad3ef291a71bdf4;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleAddOpNode;94;385.1822,1989.028;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0.5;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;115;925.4555,-578.0279;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;59;642.426,1101.953;Inherit;True;Property;_TextureSample1;Texture Sample 1;10;0;Create;True;0;0;0;False;0;False;-1;28b346f0ac0872242ad3ef291a71bdf4;28b346f0ac0872242ad3ef291a71bdf4;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.DynamicAppendNode;70;1513.429,825.3192;Inherit;False;COLOR;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;114;1101.839,-702.3286;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;107;862.2263,-106.8099;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;87;58.3587,1749.098;Inherit;False;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;109;875.2263,180.1906;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;20;32.26128,2356.778;Inherit;False;Constant;_BurnColor;_BurnColor ;0;0;Create;True;0;0;0;False;0;False;1,0.1960784,0.01960784,0;0,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;23;1422.948,37.19566;Inherit;True;Property;_Tv_1_2_diff;Tv_1_2_diff;12;0;Create;True;0;0;0;False;0;False;-1;8ca9bfcbb2ce7b541a82fd20ccd63775;8ca9bfcbb2ce7b541a82fd20ccd63775;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;97;527.9312,2308.785;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0.3;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;108;1060.226,20.19055;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;99;219.5928,2367.027;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.LerpOp;122;1729.127,210.3502;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMaxOpNode;127;1870.955,678.4946;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;125;1764.999,398.1987;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.CommentaryNode;41;-512.1387,695.7981;Inherit;False;482.9215;259.4474;desplazamiento;4;39;40;38;3;;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;48;-5.195129,720.0493;Inherit;False;574.0006;214.0476;nuevax;3;43;42;47;;1,1,1,1;0;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;38;-427.2172,748.7981;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0.5;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;47;416.805,770.0488;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;126;1929.427,483.7124;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;40;-191.2172,745.7981;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ComponentMaskNode;43;238.8052,777.0488;Inherit;False;True;False;True;True;1;0;FLOAT2;0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;3;-462.1387,839.2455;Inherit;False;Property;_GlitchAmount;_GlitchAmount ;8;0;Create;True;0;0;0;False;0;False;0.08;0.08;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;42;40.80469,776.0964;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;39;-307.2172,748.7981;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;2087.993,188.4557;Float;False;True;-1;2;ASEMaterialInspector;0;0;Standard;TV_3_4;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Opaque;0.5;True;True;0;False;Opaque;;Geometry;All;14;all;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;True;0;0;False;-1;0;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;False;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;27;0;26;0
WireConnection;6;0;5;0
WireConnection;6;1;1;0
WireConnection;28;0;27;0
WireConnection;28;1;2;0
WireConnection;29;0;28;0
WireConnection;7;0;6;0
WireConnection;31;0;7;0
WireConnection;31;1;29;0
WireConnection;33;0;31;0
WireConnection;34;0;33;0
WireConnection;49;0;27;0
WireConnection;36;0;4;0
WireConnection;36;1;34;0
WireConnection;50;0;49;0
WireConnection;56;0;50;0
WireConnection;74;0;72;0
WireConnection;53;0;36;0
WireConnection;77;0;74;0
WireConnection;77;1;72;0
WireConnection;77;2;17;0
WireConnection;61;0;56;0
WireConnection;61;1;53;0
WireConnection;90;0;89;0
WireConnection;90;1;21;0
WireConnection;80;0;77;0
WireConnection;120;0;102;0
WireConnection;66;0;61;0
WireConnection;91;1;90;0
WireConnection;63;0;50;0
WireConnection;55;0;53;0
WireConnection;55;1;56;0
WireConnection;83;0;18;0
WireConnection;119;0;102;0
WireConnection;118;0;120;0
WireConnection;118;1;12;0
WireConnection;82;0;80;0
WireConnection;82;1;18;0
WireConnection;82;2;83;0
WireConnection;113;0;119;0
WireConnection;113;1;9;0
WireConnection;62;0;55;0
WireConnection;62;1;63;0
WireConnection;110;0;101;0
WireConnection;92;0;91;0
WireConnection;67;0;66;0
WireConnection;67;1;63;0
WireConnection;111;0;101;0
WireConnection;112;0;13;0
WireConnection;112;1;119;0
WireConnection;117;0;11;0
WireConnection;117;1;120;0
WireConnection;106;0;111;0
WireConnection;106;1;16;0
WireConnection;22;1;62;0
WireConnection;116;0;112;0
WireConnection;116;1;113;0
WireConnection;103;0;10;0
WireConnection;103;1;110;0
WireConnection;105;0;15;0
WireConnection;105;1;111;0
WireConnection;104;0;110;0
WireConnection;104;1;14;0
WireConnection;85;0;82;0
WireConnection;85;1;19;0
WireConnection;64;1;67;0
WireConnection;94;0;92;0
WireConnection;115;0;117;0
WireConnection;115;1;118;0
WireConnection;59;1;50;0
WireConnection;70;0;22;1
WireConnection;70;1;59;2
WireConnection;70;2;64;3
WireConnection;114;0;116;0
WireConnection;114;1;115;0
WireConnection;107;0;103;0
WireConnection;107;1;104;0
WireConnection;87;0;85;0
WireConnection;87;1;77;0
WireConnection;109;0;105;0
WireConnection;109;1;106;0
WireConnection;97;0;94;0
WireConnection;108;0;107;0
WireConnection;108;1;109;0
WireConnection;99;0;87;0
WireConnection;99;1;20;0
WireConnection;99;2;97;0
WireConnection;122;0;23;0
WireConnection;122;1;70;0
WireConnection;122;2;114;0
WireConnection;127;0;114;0
WireConnection;127;1;108;0
WireConnection;125;0;122;0
WireConnection;125;1;99;0
WireConnection;125;2;108;0
WireConnection;38;0;34;0
WireConnection;47;0;40;0
WireConnection;47;1;43;0
WireConnection;126;0;125;0
WireConnection;126;1;127;0
WireConnection;40;0;36;0
WireConnection;40;1;39;0
WireConnection;43;0;42;0
WireConnection;39;0;38;0
WireConnection;39;1;3;0
WireConnection;0;0;125;0
WireConnection;0;2;126;0
ASEEND*/
//CHKSM=008C3A21C2BD0970D397F7A7287B7563A50780A7