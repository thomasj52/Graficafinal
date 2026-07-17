using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using static UnityEngine.EventSystems.EventTrigger;

public class waterBoat : MonoBehaviour
{
    [SerializeField] private Material mat; // arrastrá el epicentro en el Inspector

    public Transform centro;    // Punto central del área
    public float radio = 5f;    // Radio del círculo
    public float velocidad = 1f; // Velocidad angular

    private float angulo = 0f;

    void Update()
    {
        mat.SetVector("_splashPos", transform.position);
        angulo += velocidad * Time.deltaTime;

        // Calculamos la posición relativa al centro
        float x = Mathf.Cos(angulo) * radio;
        float z = Mathf.Sin(angulo) * radio;
        Vector3 nuevaPosicion = centro.position + new Vector3(x, 0, z);

        // Dirección hacia la que se mueve
        Vector3 direccion = nuevaPosicion - transform.position;

        // Actualizamos posición
        transform.position = nuevaPosicion;

        // Rotamos el barco para que mire hacia adelante
        if (direccion != Vector3.zero)
        {
            Quaternion rotacion = Quaternion.LookRotation(direccion);
            transform.rotation = Quaternion.Slerp(transform.rotation, rotacion, 5f * Time.deltaTime);
        }
    }
}
