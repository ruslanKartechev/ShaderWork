using System;
using System.Collections.Generic;
using UnityEngine;

namespace ShaderUtils
{
    public class WaterShaderSettingsGenerator : MonoBehaviour
    {
        private const string BufferSizeVarName = "_BufferSize";
        [SerializeField] private Renderer _renderer;
        [Space(10)]
        [SerializeField] private float _frequencyStep;
        [SerializeField] private float _minFrequency = 0.1f;
        [SerializeField] private float _maxFrequency = 1f;
        [Space(4)]
        [SerializeField] private float _amplitudeStep;
        [SerializeField] private float _maxAmplitude = 0.5f;
        [SerializeField] private float _minAmplitude = 0.1f;
        [Space(4)]
        [SerializeField] private string _amplitudeBufferName = "_Amplitudes";
        [SerializeField] private string _frequencyBufferName = "_Omegas";
        [SerializeField] private string _directionsBufferName = "_Directions";
        [Space(10)]
        [SerializeField] private List<Vector4> _directions;
        [SerializeField] private List<float> _amplitudes;
        [SerializeField] private List<float> _frequencies;

        #if UNITY_EDITOR
        private void OnValidate()
        {
            AssignBuffersWithCheck();   
        }
        #endif

        private void OnEnable()
        {
            AssignBuffers();
        }

        public void AssignBuffersWithCheck()
        {
            if (_renderer == null)
                _renderer = GetComponent<Renderer>();
            var mat = _renderer.sharedMaterial;
            if(_amplitudes.Count > 0)
                mat.SetFloatArray(_amplitudeBufferName, _amplitudes);
            if(_frequencies.Count > 0)
                mat.SetFloatArray(_frequencyBufferName, _frequencies);
            if(_directions.Count > 0)
                mat.SetVectorArray(_directionsBufferName, _directions);
        }

        public void AssignBuffers()
        {
            var mat = _renderer.sharedMaterial;
            mat.SetFloatArray(_amplitudeBufferName, _amplitudes);
            mat.SetFloatArray(_frequencyBufferName, _frequencies);
            mat.SetVectorArray(_directionsBufferName, _directions);
        }
        
        public void SetDirections()
        {
            if (_renderer == null)
                _renderer = GetComponent<Renderer>();
            var mat = _renderer.sharedMaterial;
            var count = (int)mat.GetFloat(BufferSizeVarName);
            _directions = new List<Vector4>(count);
            for (var i = 0; i < count; i++)
            {
                var vec = UnityEngine.Random.insideUnitCircle;
                vec.Normalize();
                _directions.Add(vec);
            }
            mat.SetVectorArray(_directionsBufferName, _directions);
        }
        
        public void GenerateFrequencies()
        {
            if (_renderer == null)
                _renderer = GetComponent<Renderer>();
            var mat = _renderer.sharedMaterial;
            _frequencies.Clear();
            _frequencies = new List<float>();
            var count = mat.GetFloat(BufferSizeVarName);
            for (var i = 0; i < count; i++)
            {
                var it = i;
                var frequency = _minFrequency * (float)Math.Pow(_frequencyStep, it);
                if (frequency <= 0)
                {
                    Debug.Log($"Frequency <= 0");
                    frequency = _minFrequency;
                }
                if (frequency >= _maxFrequency)
                {
                    Debug.Log($"Frequency >= Max");
                    frequency = _maxFrequency;
                }
                _frequencies.Add(frequency);
            }   
            mat.SetFloatArray(_frequencyBufferName, _frequencies);
        }

        public void GenerateAmplitudes()
        {
            if (_renderer == null)
                _renderer = GetComponent<Renderer>();
            var mat = _renderer.sharedMaterial;
            var count = (int)mat.GetFloat(BufferSizeVarName);
            var amplitude = _maxAmplitude;
            _amplitudes.Clear();
            _amplitudes = new List<float>(count);
            for (var i = 0f; i < count; i++)
            {
                var it = i;
                amplitude = _maxAmplitude * (float)Math.Pow(_amplitudeStep, it);
                _amplitudes.Add(amplitude);
            }
            mat.SetFloatArray(_amplitudeBufferName, _amplitudes);
        }
        
        
        private float Factorial(int number)
        {
            if (number <= 0)
                return 1;
            var fact = number;
            for (var i = number - 1; i >= 1; i--)
                fact = fact * i;
            return fact;
        }
    }
 }
