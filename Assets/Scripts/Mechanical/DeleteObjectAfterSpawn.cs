using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class DeleteObjectAfterSpawn : MonoBehaviour
{
    
    void Start()
    {
        StartCoroutine(DeleteAfterOneSecond(gameObject));
    }


    IEnumerator DeleteAfterOneSecond(GameObject gameObject) 
    {
        yield return new WaitForSeconds(1);
        Destroy(gameObject);
    }

}
