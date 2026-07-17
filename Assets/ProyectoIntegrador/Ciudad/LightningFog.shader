// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "LightningFog"
{
	Properties
	{
		_Lightning("Lightning", Range( 0 , 1)) = 0
		_LightningColor("Lightning Color", Color) = (0.75,0.85,1,1)
		_BaseSmoothness("Base Smoothness", Float) = 0.55
		_LightningSmoothness("Lightning Smoothness", Float) = 1
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Opaque"  "Queue" = "Geometry+0" "IgnoreProjector" = "True" "IsEmissive" = "true"  }
		Cull Back
		CGPROGRAM
		#pragma target 3.0
		#pragma surface surf Standard keepalpha addshadow fullforwardshadows exclude_path:deferred 
		struct Input
		{
			half filler;
		};

		uniform float4 _LightningColor;
		uniform float _Lightning;
		uniform float _BaseSmoothness;
		uniform float _LightningSmoothness;

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			o.Emission = ( _LightningColor * _Lightning ).rgb;
			float lerpResult19 = lerp( _BaseSmoothness , _LightningSmoothness , _Lightning);
			o.Smoothness = lerpResult19;
			o.Alpha = 1;
		}

		ENDCG
	}
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=18900
0;843;1989;508;1655.721;107.3392;1.221297;True;False
Node;AmplifyShaderEditor.ColorNode;17;-507.4124,46.68196;Inherit;False;Property;_LightningColor;Lightning Color;6;0;Create;True;0;0;0;False;0;False;0.75,0.85,1,1;0,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;21;-1058.373,152.2753;Inherit;False;Property;_BaseSmoothness;Base Smoothness;7;0;Create;True;0;0;0;False;0;False;0.55;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;7;-451.3607,226.2285;Inherit;False;Property;_Lightning;Lightning;5;0;Create;True;0;0;0;False;0;False;0;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;22;-1086.603,227.5499;Inherit;False;Property;_LightningSmoothness;Lightning Smoothness;8;0;Create;True;0;0;0;False;0;False;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;3;-598.4492,330.5251;Inherit;True;Property;_TextureSample0;Texture Sample 0;3;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;6;-1230.449,871.5251;Inherit;False;Property;_NoiseSpeed;NoiseSpeed;4;0;Create;True;0;0;0;False;0;False;0.01;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.Vector2Node;5;-1233.449,537.5251;Inherit;False;Property;_NoiseTiling;NoiseTiling;3;0;Create;True;0;0;0;False;0;False;1,1;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;12;-1097.449,767.5251;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;9;-1037.449,519.5251;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.DynamicAppendNode;15;-914.4492,762.5251;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;2;-598.5489,547.7248;Inherit;False;Property;_FogAlpha;FogAlpha;1;0;Create;True;0;0;0;False;0;False;0.35;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;10;-755.4492,499.5251;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;18;-248.1287,51.90898;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.ColorNode;1;-617.4492,-131.4749;Inherit;False;Property;_FogColor;FogColor;0;0;Create;True;0;0;0;False;0;False;0.45,0.48,0.55,1;0,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;16;-187.5599,245.6339;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;19;-829.4155,156.4573;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleTimeNode;11;-1379.449,726.5251;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.TexturePropertyNode;4;-911.4492,298.5251;Inherit;True;Property;_NoiseTex;NoiseTex;2;0;Create;True;0;0;0;False;0;False;None;None;False;white;Auto;Texture2D;-1;0;2;SAMPLER2D;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;100.4055,12.17037;Float;False;True;-1;2;ASEMaterialInspector;0;0;Standard;LightningFog;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;False;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Opaque;0.5;True;True;0;False;Opaque;;Geometry;ForwardOnly;14;all;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;True;0;5;False;-1;10;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;2;0;0;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;False;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;3;0;4;0
WireConnection;3;1;10;0
WireConnection;12;0;11;0
WireConnection;12;1;6;0
WireConnection;9;0;5;0
WireConnection;15;0;12;0
WireConnection;15;1;12;0
WireConnection;10;0;9;0
WireConnection;10;1;15;0
WireConnection;18;0;17;0
WireConnection;18;1;7;0
WireConnection;16;0;3;1
WireConnection;16;1;2;0
WireConnection;19;0;21;0
WireConnection;19;1;22;0
WireConnection;19;2;7;0
WireConnection;0;2;18;0
WireConnection;0;4;19;0
ASEEND*/
//CHKSM=4AFB840D4FAD02FDD61D038A438F0FCF3F6FDF49