using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class MapDisplacementToChannel : MonoBehaviour
{
    private Vector3 initialPosition;
    private Rigidbody rigidBody;
    private CsoundUnity csoundUnity;

    private float m_Displacement;
    private float n_Displacement = 0;
    private float rbMass;

    private float m_Position;
    private float n_Position;
    private bool useFixedUpdate;
    
    void Start()
    {
        rigidBody = GetComponent<Rigidbody>();
        initialPosition = rigidBody.worldCenterOfMass;
        rbMass = rigidBody.mass;
        csoundUnity = GetComponent<CsoundUnity>();
    }

    void FixedUpdate()
    {
        DisplacementToChannel(m_Displacement, n_Displacement);
        PositionToChannel(m_Position, n_Position);
        MassToChannel(rbMass);
    }

    public void DisplacementToChannel(float m_Displacement, float n_Displacement)
    {
        m_Displacement = Vector3.Distance (initialPosition, rigidBody.worldCenterOfMass);
        //if the value since last update changed, then update channel
        if(m_Displacement != n_Displacement)
        {
            n_Displacement = m_Displacement;
            csoundUnity.SetChannel("displace", CsoundUnity.Remap(m_Displacement, 0.0f, 5.0f, 0.0f, 0.3f));
        }
    }

    public void PositionToChannel(float m_Position, float n_Position)   
    {
        m_Position =rigidBody.worldCenterOfMass.x - initialPosition.x;
        //if the value since last update changed, then update channel
        if(m_Position != n_Position)
        {
            n_Position = m_Position;
            csoundUnity.SetChannel("position", CsoundUnity.Remap(m_Position, 0.0f, 2.0f, 0.0f, 1.0f));
        }
    }

    public void MassToChannel(float rbMass)
    {
        rbMass = rigidBody.mass;
        csoundUnity.SetChannel("mass", CsoundUnity.Remap(rbMass, 0.0f, 3.0f, 0.0f, 10.0f));
    }
}
