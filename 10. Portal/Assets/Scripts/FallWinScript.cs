using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.SceneManagement;

public class FallWinScript : MonoBehaviour
{
    private Vector3 initialPosition;
    public WinManager winManager;
    
    void Start()
    {
        initialPosition = transform.position;
    }

    void Update()
    {
        if (transform.position.y < -15)
        {
            transform.position = initialPosition;
        }
        
        if (Input.GetKeyDown(KeyCode.R))
        {
            SceneManager.LoadScene(SceneManager.GetActiveScene().name);
        }
    }
    
    void OnTriggerEnter(Collider other)
    {
        if (other.CompareTag("WinCollider"))
        {
            if (!winManager.hasWon)
            {
                winManager.PlayerWon();
            }
        }
    }
}
