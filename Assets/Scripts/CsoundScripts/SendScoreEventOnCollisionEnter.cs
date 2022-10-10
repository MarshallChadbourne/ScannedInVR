using UnityEngine;


public class SendScoreEventOnCollisionEnter : MonoBehaviour
{
    private CsoundUnity csoundUnity;

    private float minImpactVelocity = 0.00f;
    private float maxImpactVelocity = 5.00f;
    //private float minAmpOutput = 0.00f;
    //private float maxAmpOutput = 60.00f;

    private int tagIndex = 13;
    private int noteLength = 10;
    private float ampLevel = 0f;
    private float noteValue;
    private string scoreEvent = "i 2 0";

    void Start()
    {
        csoundUnity = GameObject.Find("BARS").GetComponent<CsoundUnity>();
    }

    private void OnCollisionEnter(Collision collision)
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
        float impactVelocity = collision.relativeVelocity.magnitude;
        Debug.Log("Impact velocity is: " + impactVelocity);
        //DEFINE AMP LEVEL
        ampLevel = (MapValue(minImpactVelocity, maxImpactVelocity, 0, 50, impactVelocity) - 80);
        int ampLevelInt = (int) ampLevel;
        //UPDATE THE SCORE EVENT
        scoreEvent = scoreEvent + " " + noteLength.ToString() + " " + ampLevelInt.ToString() + " " + noteValue.ToString();
        //send score event as defined in the variable
        csoundUnity.SendScoreEvent(scoreEvent); 
        Debug.Log("CSOUND SCORE EVENT: " + gameObject.name + " " + scoreEvent);
        scoreEvent = "i 2 0";
    }

    
    //method to re-map values to new scale
    public float MapValue(float a0, float a1, float b0, float b1, float a)
    {
        return b0 + (b1 - b0) * ((a-a0)/(a1-a0));
    } 
}
