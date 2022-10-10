using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class XylophoneBarChannelSenders : MonoBehaviour
{

    private CsoundUnity csoundUnity;
    private Rigidbody rb;

    private float objectMass;
    private float outputMass;
    private float objectMassMin;
    private float objectMassMax;

    void Start()
    {
        //find the parent CsoundUnity componant 
        csoundUnity = GameObject.Find("BARS").GetComponent<CsoundUnity>();
        rb = gameObject.GetComponent<Rigidbody>();
        //mass and min 'masses'. from the smallest bar to the biggest one.
        objectMassMin = GameObject.Find("Bar1").GetComponent<Rigidbody>().mass;
        objectMassMax = GameObject.Find("Bar12").GetComponent<Rigidbody>().mass;
        //get mass from rb
        objectMass = rb.mass;
    }


    private void OnCollisionEnter(Collision other)
    {
        BarMassToChannel(); 
    }


    //method to set the channel "mass" based on the mass of the rb that was collided
    public void BarMassToChannel()
    {
        csoundUnity.SetChannel("mass", CsoundUnity.Remap(objectMass, objectMassMin, objectMassMax, 1.0f, 12.0f));
        //Print the mass channel value
        float channelMassValue =(float) csoundUnity.GetChannel("mass");
    }

}
