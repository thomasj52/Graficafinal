// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Portal Glitch"
{
	Properties
	{
		_Noise("Noise", 2D) = "white" {}
		_Texture("Texture", 2D) = "white" {}
		_Distortion("Distortion", Range( 0 , 0.1)) = 0.01664249
		[HDR]_Color("Color", Color) = (0,0,0,0)
		_Intensity("Intensity", Range( 0 , 5)) = 0.1588235

	}
	
	SubShader
	{
		
		
		Tags { "RenderType"="Opaque" }
	LOD 100

		CGINCLUDE
		#pragma target 3.0
		ENDCG
		Blend Off
		AlphaToMask Off
		Cull Back
		ColorMask RGBA
		ZWrite On
		ZTest LEqual
		Offset 0 , 0
		
		
		
		Pass
		{
			Name "Unlit"
			Tags { "LightMode"="ForwardBase" }
			CGPROGRAM

			

			#ifndef UNITY_SETUP_STEREO_EYE_INDEX_POST_VERTEX
			//only defining to not throw compilation error over Unity 5.5
			#define UNITY_SETUP_STEREO_EYE_INDEX_POST_VERTEX(input)
			#endif
			#pragma vertex vert
			#pragma fragment frag
			#pragma multi_compile_instancing
			#include "UnityCG.cginc"
			#include "UnityShaderVariables.cginc"


			struct appdata
			{
				float4 vertex : POSITION;
				float4 color : COLOR;
				float4 ase_texcoord : TEXCOORD0;
				UNITY_VERTEX_INPUT_INSTANCE_ID
			};
			
			struct v2f
			{
				float4 vertex : SV_POSITION;
				#ifdef ASE_NEEDS_FRAG_WORLD_POSITION
				float3 worldPos : TEXCOORD0;
				#endif
				float4 ase_texcoord1 : TEXCOORD1;
				UNITY_VERTEX_INPUT_INSTANCE_ID
				UNITY_VERTEX_OUTPUT_STEREO
			};

			uniform sampler2D _Texture;
			uniform sampler2D _Noise;
			uniform float _Distortion;
			uniform float4 _Color;
			uniform float _Intensity;

			
			v2f vert ( appdata v )
			{
				v2f o;
				UNITY_SETUP_INSTANCE_ID(v);
				UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(o);
				UNITY_TRANSFER_INSTANCE_ID(v, o);

				o.ase_texcoord1.xy = v.ase_texcoord.xy;
				
				//setting value to unused interpolator channels and avoid initialization warnings
				o.ase_texcoord1.zw = 0;
				float3 vertexValue = float3(0, 0, 0);
				#if ASE_ABSOLUTE_VERTEX_POS
				vertexValue = v.vertex.xyz;
				#endif
				vertexValue = vertexValue;
				#if ASE_ABSOLUTE_VERTEX_POS
				v.vertex.xyz = vertexValue;
				#else
				v.vertex.xyz += vertexValue;
				#endif
				o.vertex = UnityObjectToClipPos(v.vertex);

				#ifdef ASE_NEEDS_FRAG_WORLD_POSITION
				o.worldPos = mul(unity_ObjectToWorld, v.vertex).xyz;
				#endif
				return o;
			}
			
			fixed4 frag (v2f i ) : SV_Target
			{
				UNITY_SETUP_INSTANCE_ID(i);
				UNITY_SETUP_STEREO_EYE_INDEX_POST_VERTEX(i);
				fixed4 finalColor;
				#ifdef ASE_NEEDS_FRAG_WORLD_POSITION
				float3 WorldPosition = i.worldPos;
				#endif
				float2 texCoord25 = i.ase_texcoord1.xy * float2( 1,1 ) + float2( 0,0 );
				float mulTime32 = _Time.y * 0.3;
				float temp_output_42_0 = ( floor( ( mulTime32 * 6.0 ) ) / 6.0 );
				float2 texCoord20 = i.ase_texcoord1.xy * float2( 1,1 ) + float2( 0,0 );
				float2 panner21 = ( temp_output_42_0 * float2( -0.4,0.1 ) + texCoord20);
				float2 texCoord44 = i.ase_texcoord1.xy * float2( 1,1 ) + float2( 0,0 );
				float2 appendResult54 = (float2(0.0015 , 0.0));
				float4 lerpResult64 = lerp( tex2D( _Texture, ( ( float4( texCoord25, 0.0 , 0.0 ) + ( tex2D( _Noise, panner21 ) * step( sin( ( ( texCoord44.y + temp_output_42_0 ) * 30.0 ) ) , 0.0 ) * _Distortion ) ) + float4( appendResult54, 0.0 , 0.0 ) ).rg ) , _Color , float4( 0,0,0,0 ));
				
				
				finalColor = ( lerpResult64 * _Intensity );
				return finalColor;
			}
			ENDCG
		}
	}
	CustomEditor "ASEMaterialInspector"
	
	
}
/*ASEBEGIN
Version=18900
288;73;1176;511;1256.198;-323.6011;1;True;False
Node;AmplifyShaderEditor.SimpleTimeNode;32;-798.4392,561.0045;Inherit;False;1;0;FLOAT;0.3;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;39;-906.6765,670.392;Inherit;False;Constant;_Frecuencia;Frecuencia;5;0;Create;True;0;0;0;False;0;False;6;0;0;15;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;40;-537.0573,561.0035;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.FloorOpNode;41;-326.3398,562.1557;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.WireNode;43;-223.7394,699.2999;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;44;-532.6207,913.1531;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleDivideOpNode;42;-149.0148,561.004;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.BreakToComponentsNode;45;-194.4377,912.4874;Inherit;False;FLOAT2;1;0;FLOAT2;0,0;False;16;FLOAT;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT;5;FLOAT;6;FLOAT;7;FLOAT;8;FLOAT;9;FLOAT;10;FLOAT;11;FLOAT;12;FLOAT;13;FLOAT;14;FLOAT;15
Node;AmplifyShaderEditor.SimpleAddOpNode;46;62.01514,936.8407;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;20;-278.0348,376.6999;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;48;286.5313,936.6806;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;30;False;1;FLOAT;0
Node;AmplifyShaderEditor.SinOpNode;47;467.3311,935.6807;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.PannerNode;21;24.53963,378.7403;Inherit;False;3;0;FLOAT2;0,0;False;2;FLOAT2;-0.4,0.1;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SamplerNode;22;282.0335,349.7521;Inherit;True;Property;_Noise;Noise;0;0;Create;True;0;0;0;False;0;False;-1;e666db4aa834dbf44ab03b53a4961814;e666db4aa834dbf44ab03b53a4961814;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.StepOpNode;49;696.6309,934.3806;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;23;298.2197,549.266;Inherit;False;Property;_Distortion;Distortion;4;0;Create;True;0;0;0;False;0;False;0.01664249;0;0;0.1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;63;734.4884,352.2257;Inherit;False;3;3;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;25;676.3562,203.7471;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;53;1246.644,431.9362;Inherit;False;Constant;_SeparacionRGB;SeparacionRGB;7;0;Create;True;0;0;0;False;0;False;0.0015;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;54;1537.212,393.0273;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleAddOpNode;69;983.0089,329.8748;Inherit;False;2;2;0;FLOAT2;0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;55;1699.13,331.3784;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT2;0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SamplerNode;27;1922.573,299.6225;Inherit;True;Property;_Texture;Texture;1;0;Create;True;0;0;0;False;0;False;-1;b17cea7f8dbaa36419f18f88ef995ae1;b17cea7f8dbaa36419f18f88ef995ae1;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;28;1931.871,639.2065;Inherit;False;Property;_Color;Color;5;1;[HDR];Create;True;0;0;0;False;0;False;0,0,0,0;0,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;30;2449.378,625.3325;Inherit;False;Property;_Intensity;Intensity;6;0;Create;True;0;0;0;False;0;False;0.1588235;0;0;5;0;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;64;2438.666,455.3089;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SamplerNode;50;1625.343,1470.67;Inherit;True;Property;_TextureSample0;Texture Sample 0;2;0;Create;True;0;0;0;False;0;False;-1;b17cea7f8dbaa36419f18f88ef995ae1;b17cea7f8dbaa36419f18f88ef995ae1;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;31;2766.582,454.8651;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.DynamicAppendNode;62;1924.806,1605.517;Inherit;False;FLOAT4;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;59;1457.056,1721.994;Inherit;False;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SamplerNode;51;1623.644,1689.929;Inherit;True;Property;_TextureSample1;Texture Sample 1;3;0;Create;True;0;0;0;False;0;False;-1;b17cea7f8dbaa36419f18f88ef995ae1;b17cea7f8dbaa36419f18f88ef995ae1;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.DynamicAppendNode;57;1234.897,1822.52;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;58;906.3287,1817.428;Inherit;False;Constant;_Float0;Float 0;7;0;Create;True;0;0;0;False;0;False;0.0015;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;0;3041.864,451.8281;Float;False;True;-1;2;ASEMaterialInspector;100;1;Portal Glitch;0770190933193b94aaa3065e307002fa;True;Unlit;0;0;Unlit;2;True;True;0;1;False;-1;0;False;-1;0;1;False;-1;0;False;-1;True;0;False;-1;0;False;-1;False;False;False;False;False;False;False;False;False;True;0;False;-1;True;True;0;False;-1;False;True;True;True;True;True;0;False;-1;False;False;False;False;False;False;False;True;False;255;False;-1;255;False;-1;255;False;-1;7;False;-1;1;False;-1;1;False;-1;1;False;-1;7;False;-1;1;False;-1;1;False;-1;1;False;-1;False;True;1;False;-1;True;3;False;-1;True;True;0;False;-1;0;False;-1;True;1;RenderType=Opaque=RenderType;True;2;0;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;1;LightMode=ForwardBase;False;0;;0;0;Standard;1;Vertex Position,InvertActionOnDeselection;1;0;1;True;False;;False;0
WireConnection;40;0;32;0
WireConnection;40;1;39;0
WireConnection;41;0;40;0
WireConnection;43;0;39;0
WireConnection;42;0;41;0
WireConnection;42;1;43;0
WireConnection;45;0;44;0
WireConnection;46;0;45;1
WireConnection;46;1;42;0
WireConnection;48;0;46;0
WireConnection;47;0;48;0
WireConnection;21;0;20;0
WireConnection;21;1;42;0
WireConnection;22;1;21;0
WireConnection;49;0;47;0
WireConnection;63;0;22;0
WireConnection;63;1;49;0
WireConnection;63;2;23;0
WireConnection;54;0;53;0
WireConnection;69;0;25;0
WireConnection;69;1;63;0
WireConnection;55;0;69;0
WireConnection;55;1;54;0
WireConnection;27;1;55;0
WireConnection;64;0;27;0
WireConnection;64;1;28;0
WireConnection;31;0;64;0
WireConnection;31;1;30;0
WireConnection;59;1;57;0
WireConnection;57;0;58;0
WireConnection;0;0;31;0
ASEEND*/
//CHKSM=A8BDC2DDC47D4D6771E27D01B41A2309547EE63A