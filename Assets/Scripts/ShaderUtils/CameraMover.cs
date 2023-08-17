using System;
using UnityEngine;

namespace ShaderUtils
{
    public class CameraMover : MonoBehaviour
    {
        [SerializeField] private float _moveSpeed;
        [SerializeField] private float _rotationSpeed;
        [SerializeField] private Transform _movable;
        private Vector3 _prevMousePos;
        private void Update()
        {
            CheckMoveInput();
            CheckRotationInput();
        }

        private void CheckMoveInput()
        {
            var input = Vector2.zero;
            if (Input.GetKey(KeyCode.W))
                input.y = 1;
            if (Input.GetKey(KeyCode.D))
                input.x = 1;
            if (Input.GetKey(KeyCode.A))
                input.x = -1;
            if (Input.GetKey(KeyCode.S))
                input.y = -1;

            if (input == Vector2.zero)
                return;
            var displacement = (_movable.forward * input.y + _movable.right * input.x).normalized 
                               * (Time.deltaTime * _moveSpeed);
            _movable.position += displacement;       
        }

        private void CheckRotationInput()
        {
            if (!Input.GetMouseButton(1))
            {
                _prevMousePos = Input.mousePosition;
                return;
            }
            var position = Input.mousePosition;
            var diff = (position - _prevMousePos);
            if (Mathf.Abs(diff.x) > 0)
            {
                _movable.Rotate(0, Mathf.Sign(diff.x) * _rotationSpeed * Time.deltaTime, 0, Space.World);
            }
            if (Mathf.Abs(diff.y) > 0)
            {
                _movable.Rotate(-Mathf.Sign(diff.y) * _rotationSpeed * Time.deltaTime, 0, 0, Space.Self);
            }
            _prevMousePos = position;
        }
    }
}