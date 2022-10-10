using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class SendScoreEventOnVelocityReach : MonoBehaviour
{
    private CsoundUnity csoundUnity;

    private Rigidbody rigidBody;
    private float speed;
    private bool sendDelay;

    private string scoreEvent = "i 2 0 10 80 6.0";
    void Start()
    {
        csoundUnity = GetComponent<CsoundUnity>();
        rigidBody = GetComponent<Rigidbody>();
    }

    // Update is called once per frame
    void Update()
    {
        speed = rigidBody.velocity.magnitude;
        
        if(speed > 10.0 && sendDelay == true)
        {
            csoundUnity.SendScoreEvent(scoreEvent); 
            Debug.Log("CSOUND SCORE EVENT: " + gameObject.name + " " + scoreEvent);
            sendDelay = false;
        }

        if(speed < 10)
        {
            sendDelay = true;
        }
    }
}
