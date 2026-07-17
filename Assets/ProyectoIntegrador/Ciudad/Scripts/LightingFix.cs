using UnityEngine;
using UnityEngine.SceneManagement;

public class LightingFix : MonoBehaviour
{
    void Start()
    {
        SceneManager.SetActiveScene(gameObject.scene);
        DynamicGI.UpdateEnvironment();
    }
}