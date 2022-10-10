using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class NoteObjectSpawner : MonoBehaviour
{
    private Vector3 spawnObjectPosition;

    public GameObject objectPrefab;
    public GameObject spawnObjectAnchor;

    private float rightInput;
    private float leftInput;
    public float speed = 1.0f;

    void Start()
    {

    }

    void FixedUpdate()
    {
        MoveObjectLeftOrRight();
        
        if(Input.GetKeyDown(KeyCode.Space))
        {
            spawnObjectPosition = spawnObjectAnchor.transform.position;
            Instantiate(objectPrefab, spawnObjectPosition, objectPrefab.transform.rotation);
        }
    }

    //control objects movement on X axis using 't' and 'y'
    private void MoveObjectLeftOrRight()
    {
        if (Input.GetKey(KeyCode.T))
        {
            gameObject.transform.Translate(Vector3.left * speed);
        }
        if (Input.GetKey(KeyCode.Y))
        {
            gameObject.transform.Translate(Vector3.right * speed);
        }
    }
    //spawn prefabs on command 
    private void SpawnPrefab()
    {
        if(Input.GetKeyDown(KeyCode.Space))
        {
            spawnObjectPosition = spawnObjectAnchor.transform.position;
            Instantiate(objectPrefab, spawnObjectPosition, objectPrefab.transform.rotation);
        }
    }
}
