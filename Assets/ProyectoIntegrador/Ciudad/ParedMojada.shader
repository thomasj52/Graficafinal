// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "ParedMojada"
{
	Properties
	{
		_WetWallColor("WetWallColor", Color) = (0.3,0.35,0.4,1)
		_SpeedPanner("SpeedPanner", Vector) = (0,-0.15,0,0)
		_WetSmoothness("WetSmoothness", Range( 0 , 1)) = 0.85
		_WallTexture("WallTexture", 2D) = "white" {}
		_Wetness("Wetness", Range( 0 , 1)) = 0.5
		_Gotas("Gotas", Vector) = (3,0.15,0,0)
		_GotasLluviaTexture("GotasLluviaTexture", 2D) = "white" {}
		_GotasVisibility("GotasVisibility", Float) = 0.15
		_GotasColor("GotasColor", Color) = (0.6,0.7,0.8,0)
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Opaque"  "Queue" = "Geometry+0" "IgnoreProjector" = "True" }
		Cull Back
		CGPROGRAM
		#include "UnityShaderVariables.cginc"
		#pragma target 3.0
		#pragma surface surf Standard keepalpha addshadow fullforwardshadows 
		struct Input
		{
			float2 uv_texcoord;
		};

		uniform sampler2D _WallTexture;
		uniform float4 _WallTexture_ST;
		uniform float4 _WetWallColor;
		uniform float _Wetness;
		uniform sampler2D _GotasLluviaTexture;
		uniform float2 _SpeedPanner;
		uniform float2 _Gotas;
		uniform float _GotasVisibility;
		uniform float4 _GotasColor;
		uniform float _WetSmoothness;

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float2 uv_WallTexture = i.uv_texcoord * _WallTexture_ST.xy + _WallTexture_ST.zw;
			float4 lerpResult16 = lerp( tex2D( _WallTexture, uv_WallTexture ) , _WetWallColor , _Wetness);
			float2 uv_TexCoord4 = i.uv_texcoord * _Gotas;
			float2 panner5 = ( 1.0 * _Time.y * _SpeedPanner + uv_TexCoord4);
			o.Albedo = ( lerpResult16 + ( ( tex2D( _GotasLluviaTexture, panner5 ).r * _GotasVisibility ) * _GotasColor ) ).rgb;
			o.Smoothness = _WetSmoothness;
			o.Alpha = 1;
		}

		ENDCG
	}
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=18900
0;843;1989;508;2135.843;208.3836;1.3;True;False
Node;AmplifyShaderEditor.Vector2Node;17;-1680.843,77.61654;Inherit;False;Property;_Gotas;Gotas;5;0;Create;True;0;0;0;False;0;False;3,0.15;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.Vector2Node;6;-1180.378,185.4033;Inherit;False;Property;_SpeedPanner;SpeedPanner;1;0;Create;True;0;0;0;False;0;False;0,-0.15;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.TextureCoordinatesNode;4;-1461.08,60.30328;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TexturePropertyNode;21;-1208.943,-129.0836;Inherit;True;Property;_GotasLluviaTexture;GotasLluviaTexture;6;0;Create;True;0;0;0;False;0;False;06a369e28b852f340bb478a151b527cf;None;False;white;Auto;Texture2D;-1;0;2;SAMPLER2D;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.PannerNode;5;-1172.98,60.30327;Inherit;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.TexturePropertyNode;13;-706.5804,-388.3971;Inherit;True;Property;_WallTexture;WallTexture;3;0;Create;True;0;0;0;False;0;False;0495185e035d28e4a92f01ac9cf57692;None;False;white;Auto;Texture2D;-1;0;2;SAMPLER2D;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.RangedFloatNode;23;-566.7426,73.7165;Inherit;False;Property;_GotasVisibility;GotasVisibility;7;0;Create;True;0;0;0;False;0;False;0.15;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;20;-934.6431,-53.68362;Inherit;True;Property;_TextureSample1;Texture Sample 1;8;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;14;-103.4802,-98.9967;Inherit;False;Property;_Wetness;Wetness;4;0;Create;True;0;0;0;False;0;False;0.5;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;24;-323.6427,143.9164;Inherit;False;Property;_GotasColor;GotasColor;8;0;Create;True;0;0;0;False;0;False;0.6,0.7,0.8,0;0,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;11;-428.5802,-389.2965;Inherit;True;Property;_TextureSample0;Texture Sample 0;5;0;Create;True;0;0;0;False;0;False;-1;f368627dbf4c8b644827642c33a47f0b;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;1;-349.5802,-206.2968;Inherit;False;Property;_WetWallColor;WetWallColor;0;0;Create;True;0;0;0;False;0;False;0.3,0.35,0.4,1;0,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;22;-504.3427,-26.38345;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;16;10.51978,-223.9967;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;25;-197.5427,39.91641;Inherit;False;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;10;-3.580232,-14.59672;Inherit;False;Property;_WetSmoothness;WetSmoothness;2;0;Create;True;0;0;0;False;0;False;0.85;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;19;193.7564,-218.7838;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;310,-228;Float;False;True;-1;2;ASEMaterialInspector;0;0;Standard;ParedMojada;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;False;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Opaque;0.5;True;True;0;False;Opaque;;Geometry;All;14;all;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;True;0;5;False;-1;10;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;False;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;4;0;17;0
WireConnection;5;0;4;0
WireConnection;5;2;6;0
WireConnection;20;0;21;0
WireConnection;20;1;5;0
WireConnection;11;0;13;0
WireConnection;22;0;20;1
WireConnection;22;1;23;0
WireConnection;16;0;11;0
WireConnection;16;1;1;0
WireConnection;16;2;14;0
WireConnection;25;0;22;0
WireConnection;25;1;24;0
WireConnection;19;0;16;0
WireConnection;19;1;25;0
WireConnection;0;0;19;0
WireConnection;0;4;10;0
ASEEND*/
//CHKSM=ED93C0204574F04BD93352D1F41FD272B18FFA96