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
        [SerializeField] private float _speedMin = 10;
        [SerializeField] private float _speedMax = 100;
        [Space(4)]
        [SerializeField] private string _amplitudeBufferName = "_Amplitudes";
        [SerializeField] private string _frequencyBufferName = "_Omegas";
        [SerializeField] private string _directionsBufferName = "_Directions";
        [SerializeField] private string _speedsBufferName = "_Speeds";
        [Space(10)]
        [SerializeField] private List<Vector4> _directions;
        [SerializeField] private List<float> _amplitudes;
        [SerializeField] private List<float> _frequencies;
        [SerializeField] private List<float> _speeds;

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
            mat.SetFloatArray(_speedsBufferName, _speeds);
        }

        public void AssignBuffers()
        {
            var mat = _renderer.sharedMaterial;
            mat.SetFloatArray(_amplitudeBufferName, _amplitudes);
            mat.SetFloatArray(_frequencyBufferName, _frequencies);
            mat.SetVectorArray(_directionsBufferName, _directions);
            mat.SetFloatArray(_speedsBufferName, _speeds);
        }
        
        public void SetDirections()
        {
            if (_renderer == null)
                _renderer = GetComponent<Renderer>();
            var mat = _renderer.sharedMaterial;
            var count = mat.GetInt(BufferSizeVarName);
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
            var count = mat.GetInt(BufferSizeVarName);
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
            var count = mat.GetInt(BufferSizeVarName);
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
        
        
        public void SetSpeeds()
        {
            if (_renderer == null)
                _renderer = GetComponent<Renderer>();
            var mat = _renderer.sharedMaterial;
            var count = mat.GetInt(BufferSizeVarName);
            _speeds.Clear();
            _speeds = new List<float>(count);
            for (var i = 0; i < count; i++)
            {
                var t = (float)(i) / (count-1);
                _speeds.Add(Mathf.Lerp(_speedMin, _speedMax, t));
            }
            mat.SetFloatArray(_speedsBufferName, _speeds);
        }
    }
 }
