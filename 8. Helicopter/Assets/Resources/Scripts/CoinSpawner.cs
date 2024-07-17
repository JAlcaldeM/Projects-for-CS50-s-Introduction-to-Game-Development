using UnityEngine;
using System.Collections;

public class CoinSpawner : MonoBehaviour {

    public GameObject coinPrefab;
    public GameObject gemPrefab;
    private float gemProbability = 0.2f;

    void Start () {
        StartCoroutine(SpawnItems());
    }

    void Update () {}

    IEnumerator SpawnItems() {
        while (true) {
            int coinsThisRow = Random.Range(1, 4);

            if (Random.value < gemProbability) {
                Instantiate(gemPrefab, new Vector3(26, Random.Range(-6, 6), 10), Quaternion.identity);
            } else {
                for (int i = 0; i < coinsThisRow; i++) {
                    Instantiate(coinPrefab, new Vector3(26, Random.Range(-6, 6), 10), Quaternion.identity);
                }
            }

            yield return new WaitForSeconds(Random.Range(1, 5));
        }
    }
}
