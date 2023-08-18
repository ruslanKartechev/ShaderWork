using System.Collections.Generic;
using UnityEngine;

namespace ShaderUtils
{
    public class FogShaderSettingsGenerator : MonoBehaviour
    {
        [SerializeField] private Renderer _renderer;
        [SerializeField] private string _directionName;
        [SerializeField] private int count;
        [Space(10)]
        [SerializeField] private float _amplitude_min = 1f;
        [SerializeField] private float _amplitude_max = 2f;
        [Space(4)]
        [SerializeField] private float _frequency_min = 1f;
        [SerializeField] private float _frequency_max = 2f;
        [Space(4)]
        [SerializeField] private string _amplitudeName;
        [SerializeField] private string _frequencyName;
        [Space(10)]
        [SerializeField] private List<Vector2> _directions;
        
        public void GenerateDirections()
        {
            if (_renderer == null)
                _renderer = GetComponent<Renderer>();
            var mat = _renderer.sharedMaterial;
            _directions = new List<Vector2>(count);
            for (var i = 0; i < count; i++)
            {
                var vec = UnityEngine.Random.insideUnitCircle;
                vec.Normalize();
                _directions.Add(vec);
                var propName = _directionName + $"{i + 1}";
                mat.SetVector(propName, _directions[i]);
            }
        }

        public void RandomFreq()
        {
            if (_renderer == null)
                _renderer = GetComponent<Renderer>();
            var mat = _renderer.sharedMaterial;
            for (var i = 0; i < count; i++)
            {
                var frequency = UnityEngine.Random.Range(_frequency_min, _frequency_max);
                mat.SetFloat($"{_frequencyName}{i+1}", frequency);
            }
        }

        public void RandomAmpl()
        {
            if (_renderer == null)
                _renderer = GetComponent<Renderer>();
            var mat = _renderer.sharedMaterial;
            for (var i = 0; i < count; i++)
            {
                var amplitude = UnityEngine.Random.Range(_amplitude_min, _amplitude_max);
                mat.SetFloat($"{_amplitudeName}{i+1}", amplitude);
            }
        }
    }
}