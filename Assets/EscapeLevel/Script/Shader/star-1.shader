Shader "TF4R/Star-1" {
Properties {
	_Color ("Color", Color) = (1,1,0.87,1)
}

Category {
	Tags {"Queue"="Transparent" "IgnoreProjector"="True" "RenderType"="Transparent"}
	ZWrite Off
	Blend SrcAlpha OneMinusSrcAlpha

    SubShader {
    	LOD 100
    	
    	Pass {
            CGPROGRAM
#pragma vertex vert
#pragma fragment frag

#include "UnityCG.cginc"

float4 _Color;

struct v2f {
    float4  pos : SV_POSITION;
};

v2f vert (appdata_base v)
{
    v2f o;
    o.pos = mul (UNITY_MATRIX_MVP, v.vertex);
    return o;
}

half4 frag (v2f i) : COLOR
{
    return _Color;
}

ENDCG

}
}
}
}