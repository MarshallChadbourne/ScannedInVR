using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class UntilCsoundIsInitialized : MonoBehaviour
{
    public GameObject[] disabledObjects;
    public GameObject csoundObject;
    private CsoundUnity csoundUnity;
    private int arraySize;

    void Start()
    {
        csoundUnity = csoundObject.GetComponent<CsoundUnity>();
        arraySize = disabledObjects.GetLength(arraySize);
    }

    private void Update()
    {    
        InitAfterCsound(disabledObjects, csoundUnity);
    }
    //method to turn on objects after csound is init
    public void InitAfterCsound(GameObject[] disabledObjects, CsoundUnity csoundUnity)
    {
        if(csoundUnity.IsInitialized == true)  
            foreach (GameObject gameObject in disabledObjects)
            {
                gameObject.SetActive(true);
            }
    }
        
    
   
}
