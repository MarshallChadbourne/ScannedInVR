using UnityEngine;

public class ChannelMap : MonoBehaviour
{
    CsoundUnity _csound;
    private float yPosition;
    private int yIntPosition;

    void Start() 
    {
       _csound = GetComponent<CsoundUnity>();

    }
    
    
    void Update()
    {
        if(!_csound.IsInitialized)
        {
            return;
        }

        yPosition = transform.position.y;
        yIntPosition = (int) (yPosition * 100);
        yPosition = (float) yIntPosition / 100;
       // Debug.Log("yint position = " + yPosition);
        _csound.SetChannel("displace", CsoundUnity.Remap(yPosition, 0.0f, 5.0f, 0.0f, 1.0f));
    }

}
