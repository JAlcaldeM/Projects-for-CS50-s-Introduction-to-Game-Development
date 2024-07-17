using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;

public class WinManager : MonoBehaviour
{   

    public Text winText;
    public Text timeText;
    private float startTime;
    public bool hasWon = false;
    private float highscore;
    public AudioClip winSound;
    public GameObject portalGunFPSController;
    private AudioSource audioSource;
    
    void Start()
    {
        winText.gameObject.SetActive(false);
        timeText.gameObject.SetActive(false);
        startTime = Time.time;
        highscore = PlayerPrefs.GetFloat("Highscore", float.MaxValue);
        audioSource = portalGunFPSController.GetComponent<AudioSource>();
    }

    public void PlayerWon()
    {
        hasWon = true;
        float elapsedTime = Time.time - startTime;
        
        if (elapsedTime < highscore)
            {
                highscore = elapsedTime;
                PlayerPrefs.SetFloat("Highscore", highscore);
            }
        
        winText.gameObject.SetActive(true);
        timeText.gameObject.SetActive(true);
        timeText.text = string.Format("Time: {0:F2} seconds\nHighscore: {1:F2} seconds\nPush R to restart the level", elapsedTime, highscore); 
        audioSource.PlayOneShot(winSound);
    }
}
