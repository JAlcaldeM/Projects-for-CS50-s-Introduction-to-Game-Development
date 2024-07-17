using UnityEngine;

public class PortalGunFPSController : MonoBehaviour
{
    private Vector3 initialPosition; // Almacenar la posición inicial

    void Start()
    {
        // Guardar la posición inicial
        initialPosition = transform.position;
    }

    void Update()
    {
        // Verificar si la posición y es menor que -10
        if (transform.position.y < -10)
        {
            // Resetear la posición a la inicial
            transform.position = initialPosition;
        }
    }

    void OnTriggerEnter(Collider other)
    {
        // Verificar si el objeto ha colisionado con el `Collider` específico
        if (other.CompareTag("WinCollider")) // Suponiendo que el collider tiene la etiqueta "WinCollider"
        {
            // Imprimir el mensaje en la consola
            Debug.Log("has ganado");
        }
    }
}
