using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class BallController : MonoBehaviour
{
    private Rigidbody rigidBody;
    private float xForce;
    private float yForce;
    private float zForce;

    private string scoreEvent = "i 2 0 10 80 ";

    private CsoundUnity csoundUnity;

    private int pVal1;
    private int pVal2;
    private int pVal3;
    private int pVal4;
    void Start()
    {
        rigidBody = GetComponent<Rigidbody>();
        csoundUnity = GetComponent<CsoundUnity>();

        //random pitch linseg values
        int pVal1 = Random.Range(15, 40);
        int pVal2 = Random.Range(30, 40);
        int pVal3 = Random.Range(80, 120);
        int pVal4 = Random.Range(15, 40);
    }

    // Update is called once per frame
    void Update()
    {
        xForce = Random.Range(0, 150);
        yForce = Random.Range(0, 150);
        zForce = Random.Range(0, 150);

        if(Input.GetKeyDown(KeyCode.Space))
        {
            //addd random ish- force on press
            rigidBody.AddForce(xForce, yForce, zForce, ForceMode.Force);
            //send score event on press
            SendScoreEvent();
            Debug.Log(scoreEvent + pVal1 + " " + pVal2  + " " + pVal3 + " " + pVal4);
        }
    }

    void SendScoreEvent()
    {
        int pVal1 = Random.Range(15, 40);
        int pVal2 = Random.Range(30, 40);
        int pVal3 = Random.Range(80, 120);
        int pVal4 = Random.Range(15, 40);
        csoundUnity.SendScoreEvent(scoreEvent + pVal1 + " " + pVal2  + " " + pVal3 + " " + pVal4);
    }
}
