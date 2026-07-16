// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "WaterBehaviour"
{
	Properties
	{
		_splashPos("splashPos", Vector) = (0,0,0,0)
		_Color2("Color 2", Color) = (0.380429,0.568468,0.7830189,0)
		_wavelenght("wave lenght", Vector) = (0,0.4,0,0)
		_WaterPrincipal("WaterPrincipal", Color) = (0.02313991,0.7559407,0.9811321,0)
		_WaterSecondary("WaterSecondary", Color) = (1,1,1,0)
		_ObjectWaveRadius("Object Wave Radius", Range( 0.8 , 1.3)) = 0
		_Depthscale("Depth scale", Range( 1 , 8)) = 0
		_Texture0("Texture 0", 2D) = "white" {}
		_waveDensity("waveDensity", Range( 8 , 13)) = 0
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Opaque"  "Queue" = "Geometry+0" }
		Cull Back
		CGPROGRAM
		#include "UnityShaderVariables.cginc"
		#include "Tessellation.cginc"
		#pragma target 4.6
		#pragma surface surf Standard keepalpha addshadow fullforwardshadows vertex:vertexDataFunc tessellate:tessFunction 
		struct Input
		{
			float3 worldPos;
			float2 uv_texcoord;
		};

		uniform float3 _wavelenght;
		uniform float _Depthscale;
		uniform float3 _splashPos;
		uniform float _ObjectWaveRadius;
		uniform sampler2D _Texture0;
		uniform float _waveDensity;
		uniform float4 _Color2;
		uniform float4 _WaterPrincipal;
		uniform float4 _WaterSecondary;


		float2 voronoihash1( float2 p )
		{
			
			p = float2( dot( p, float2( 127.1, 311.7 ) ), dot( p, float2( 269.5, 183.3 ) ) );
			return frac( sin( p ) *43758.5453);
		}


		float voronoi1( float2 v, float time, inout float2 id, inout float2 mr, float smoothness )
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
			 		float2 o = voronoihash1( n + g );
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


		float2 voronoihash29( float2 p )
		{
			
			p = float2( dot( p, float2( 127.1, 311.7 ) ), dot( p, float2( 269.5, 183.3 ) ) );
			return frac( sin( p ) *43758.5453);
		}


		float voronoi29( float2 v, float time, inout float2 id, inout float2 mr, float smoothness )
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
			 		float2 o = voronoihash29( n + g );
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


		float4 tessFunction( appdata_full v0, appdata_full v1, appdata_full v2 )
		{
			return UnityEdgeLengthBasedTess (v0.vertex, v1.vertex, v2.vertex, 0.8);
		}

		void vertexDataFunc( inout appdata_full v )
		{
			float time1 = _Time.y;
			float2 coords1 = v.texcoord.xy * 20.0;
			float2 id1 = 0;
			float2 uv1 = 0;
			float voroi1 = voronoi1( coords1, time1, id1, uv1, 0 );
			float VoronoiPrimary56 = voroi1;
			float3 ase_worldPos = mul( unity_ObjectToWorld, v.vertex );
			float objectPos81 = distance( ase_worldPos , _splashPos );
			float temp_output_110_0 = (-0.1*_Depthscale + ( objectPos81 / _ObjectWaveRadius ));
			float WaveWeight43 = saturate( temp_output_110_0 );
			float2 temp_cast_1 = (( temp_output_110_0 / _waveDensity )).xx;
			float4 smoothstepResult122 = smoothstep( float4( 0,0,0,0 ) , float4( 0.3962264,0.3962264,0.3962264,0 ) , tex2Dlod( _Texture0, float4( temp_cast_1, 0, 0.0) ));
			v.vertex.xyz += ( float4( ( VoronoiPrimary56 * _wavelenght ) , 0.0 ) + ( WaveWeight43 * ( 1.0 - smoothstepResult122 ) * float4( float3(0,0.4,0) , 0.0 ) ) ).rgb;
			v.vertex.w = 1;
		}

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float4 WaterWaveColor66 = _Color2;
			float4 WaterPrincipalColor63 = _WaterPrincipal;
			float time1 = _Time.y;
			float2 coords1 = i.uv_texcoord * 20.0;
			float2 id1 = 0;
			float2 uv1 = 0;
			float voroi1 = voronoi1( coords1, time1, id1, uv1, 0 );
			float VoronoiPrimary56 = voroi1;
			float4 lerpResult26 = lerp( WaterPrincipalColor63 , _WaterSecondary , VoronoiPrimary56);
			float time29 = _Time.y;
			float2 coords29 = i.uv_texcoord * 12.0;
			float2 id29 = 0;
			float2 uv29 = 0;
			float voroi29 = voronoi29( coords29, time29, id29, uv29, 0 );
			float Voronoisecondary51 = voroi29;
			float smoothstepResult35 = smoothstep( 0.0 , 1.0 , Voronoisecondary51);
			float4 lerpResult32 = lerp( WaterPrincipalColor63 , WaterWaveColor66 , smoothstepResult35);
			float4 lerpResult41 = lerp( lerpResult26 , lerpResult32 , Voronoisecondary51);
			float3 ase_worldPos = i.worldPos;
			float objectPos81 = distance( ase_worldPos , _splashPos );
			float temp_output_110_0 = (-0.1*_Depthscale + ( objectPos81 / _ObjectWaveRadius ));
			float WaveWeight43 = saturate( temp_output_110_0 );
			float temp_output_47_0 = ( WaveWeight43 + voroi1 );
			float VoronoiWorldPos62 = temp_output_47_0;
			float4 lerpResult48 = lerp( WaterWaveColor66 , lerpResult41 , saturate( VoronoiWorldPos62 ));
			o.Albedo = lerpResult48.rgb;
			o.Alpha = 1;
		}

		ENDCG
	}
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=18900
0;607;1465;384;1499.077;-88.9554;2.502925;True;False
Node;AmplifyShaderEditor.WorldPosInputsNode;16;-2550.479,848.3757;Inherit;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.Vector3Node;20;-2531.046,1000.928;Inherit;False;Property;_splashPos;splashPos;0;0;Create;True;0;0;0;False;0;False;0,0,0;-2.4,0.929,0.6;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.DistanceOpNode;17;-2245.967,926.3212;Inherit;False;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;81;-2039.775,921.0408;Inherit;False;objectPos;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;82;-1397.793,1065.706;Inherit;False;81;objectPos;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;42;-1501.706,1151.767;Inherit;False;Property;_ObjectWaveRadius;Object Wave Radius;5;0;Create;True;0;0;0;False;0;False;0;1.3;0.8;1.3;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;111;-1255.319,964.7534;Inherit;False;Property;_Depthscale;Depth scale;6;0;Create;True;0;0;0;False;0;False;0;8;1;8;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleDivideOpNode;18;-1183.848,1070.063;Inherit;True;2;0;FLOAT;0;False;1;FLOAT;1.5;False;1;FLOAT;0
Node;AmplifyShaderEditor.ScaleAndOffsetNode;110;-905.7528,1022.119;Inherit;True;3;0;FLOAT;-0.1;False;1;FLOAT;5;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleTimeNode;2;-2169.106,159.1336;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;19;-609.2665,1022.897;Inherit;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;43;-322.3154,1015.76;Inherit;False;WaveWeight;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;123;-1016.666,746.8845;Inherit;False;Property;_waveDensity;waveDensity;8;0;Create;True;0;0;0;False;0;False;0;10.71;8;13;0;1;FLOAT;0
Node;AmplifyShaderEditor.VoronoiNode;29;-1799.951,305.8778;Inherit;True;0;0;1;0;1;False;1;False;False;4;0;FLOAT2;0,0;False;1;FLOAT;0;False;2;FLOAT;12;False;3;FLOAT;0;False;3;FLOAT;0;FLOAT2;1;FLOAT2;2
Node;AmplifyShaderEditor.GetLocalVarNode;46;-1803.392,-234.6793;Inherit;False;43;WaveWeight;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;27;-901.8172,-1002.69;Inherit;False;Property;_WaterPrincipal;WaterPrincipal;3;0;Create;True;0;0;0;False;0;False;0.02313991,0.7559407,0.9811321,0;0.05833866,0.5386303,0.6509434,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RegisterLocalVarNode;51;-1535.18,300.6391;Float;False;Voronoisecondary;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.VoronoiNode;1;-1804.079,18.98669;Inherit;True;0;0;1;0;1;False;1;False;False;4;0;FLOAT2;0,0;False;1;FLOAT;0;False;2;FLOAT;20;False;3;FLOAT;0;False;3;FLOAT;0;FLOAT2;1;FLOAT2;2
Node;AmplifyShaderEditor.ColorNode;33;-889.6872,-797.3638;Inherit;False;Property;_Color2;Color 2;1;0;Create;True;0;0;0;False;0;False;0.380429,0.568468,0.7830189,0;1,1,1,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleDivideOpNode;121;-637.3684,727.4417;Inherit;True;2;0;FLOAT;0;False;1;FLOAT;3;False;1;FLOAT;0
Node;AmplifyShaderEditor.TexturePropertyNode;114;-656.3701,395.107;Inherit;True;Property;_Texture0;Texture 0;7;0;Create;True;0;0;0;False;0;False;None;5d182491e406fb749a90677b5c9564f1;False;white;Auto;Texture2D;-1;0;2;SAMPLER2D;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.SimpleAddOpNode;47;-1556.701,-231.6617;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;63;-601.086,-1003.52;Inherit;False;WaterPrincipalColor;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;56;-1547.896,14.83627;Float;False;VoronoiPrimary;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;70;-401.9335,697.7078;Inherit;True;Property;_TextureSample0;Texture Sample 0;6;0;Create;True;0;0;0;False;0;False;-1;None;5d182491e406fb749a90677b5c9564f1;True;1;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RegisterLocalVarNode;66;-590.8265,-797.3873;Inherit;False;WaterWaveColor;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;52;-623.8425,-65.79668;Inherit;False;51;Voronoisecondary;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.SmoothstepOpNode;35;-349.6813,-60.12041;Inherit;True;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;60;-285.3459,-525.0261;Inherit;False;56;VoronoiPrimary;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;65;-351.5181,-294.0391;Inherit;False;63;WaterPrincipalColor;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.SmoothstepOpNode;122;-53.28743,702.0317;Inherit;True;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;COLOR;0.3962264,0.3962264,0.3962264,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;62;-1281.495,-236.7576;Inherit;False;VoronoiWorldPos;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;28;-892.7742,-604.1269;Inherit;False;Property;_WaterSecondary;WaterSecondary;4;0;Create;True;0;0;0;False;0;False;1,1,1,0;0.7924528,0.7924528,0.7924528,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.GetLocalVarNode;64;-308.098,-666.4194;Inherit;False;63;WaterPrincipalColor;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;67;-334.5214,-202.0122;Inherit;False;66;WaterWaveColor;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.Vector3Node;3;446.4894,719.6408;Inherit;False;Constant;_Waveheight;Wave height;1;0;Create;True;0;0;0;False;0;False;0,0.4,0;0,0,0;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.LerpOp;26;-16.49545,-623.3312;Inherit;True;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.LerpOp;32;-16.82752,-290.9724;Inherit;True;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.OneMinusNode;125;199.391,699.8356;Inherit;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;54;248.6077,150.146;Inherit;False;62;VoronoiWorldPos;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;57;-43.9295,334.4944;Inherit;False;56;VoronoiPrimary;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;55;13.69421,-15.98231;Inherit;False;51;Voronoisecondary;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;45;468.7856,430.6418;Inherit;False;43;WaveWeight;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.Vector3Node;50;-23.30876,460.0999;Inherit;False;Property;_wavelenght;wave lenght;2;0;Create;True;0;0;0;False;0;False;0,0.4,0;0,0.5,0;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;13;243.9991,339.4229;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.LerpOp;41;379.3139,-315.8221;Inherit;True;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SaturateNode;84;516.1333,154.4316;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;68;358.6002,43.51682;Inherit;False;66;WaterWaveColor;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;4;671.3665,435.9904;Inherit;False;3;3;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;2;FLOAT3;0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;25;807.3641,335.7855;Inherit;True;2;2;0;FLOAT3;0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.LerpOp;48;745.0458,47.3936;Inherit;True;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.EdgeLengthTessNode;5;740.8049,588.5121;Inherit;False;1;0;FLOAT;0.8;False;1;FLOAT4;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;1034.638,46.60728;Float;False;True;-1;6;ASEMaterialInspector;0;0;Standard;WaterBehaviour;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Opaque;0.5;True;True;0;False;Opaque;;Geometry;All;14;all;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;True;2;15;10;25;False;0.5;True;0;0;False;-1;0;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;False;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;17;0;16;0
WireConnection;17;1;20;0
WireConnection;81;0;17;0
WireConnection;18;0;82;0
WireConnection;18;1;42;0
WireConnection;110;1;111;0
WireConnection;110;2;18;0
WireConnection;19;0;110;0
WireConnection;43;0;19;0
WireConnection;29;1;2;0
WireConnection;51;0;29;0
WireConnection;1;1;2;0
WireConnection;121;0;110;0
WireConnection;121;1;123;0
WireConnection;47;0;46;0
WireConnection;47;1;1;0
WireConnection;63;0;27;0
WireConnection;56;0;1;0
WireConnection;70;0;114;0
WireConnection;70;1;121;0
WireConnection;66;0;33;0
WireConnection;35;0;52;0
WireConnection;122;0;70;0
WireConnection;62;0;47;0
WireConnection;26;0;64;0
WireConnection;26;1;28;0
WireConnection;26;2;60;0
WireConnection;32;0;65;0
WireConnection;32;1;67;0
WireConnection;32;2;35;0
WireConnection;125;0;122;0
WireConnection;13;0;57;0
WireConnection;13;1;50;0
WireConnection;41;0;26;0
WireConnection;41;1;32;0
WireConnection;41;2;55;0
WireConnection;84;0;54;0
WireConnection;4;0;45;0
WireConnection;4;1;125;0
WireConnection;4;2;3;0
WireConnection;25;0;13;0
WireConnection;25;1;4;0
WireConnection;48;0;68;0
WireConnection;48;1;41;0
WireConnection;48;2;84;0
WireConnection;0;0;48;0
WireConnection;0;11;25;0
WireConnection;0;14;5;0
ASEEND*/
//CHKSM=520C4826015A0AACE739A86E2AB9458BA320E982