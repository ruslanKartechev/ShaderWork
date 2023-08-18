#if UNITY_EDITOR
using UnityEditor;
using UnityEngine;

namespace ShaderUtils
{
    [CustomEditor(typeof(FogShaderSettingsGenerator))]
    public class FogShaderSettingsGeneratorEditor : Editor
    {
        private FogShaderSettingsGenerator me;

        private void OnEnable()
        {
            me = target as FogShaderSettingsGenerator;
        }

        public override void OnInspectorGUI()
        {
            base.OnInspectorGUI();
            var height = 28;
            var width = 140;
            if(GUILayout.Button("Generate Directions", GUILayout.Width(width), GUILayout.Height(height)))
                me.GenerateDirections();
            if(GUILayout.Button("Random frequencies", GUILayout.Width(width), GUILayout.Height(height)))
                me.RandomFreq();
            if(GUILayout.Button("Random amplitudes", GUILayout.Width(width), GUILayout.Height(height)))
                me.RandomAmpl();
        }
    }
}
#endif