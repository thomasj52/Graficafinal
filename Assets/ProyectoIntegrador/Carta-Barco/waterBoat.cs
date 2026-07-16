using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class waterBoat : MonoBehaviour
{
    [SerializeField] private Material mat; // arrastrá el epicentro en el Inspector

    void Update()
    {
        mat.SetVector("_splashPos", transform.position);
    }

}
