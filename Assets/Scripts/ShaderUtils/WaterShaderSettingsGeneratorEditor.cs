#if UNITY_EDITOR
using UnityEditor;
using UnityEngine;

namespace ShaderUtils
{
    [CustomEditor(typeof(WaterShaderSettingsGenerator))]
    public class WaterShaderSettingsGeneratorEditor : Editor
    {
        private WaterShaderSettingsGenerator me;

        private void OnEnable()
        {
            me = target as WaterShaderSettingsGenerator;
        }

        public override void OnInspectorGUI()
        {
            base.OnInspectorGUI();
            var height = 28;
            var width = 140;
            if(GUILayout.Button("Generate Directions", GUILayout.Width(width), GUILayout.Height(height)))
                me.SetDirections();
            if(GUILayout.Button("Generate Frequencies", GUILayout.Width(width), GUILayout.Height(height)))
                me.GenerateFrequencies();
            if(GUILayout.Button("Generate Amplitudes", GUILayout.Width(width), GUILayout.Height(height)))
                me.GenerateAmplitudes();
            GUILayout.Space(10);
            if(GUILayout.Button("Assign buffers", GUILayout.Width(width), GUILayout.Height(height)))
                me.AssignBuffersWithCheck();
        }
    }
}
#endif