using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class MoveObjectWithInput : MonoBehaviour
{

    public float speed = 1;
    public Vector3 boundaries; 
    void Update()
    {
        MoveObject();
        CheckBoundaries();
    }

    void MoveObject()
    {
        float verticalInput = Input.GetAxis("Vertical");

        Vector3 positionOffset = new Vector3(0, verticalInput * speed, 0);

        transform.Translate(positionOffset * speed * Time.deltaTime);
    }

    void CheckBoundaries()
    {
    
        if(transform.position.y > boundaries.y)
            transform.position = new Vector3(transform.position.x, boundaries.y, transform.position.z);
         else if(transform.position.y < 0)
            transform.position = new Vector3(transform.position.x, 0, transform.position.z);
        

    }
}
