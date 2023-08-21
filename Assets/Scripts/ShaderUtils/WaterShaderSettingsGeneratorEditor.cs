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
            if(GUILayout.Button("Set Directions", GUILayout.Width(width), GUILayout.Height(height)))
                me.SetDirections();
            if(GUILayout.Button("Set Frequencies", GUILayout.Width(width), GUILayout.Height(height)))
                me.GenerateFrequencies();
            if(GUILayout.Button("Set Amplitudes", GUILayout.Width(width), GUILayout.Height(height)))
                me.GenerateAmplitudes();
            if(GUILayout.Button("Set speeds", GUILayout.Width(width), GUILayout.Height(height)))
                me.SetSpeeds();
            GUILayout.Space(10);
            if(GUILayout.Button("Assign buffers", GUILayout.Width(width), GUILayout.Height(height)))
                me.AssignBuffersWithCheck();
        }
    }
}
#endif