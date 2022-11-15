using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;
using System;

public class ControlJoints : MonoBehaviour
{
    //array of all the joints in children
    public ConfigurableJoint[] configurableJoints;
    //JointDrive Struct to pass into each joint
    private JointDrive jointDrive;
    //refs to UI sliders
    public Slider dampSlider;
    public Slider stiffSlider;

    //DAMPENING VARIABLES 
    [Range(1.00f, 4.00f)]    
    public float driveDampFactor;
    private float _driveMaximumForce = 3.402823e+38F;
    public float minSmallBarDamp = .0375f; 
    public float minBigBarDamp = .500f;
    private float _dampIncreasePer;
    //STIFFNESS VARIABLES
    [Range(1.00f, 200.00f)]
    public float driveSpringStiff;

    void Start()
    {
        //Gather joints from children objects
        configurableJoints = GetComponentsInChildren<ConfigurableJoint>();
        //Find slider refs
        dampSlider = GameObject.Find("Damp Slider").GetComponent<Slider>();
        stiffSlider = GameObject.Find("Stiff Slider").GetComponent<Slider>();
        //pass in maximum force to 
        jointDrive.maximumForce = _driveMaximumForce;
    }

    void Update()
    {
        //Damp Slider => DampFactor Variable
        driveDampFactor = dampSlider.value;
        driveSpringStiff = stiffSlider.value;
        AssignDampAndStiffToJoint(configurableJoints, jointDrive, minSmallBarDamp, minBigBarDamp, driveDampFactor, driveSpringStiff);

    }

    //takes in the smallest desired damp range and assigns it linearly to joints
    void AssignDampAndStiffToJoint(ConfigurableJoint[] configurableJoints, JointDrive jointDrive, float minSmallBarDamp, float minBigBarDamp, float driveDampFactor, float driveSpringStiff)
    {
        _dampIncreasePer = ((minBigBarDamp  * driveDampFactor) - (minSmallBarDamp * driveDampFactor)) /  (configurableJoints.Length - 1);
        minSmallBarDamp *= driveDampFactor;
        for (int i = 0; i < configurableJoints.Length; i++)
        {
            jointDrive.positionDamper = minSmallBarDamp + (_dampIncreasePer * i);
            jointDrive.positionSpring = driveSpringStiff;
            configurableJoints[i].yDrive = jointDrive;
        }
    }
}
