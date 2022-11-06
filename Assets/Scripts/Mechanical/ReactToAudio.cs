using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class ReactToAudio : MonoBehaviour
{
    private CsoundUnity csoundUnity;
    private Rigidbody rb;

    
    public float delayBetweenShakes = 0.01f;
    [SerializeField]
    private float ampLevel;
    [SerializeField]
    private float shakeAmount = 1.00f;
    [SerializeField]
    private float bias = 0.01f; 

    void Awake()
    {
        csoundUnity = GameObject.Find("BARS").GetComponent<CsoundUnity>();
        rb = GetComponent<Rigidbody>();
    }

    void Update()
    {
        ampLevel = (float) csoundUnity.GetChannel("outlev1");
        if(ampLevel < 0.0001)
        {
            ampLevel = 0.0000f;
        }

        StartCoroutine(ShakeObject(ampLevel, rb));
    }

    //method to shake object from output amp level 
    private IEnumerator ShakeObject(float ampLevel, Rigidbody rb)
    {
        if(ampLevel > bias)
        {    
            float forceAdded = ampLevel * shakeAmount;

            rb.AddRelativeForce(Random.onUnitSphere * forceAdded, ForceMode.Impulse);
            
            if(delayBetweenShakes > 0)
            {
                yield return new WaitForSeconds(delayBetweenShakes);
            }
            else
            {
                yield return null;
            }
        }
    }
}
