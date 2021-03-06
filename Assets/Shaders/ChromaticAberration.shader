﻿Shader "Hidden/ChromaticAberration"
{
	Properties
	{
		_MainTex("Texture", 2D) = "white" {}
		_AberrationAmount("AberrationAmount", Range(0.0, 1)) = 0.01

	}
    SubShader
    {
        // No culling or depth
        Cull Off ZWrite Off ZTest Always

        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            #include "UnityCG.cginc"

            struct appdata
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
            };

            struct v2f
            {
                float2 uv : TEXCOORD0;
                float4 vertex : SV_POSITION;
            };

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = v.uv;
                return o;
            }

            sampler2D _MainTex;
			float _AberrationAmount;

            fixed4 frag (v2f i) : SV_Target
            {
				fixed4 col = tex2D(_MainTex, i.uv);
				
				// get distance from center of the screen 
				float xFromCenter = (i.uv.x - 0.5);
				float yFromCenter = (i.uv.y - 0.5);

				// apply aberration based off distance from screen
				float R = tex2D(_MainTex, float2(i.uv.x - _AberrationAmount * xFromCenter, i.uv.y - _AberrationAmount * yFromCenter)).r;
				float G = tex2D(_MainTex, i.uv).g;
				float B = tex2D(_MainTex, float2(i.uv.x + _AberrationAmount * xFromCenter, i.uv.y + _AberrationAmount * yFromCenter)).b;

				return fixed4(R,G,B,1);
            }
            ENDCG
        }
    }
}
