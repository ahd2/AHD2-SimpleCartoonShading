Shader "AHD2SimpleCartoonShading/CartoonLit"
{
    Properties
    {
        [Header(MainColor)]
        [Space(10)]
        _MainTex ("Texture", 2D) = "white" {}
        _BaseCol("BaseCol", Color) = (1, 1, 1, 1)
        
        [Header(FakePBR)]
        [Space(10)]
        //法线
        _NormalMap("NormalMap", 2D) = "bump" { }
        
        [Space(10)]
        //金属度粗糙度
        _MetalCap("MetalCap", 2D) = "" { }
        _Metalness("Metalness", Range(0,1)) = 0.0
        _MetalIntensity("金属度亮度", Range(0,1)) = 1
        [Space(10)]
        _RoughnessCap("RoughnessCap", 2D) = "" { }
        _Roughness("Roughness", Range(0,1)) = 0.0
        _RoughnessIntensity("粗糙度亮度", Range(0,1)) = 0.27
        [Space(10)]
        //菲涅尔
        _FresnelColor("菲涅尔颜色", Color) = (0, 0, 0, 1)
        _FresnelRatio("菲涅尔范围", Range(0.01,1)) = 0.01
        //阴影
        [Header(Shadow)]
        [Space(10)]
        _ShadowRatio("阴影浓度", Range(0.01,1)) = 0.7
        _ShadowShreshold("阴影过渡阈值", Range(0.03,1)) = 0.8
        //Test,测试用属性
        
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }

        Pass
        {
            //光照Pass
            Name "CartoonForwardLit"
            HLSLPROGRAM
            #pragma vertex CartoonLitVertex
            #pragma fragment CartoonLitFragment
            //接收投影变体
			#pragma multi_compile _ _MAIN_LIGHT_SHADOWS _MAIN_LIGHT_SHADOWS_CASCADE _MAIN_LIGHT_SHADOWS_SCREEN
            //光照贴图变体（只开启静态）
            #pragma multi_compile _ LIGHTMAP_SHADOW_MIXING
            #pragma multi_compile _ SHADOWS_SHADOWMASK //这两个宏用于控制阴影的烘焙和采样。当你在Unity的Lighting窗口中选择了Shadowmask或者Subtractive模式，这两个宏就会被激活。
            #pragma multi_compile _ DIRLIGHTMAP_COMBINED //这个宏用于控制是否将定向光源的光照信息烘焙到光照贴图中。当你在Unity的Lighting窗口中选择了Baked GI，并且选择了Directional Mode，这个宏就会被激活。
            #pragma multi_compile _ LIGHTMAP_ON
            #include "CartoonLitInput.hlsl"
	        #include "CartoonLitForwardPass.hlsl"
            ENDHLSL
        }

        Pass
        {
            //阴影写入Pass（目前不支持alphaTest阴影，需要的话再加）
            Name "CartoonShadowCaster"
            Tags{ "LightMode" = "ShadowCaster" }
            HLSLPROGRAM
            #pragma vertex CartoonShadowCasterVertex
            #pragma fragment CartoonShadowCasterFragment
            #include "CartoonLitInput.hlsl"
	        #include "CartoonShadowCasterPass.hlsl"
            ENDHLSL
        }

        Pass
        {
            //深度法线Pass
            Name "CartoonDepthNormals"
            Tags{ "LightMode" = "DepthNormals" }
            HLSLPROGRAM
            #pragma vertex CartoonDepthNormalsVertex
            #pragma fragment CartoonDepthNormalsFragment
            #include "CartoonLitInput.hlsl"
	        #include "CartoonDepthNormalsPass.hlsl"
            ENDHLSL
        }

        Pass
        {
            //深度Pass
            Name "CartoonDepthOnly"
            Tags{ "LightMode" = "DepthOnly" }
            HLSLPROGRAM
            #pragma vertex CartoonDepthOnlyVertex
            #pragma fragment CartoonDepthOnlyFragment
            #include "CartoonLitInput.hlsl"
	        #include "CartoonDepthOnlyPass.hlsl"
            ENDHLSL
        }

        Pass
        {
            //烘焙光照Pass
            Name "Meta"
            Tags{ "LightMode" = "Meta" }
            HLSLPROGRAM
            #pragma vertex UniversalVertexMeta
            #pragma fragment CartoonMetaFragment
            #include "CartoonLitInput.hlsl"
	        #include "CartoonMetaPass.hlsl"
            ENDHLSL
        }

    }
}
