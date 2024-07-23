#ifndef CARTOON_LIT_FORWARD_PASS_INCLUDED
#define CARTOON_LIT_FORWARD_PASS_INCLUDED

struct appdata
{
    float4 vertex : POSITION;
    float3 normalOS  : NORMAL;
    float2 uv : TEXCOORD0;
    float2 staticLightmapUV   : TEXCOORD1; //静态光照贴图UV
};

struct v2f
{
    float4 vertex : SV_POSITION;
    float2 uv : TEXCOORD0;
    float3 positionWS : TEXCOORD1;
    float3 normalWS : TEXCOORD2;
    float3 viewDirWS : TEXCOORD4;
    float4 shadowCoord : TEXCOORD6;
    DECLARE_LIGHTMAP_OR_SH(staticLightmapUV, vertexSH, 7);//第七通道为光照贴图uv
};

v2f CartoonLitVertex (appdata v)
{
    v2f o;
    o.vertex = TransformObjectToHClip(v.vertex);
    o.uv = TRANSFORM_TEX(v.uv, _MainTex);
    
    o.positionWS = TransformObjectToWorld(v.vertex);
    o.normalWS = TransformObjectToWorldNormal(v.normalOS);

    o.viewDirWS = GetWorldSpaceNormalizeViewDir(o.positionWS); //方向从顶点指向摄像机

    // 处理烘培光照
    OUTPUT_LIGHTMAP_UV(v.staticLightmapUV, unity_LightmapST, o.staticLightmapUV);
    OUTPUT_SH(o.normalWS, o.vertexSH);
    return o;
}

half4 CartoonLitFragment (v2f i) : SV_Target
{
    i.shadowCoord = TransformWorldToShadowCoord(i.positionWS);//这里采样才不会出现精度瑕疵
    //获取主光源
    Light mainLight = GetMainLight(i.shadowCoord);
    half shadow = mainLight.shadowAttenuation;//接受投射阴影
    half lambert = smoothstep(0,_ShadowShreshold,saturate(dot(i.normalWS, mainLight.direction)));//仿supercell卡通风格，二分化着色，但是阴影还是平滑一下。
    shadow *= lambert;//阴影
    half3 ambient = _GlossyEnvironmentColor.rgb;//环境光
    
    half4 col = tex2D(_MainTex, i.uv) * _BaseCol;

    half4 finalcol = _ShadowRatio * col  + (1 - _ShadowRatio) *  col *  shadow ; //确定基础明暗
    finalcol.xyz = lerp(finalcol.xyz * ambient, finalcol.xyz * mainLight.color,shadow);//光照部分受方向光影响，阴影部分受环境光影响

    //多光源
    uint pixelLightCount = GetAdditionalLightsCount();
    half4 pointLightColor = half4(0,0,0,1);
    for (uint lightIndex = 0; lightIndex < pixelLightCount; ++lightIndex)
    {
        Light light = GetAdditionalLight(lightIndex, i.positionWS);
        lambert = smoothstep(0,0.8,saturate(dot(i.normalWS, light.direction)));
        pointLightColor.xyz += light.color * lambert * saturate(light.distanceAttenuation);
    }
    finalcol.xyz += pointLightColor.xyz;

    //MatcapUV
    half3 reflectDir = reflect(-normalize(i.viewDirWS), i.normalWS);
    half3 reflectDirVS = normalize(mul(UNITY_MATRIX_V, reflectDir)); // View Space
    float m = 2.82842712474619 * sqrt(reflectDirVS.z + 1.0);
    half2 capUV = reflectDirVS.xy / m + 0.5;
    //金属matcap
    half4 mentalMatcapCol = tex2D(_MetalCap,capUV);
    //光滑matcap
    half4 roughnessMatcapCol = tex2D(_RoughnessCap,capUV);

    finalcol = lerp(finalcol,  0.8 * finalcol + _MetalIntensity *  finalcol * mentalMatcapCol,_Metalness);

    finalcol = lerp(finalcol, 0.8 * finalcol + _RoughnessIntensity * finalcol * roughnessMatcapCol,_Roughness);

    // 采样光照贴图
    
    half3 lightmapColor = SAMPLE_GI(i.staticLightmapUV, i.vertexSH, i.normalWS);
    half3 indirectDiffuse = lightmapColor.rgb;

    finalcol.xyz *= indirectDiffuse;
    return finalcol;
}
#endif