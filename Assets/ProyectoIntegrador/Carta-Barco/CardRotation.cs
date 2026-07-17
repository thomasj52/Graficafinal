using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class CardRotation : MonoBehaviour
{
    public float amplitud = 15f;   // Grados máximos de inclinación a cada lado
    public float velocidad = 2f;   // Velocidad de oscilación

    private float anguloInicial;

    void Start()
    {
        // Guardamos el ángulo inicial en Y para que oscile alrededor de él
        anguloInicial = transform.eulerAngles.y;
    }

    void Update()
    {
        // Calculamos el ángulo oscilante con seno
        float anguloY = anguloInicial + Mathf.Sin(Time.time * velocidad) * amplitud;

        // Aplicamos la rotación solo en Y
        transform.eulerAngles = new Vector3(
            transform.eulerAngles.x,
            anguloY,
            transform.eulerAngles.z
        );
    }
}
