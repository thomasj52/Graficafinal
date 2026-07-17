// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Mask"
{
	Properties
	{
		_Texture("Texture", 2D) = "white" {}
		_Frequency1("Frequency", Float) = 1
		_WaveLenght1("Wave Lenght", Range( 1 , 0.05)) = 0.5423678
		_LineSpeed1("Line Speed", Float) = 1
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Opaque"  "Queue" = "Geometry+0" }
		Cull Back
		Stencil
		{
			Ref 5
			Comp Always
			Pass Replace
			Fail Keep
			ZFail Keep
		}
		CGPROGRAM
		#include "UnityShaderVariables.cginc"
		#pragma target 3.0
		#pragma surface surf Standard keepalpha addshadow fullforwardshadows 
		struct Input
		{
			float2 uv_texcoord;
			float3 worldPos;
		};

		uniform sampler2D _Texture;
		uniform float4 _Texture_ST;
		uniform float _LineSpeed1;
		uniform float _Frequency1;
		uniform float _WaveLenght1;

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float2 uv_Texture = i.uv_texcoord * _Texture_ST.xy + _Texture_ST.zw;
			float3 ase_vertex3Pos = mul( unity_WorldToObject, float4( i.worldPos , 1 ) );
			float mulTime4 = _Time.y * _LineSpeed1;
			o.Albedo = ( tex2D( _Texture, uv_Texture ) + ( sin( ( ( ase_vertex3Pos.x + mulTime4 + ase_vertex3Pos.z ) * ( _Frequency1 * 6.28318548202515 ) ) ) * _WaveLenght1 ) ).rgb;
			o.Alpha = 1;
		}

		ENDCG
	}
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=18900
0;631;1466;360;938.6353;100.6358;1;True;False
Node;AmplifyShaderEditor.RangedFloatNode;9;-1250.373,357.8437;Inherit;False;Property;_LineSpeed1;Line Speed;3;0;Create;True;0;0;0;False;0;False;1;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleTimeNode;4;-1016.227,363.0436;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.TauNode;6;-1095.559,576.8527;Inherit;False;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;7;-1098.515,467.9106;Inherit;False;Property;_Frequency1;Frequency;1;0;Create;True;0;0;0;False;0;False;1;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.PosVertexDataNode;8;-1023.054,180.2985;Inherit;False;0;0;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleAddOpNode;3;-813.3653,339.0613;Inherit;False;3;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;11;-907.645,469.5071;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;10;-679.6422,347.1139;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;5;-719.7571,459.9084;Inherit;False;Property;_WaveLenght1;Wave Lenght;2;0;Create;True;0;0;0;False;0;False;0.5423678;0.0239;1;0.05;0;1;FLOAT;0
Node;AmplifyShaderEditor.SinOpNode;2;-510.8171,342.4971;Inherit;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;12;-247.2861,341.6847;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;1;-496.4286,-31.67289;Inherit;True;Property;_Texture;Texture;0;0;Create;True;0;0;0;False;0;False;-1;a2960ffde020f27409e070d92fb2e00b;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;13;-164.8508,-67.30425;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;14;-32.30705,11.24015;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;259.6059,-4.909025;Float;False;True;-1;2;ASEMaterialInspector;0;0;Standard;Mask;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Opaque;0.5;True;True;0;False;Opaque;;Geometry;All;14;all;True;True;True;True;0;False;-1;True;5;False;-1;255;False;-1;255;False;-1;7;False;-1;3;False;-1;1;False;-1;1;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;True;0;0;False;-1;0;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;False;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;4;0;9;0
WireConnection;3;0;8;1
WireConnection;3;1;4;0
WireConnection;3;2;8;3
WireConnection;11;0;7;0
WireConnection;11;1;6;0
WireConnection;10;0;3;0
WireConnection;10;1;11;0
WireConnection;2;0;10;0
WireConnection;12;0;2;0
WireConnection;12;1;5;0
WireConnection;14;0;1;0
WireConnection;14;1;12;0
WireConnection;0;0;14;0
ASEEND*/
//CHKSM=E30D54BA6AA1A1B0CB3A92DF56FF135494C04251