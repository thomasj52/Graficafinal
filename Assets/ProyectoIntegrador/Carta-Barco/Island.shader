// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Island"
{
	Properties
	{
		_IslandTexture("Island Texture", 2D) = "white" {}
		_heighttexture("height texture", 2D) = "white" {}
		_Height("Height", Vector) = (0,1,0,0)
		_Limit("Limit", Float) = 0
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Pass
		{
			ColorMask 0
			ZTest GEqual
			ZWrite On
		}

		Tags{ "RenderType" = "Opaque"  "Queue" = "Geometry+0" }
		Cull Back
		ZWrite On
		ZTest GEqual
		Stencil
		{
			Ref 5
			Comp Equal
			Pass Keep
		}
		CGPROGRAM
		#include "Tessellation.cginc"
		#pragma target 4.6
		#pragma surface surf Standard keepalpha addshadow fullforwardshadows vertex:vertexDataFunc tessellate:tessFunction 
		struct Input
		{
			float2 uv_texcoord;
		};

		uniform sampler2D _heighttexture;
		uniform float4 _heighttexture_ST;
		uniform float3 _Height;
		uniform float _Limit;
		uniform sampler2D _IslandTexture;
		uniform float4 _IslandTexture_ST;

		float4 tessFunction( appdata_full v0, appdata_full v1, appdata_full v2 )
		{
			return UnityEdgeLengthBasedTess (v0.vertex, v1.vertex, v2.vertex, 0.2);
		}

		void vertexDataFunc( inout appdata_full v )
		{
			float2 uv_heighttexture = v.texcoord * _heighttexture_ST.xy + _heighttexture_ST.zw;
			float4 tex2DNode7 = tex2Dlod( _heighttexture, float4( uv_heighttexture, 0, 0.0) );
			float4 temp_cast_1 = (_Limit).xxxx;
			float4 clampResult9 = clamp( ( tex2DNode7 * float4( _Height , 0.0 ) ) , float4( 0,0,0,0 ) , temp_cast_1 );
			v.vertex.xyz += clampResult9.rgb;
			v.vertex.w = 1;
		}

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float2 uv_IslandTexture = i.uv_texcoord * _IslandTexture_ST.xy + _IslandTexture_ST.zw;
			o.Albedo = tex2D( _IslandTexture, uv_IslandTexture ).rgb;
			o.Alpha = 1;
		}

		ENDCG
	}
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=18900
0;631;1465;360;1396.043;-114.3739;1;True;False
Node;AmplifyShaderEditor.Vector3Node;4;-630.9231,379.958;Inherit;False;Property;_Height;Height;2;0;Create;True;0;0;0;False;0;False;0,1,0;0,1,0;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.SamplerNode;7;-1167.185,139.1898;Inherit;True;Property;_heighttexture;height texture;1;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;3;-382.9729,276.0294;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT3;0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;10;-388.158,401.2725;Inherit;False;Property;_Limit;Limit;3;0;Create;True;0;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.EdgeLengthTessNode;5;-248.8652,514.3315;Inherit;False;1;0;FLOAT;0.2;False;1;FLOAT4;0
Node;AmplifyShaderEditor.SamplerNode;1;-391.6062,-4.39815;Inherit;True;Property;_IslandTexture;Island Texture;0;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ClampOpNode;9;-188.0847,300.6809;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;COLOR;1,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SmoothstepOpNode;12;-823.1576,222.3284;Inherit;True;3;0;COLOR;0,0,0,0;False;1;COLOR;1,1,1,0;False;2;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;0,0;Float;False;True;-1;6;ASEMaterialInspector;0;0;Standard;Island;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Back;1;False;-1;4;False;-1;False;0;False;-1;0;False;-1;True;4;Opaque;0.5;True;True;0;False;Opaque;;Geometry;All;14;all;True;True;True;True;0;False;-1;True;5;False;-1;255;False;-1;255;False;-1;5;False;-1;1;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;True;2;15;10;25;False;0.5;True;0;0;False;-1;0;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;False;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;3;0;7;0
WireConnection;3;1;4;0
WireConnection;9;0;3;0
WireConnection;9;2;10;0
WireConnection;12;0;7;0
WireConnection;0;0;1;0
WireConnection;0;11;9;0
WireConnection;0;14;5;0
ASEEND*/
//CHKSM=17BAE604F80022B131C108D0A277AE06201EFC25