using UnityEngine;
using UnityEngine.SceneManagement;

public class SceneLoader : MonoBehaviour
{
    void Start()
    {
        // Cargamos ambas escenas en paralelo de forma aditiva
        SceneManager.LoadScene("PI_Ciudad_07", LoadSceneMode.Additive);
        SceneManager.LoadScene("PI_Carta-Barco_03", LoadSceneMode.Additive);
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
        // Si se carga la ciudad o la escena del barco, limpiamos sus AudioListeners
        if (scene.name == "PI_Ciudad_07" || scene.name == "PI_Carta-Barco_03")
        {
            foreach (AudioListener al in FindObjectsOfType<AudioListener>())
            {
                // Desactivamos el AudioListener si pertenece a cualquiera de las dos escenas cargadas
                if (al.gameObject.scene.name == scene.name)
                {
                    al.enabled = false;
                }
            }
        }
    }
}