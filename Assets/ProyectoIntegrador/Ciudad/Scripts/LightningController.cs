using UnityEngine;
using System.Collections;

public class LightningController : MonoBehaviour
{
    public Light lightningLight;

    public float minTime = 4f;
    public float maxTime = 10f;

    public float flashIntensity = 2.5f;

    public float baseIntensity = 0.5f;

    public AudioSource thunderAudio;

    public LightningBolt lightningBolt;

    private Color originalFogColor;
    public Color lightningFogColor = new Color(0.65f, 0.7f, 0.8f);

    private void Start()
    {
        originalFogColor = RenderSettings.fogColor;
        lightningLight.intensity = baseIntensity;

        StartCoroutine(LightningRoutine());
    }

    IEnumerator LightningRoutine()
    {
        while (true)
        {
            yield return new WaitForSeconds(Random.Range(minTime, maxTime));

            yield return Flash();
        }
    }

    IEnumerator Flash()
    {
        if (lightningBolt != null)
            lightningBolt.TriggerBolt();

        RenderSettings.fogColor = lightningFogColor;
        lightningLight.intensity = flashIntensity;
        yield return new WaitForSeconds(0.04f);

        lightningLight.intensity = baseIntensity;
        yield return new WaitForSeconds(0.02f);

        lightningLight.intensity = flashIntensity * 0.6f;
        yield return new WaitForSeconds(0.06f);

        lightningLight.intensity = baseIntensity;
        RenderSettings.fogColor = originalFogColor;

        float distancia = Random.Range(0.8f, 2f);
        yield return new WaitForSeconds(distancia);

        thunderAudio.Play();
    }
}