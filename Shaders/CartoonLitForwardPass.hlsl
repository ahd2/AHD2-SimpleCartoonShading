#ifndef CARTOON_LIT_FORWARD_PASS_INCLUDED
#define CARTOON_LIT_FORWARD_PASS_INCLUDED

struct appdata
{
    float4 vertex : POSITION;
    float3 normalOS  : NORMAL;
    float4 tangentOS  : TANGENT;
    float2 uv : TEXCOORD0;
    float2 staticLightmapUV   : TEXCOORD1; //静态光照贴图UV
};

struct v2f
{
    float4 vertex : SV_POSITION;
    float2 uv : TEXCOORD0;
    float3 positionWS : TEXCOORD1;
    float3 normalWS : TEXCOORD2;
    half3 tangentWS  : TEXCOORD3;
    float3 viewDirWS : TEXCOORD4;
    float2 capUV : TEXCOORD5;
    float4 shadowCoord : TEXCOORD6;
    float4 lightmapUVOrVertexSH : TEXCOORD7;
    //DECLARE_LIGHTMAP_OR_SH(staticLightmapUV, vertexSH, 7);//第七通道为光照贴图uv
    half3 bitangentWS : TEXCOORD8;
};
float3 IndirectDiffuse( float2 uvStaticLightmap, float3 normalWS )
{
    #ifdef LIGHTMAP_ON
    return SampleLightmap( uvStaticLightmap, normalWS );
    #else
    return SampleSH(normalWS);
    #endif
}
v2f CartoonLitVertex (appdata v)
{
    v2f o;
    o.vertex = TransformObjectToHClip(v.vertex);
    o.uv = TRANSFORM_TEX(v.uv, _MainTex);
    
    o.positionWS = TransformObjectToWorld(v.vertex);
    VertexNormalInputs normalInput = GetVertexNormalInputs(v.normalOS, v.tangentOS);
    o.normalWS = normalInput.normalWS;
    o.tangentWS = normalInput.tangentWS;
    o.bitangentWS = normalInput.bitangentWS;

    o.viewDirWS = GetWorldSpaceNormalizeViewDir(o.positionWS); //方向从顶点指向摄像机
    //MatcapUV
    half3 reflectDir = reflect(-normalize(o.viewDirWS), o.normalWS);//世界空间下，看向平面的反射向量
    half3 reflectDirVS = normalize(mul(UNITY_MATRIX_V, reflectDir)); //将反射向量转换到视角空间，平面的反射方向永远包含于球面内。
    float m = 2.82842712474619 * sqrt(reflectDirVS.z + 1.0);//2倍法向量模长
    o.capUV = reflectDirVS.xy / m + 0.5;

    // 处理烘培光照
    OUTPUT_LIGHTMAP_UV(v.staticLightmapUV, unity_LightmapST, o.lightmapUVOrVertexSH.xy);
    OUTPUT_SH(o.normalWS, o.lightmapUVOrVertexSH.xyz);
    return o;
}

half4 CartoonLitFragment (v2f i) : SV_Target
{
    half3x3 TBN = half3x3(i.tangentWS.xyz, i.bitangentWS.xyz, i.normalWS.xyz);
    //法线贴图
    half3 normalMap = tex2D(_NormalMap,i.uv * _NormalMap_ST.xy + _NormalMap_ST.zw,ddx(i.uv.x),ddy(i.uv.y));
    normalMap = normalize(normalMap * 2 - 1);
    i.normalWS = TransformTangentToWorld(normalMap,half3x3(i.tangentWS,i.bitangentWS,i.normalWS));
    i.shadowCoord = TransformWorldToShadowCoord(i.positionWS);//这里采样才不会出现精度瑕疵
    //获取主光源
    Light mainLight = GetMainLight(i.shadowCoord);
    half shadow = mainLight.shadowAttenuation;//接受投射阴影
    half lambert = smoothstep(0,_ShadowShreshold,saturate(dot(i.normalWS, mainLight.direction)));//仿supercell卡通风格，二分化着色，但是阴影还是平滑一下。
    shadow *= lambert;//阴影
    half3 ambient = _GlossyEnvironmentColor.rgb;//环境光

    half4 col = tex2D(_MainTex, i.uv) * _BaseCol;
    // 采样光照贴图
    half3 lightmapColor = IndirectDiffuse( i.lightmapUVOrVertexSH.xy, i.normalWS);
    MixRealtimeAndBakedGI(mainLight, i.normalWS, lightmapColor, shadow);
    col.xyz *= lightmapColor;

    half4 finalcol = _ShadowRatio * col  + (1 - _ShadowRatio) *  col *  shadow ; //确定基础明暗
    finalcol.xyz = lerp(finalcol.xyz , finalcol.xyz * mainLight.color,shadow);//光照部分受方向光影响，阴影部分受环境光影响

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
    
    //金属matcap
    half4 mentalMatcapCol = tex2D(_MetalCap,i.capUV);
    //光滑matcap
    half4 roughnessMatcapCol = tex2D(_RoughnessCap,i.capUV);

    finalcol = lerp(finalcol,  0.8 * finalcol + _MetalIntensity *  finalcol * mentalMatcapCol,_Metalness);

    finalcol = lerp(finalcol, 0.8 * finalcol + _RoughnessIntensity * finalcol * roughnessMatcapCol,_Roughness);

    //菲涅尔
    half fresnel = saturate(pow(dot(i.viewDirWS,i.normalWS) , _FresnelRatio));
    finalcol.xyz  = lerp(_FresnelColor,finalcol,fresnel);

    //finalcol.xyz *= lightmapColor;

    
    return finalcol;
}
#endif