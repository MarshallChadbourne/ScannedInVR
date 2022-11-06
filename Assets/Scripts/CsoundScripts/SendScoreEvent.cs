using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using System;

public class SendScoreEvent : MonoBehaviour
{
    public CsoundUnity csoundUnity; 
    
    public float initYPos;
    public float initDisp;

    public float minInitDisp = 0f;
    public float maxInitDisp = 0.90f;

    public int tagIndex = 13;
    public int noteLength = 13;
    public float ampLevel;

    public float noteValue;
    public string scoreEvent = "i 2 0";

    void Start()
    {
        csoundUnity = GameObject.Find("BARS").GetComponent<CsoundUnity>();
        
        initYPos = gameObject.transform.position.y;
        
    }


    public void SendScoreEventNow()
    {
        //iterate through each possible tag 
        for (int i = 0; i <= tagIndex; i++)
        {
            //if the tag is the same as the index, add that tag value 
            if (gameObject.CompareTag(i.ToString()))
            {
                float noteValueToAdd = (float) i / 100;
                //DEFINE NOTE VALUE
                noteValue = 6.12f - noteValueToAdd;
            }
        }
        float initDisp = Math.Abs(initYPos - transform.position.y);
        //DEFINE AMP LEVEL
        ampLevel = (MapValue(minInitDisp, maxInitDisp, 30, 50, initDisp) - 60);
        int ampLevelInt = (int) ampLevel;
        scoreEvent = scoreEvent + " " + noteLength.ToString() + " " + ampLevelInt.ToString() + " " + noteValue.ToString();
        //send score event as defined in the variable
        csoundUnity.SendScoreEvent(scoreEvent); 
        Debug.Log("CSOUND SCORE EVENT: " + gameObject.name + " " + scoreEvent);
        scoreEvent = "i 2 0";        
    }

    public float MapValue(float a0, float a1, float b0, float b1, float a)
    {
        return b0 + (b1 - b0) * ((a-a0)/(a1-a0));
    } 


}
