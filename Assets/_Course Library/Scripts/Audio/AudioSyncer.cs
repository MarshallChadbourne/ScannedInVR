using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class AudioSyncer : MonoBehaviour
{
    //what spectrum value triggers a beat
    public float bias; 
    //minimum interval between each beat 
    public float timeStep;
    //how much time before visualization completes 
    public float timeToBeat;
    //how fast object goes to rest after beat
    public float restSmoothTime;
    //did value go above or below bias during frame
    private float m_previousAudioValue;
    private float m_audiovalue;
    //time step interval
    private float m_timer;
    //is sync object in a beat state
    protected bool m_isBeat;

    // Update is called once per frame
    private void Update()
    {
        OnUpdate();
    }

    public virtual void OnUpdate()
    {
        m_previousAudioValue = m_audiovalue;
        m_audiovalue = AudioSpectrum.spectrumValue;
        if(m_previousAudioValue > bias && m_audiovalue <= bias)
        {
            if(m_timer > timeStep)
                OnBeat();
        }
        if(m_previousAudioValue <= bias && m_audiovalue > bias)
        {
            if(m_timer > timeStep)
                OnBeat();
        }
    }
    public virtual void OnBeat()
    {
        Debug.Log("beat");
        m_timer = 0;
        m_isBeat = true;
    }
}
