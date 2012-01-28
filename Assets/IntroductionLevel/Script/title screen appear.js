/*
 Makes the title screen picture appear by
 increasing the alpha channel from 0 to 1.
 
 Then the script to make appear the title
 text "Thunder Force" using a radial blur
 effect with blending will be started.
*/
function Update () {
	// and make it visible
	if( renderer.material.color.a < 1) {
		renderer.material.color.a += 0.4*Time.deltaTime;
	} else {
		var thunderForce = gameObject.Find("ThunderForceTitle");
		thunderForce.GetComponent("ThunderForceRadialBlur").enabled = true;
		enabled=false;
	}
}