#if UNITY_EDITOR
using UnityEditor;
using UnityEngine;

namespace ShaderUtils
{
    [CustomEditor(typeof(WaterShaderSettingsGenerator))]
    public class RandomDirectionsSetterEditor : Editor
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
                me.Generate();
            if(GUILayout.Button("Assign Directions", GUILayout.Width(width), GUILayout.Height(height)))
                me.Assign();
            if(GUILayout.Button("Ws And As Exp", GUILayout.Width(width), GUILayout.Height(height)))
                me.GenerateFrequenciesAndAmplitudes();
            if(GUILayout.Button("Ws And As Polyn", GUILayout.Width(width), GUILayout.Height(height)))
                me.GenerateFrequenciesAndAmplitudesPolynomial();
            if(GUILayout.Button("Ws And As Linear", GUILayout.Width(width), GUILayout.Height(height)))
                me.GenerateFrequenciesAndAmplitudesLinear();
        }
    }
}
#endif