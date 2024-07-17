using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.SceneManagement;

public class GrabPickups : MonoBehaviour {

	private AudioSource pickupSoundSource;

	void Awake() {
		pickupSoundSource = DontDestroy.instance.GetComponents<AudioSource>()[1];
	}

	void OnControllerColliderHit(ControllerColliderHit hit) {
		if (hit.gameObject.tag == "Pickup") {
			pickupSoundSource.Play();
      GlobalVariables.roomNumber += 1;
      Debug.Log("Room Number: " + GlobalVariables.roomNumber);
      hit.gameObject.SetActive(false);
			SceneManager.LoadScene("Play");
		}
	}
}
