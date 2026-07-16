// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Portal_Ciudad"
{
	Properties
	{
		_Speed("Speed", Float) = 2
		_ScaleVoronoi("ScaleVoronoi", Float) = 5
		_NoiseScale("NoiseScale", Float) = 50
		_NoiseBlend("NoiseBlend", Float) = 0.3
		_ColorOscuro("ColorOscuro", Color) = (0,0.02,0.05,1)
		_ColorRayo("ColorRayo", Color) = (0.7,0.9,1,1)
		_EmissionIntensity("EmissionIntensity", Float) = 4
		_Contraste("Contraste", Float) = 4
		_NoiseSpeed("NoiseSpeed", Float) = 0.5
		_FresnelPower("FresnelPower", Float) = 3
		_FresnelColor("FresnelColor", Color) = (0.3,0.7,1,0)
		_RTTexture("RT Texture", 2D) = "white" {}
		_RadioCirculoExterior("RadioCirculoExterior", Float) = 0.4
		_RadioCirculoInterior("RadioCirculoInterior", Float) = 0.4
		_RadioCirculo("RadioCirculo", Float) = 0.4
		_DistanceCirculo("DistanceCirculo", Vector) = (0.5,0.5,0,0)
		_EscalaCirculo("EscalaCirculo", Vector) = (0.5,0.5,0,0)
		_ColorBorde("ColorBorde", Color) = (0.2,0.6,1,0)
		_IntensidadBorde("IntensidadBorde", Float) = 3
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Opaque"  "Queue" = "Geometry+0" "IsEmissive" = "true"  }
		Cull Back
		CGINCLUDE
		#include "UnityShaderVariables.cginc"
		#include "UnityPBSLighting.cginc"
		#include "Lighting.cginc"
		#pragma target 3.0
		struct Input
		{
			float2 uv_texcoord;
			float3 worldPos;
			float3 worldNormal;
		};

		uniform sampler2D _RTTexture;
		uniform float4 _RTTexture_ST;
		uniform float4 _ColorOscuro;
		uniform float4 _ColorRayo;
		uniform float _ScaleVoronoi;
		uniform float _Speed;
		uniform float _NoiseSpeed;
		uniform float _NoiseScale;
		uniform float _NoiseBlend;
		uniform float _Contraste;
		uniform float2 _EscalaCirculo;
		uniform float2 _DistanceCirculo;
		uniform float _RadioCirculo;
		uniform float _EmissionIntensity;
		uniform float4 _FresnelColor;
		uniform float _FresnelPower;
		uniform float _RadioCirculoExterior;
		uniform float _RadioCirculoInterior;
		uniform float4 _ColorBorde;
		uniform float _IntensidadBorde;


		float2 voronoihash2( float2 p )
		{
			
			p = float2( dot( p, float2( 127.1, 311.7 ) ), dot( p, float2( 269.5, 183.3 ) ) );
			return frac( sin( p ) *43758.5453);
		}


		float voronoi2( float2 v, float time, inout float2 id, inout float2 mr, float smoothness )
		{
			float2 n = floor( v );
			float2 f = frac( v );
			float F1 = 8.0;
			float F2 = 8.0; float2 mg = 0;
			for ( int j = -1; j <= 1; j++ )
			{
				for ( int i = -1; i <= 1; i++ )
			 	{
			 		float2 g = float2( i, j );
			 		float2 o = voronoihash2( n + g );
					o = ( sin( time + o * 6.2831 ) * 0.5 + 0.5 ); float2 r = f - g - o;
					float d = 0.5 * dot( r, r );
			 		if( d<F1 ) {
			 			F2 = F1;
			 			F1 = d; mg = g; mr = r; id = o;
			 		} else if( d<F2 ) {
			 			F2 = d;
			 		}
			 	}
			}
			return F1;
		}


		inline float noise_randomValue (float2 uv) { return frac(sin(dot(uv, float2(12.9898, 78.233)))*43758.5453); }

		inline float noise_interpolate (float a, float b, float t) { return (1.0-t)*a + (t*b); }

		inline float valueNoise (float2 uv)
		{
			float2 i = floor(uv);
			float2 f = frac( uv );
			f = f* f * (3.0 - 2.0 * f);
			uv = abs( frac(uv) - 0.5);
			float2 c0 = i + float2( 0.0, 0.0 );
			float2 c1 = i + float2( 1.0, 0.0 );
			float2 c2 = i + float2( 0.0, 1.0 );
			float2 c3 = i + float2( 1.0, 1.0 );
			float r0 = noise_randomValue( c0 );
			float r1 = noise_randomValue( c1 );
			float r2 = noise_randomValue( c2 );
			float r3 = noise_randomValue( c3 );
			float bottomOfGrid = noise_interpolate( r0, r1, f.x );
			float topOfGrid = noise_interpolate( r2, r3, f.x );
			float t = noise_interpolate( bottomOfGrid, topOfGrid, f.y );
			return t;
		}


		float SimpleNoise(float2 UV)
		{
			float t = 0.0;
			float freq = pow( 2.0, float( 0 ) );
			float amp = pow( 0.5, float( 3 - 0 ) );
			t += valueNoise( UV/freq )*amp;
			freq = pow(2.0, float(1));
			amp = pow(0.5, float(3-1));
			t += valueNoise( UV/freq )*amp;
			freq = pow(2.0, float(2));
			amp = pow(0.5, float(3-2));
			t += valueNoise( UV/freq )*amp;
			return t;
		}


		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float2 uv_RTTexture = i.uv_texcoord * _RTTexture_ST.xy + _RTTexture_ST.zw;
			float mulTime1 = _Time.y * _Speed;
			float NodoTime67 = mulTime1;
			float time2 = NodoTime67;
			float2 coords2 = i.uv_texcoord * _ScaleVoronoi;
			float2 id2 = 0;
			float2 uv2 = 0;
			float voroi2 = voronoi2( coords2, time2, id2, uv2, 0 );
			float2 temp_cast_0 = (( NodoTime67 * _NoiseSpeed )).xx;
			float simpleNoise5 = SimpleNoise( temp_cast_0*_NoiseScale );
			float lerpResult7 = lerp( voroi2 , simpleNoise5 , _NoiseBlend);
			float4 lerpResult11 = lerp( _ColorOscuro , _ColorRayo , pow( lerpResult7 , _Contraste ));
			float DistanceCirculo52 = distance( ( uv_RTTexture * _EscalaCirculo ) , _DistanceCirculo );
			float CirculoCiudad39 = ( 1.0 - step( DistanceCirculo52 , _RadioCirculo ) );
			float4 lerpResult28 = lerp( tex2D( _RTTexture, uv_RTTexture ) , lerpResult11 , CirculoCiudad39);
			o.Albedo = lerpResult28.rgb;
			float3 ase_worldPos = i.worldPos;
			float3 ase_worldViewDir = normalize( UnityWorldSpaceViewDir( ase_worldPos ) );
			float3 ase_worldNormal = i.worldNormal;
			float fresnelNdotV20 = dot( ase_worldNormal, ase_worldViewDir );
			float fresnelNode20 = ( 0.0 + 1.0 * pow( 1.0 - fresnelNdotV20, _FresnelPower ) );
			float4 BordeCirculo55 = ( ( ( ( 1.0 - step( _RadioCirculoExterior , DistanceCirculo52 ) ) - ( 1.0 - step( _RadioCirculoInterior , DistanceCirculo52 ) ) ) * _ColorBorde ) * _IntensidadBorde );
			o.Emission = ( ( ( lerpResult11 * _EmissionIntensity ) + ( _FresnelColor * fresnelNode20 ) ) + BordeCirculo55 ).rgb;
			o.Alpha = 1;
		}

		ENDCG
		CGPROGRAM
		#pragma surface surf Standard keepalpha fullforwardshadows 

		ENDCG
		Pass
		{
			Name "ShadowCaster"
			Tags{ "LightMode" = "ShadowCaster" }
			ZWrite On
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#pragma target 3.0
			#pragma multi_compile_shadowcaster
			#pragma multi_compile UNITY_PASS_SHADOWCASTER
			#pragma skip_variants FOG_LINEAR FOG_EXP FOG_EXP2
			#include "HLSLSupport.cginc"
			#if ( SHADER_API_D3D11 || SHADER_API_GLCORE || SHADER_API_GLES || SHADER_API_GLES3 || SHADER_API_METAL || SHADER_API_VULKAN )
				#define CAN_SKIP_VPOS
			#endif
			#include "UnityCG.cginc"
			#include "Lighting.cginc"
			#include "UnityPBSLighting.cginc"
			struct v2f
			{
				V2F_SHADOW_CASTER;
				float2 customPack1 : TEXCOORD1;
				float3 worldPos : TEXCOORD2;
				float3 worldNormal : TEXCOORD3;
				UNITY_VERTEX_INPUT_INSTANCE_ID
				UNITY_VERTEX_OUTPUT_STEREO
			};
			v2f vert( appdata_full v )
			{
				v2f o;
				UNITY_SETUP_INSTANCE_ID( v );
				UNITY_INITIALIZE_OUTPUT( v2f, o );
				UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO( o );
				UNITY_TRANSFER_INSTANCE_ID( v, o );
				Input customInputData;
				float3 worldPos = mul( unity_ObjectToWorld, v.vertex ).xyz;
				half3 worldNormal = UnityObjectToWorldNormal( v.normal );
				o.worldNormal = worldNormal;
				o.customPack1.xy = customInputData.uv_texcoord;
				o.customPack1.xy = v.texcoord;
				o.worldPos = worldPos;
				TRANSFER_SHADOW_CASTER_NORMALOFFSET( o )
				return o;
			}
			half4 frag( v2f IN
			#if !defined( CAN_SKIP_VPOS )
			, UNITY_VPOS_TYPE vpos : VPOS
			#endif
			) : SV_Target
			{
				UNITY_SETUP_INSTANCE_ID( IN );
				Input surfIN;
				UNITY_INITIALIZE_OUTPUT( Input, surfIN );
				surfIN.uv_texcoord = IN.customPack1.xy;
				float3 worldPos = IN.worldPos;
				half3 worldViewDir = normalize( UnityWorldSpaceViewDir( worldPos ) );
				surfIN.worldPos = worldPos;
				surfIN.worldNormal = IN.worldNormal;
				SurfaceOutputStandard o;
				UNITY_INITIALIZE_OUTPUT( SurfaceOutputStandard, o )
				surf( surfIN, o );
				#if defined( CAN_SKIP_VPOS )
				float2 vpos = IN.pos;
				#endif
				SHADOW_CASTER_FRAGMENT( IN )
			}
			ENDCG
		}
	}
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=18900
0;843;1989;508;827.6559;181.3821;1.3;True;False
Node;AmplifyShaderEditor.TexturePropertyNode;30;254.5208,-499.2401;Inherit;True;Property;_RTTexture;RT Texture;11;0;Create;True;0;0;0;False;0;False;8db9391c6bad4f145a2bcd6fc1fc4c69;8db9391c6bad4f145a2bcd6fc1fc4c69;False;white;Auto;Texture2D;-1;0;2;SAMPLER2D;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.TextureCoordinatesNode;36;510.1744,-500.4576;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.Vector2Node;41;744.2578,-399.4297;Inherit;False;Property;_EscalaCirculo;EscalaCirculo;16;0;Create;True;0;0;0;False;0;False;0.5,0.5;0.5,0.5;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.Vector2Node;33;970.5562,-397.2458;Inherit;False;Property;_DistanceCirculo;DistanceCirculo;15;0;Create;True;0;0;0;False;0;False;0.5,0.5;0.5,0.5;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;40;813.2578,-499.4297;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;3;-1515.732,176.0534;Inherit;False;Property;_Speed;Speed;0;0;Create;True;0;0;0;False;0;False;2;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.DistanceOpNode;32;1078.62,-504.1045;Inherit;False;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleTimeNode;1;-1517.732,106.0535;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;52;1265.58,-507.4414;Inherit;False;DistanceCirculo;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;60;1958.58,-840.4415;Inherit;False;1390.638;592.0002;Borde del Circulo;14;35;54;43;53;49;42;58;59;45;44;48;46;47;55;;1,1,1,1;0;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;67;-1328.042,97.38258;Inherit;False;NodoTime;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;54;2030.58,-364.4413;Inherit;False;52;DistanceCirculo;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;53;2028.166,-617.3522;Inherit;False;52;DistanceCirculo;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;43;2008.58,-790.4415;Inherit;False;Property;_RadioCirculoExterior;RadioCirculoExterior;12;0;Create;True;0;0;0;False;0;False;0.4;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;15;-892.6528,265.9563;Inherit;False;Property;_NoiseSpeed;NoiseSpeed;8;0;Create;True;0;0;0;False;0;False;0.5;0.5;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;35;2021.818,-536.5411;Inherit;False;Property;_RadioCirculoInterior;RadioCirculoInterior;13;0;Create;True;0;0;0;False;0;False;0.4;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;69;-1044.042,157.3826;Inherit;False;67;NodoTime;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.StepOpNode;42;2101.58,-714.4415;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;6;-649.7325,276.0537;Inherit;False;Property;_NoiseScale;NoiseScale;2;0;Create;True;0;0;0;False;0;False;50;50;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.StepOpNode;49;2113.58,-462.9414;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;70;-1040.042,7.382625;Inherit;False;67;NodoTime;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;14;-856.653,163.956;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;4;-648.7325,97.05346;Inherit;False;Property;_ScaleVoronoi;ScaleVoronoi;1;0;Create;True;0;0;0;False;0;False;5;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.VoronoiNode;2;-646.7325,-19.94648;Inherit;False;0;0;1;0;1;False;1;False;False;4;0;FLOAT2;0,0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;0;False;3;FLOAT;0;FLOAT2;1;FLOAT2;2
Node;AmplifyShaderEditor.NoiseGeneratorNode;5;-649.7325,181.0534;Inherit;False;Simple;True;False;2;0;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;58;2250.469,-465.6549;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;61;1948.492,-222.7652;Inherit;False;829.7296;263.5266;Radio del Circulo;5;51;50;34;37;39;;1,1,1,1;0;0
Node;AmplifyShaderEditor.OneMinusNode;59;2247.901,-714.8491;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;8;-315.121,222.3351;Inherit;False;Property;_NoiseBlend;NoiseBlend;3;0;Create;True;0;0;0;False;0;False;0.3;0.3;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;50;2178.904,-75.23862;Inherit;False;Property;_RadioCirculo;RadioCirculo;14;0;Create;True;0;0;0;False;0;False;0.4;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;7;-294.121,102.3351;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;45;2619.58,-499.4413;Inherit;False;Property;_ColorBorde;ColorBorde;17;0;Create;True;0;0;0;False;0;False;0.2,0.6,1,0;0.2,0.6,1,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleSubtractOpNode;44;2431.58,-598.4415;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;51;1998.492,-171.6495;Inherit;False;52;DistanceCirculo;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;17;-40.92065,234.9026;Inherit;False;Property;_Contraste;Contraste;7;0;Create;True;0;0;0;False;0;False;4;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;9;-32.88136,-215.2703;Inherit;False;Property;_ColorOscuro;ColorOscuro;4;0;Create;True;0;0;0;False;0;False;0,0.02,0.05,1;0,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;10;-26.84436,-43.76299;Inherit;False;Property;_ColorRayo;ColorRayo;5;0;Create;True;0;0;0;False;0;False;0.7,0.9,1,1;0,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.PowerNode;16;-26.92065,127.9026;Inherit;False;False;2;0;FLOAT;0;False;1;FLOAT;2;False;1;FLOAT;0
Node;AmplifyShaderEditor.StepOpNode;34;2231.142,-165.8383;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;21;125.3231,645.2306;Inherit;False;Property;_FresnelPower;FresnelPower;9;0;Create;True;0;0;0;False;0;False;3;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;46;2696.58,-598.4415;Inherit;False;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;48;2863.58,-490.4413;Inherit;False;Property;_IntensidadBorde;IntensidadBorde;18;0;Create;True;0;0;0;False;0;False;3;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;47;2921.58,-592.4415;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.OneMinusNode;37;2381.221,-167.7652;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.FresnelNode;20;128.7408,479.2751;Inherit;False;Standard;WorldNormal;ViewDir;False;False;5;0;FLOAT3;0,0,1;False;4;FLOAT3;0,0,0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;5;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;13;337.9375,212.5644;Inherit;False;Property;_EmissionIntensity;EmissionIntensity;6;0;Create;True;0;0;0;False;0;False;4;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;11;202.9274,52.10631;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.ColorNode;23;153.3231,304.2306;Inherit;False;Property;_FresnelColor;FresnelColor;10;0;Create;True;0;0;0;False;0;False;0.3,0.7,1,0;0,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RegisterLocalVarNode;55;3125.218,-599.243;Inherit;False;BordeCirculo;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;39;2554.221,-172.7652;Inherit;False;CirculoCiudad;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;24;398.3231,310.2306;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;12;402.7706,115.9038;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;25;630.3231,112.2306;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;38;572.4824,19.62134;Inherit;False;39;CirculoCiudad;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;26;253.169,-297.8152;Inherit;True;Property;_TextureSample0;Texture Sample 0;11;0;Create;True;0;0;0;False;0;False;-1;8db9391c6bad4f145a2bcd6fc1fc4c69;8db9391c6bad4f145a2bcd6fc1fc4c69;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.GetLocalVarNode;56;656.7837,295.9024;Inherit;False;55;BordeCirculo;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.LerpOp;28;611.8931,-98.40396;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;57;827.2368,107.2348;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;994.3662,-93.88201;Float;False;True;-1;2;ASEMaterialInspector;0;0;Standard;Portal_Ciudad;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Opaque;0.5;True;True;0;False;Opaque;;Geometry;All;14;all;True;True;True;True;0;False;-1;False;1;False;-1;255;False;-1;255;False;-1;5;False;-1;1;False;-1;1;False;-1;1;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;True;0;5;False;-1;10;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;False;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;36;2;30;0
WireConnection;40;0;36;0
WireConnection;40;1;41;0
WireConnection;32;0;40;0
WireConnection;32;1;33;0
WireConnection;1;0;3;0
WireConnection;52;0;32;0
WireConnection;67;0;1;0
WireConnection;42;0;43;0
WireConnection;42;1;53;0
WireConnection;49;0;35;0
WireConnection;49;1;54;0
WireConnection;14;0;69;0
WireConnection;14;1;15;0
WireConnection;2;1;70;0
WireConnection;2;2;4;0
WireConnection;5;0;14;0
WireConnection;5;1;6;0
WireConnection;58;0;49;0
WireConnection;59;0;42;0
WireConnection;7;0;2;0
WireConnection;7;1;5;0
WireConnection;7;2;8;0
WireConnection;44;0;59;0
WireConnection;44;1;58;0
WireConnection;16;0;7;0
WireConnection;16;1;17;0
WireConnection;34;0;51;0
WireConnection;34;1;50;0
WireConnection;46;0;44;0
WireConnection;46;1;45;0
WireConnection;47;0;46;0
WireConnection;47;1;48;0
WireConnection;37;0;34;0
WireConnection;20;3;21;0
WireConnection;11;0;9;0
WireConnection;11;1;10;0
WireConnection;11;2;16;0
WireConnection;55;0;47;0
WireConnection;39;0;37;0
WireConnection;24;0;23;0
WireConnection;24;1;20;0
WireConnection;12;0;11;0
WireConnection;12;1;13;0
WireConnection;25;0;12;0
WireConnection;25;1;24;0
WireConnection;26;0;30;0
WireConnection;28;0;26;0
WireConnection;28;1;11;0
WireConnection;28;2;38;0
WireConnection;57;0;25;0
WireConnection;57;1;56;0
WireConnection;0;0;28;0
WireConnection;0;2;57;0
ASEEND*/
//CHKSM=D375CF055D86E2B506A1656EABFFCA3F297E2601