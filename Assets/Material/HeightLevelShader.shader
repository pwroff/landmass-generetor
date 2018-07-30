Shader "Terrain/LIT/HeightLevelShader" {
	Properties {
		_Color ("Color", Color) = (1,1,1,1)
		_MainTex ("Albedo (RGB)", 2D) = "white" {}
		_Glossiness ("Smoothness", Range(0,1)) = 0.5
		_Metallic ("Metallic", Range(0,1)) = 0.0
		_WorldMaxHeight("WorldMaxHeigth", Float) = 100.0
		_LowTex("LowLevelTexture (RGB)", 2D) = "white" {}
		_LowTexNormal("LowLevelNormal (RGB)", 2D) = "bump" {}
		_LowTexThresh("LowLevelThreshold", Range(0,1)) = 0.0
		_MidTex("MidLevelTexture (RGB)", 2D) = "white" {}
		_MidTexNormal("MidLevelNormal (RGB)", 2D) = "bump" {}
		_MidTexThresh("MidLevelThreshold", Range(0,1)) = 0.5
		_HighTex("HighLevelTexture (RGB)", 2D) = "white" {}
		_HighTexNormal("HighLevelNormal (RGB)", 2D) = "bump" {}
		_HighTexThresh("HighLevelThreshold", Range(0,1)) = 1.0
		_BlendThresh("LevelsBlendThreshold", Range(0,0.5)) = 0.1
	}
	SubShader {
		Tags { "RenderType"="Opaque" }
		LOD 200

		CGPROGRAM
		// Physically based Standard lighting model, and enable shadows on all light types
		#pragma surface surf Standard fullforwardshadows

		// Use shader model 3.0 target, to get nicer looking lighting
		#pragma target 3.0

		sampler2D _MainTex;
		sampler2D _LowTex;
		sampler2D _LowTexNormal;
		sampler2D _MidTex;
		sampler2D _MidTexNormal;
		sampler2D _HighTex;
		sampler2D _HighTexNormal;

		struct Input {
			float2 uv_MainTex;
			float3 worldPos;
		};

		half _Glossiness;
		half _Metallic;
		half _WorldMaxHeight;
		fixed4 _Color;
		half _LowTexThresh;
		half _MidTexThresh;
		half _HighTexThresh;
		half _BlendThresh;

		// Add instancing support for this shader. You need to check 'Enable Instancing' on materials that use the shader.
		// See https://docs.unity3d.com/Manual/GPUInstancing.html for more information about instancing.
		// #pragma instancing_options assumeuniformscaling
		UNITY_INSTANCING_BUFFER_START(Props)
			// put more per-instance properties here
		UNITY_INSTANCING_BUFFER_END(Props)

		fixed4 calculateColor(float3 wp, float2 uv, sampler2D lowtex, sampler2D midtex, sampler2D hightex)
		{
			half thresh = wp.y / _WorldMaxHeight;
			if (thresh >= _HighTexThresh)
			{
				half until = thresh / (_HighTexThresh + _BlendThresh);
				if (until >= 1)
					return tex2D(hightex, uv);
				return tex2D(hightex, uv)*until + (1 - until)*tex2D(midtex, uv);
			}
			if (thresh >= _MidTexThresh)
			{
				half until = thresh / (_MidTexThresh + _BlendThresh);
				if (until >= 1)
					return tex2D(midtex, uv);
				return tex2D(midtex, uv)*until + (1 - until)*tex2D(lowtex, uv);
			}
			if (thresh >= _MidTexThresh - _BlendThresh)
			{
				half until = thresh / _MidTexThresh + _BlendThresh;
				return tex2D(lowtex, uv)*until + (1 - until)*tex2D(midtex, uv);
			}
			return tex2D(lowtex, uv);
		}

		void surf (Input IN, inout SurfaceOutputStandard o) {
			fixed4 c = calculateColor(IN.worldPos, IN.uv_MainTex, _LowTex, _MidTex, _HighTex) * _Color;
			o.Albedo = c.rgb;
			o.Normal = UnpackNormal(calculateColor(IN.worldPos, IN.uv_MainTex, _LowTexNormal, _MidTexNormal, _HighTexNormal));
			o.Metallic = _Metallic;
			o.Smoothness = _Glossiness;
			o.Alpha = c.a;
		}
		ENDCG
	}
	FallBack "Diffuse"
}
