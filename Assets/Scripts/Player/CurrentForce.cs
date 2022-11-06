using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class CurrentForce : MonoBehaviour
{
    public float currentForce;

    private ConfigurableJoint configJoint;

    void Start()
    {
        configJoint = GetComponent<ConfigurableJoint>();
    }

    void Update()
    {
        currentForce = configJoint.currentForce.magnitude;
    }
}
