using UnityEngine;

public class CameraMovement : MonoBehaviour
{
    [Header("Velocidad de movimiento")]
    public float moveSpeed = 5f;

    void Update()
    {
        float x = Input.GetAxis("Horizontal");   // A / D
        float z = Input.GetAxis("Vertical");     // W / S

        Vector3 direction = new Vector3(x, 0f, z);

        // Mueve la cámara en su espacio local
        transform.Translate(direction * moveSpeed * Time.deltaTime);
    }
}
