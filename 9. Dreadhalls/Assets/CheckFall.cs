using UnityEngine;
using UnityEngine.SceneManagement;

public class CheckFall : MonoBehaviour {
    
    public AudioSource WhisperSource;

    // Update is called once per frame
    void Update () {
        // Check if the y position is less than -80
        if (transform.position.y < -80) {
            DontDestroy.instance.DestroyWhisper();
            // Load the Restart scene
            SceneManager.LoadScene("Restart");
        }
    }
}
