using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class waterBoat : MonoBehaviour
{
    [SerializeField] private Material mat; // arrastrá el epicentro en el Inspector

    public float radio = 5f;          // Radio del círculo
    public float velocidad = 1f;      // Velocidad angular del movimiento
    public float velocidadRotacion = 50f; // Velocidad de rotación propia

    private float angulo = 0f;

    void Update()
    {
        mat.SetVector("_splashPos", transform.position);
        angulo += velocidad * Time.deltaTime;

        // Calculamos la nueva posición en el círculo
        float x = Mathf.Cos(angulo) * radio;
        float z = Mathf.Sin(angulo) * radio;
        Vector3 nuevaPosicion = new Vector3(x, transform.position.y, z);

        // Dirección hacia la que se mueve
        Vector3 direccion = nuevaPosicion - transform.position;

        // Actualizamos posición
        transform.position = nuevaPosicion;

        // Rotamos el barco para que mire hacia adelante en la dirección del movimiento
        if (direccion != Vector3.zero)
        {
            Quaternion rotacion = Quaternion.LookRotation(direccion);
            transform.rotation = rotacion;
        }
    }
}
