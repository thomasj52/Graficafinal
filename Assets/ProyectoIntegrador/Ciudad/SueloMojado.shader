// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "SueloMojado"
{
	Properties
	{
		_NormalMap("NormalMap", 2D) = "white" {}
		_ColorBase("ColorBase", Color) = (1,1,1,1)
		_MainTex("MainTex", 2D) = "white" {}
		_Roughness("Roughness", 2D) = "white" {}
		_Tiling("Tiling", Vector) = (4,4,0,0)
		_WetMaskTiling("WetMaskTiling", Vector) = (4,4,0,0)
		_WetMask("WetMask", 2D) = "white" {}
		_WetAmount("WetAmount", Range( 0 , 1)) = 1
		_WetDarkness("WetDarkness", Range( 0.3 , 1)) = 0.55
		_WetSmoothness("WetSmoothness", Range( 0.3 , 1)) = 0.95
		_WetContrast("WetContrast", Float) = 4
		_WaterNormal("WaterNormal", 2D) = "white" {}
		_WaterNormalTilling("WaterNormalTilling", Vector) = (3,3,0,0)
		_WaterSpped("WaterSpped", Float) = 0.03
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Opaque"  "Queue" = "Geometry+0" }
		Cull Back
		CGPROGRAM
		#include "UnityShaderVariables.cginc"
		#pragma target 3.0
		#pragma surface surf Standard keepalpha addshadow fullforwardshadows 
		struct Input
		{
			float2 uv_texcoord;
		};

		uniform sampler2D _NormalMap;
		uniform float2 _Tiling;
		uniform sampler2D _WaterNormal;
		uniform float2 _WaterNormalTilling;
		uniform float _WaterSpped;
		uniform sampler2D _WetMask;
		uniform float2 _WetMaskTiling;
		uniform float _WetAmount;
		uniform float _WetContrast;
		uniform sampler2D _MainTex;
		uniform float4 _ColorBase;
		uniform float _WetDarkness;
		uniform sampler2D _Roughness;
		uniform float4 _Roughness_ST;
		uniform float _WetSmoothness;

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float2 uv_TexCoord31 = i.uv_texcoord * _Tiling;
			float2 TexCoord49 = uv_TexCoord31;
			float3 NormalMap57 = UnpackNormal( tex2D( _NormalMap, TexCoord49 ) );
			float2 uv_TexCoord96 = i.uv_texcoord * _WaterNormalTilling;
			float temp_output_92_0 = ( _Time.y * _WaterSpped );
			float2 appendResult94 = (float2(temp_output_92_0 , ( temp_output_92_0 * -0.5 )));
			float3 WaterNormalMap103 = UnpackNormal( tex2D( _WaterNormal, ( uv_TexCoord96 + appendResult94 ) ) );
			float2 uv_TexCoord78 = i.uv_texcoord * _WetMaskTiling;
			float4 temp_cast_0 = (_WetContrast).xxxx;
			float4 WetMask53 = pow( ( tex2D( _WetMask, uv_TexCoord78 ) * _WetAmount ) , temp_cast_0 );
			float3 lerpResult100 = lerp( NormalMap57 , WaterNormalMap103 , WetMask53.rgb);
			o.Normal = lerpResult100;
			float4 AlbedoNormal65 = ( tex2D( _MainTex, TexCoord49 ) * _ColorBase );
			float4 lerpResult46 = lerp( AlbedoNormal65 , ( AlbedoNormal65 * _WetDarkness ) , WetMask53);
			o.Albedo = lerpResult46.rgb;
			float2 uv_Roughness = i.uv_texcoord * _Roughness_ST.xy + _Roughness_ST.zw;
			float4 Roughness59 = ( 1.0 - tex2D( _Roughness, uv_Roughness ) );
			float4 temp_cast_3 = (_WetSmoothness).xxxx;
			float4 lerpResult47 = lerp( Roughness59 , temp_cast_3 , WetMask53);
			float4 SmoothnessFinal62 = lerpResult47;
			o.Smoothness = SmoothnessFinal62.r;
			o.Alpha = 1;
		}

		ENDCG
	}
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=18900
0;843;1989;508;991.2156;-125.6305;1.968254;True;False
Node;AmplifyShaderEditor.CommentaryNode;73;-1667.511,981.4925;Inherit;False;1762.679;385.2932;WetMask;9;53;74;75;39;78;40;77;84;85;;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;70;-1454.388,261.8655;Inherit;False;765.4984;239.863;Texture Coordinates;3;30;31;49;;1,1,1,1;0;0
Node;AmplifyShaderEditor.Vector2Node;77;-1616.945,1230.536;Inherit;False;Property;_WetMaskTiling;WetMaskTiling;5;0;Create;True;0;0;0;False;0;False;4,4;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.Vector2Node;30;-1404.388,337.7285;Inherit;False;Property;_Tiling;Tiling;4;0;Create;True;0;0;0;False;0;False;4,4;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.CommentaryNode;104;-1680.846,1386.775;Inherit;False;1391.177;607;WaterMask;11;89;91;92;95;88;96;94;87;97;86;103;;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;71;-1466.464,512.3732;Inherit;False;1137.97;443.2778;Smoothness;5;34;35;36;59;76;;1,1,1,1;0;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;31;-1198.388,318.7285;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TexturePropertyNode;40;-1416.274,1031.492;Inherit;True;Property;_WetMask;WetMask;6;0;Create;True;0;0;0;False;0;False;None;None;False;white;Auto;Texture2D;-1;0;2;SAMPLER2D;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.TextureCoordinatesNode;78;-1414.373,1232.551;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleTimeNode;91;-1630.846,1796.775;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;89;-1623.846,1877.775;Inherit;False;Property;_WaterSpped;WaterSpped;13;0;Create;True;0;0;0;False;0;False;0.03;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;92;-1424.846,1798.775;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;49;-912.889,311.8655;Inherit;False;TexCoord;-1;True;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;85;-962.2134,1292.306;Inherit;False;Property;_WetAmount;WetAmount;7;0;Create;True;0;0;0;False;0;False;1;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;39;-1130.627,1094.033;Inherit;True;Property;_TextureSample3;Texture Sample 3;6;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.CommentaryNode;68;-1446.376,-665.2048;Inherit;False;1230.508;467.0637;AlbedoNormal;6;18;17;33;65;15;50;;1,1,1,1;0;0
Node;AmplifyShaderEditor.TexturePropertyNode;34;-1416.464,562.3732;Inherit;True;Property;_Roughness;Roughness;3;0;Create;True;0;0;0;False;0;False;51430ce2313cf9d47b03ccd2f7b9ad05;cda6ec74e3a3f3f49840fe742aa14b01;False;white;Auto;Texture2D;-1;0;2;SAMPLER2D;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;95;-1253.846,1857.775;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;-0.5;False;1;FLOAT;0
Node;AmplifyShaderEditor.TexturePropertyNode;18;-1396.376,-599.2527;Inherit;True;Property;_MainTex;MainTex;2;0;Create;True;0;0;0;False;0;False;82802ccdfaa3ee74aaf637c950232fcc;cda6ec74e3a3f3f49840fe742aa14b01;False;white;Auto;Texture2D;-1;0;2;SAMPLER2D;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;84;-718.0636,1114.796;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SamplerNode;35;-1122.116,725.6509;Inherit;True;Property;_TextureSample2;Texture Sample 2;5;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.GetLocalVarNode;50;-1282.945,-413.4907;Inherit;False;49;TexCoord;1;0;OBJECT;;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;75;-664.0577,1219.68;Inherit;False;Property;_WetContrast;WetContrast;10;0;Create;True;0;0;0;False;0;False;4;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.Vector2Node;88;-1553.846,1654.775;Inherit;False;Property;_WaterNormalTilling;WaterNormalTilling;12;0;Create;True;0;0;0;False;0;False;3,3;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.CommentaryNode;69;-1446.33,-185.8223;Inherit;False;936.7686;443.4166;NormalMap;4;51;4;1;57;;1,1,1,1;0;0
Node;AmplifyShaderEditor.DynamicAppendNode;94;-1104.845,1797.775;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.ColorNode;15;-971.1886,-410.1413;Inherit;False;Property;_ColorBase;ColorBase;1;0;Create;True;0;0;0;False;0;False;1,1,1,1;0,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.PowerNode;74;-566.6063,1113.714;Inherit;False;False;2;0;COLOR;0,0,0,0;False;1;FLOAT;1;False;1;COLOR;0
Node;AmplifyShaderEditor.OneMinusNode;36;-777.0789,727.2066;Inherit;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SamplerNode;17;-1044.452,-598.2686;Inherit;True;Property;_TextureSample1;Texture Sample 1;5;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TextureCoordinatesNode;96;-1316.455,1636.091;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.GetLocalVarNode;51;-1269.589,52.3177;Inherit;False;49;TexCoord;1;0;OBJECT;;False;1;FLOAT2;0
Node;AmplifyShaderEditor.TexturePropertyNode;4;-1396.33,-135.8223;Inherit;True;Property;_NormalMap;NormalMap;0;0;Create;True;0;0;0;False;0;False;aa0c3ea8965be9a4ab87cce181643e37;31c6163b6243da04d8523e5aa3b6c810;False;white;Auto;Texture2D;-1;0;2;SAMPLER2D;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.SimpleAddOpNode;97;-1065.455,1636.091;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.CommentaryNode;72;-301.8006,522.001;Inherit;False;784.4194;301.8602;Smoothness Final;5;60;43;55;47;62;;1,1,1,1;0;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;53;-109.7676,1106.536;Inherit;False;WetMask;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;33;-583.2893,-589.8021;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.TexturePropertyNode;87;-1160.846,1436.775;Inherit;True;Property;_WaterNormal;WaterNormal;11;0;Create;True;0;0;0;False;0;False;b59a96d28fb580141956844b613d65b2;b59a96d28fb580141956844b613d65b2;False;white;Auto;Texture2D;-1;0;2;SAMPLER2D;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.RegisterLocalVarNode;59;-552.4955,715.302;Inherit;False;Roughness;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;55;16.26168,707.8612;Inherit;False;53;WetMask;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;43;-256.8011,677.5287;Inherit;False;Property;_WetSmoothness;WetSmoothness;9;0;Create;True;0;0;0;False;0;False;0.95;0.3;0.3;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;65;-434.5901,-597.6108;Inherit;False;AlbedoNormal;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;60;-150.2365,573.0625;Inherit;False;59;Roughness;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.SamplerNode;86;-904.4938,1579.685;Inherit;True;Property;_TextureSample4;Texture Sample 4;11;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;True;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;1;-1088.216,27.59431;Inherit;True;Property;_TextureSample0;Texture Sample 0;0;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;True;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;42;1121.469,106.3974;Inherit;False;Property;_WetDarkness;WetDarkness;8;0;Create;True;0;0;0;False;0;False;0.55;0;0.3;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;67;1204.912,29.19766;Inherit;False;65;AlbedoNormal;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.LerpOp;47;37.96991,578.8922;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;103;-526.6698,1575.846;Inherit;False;WaterNormalMap;-1;True;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;57;-733.5618,26.51292;Inherit;False;NormalMap;-1;True;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.GetLocalVarNode;66;1430.912,-43.80231;Inherit;False;65;AlbedoNormal;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;101;1577.993,188.3892;Inherit;False;57;NormalMap;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.GetLocalVarNode;56;1628.186,80.38847;Inherit;False;53;WetMask;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;45;1419.862,31.82022;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;62;245.6186,640.001;Inherit;False;SmoothnessFinal;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;102;1584.911,334.7151;Inherit;False;53;WetMask;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;105;1546.133,262.8539;Inherit;False;103;WaterNormalMap;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.LerpOp;100;1799.251,190.8925;Inherit;False;3;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.GetLocalVarNode;61;1824.665,425.229;Inherit;False;62;SmoothnessFinal;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;76;-1353.654,831.8083;Inherit;False;49;TexCoord;1;0;OBJECT;;False;1;FLOAT2;0
Node;AmplifyShaderEditor.LerpOp;46;1652.173,-40.39222;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;2247.83,-36.62964;Float;False;True;-1;2;ASEMaterialInspector;0;0;Standard;SueloMojado;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Opaque;0.5;True;True;0;False;Opaque;;Geometry;All;14;all;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;True;0;0;False;-1;0;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;False;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;31;0;30;0
WireConnection;78;0;77;0
WireConnection;92;0;91;0
WireConnection;92;1;89;0
WireConnection;49;0;31;0
WireConnection;39;0;40;0
WireConnection;39;1;78;0
WireConnection;95;0;92;0
WireConnection;84;0;39;0
WireConnection;84;1;85;0
WireConnection;35;0;34;0
WireConnection;94;0;92;0
WireConnection;94;1;95;0
WireConnection;74;0;84;0
WireConnection;74;1;75;0
WireConnection;36;0;35;0
WireConnection;17;0;18;0
WireConnection;17;1;50;0
WireConnection;96;0;88;0
WireConnection;97;0;96;0
WireConnection;97;1;94;0
WireConnection;53;0;74;0
WireConnection;33;0;17;0
WireConnection;33;1;15;0
WireConnection;59;0;36;0
WireConnection;65;0;33;0
WireConnection;86;0;87;0
WireConnection;86;1;97;0
WireConnection;1;0;4;0
WireConnection;1;1;51;0
WireConnection;47;0;60;0
WireConnection;47;1;43;0
WireConnection;47;2;55;0
WireConnection;103;0;86;0
WireConnection;57;0;1;0
WireConnection;45;0;67;0
WireConnection;45;1;42;0
WireConnection;62;0;47;0
WireConnection;100;0;101;0
WireConnection;100;1;105;0
WireConnection;100;2;102;0
WireConnection;46;0;66;0
WireConnection;46;1;45;0
WireConnection;46;2;56;0
WireConnection;0;0;46;0
WireConnection;0;1;100;0
WireConnection;0;4;61;0
ASEEND*/
//CHKSM=E84D32A9FC0A52FEA12D62F675BECAF434AE0C50