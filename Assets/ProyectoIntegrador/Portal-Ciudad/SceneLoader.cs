using UnityEngine;
using UnityEngine.SceneManagement;

public class SceneLoader : MonoBehaviour
{
    void Start()
    {
        SceneManager.LoadScene("PI_Ciudad_07", LoadSceneMode.Additive);
    }
}