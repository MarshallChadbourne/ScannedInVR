using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class XylophoneParentChannelSender : MonoBehaviour
{
    //List for storing bars
    public List<GameObject> bars = new List<GameObject>();

    private CsoundUnity csoundUnity;

    private int numberOfBars = 12;

    private float maxObjectDisplacement = 1.00f;
    private float maxChannelDisplacement = 1.00f;

    void Start()
    {
        csoundUnity = GetComponent<CsoundUnity>();
        //store each bar into the list.
        for (int i = 1; i < numberOfBars + 1; i++)
        {
            bars.Add(GameObject.Find("Bar" + i.ToString()));
        }
    }


    void Update()
    {
        MapDisplacementToChannel();
    }

    //TODO map the averaged Y displacement into scanned synthesis model

    public void MapDisplacementToChannel()
    {
        float averageDisplacement = ABSAverageYDisplacement();
        csoundUnity.SetChannel("displacement", CsoundUnity.Remap(averageDisplacement, 0, maxObjectDisplacement, 0, maxChannelDisplacement));
    }

    //method to store the (absolute) average Ydisplacement of bars
    public float ABSAverageYDisplacement()
    {
        float singleDisplacement = 0.00f;
        float averageDisplacement = 0.00f;
        float summedDisplacement = 0.00f;
        for (int i = 0; i < numberOfBars; i++)
        {
            singleDisplacement = Mathf.Abs(1 - bars[i].transform.position.y);
            
            //sum displacments
            summedDisplacement += singleDisplacement;
        }
        //average the displacements
        averageDisplacement = summedDisplacement / 12;

        return averageDisplacement;
    }
}
