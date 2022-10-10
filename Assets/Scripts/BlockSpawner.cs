using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class BlockSpawner : MonoBehaviour
{
    public GameObject objectPrefab;
    Vector3 spawnPosition = new Vector3(0, 2, 0);
    void Start()
    {
        
    }

    // Update is called once per frame
    void Update()
    {
        
        if(Input.GetKeyDown(KeyCode.Space))
        {
            Instantiate(objectPrefab, spawnPosition, gameObject.transform.rotation);
        }

    }
}
