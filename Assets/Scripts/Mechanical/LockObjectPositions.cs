using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class LockObjectPositions : MonoBehaviour
{
    private Quaternion defaultRotation;



    void Start()
    {
        defaultRotation = transform.rotation;
    }

    void LateUpdate() 
    {
        gameObject.transform.rotation = defaultRotation;
    }
}
