using UnityEngine;
using UnityEngine.SceneManagement;

public class SceneLoader : MonoBehaviour
{
    void Start()
    {
        SceneManager.LoadScene("PI_Ciudad_07", LoadSceneMode.Additive);
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
        if (scene.name == "PI_Ciudad_07")
        {
            foreach (AudioListener al in FindObjectsOfType<AudioListener>())
            {
                if (al.gameObject.scene.name == "PI_Ciudad_07")
                    al.enabled = false;
            }
        }
    }
}