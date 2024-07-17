using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.SceneManagement;

public class LoadSceneOnInput : MonoBehaviour {

    void Start () {}

    void Update() {
        if (Input.GetButtonDown("Submit")) {
            string currentSceneName = SceneManager.GetActiveScene().name;
            if (currentSceneName == "Title") {
                GlobalVariables.roomNumber = 1;
                Debug.Log("Room Number: " + GlobalVariables.roomNumber);
                SceneManager.LoadScene("Play");
            } else if (currentSceneName == "Restart") {
                SceneManager.LoadScene("Title");
            }
        }
    }
}
