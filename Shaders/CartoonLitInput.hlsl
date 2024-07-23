#ifndef CARTOON_LIT_INPUT_INCLUDED
#define CARTOON_LIT_INPUT_INCLUDED
#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"

CBUFFER_START(UnityPerMaterial)
//贴图ST
float4 _MainTex_ST;
float4 _MetalCap_ST;
float4 _RoughnessCap_ST;
//half4
half4 _BaseCol;
//half
half _Metalness;
half _MetalIntensity;
half _Roughness;
half _RoughnessIntensity;

half _ShadowRatio;
half _ShadowShreshold;
//Test,测试用属性

CBUFFER_END

//贴图采样
sampler2D _MainTex;
sampler2D _MetalCap;
sampler2D _RoughnessCap;

#endif