using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class OffAtStart : MonoBehaviour
{
    
    void Awake()
    {
        gameObject.SetActive(false);
    }


}
