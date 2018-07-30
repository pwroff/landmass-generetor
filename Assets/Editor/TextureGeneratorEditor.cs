using System.Collections;
using System.Collections.Generic;
using UnityEditor;
using UnityEngine;

[CustomEditor(typeof(GenerateTexture))]
public class GenerateTextureEditor : Editor
{

    public override void OnInspectorGUI()
    {
        GenerateTexture mapGen = (GenerateTexture)target;
        if (DrawDefaultInspector())
        {
            if (mapGen.autoUpdate)
                mapGen.UpdateTexture();
        }
        if (GUILayout.Button("Generate"))
        {
            mapGen.UpdateTexture();
        }
    }

}
