using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEditor;
public class CartoonLit
{
    [MenuItem("Assets/Create/AHD2SimpleCartoonLit", false, 70)]
    public static void CreatNewMat()
    {
        var material = new Material (Shader.Find ("AHD2SimpleCartoonShading/CartoonLit"));
        // 金属matcap
        Texture2D MetalMatcap = AssetDatabase.LoadAssetAtPath<Texture2D>("Packages/com.ahd2.simple-cartoon-shading/Texture/MetalMatcap.jpg");
        //反射matcap
        Texture2D RoughnessMatcap = AssetDatabase.LoadAssetAtPath<Texture2D>("Packages/com.ahd2.simple-cartoon-shading/Texture/RoughnessMatcap1.jpg");
        // 将贴图赋给材质
        material.SetTexture(Shader.PropertyToID("_MetalCap"), MetalMatcap);
        material.SetTexture(Shader.PropertyToID("_RoughnessCap"), RoughnessMatcap);
        ProjectWindowUtil.CreateAsset (material, "New Material.mat");
    }
}