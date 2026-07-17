using UnityEngine;

public class HubLighting : MonoBehaviour
{
    public float ambientIntensity = 0.1f;

    void Update()
    {
        RenderSettings.ambientIntensity = ambientIntensity;
    }
}