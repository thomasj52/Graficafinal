using UnityEngine;
using System.Collections;

public class LightningBolt : MonoBehaviour
{
    public LineRenderer lineRenderer;
    public int segments = 12;
    public float displacementAmount = 3f;
    public float boltDuration = 0.15f;

    public Vector3 startPosition = new Vector3(0, 25, 0);
    public Vector3 endPosition = new Vector3(0, 0, 0);

    void Start()
    {
        if (lineRenderer == null)
            lineRenderer = GetComponent<LineRenderer>();

        lineRenderer.startWidth = 2f;
        lineRenderer.endWidth = 0.3f;
        lineRenderer.enabled = false;
    }

    public void TriggerBolt()
    {
        StartCoroutine(ShowBolt());
    }

    IEnumerator ShowBolt()
    {
        GenerateZigZag();
        lineRenderer.enabled = true;
        yield return new WaitForSeconds(boltDuration * 0.4f);

        GenerateZigZag();
        yield return new WaitForSeconds(boltDuration * 0.6f);

        lineRenderer.enabled = false;
    }

    void GenerateZigZag()
    {
        lineRenderer.positionCount = segments;

        for (int i = 0; i < segments; i++)
        {
            float t = (float)i / (segments - 1);
            Vector3 point = Vector3.Lerp(startPosition, endPosition, t);

            if (i != 0 && i != segments - 1)
            {
                point.x += Random.Range(-displacementAmount, displacementAmount);
                point.z += Random.Range(-displacementAmount * 0.5f, displacementAmount * 0.5f);
            }

            lineRenderer.SetPosition(i, point);
        }
    }
}