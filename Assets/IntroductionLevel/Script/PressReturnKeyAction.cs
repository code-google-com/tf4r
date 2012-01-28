using UnityEngine;
using System.Collections;

public class PressReturnKeyAction : MonoBehaviour {
	// Update is called once per frame
	void Update () {
		if( Input.GetKeyDown(KeyCode.Return) ) {
			// print("ENTER pressed!");
			Application.LoadLevel(1);
		}
	}
}
