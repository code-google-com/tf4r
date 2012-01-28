/*
 First script to run, will make the "To be continued" 
 text scroll from bottom to tom of the screen and make
 the alpha channel increase from 0 to 1.
 
 After that the script to make the title screen picture
 appear will be started.
*/

function Update () {
	// scrolls up the text "To be continued."
	transform.Translate(Vector3(0,0.113*Time.deltaTime,0));
	// and make it visible
	if( guiTexture.color.a < 255) {
		guiTexture.color.a += 0.05*Time.deltaTime;
	}
	
	if( transform.position.y > 1) {
		var titleScreen = gameObject.Find("titleScreen");
		titleScreen.GetComponent("title screen appear").enabled = true;
		enabled=false;
	}
}
