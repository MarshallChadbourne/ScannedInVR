using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.InputSystem;
using UnityEngine.UI;

public class Baton : MonoBehaviour
{
    public InputAction action = null;

    [SerializeField]
    private bool _isGrabbed = false;

    
    //Vectors 
    private Vector3 _localPosAtGrab;
    public float _yGain;
    //UI Slider/Values 
    public Slider massSlider;
    public Slider dampSlider;
    public Slider stiffSlider;

    void Awake()
    {

    }

    void Update() 
    {
        if(_isGrabbed)
        {
            _yGain = _localPosAtGrab.y + transform.position.y;
        } 
    }


    public void InitializePosition()
    {
        _localPosAtGrab = transform.position;
    }

    //Turns input action off or on 
    private void OnEnable()
    {
        action.Enable();
    }
    private void OnDisable()
    {
        action.Disable();
    }

    //Called by XR grab interactable
    public void Grabbed()
    {
        _isGrabbed = true;
    }
    public void Released()
    {
        _isGrabbed = false;
    }

}
