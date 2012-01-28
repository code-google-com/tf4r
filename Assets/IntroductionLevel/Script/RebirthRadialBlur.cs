/*
 Makes the title "Rebirth" appear using a radial blur effect
 with blending (One) at the beginning.
 */

using UnityEngine;
using System.Collections;

public class RebirthRadialBlur : MonoBehaviour
{
	private float radialBlur = 0.1f;
	private Shader radialBlurNoBlendShader;
	private static Color enabledColor = new Color(1.0f,1.0f,1.0f,1.0f);
	
	// Use this for initialization
	void Start () {
		radialBlurNoBlendShader = Shader.Find("TF4R/RadialBlur");
		renderer.material.color = enabledColor;
	}

	// Update is called once per frame
	void Update () {
		radialBlur -= 0.005f;

		renderer.material.SetFloat( "_BlurRadius", radialBlur );
		
		if( radialBlur <= 0 ) {
		    renderer.material.shader = radialBlurNoBlendShader;
		    renderer.material.color = enabledColor;
		    renderer.material.SetFloat( "_BlurRadius", 0 );
			GameObject.Find("pressReturnKeyContainer").animation.Play();
			(GameObject.Find("pressReturnKey").GetComponent("PressReturnKeyAction") as PressReturnKeyAction).enabled = true;
			enabled = false;
		}
	}
}
