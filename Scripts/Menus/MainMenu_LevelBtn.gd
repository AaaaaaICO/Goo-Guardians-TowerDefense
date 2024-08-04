extends PanelContainer


var newScene = ""

func _on_button_pressed():
	SceneTransition.changeScene(newScene)
	Global.Level = newScene
