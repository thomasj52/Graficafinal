using UnityEngine;

[ExecuteInEditMode]
public class VignetteEffect : MonoBehaviour
{
    public Shader vignetteShader;

    private Material vignetteMaterial;

    void Start()
    {
        vignetteMaterial = new Material(vignetteShader);
    }

    private void OnRenderImage(RenderTexture source, RenderTexture destination)
    {
            Graphics.Blit(source, destination, vignetteMaterial);  
    }
}