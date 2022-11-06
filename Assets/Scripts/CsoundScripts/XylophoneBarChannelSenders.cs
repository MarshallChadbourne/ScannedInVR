using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;

public class XylophoneBarChannelSenders : MonoBehaviour
{

    private CsoundUnity csoundUnity;
    private Rigidbody rb;
    
    private Slider massSlider;
    private float remappedMass;
    private float minMass;

    void Start()
    {
        //find the parent CsoundUnity componant 
        csoundUnity = GameObject.Find("BARS").GetComponent<CsoundUnity>();
        rb = gameObject.GetComponent<Rigidbody>();
        //find mass slider
        minMass = rb.mass;
        massSlider = GameObject.Find("Mass Slider").GetComponent<Slider>();
    }

    void Update()
    {
        remappedMass = MapValue(10, 150, 1, 9, massSlider.value);
        rb.mass = minMass * (remappedMass); 
        // .1 = .054 * 1.857, .027
        //.054, .081, 
    }

    public float MapValue(float a0, float a1, float b0, float b1, float a)
    {
        return b0 + (b1 - b0) * ((a-a0)/(a1-a0));
    } 

}
