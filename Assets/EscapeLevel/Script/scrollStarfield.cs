using UnityEngine;
using System.Collections;

public class scrollStarfield : MonoBehaviour {
	
	public float speed;
	private static Vector3 movement = new Vector3(0,0,0);
	
	// Use this for initialization
	void Start () {
	
	}
	
	// Update is called once per frame
	void Update () {
		movement.x += speed * Time.deltaTime;
		gameObject.transform.Translate(movement);
	}
}
