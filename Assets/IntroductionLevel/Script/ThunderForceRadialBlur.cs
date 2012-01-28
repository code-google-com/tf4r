/*
 Makes the title "Thunder Force" appear using a radial blur effect
 with blending (One) at the beginning.
 */

using UnityEngine;
using System.Collections;

public class ThunderForceRadialBlur : MonoBehaviour
{
	private float radialBlur = 0.1f;
	private static Color enabledColor = new Color(1.0f,1.0f,1.0f,1.0f);
	private static Color disabledColor = new Color(1.0f,1.0f,1.0f,0.0f);
	
	// Use this for initialization
	void Start () {
		renderer.material.color = enabledColor;
	}

	// Update is called once per frame
	void Update () {
		radialBlur -= 0.005f;

		renderer.material.SetFloat( "_BlurRadius", radialBlur );
		
		if( radialBlur <= 0 ) {
		    renderer.materials[1].SetColor("_Color", enabledColor);
		    renderer.materials[0].SetColor("_Color", disabledColor);
			(GameObject.Find("IVTitle").GetComponent("IVRadialBlur") as IVRadialBlur).enabled = true;
			enabled = false;
		}
	}
}
