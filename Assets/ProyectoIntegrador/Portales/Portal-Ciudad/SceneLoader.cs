using UnityEngine;
using UnityEngine.SceneManagement;

public class SceneLoader : MonoBehaviour
{
    void Start()
    {
        SceneManager.LoadScene("PI_Ciudad_07", LoadSceneMode.Additive);
        SceneManager.LoadScene("PI_CartaCopy-Barco_03", LoadSceneMode.Additive);
    }

    void OnEnable()
    {
        SceneManager.sceneLoaded += OnSceneLoaded;
    }

    void OnDisable()
    {
        SceneManager.sceneLoaded -= OnSceneLoaded;
    }

    void OnSceneLoaded(Scene scene, LoadSceneMode mode)
    {
        if (scene.name == "PI_Ciudad_07" || scene.name == "PI_CartaCopy-Barco_03")
        {
            AudioListener[] listeners = FindObjectsOfType<AudioListener>();
            if (listeners.Length > 1)
            {
                for (int i = 1; i < listeners.Length; i++)
                {
                    listeners[i].enabled = false;
                }
            }
        }
        
        if (scene.name == "PI_Ciudad_07")
        {
            SceneManager.SetActiveScene(scene);
        }
    }
}