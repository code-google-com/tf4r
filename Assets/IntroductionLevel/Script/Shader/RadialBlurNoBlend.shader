Shader "TF4R/RadialBlur" 
{
	Properties {
		_MainTex ("Base (RGB)", 2D) = "" {}
		_BlurRadius ("Blur radius", Float) = 0.01
		_Color ("Color", Color) = (1,1,1,1)
	}
	
	 
	
	CGINCLUDE
		
	#include "UnityCG.cginc"
	
	struct v2f {
		float4 pos : POSITION;
		float2 uv : TEXCOORD0;
		float2 blurVector : TEXCOORD1;
	};
		
	sampler2D _MainTex;
	
	float _BlurRadius;
	float4 _BlurRadius4;
	float4 _SunPosition;
	float4 _Color;

	float4 _MainTex_TexelSize;
		
	v2f vert( appdata_img v ) {
		v2f o;
		o.pos = mul(UNITY_MATRIX_MVP, v.vertex);
		o.uv.xy =  v.texcoord.xy;
		
	    _SunPosition = float4(0.5,0.5,0,0);
		_BlurRadius4 = float4(_BlurRadius,_BlurRadius,0,0);
		
		o.blurVector = (_SunPosition.xy - v.texcoord.xy) * _BlurRadius4.xy;	
		
		return o; 
	}
	
	#define SAMPLES_FLOAT 10.0f
	#define SAMPLES_INT 10
	
	half4 frag(v2f i) : COLOR 
	{
		half4 color = half4(0,0,0,0);

		for(int j = 0; j < SAMPLES_INT; j++)   
		{	
			half4 tmpColor = tex2D(_MainTex, i.uv.xy);
			color += tmpColor;
			
			i.uv.xy += i.blurVector; 	
		}
		
		return (color / SAMPLES_FLOAT) * _Color;
	}

	ENDCG
	
Subshader
{
 Tags {"Queue"="Transparent" "IgnoreProjector"="True" "RenderType"="Transparent"}
	LOD 250
// Blend SrcAlpha One
 Blend SrcAlpha OneMinusSrcAlpha
 Pass {
	  ZTest Always Cull Off ZWrite Off
	  Fog { Mode off }      

      CGPROGRAM
      #pragma fragmentoption ARB_precision_hint_fastest
      #pragma vertex vert
      #pragma fragment frag
      
      ENDCG
  } // Pass
} // Subshader

Fallback off

} // shader