Shader "TF4R/SpriteNoBlend" {
Properties {
	_MainTex ("Atlas", 2D) = "white" {}
	_Color ("Color", Color) = (1,1,1,1)
//	_Width ("Sprite width", Float) = 64
//	_Height ("Sprite height", Float) = 32
	_Rows ("Rows", Float) = 1
	_Columns ("Columns", Float) = 4
	_Size ("Number of frames", Float) = 4
	_Frame ("Current frame (start at 0)", Float) = 0
//	_AtlasWidth ("Atlas width", Float) = 256
//	_AtlasHeight ("Atlas height", Float) = 32
    _SpriteVsAtlasWidthRatio ("Ratio between sprite and atlas width\nIf atlas width is 256 and sprite width is 64 then ratio is 4") = 4
    _SpriteVsAtlasHeightRatio ("Ratio between sprite and atlas width\nIf atlas width is 256 and sprite width is 64 then ratio is 4") = 4
}

Category {
	Tags {"Queue"="Transparent" "IgnoreProjector"="True" "RenderType"="Transparent"}
	ZWrite Off
	Blend SrcAlpha OneMinusSrcAlpha

    SubShader {
    	LOD 200
    	
    	Pass {

            CGPROGRAM
#pragma vertex vert
#pragma fragment frag

#include "UnityCG.cginc"

float4 _Color;
float4 _Width;
float4 _Height;
float4 _AtlasWidth;
float4 _AtlasHeight;
float4 _Rows;
float4 _Columns;
float4 _Size;
float4 _Frame;
sampler2D _MainTex;

struct v2f {
    float4  pos : SV_POSITION;
    float2  uv : TEXCOORD0;
};

float4 _MainTex_ST;

/*
4
1

1

_Frame % columns

1.0 / (_AtlasWidth / _Width)

=> 0 -> 0.25 / 0.25 -> 0.5 / 0.5 -> 0.75 / 0.75 -> 1

*/

v2f vert (appdata_base v)
{
    v2f o;
    o.pos = mul (UNITY_MATRIX_MVP, v.vertex);
    if( _Frame >= _Size ) {
        _Frame = _Size - 1;
    }
    
    o.uv = TRANSFORM_TEX (v.texcoord, _MainTex);
    return o;
}

half4 frag (v2f i) : COLOR
{
    half4 texcol = tex2D (_MainTex, i.uv);
    return texcol * _Color;
}
ENDCG

    	}
    }
}
}
