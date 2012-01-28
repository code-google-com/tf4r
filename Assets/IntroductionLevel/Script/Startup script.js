// Fixes framerate to 60 frames per second
function Awake() {
	print("Setting application framerate to 60 fps");
	Application.targetFrameRate=60;
}