using System.Collections.Generic;
using UnityEngine;

namespace ShaderUtils
{
    public class WaterShaderSettingsGenerator : MonoBehaviour
    {
        [SerializeField] private Renderer _renderer;
        [SerializeField] private string _directionName;
        [SerializeField] private int count;
        [Space(10)]
        [SerializeField] private float _maxAmplitude = 0.5f;
        [SerializeField] private float _minFrequency = 0.1f;
        [Space(4)]
        [SerializeField] private float _minAmplitude = 0.1f;
        [SerializeField] private float _maxFrequency = 1f;
        [Space(4)]
        [SerializeField] private float _frequencyFactor = 2;
        [SerializeField] private float _amplitudeFactor = 2;
        [Space(4)]
        [SerializeField] private string _amplitudeName;
        [SerializeField] private string _frequencyName;
        [Space(10)]
        [SerializeField] private List<Vector2> _directions;
        public void Generate()
        {
            _directions = new List<Vector2>(count);
            for (var i = 0; i < count; i++)
            {
                var vec = UnityEngine.Random.insideUnitCircle;
                vec.Normalize();
                _directions.Add(vec);
            }
        }

        public void Assign()
        {
            if (_renderer == null)
                _renderer = GetComponent<Renderer>();
            var mat = _renderer.sharedMaterial;
            for (var i = 0; i < _directions.Count; i++)
            {
                var propName = _directionName + $"{i + 1}";
                mat.SetVector(propName, _directions[i]);
            }
        }

        public void GenerateFrequenciesAndAmplitudes()
        {
            if (_renderer == null)
                _renderer = GetComponent<Renderer>();
            var mat = _renderer.sharedMaterial;
            var amplitudeFactor = _amplitudeFactor;
            var freqFactor = _frequencyFactor;
            for (var i = 0; i < count; i++)
            {
                var amplitude = _maxAmplitude * 1 / Mathf.Pow(amplitudeFactor, i);
                var frequency = _minFrequency * Mathf.Pow(freqFactor, i);
                mat.SetFloat($"{_amplitudeName}{i+1}", amplitude);
                mat.SetFloat($"{_frequencyName}{i+1}", frequency);
            }
        }    
        
        public void GenerateFrequenciesAndAmplitudesPolynomial()
        {
            if (_renderer == null)
                _renderer = GetComponent<Renderer>();
            var mat = _renderer.sharedMaterial;
            var amplitudeFactor = _amplitudeFactor;
            var freqFactor = _frequencyFactor;
            for (var i = 0; i < count; i++)
            {
                var amplitude = _maxAmplitude * 1 / Mathf.Pow(i+1 ,amplitudeFactor );
                var frequency = _minFrequency * Mathf.Pow(i+1, freqFactor );
                mat.SetFloat($"{_amplitudeName}{i+1}", amplitude);
                mat.SetFloat($"{_frequencyName}{i+1}", frequency);
            }
        }    

        
        public void GenerateFrequenciesAndAmplitudesLinear()
        {
            if (_renderer == null)
                _renderer = GetComponent<Renderer>();
            var mat = _renderer.sharedMaterial;
            var minAmpl = _minAmplitude;
            var maxFreq = _maxFrequency;
            for (var i = 0; i < count; i++)
            {
                var amplitude = Mathf.Lerp(_maxAmplitude, minAmpl, (float)(i) / (count-1));
                var frequency = Mathf.Lerp(_minFrequency, maxFreq, (float)(i) / (count-1));
                mat.SetFloat($"{_amplitudeName}{i+1}", amplitude);
                mat.SetFloat($"{_frequencyName}{i+1}", frequency);
            }
        }     
        
    }
}
