using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class InitializeChildrenAfterCsound : MonoBehaviour
{
    
    public GameObject _CsoundObject;
    public GameObject[] children;
    private int objectIndex;
    private int objectIndexSize;

    void Start()
    {
        objectIndexSize = children.Length;
        for (int i = 0; i < objectIndexSize; i++)
        {
            children[objectIndex].SetActive(false);
        }
    }
 
        void Update()
        {
            //check if csound object is active
            if(_CsoundObject.activeSelf == true)
            {
                //iterate through each child object and turn on
                for (int i = 0; i < objectIndexSize; i++)
                {
                    children[objectIndex].SetActive(true);
                }
                
                enabled = false;
                return;
            } 
        }

}
