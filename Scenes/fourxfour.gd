extends Control

# This contains the texture denoted by BoxRow, BoxColumn, Row & Column
# So, "1111" = BoxRow = 1, BoxColumn = 1, Row = 1 & Column = 1
var tBtns = {"0000": "blank"}
var time_elapsed = 0.0
var bTimer = false	# True = run timer
onready var speed_clock = $HBoxContainer/CluesAndButtons/Time
var bDlgYes = false
var bDlgNo = false
var bDlgOK = false
var bDlg = false
var iDlgType = 0	# 1 == QUIT, 2 == OTHER

func _ready():
	call_deferred("allReady")

func _process(delta):
	if bTimer:
		time_elapsed += delta
		speed_clock.bbcode_text = "[center][valign px=-6]Time: " + seconds2hhmmss(time_elapsed)

	if bDlg:
		if bDlgYes:
			bDlg = false
			$dlgCheck.hide()

			if iDlgType == 1:
				get_tree().get_root().get_node("Main/VBoxContainer").show()
				var node = get_tree().get_root().get_node("Control")
				get_tree().get_root().remove_child(node)

			iDlgType = 0
		elif bDlgNo:
			bDlg = false
			iDlgType = 0
			$dlgCheck.hide()
		elif bDlgOK:
			bDlg = false
			iDlgType = 0
			$dlgCheck.hide()

func seconds2hhmmss(total_seconds):
	var seconds = fmod(total_seconds, 60.0)
	var minutes = int(total_seconds / 60.0) % 60
	var hours = int(total_seconds / 3600.0)
	var hhmmss_string = "%02d:%02d:%05.2f" % [hours, minutes, seconds]
	return hhmmss_string

func allReady():
	Common.aSolution = []
	Common.aSupp = []
	Common.clueText = ""
	clearBoard()
	bTimer = true
	bDlgYes = false
	bDlgNo = false
	bDlgOK = false
	bDlg = false

func clearBoard():
	var sNode = ""
	var sNodeL = ""
	var sNode1 = ""
	var sNode2 = ""
	var sNode3 = ""
	var sNode4 = ""
	var sNode5 = ""
	var tNode
	var sX = ""
	var sY = ""
	var sTmp = ""
	var sTmp1 = ""
	var sTmp2 = ""

	# Clues
	$HBoxContainer/CluesAndButtons/Clues.bbcode_text = " CLUES:\n Clue 1:"

	# Top Left TextBox
	$HBoxContainer/HBoxContainer/HLabels/Square11/HBoxContainer/PanelContainer/HBoxContainer/Panel2/LblTopLeft.text = ""

	# Side Labels:
	$HBoxContainer/HBoxContainer/VBoxContainer/PanelContainer2/Panel/SideLabel1.bbcode_text = ""
	$HBoxContainer/HBoxContainer/VBoxContainer/PanelContainer3/Panel/SideLabel2.bbcode_text = ""
	$HBoxContainer/HBoxContainer/VBoxContainer/PanelContainer4/Panel/SideLabel3.bbcode_text = ""
	$HBoxContainer/HBoxContainer/VBoxContainer/PanelContainer5/Panel/SideLabel4.bbcode_text = ""

	# Top Labels:
	$HBoxContainer/Column1/Panel/TopLabel1.bbcode_text = ""
	$HBoxContainer/Column2/Panel/TopLabel1.bbcode_text = ""
	$HBoxContainer/Column3/Panel/TopLabel1.bbcode_text = ""
	$HBoxContainer/Column4/Panel/TopLabel1.bbcode_text = ""

	# Vertical Labels
	sNode1 = "Control/HBoxContainer/Column"
	sNode2 = "/Square1"
	sNode3 = "/HBoxContainer/PanelContainer/HBoxContainer/Panel"
	sNode4 = "/VLabel"

	for x in range(1, 5):
		sNode5 = sNode1 + str(x) + sNode2 + str(x) + sNode3

		for y in range(1, 5):
			sNode = sNode5 + str(y + 1) + sNode4 + str(x) + str(y)
			tNode = get_tree().get_root().get_node(sNode)
			tNode.set_text("")

	# Horizontal Labels
	sNode1 = "Control/HBoxContainer/HBoxContainer/HLabels/Square"
	sNode2 = "1/HBoxContainer"
	sNode3 = "/PanelContainer/HBoxContainer/Panel2/HLabel"
	sNode4 = ""
	
	for x in range(1, 5):
		sNode = sNode1 + str(x) + sNode2

		for y in range(1, 5):
			sNode4 = sNode + str(y + 1) + sNode3 + str(x) + str(y)
			tNode = get_tree().get_root().get_node(sNode4)
			tNode.set_text("")

	# Buttons
	sNode1 = "Control/HBoxContainer/Column"
	sNode2 = "/Square"
	sNode3 = "/HBoxContainer"
	sNode4 = "/PanelContainer/HBoxContainer/Panel"

	for x in range(1, 5):		#ROW
		for y in range(1, 5):	#COLUMN
			sX = str(x)
			sY = str(y)

			if x == 1 or (x == 2 and y < 4) or (x == 3 and y < 3) or (x == 4 and y == 1):
				sNodeL = sNode1 + sY + sNode2 + sX + sY + sNode3

				for r in range(1, 5):
					sTmp = str(r + 1)

					for c in range(1, 5):
						sTmp2 = sX + sY + str(r) + str(c)
						sTmp1 = str(c + 1)
						sNode = sNodeL + sTmp + sNode4 + sTmp1 + "/btn" + sTmp2
						tNode = get_tree().get_root().get_node(sNode)
						tNode.set_normal_texture(load("res://Textures/blank.png"))
						tBtns[sTmp2] = "blank"

func setCell(inS, inType, inNode):
	var sTex = ""
	var tNode = get_tree().get_root().get_node(inNode)

	if inType == 0:
		tBtns[inS] = "blank"
		sTex = "res://Textures/blank.png"
	elif inType == 1:
		tBtns[inS] = "tick"
		sTex = "res://Textures/tick.png"
	else:
		tBtns[inS] = "cross"
		sTex = "res://Textures/cross.png"

	tNode.set_normal_texture(load(sTex))

func onBtn(BRow, BColumn, Row, Column, inEvent):
	var sTmp = str(BRow) + str(BColumn) + str(Row) + str(Column)

	if inEvent is InputEventMouseButton and inEvent.pressed:
			var sTmp1 = ""
			var sNode = "Control/HBoxContainer/Column" + str(BColumn) + "/Square" + str(BRow) + str(BColumn)
			sNode = sNode + "/HBoxContainer"
			var sNode1 = sNode + str(Row + 1) + "/PanelContainer/HBoxContainer/Panel"
			sNode1 = sNode1 + str(Column + 1) + "/btn" + sTmp
			var bOK = false
			var R1 = 0
			var C1 = 0

			match inEvent.button_index:
				BUTTON_LEFT:
					# left button clicked
					if tBtns[sTmp] == "tick":
						pass
					elif tBtns[sTmp] == "blank":
						setCell(sTmp, 1, sNode1)

						for x in range(1, 5):
							if x != Column:
								sTmp = str(BRow) + str(BColumn) + str(Row) + str(x)
								sNode1 = sNode + str(Row + 1) + "/PanelContainer/HBoxContainer/Panel"
								sNode1 = sNode1 + str(x + 1) + "/btn" + sTmp
								setCell(sTmp, 2, sNode1)

						for x in range(1, 5):
							if x != Row:
								sTmp = str(BRow) + str(BColumn) + str(x) + str(Column)
								sNode1 = sNode + str(x + 1) + "/PanelContainer/HBoxContainer/Panel"
								sNode1 = sNode1 + str(Column + 1) + "/btn" + sTmp
								setCell(sTmp, 2, sNode1)
					else:
						for x in range(1, 5):
							sTmp = str(BRow) + str(BColumn) + str(Row) + str(x)
							
							if tBtns[sTmp] == "tick":
								C1 = x

								for y in range(1, 5):
									bOK = true

									for z in range(1, 5):
										if y != Row and z != Column:
											sTmp1 = str(BRow) + str(BColumn) + str(y) + str(z)

											if tBtns[sTmp1] == "tick":
												bOK = false

									if bOK:
										sTmp1 = str(BRow) + str(BColumn) + str(y) + str(C1)
										sNode1 = sNode + str(y + 1) + "/PanelContainer/HBoxContainer/Panel"
										sNode1 = sNode1 + str(C1 + 1) + "/btn" + sTmp1
										setCell(sTmp1, 0, sNode1)

						for x in range(1, 5):
							sTmp = str(BRow) + str(BColumn) + str(x) + str(Column)
							
							if tBtns[sTmp] == "tick":
								R1 = x

								for y in range(1, 5):
									bOK = true

									for z in range(1, 5):
										if y != Row and z != Column:
											sTmp1 = str(BRow) + str(BColumn) + str(y) + str(z)

											if tBtns[sTmp1] == "tick":
												bOK = false

									if bOK:
										sTmp1 = str(BRow) + str(BColumn) + str(R1) + str(y)
										sNode1 = sNode + str(R1 + 1) + "/PanelContainer/HBoxContainer/Panel"
										sNode1 = sNode1 + str(y + 1) + "/btn" + sTmp1
										setCell(sTmp1, 0, sNode1)

						sTmp1 = str(BRow) + str(BColumn) + str(Row) + str(Column)
						sNode1 = sNode + str(Row + 1) + "/PanelContainer/HBoxContainer/Panel"
						sNode1 = sNode1 + str(Column + 1) + "/btn" + sTmp1
						setCell(sTmp1, 1, sNode1)

						for x in range(1, 5):
							if x != Row:
								sTmp1 = str(BRow) + str(BColumn) + str(x) + str(Column)
								sNode1 = sNode + str(x + 1) + "/PanelContainer/HBoxContainer/Panel"
								sNode1 = sNode1 + str(Column + 1) + "/btn" + sTmp1
								setCell(sTmp1, 2, sNode1)

						for x in range(1, 5):
							if x != Column:
								sTmp1 = str(BRow) + str(BColumn) + str(Row) + str(x)
								sNode1 = sNode + str(Row + 1) + "/PanelContainer/HBoxContainer/Panel"
								sNode1 = sNode1 + str(x + 1) + "/btn" + sTmp1
								setCell(sTmp1, 2, sNode1)
				BUTTON_RIGHT:
					# right button clicked
					if tBtns[sTmp] == "blank":
						setCell(sTmp, 2, sNode1)
					elif tBtns[sTmp] == "cross":
						bOK = true

						for x in range(1, 5):
							if x != Column:
								sTmp = str(BRow) + str(BColumn) + str(Row) + str(x)

								if tBtns[sTmp] == "tick":
									bOK = false

						for x in range(1, 5):
							if x != Row:
								sTmp = str(BRow) + str(BColumn) + str(x) + str(Column)

								if tBtns[sTmp] == "tick":
									bOK = false

						if bOK:
							setCell(sTmp, 0, sNode1)
					else:
						setCell(sTmp, 0, sNode1)

						for x in range(1, 5):
							bOK = true

							for y in range(1, 5):
								sTmp = str(BRow) + str(BColumn) + str(x) + str(y)
			
								if tBtns[sTmp] == "tick":
									bOK = false

							if bOK:
								sTmp1 = str(BRow) + str(BColumn) + str(x) + str(Column)
								sNode1 = sNode + str(x + 1) + "/PanelContainer/HBoxContainer/Panel"
								sNode1 = sNode1 + str(Column + 1) + "/btn" + sTmp1
								setCell(sTmp1, 0, sNode1)

						for x in range(1, 5):
							bOK = true

							for y in range(1, 5):
								sTmp = str(BRow) + str(BColumn) + str(y) + str(x)
			
								if tBtns[sTmp] == "tick":
									bOK = false

							if bOK:
								sTmp1 = str(BRow) + str(BColumn) + str(Row) + str(x)
								sNode1 = sNode + str(Row + 1) + "/PanelContainer/HBoxContainer/Panel"
								sNode1 = sNode1 + str(x + 1) + "/btn" + sTmp1
								setCell(sTmp1, 0, sNode1)

# Button Presses:
func _on_btnSupp_pressed():
	var node = $HBoxContainer/CluesAndButtons/Clues
	var sTxt = "\n"

	for x in Common.aSupp:
		sTxt = sTxt + x + "\n"

	Common.clueText = node.get_bbcode() + sTxt
	node.set_bbcode(Common.clueText)
	time_elapsed += 30
	$HBoxContainer/CluesAndButtons/Buttons/VBoxContainer/HBoxContainer2/btnSupp.disabled = true

func _on_btnCheck_pressed():
	var bOK = true
	bTimer = false

	for y in Common.aSolution:
		if tBtns[y] != "tick":
			bOK = false

	if bOK:
		var sT = seconds2hhmmss(time_elapsed)
		updateDlg("Congratulations!", "Congratulations! You have completed the puzzle in:\n\n" + sT, 2, false, false, true)
	else:
		var sT = ""
		var bDisabled = $HBoxContainer/CluesAndButtons/Buttons/VBoxContainer/HBoxContainer2/btnSupp.is_disabled()

		if not bDisabled:
			sT = "Sorry, that is not correct!\n\nPress the [color=red]MORE CLUES[/color] button to get some more clues."
		else:
			sT = "Sorry, that is not correct!"

		updateDlg("Not this time!", sT, 2, false, false, true)
		bTimer = true

func _on_btnQuit_pressed():
	updateDlg("Are you sure?", "Are you sure you want to exit the game?", 1, true, true, false)

# these are labelled as 1111 == BOX 11 (i.e. ROW 1 COLUMN 1) ROW 1 COLUMN 1
func _on_btn1111_gui_input(event):
	onBtn(1,1,1,1,event)

func _on_btn1112_gui_input(event):
	onBtn(1,1,1,2,event)

func _on_btn1113_gui_input(event):
	onBtn(1,1,1,3,event)

func _on_btn1114_gui_input(event):
	onBtn(1,1,1,4,event)

func _on_btn1121_gui_input(event):
	onBtn(1,1,2,1,event)

func _on_btn1122_gui_input(event):
	onBtn(1,1,2,2,event)

func _on_btn1123_gui_input(event):
	onBtn(1,1,2,3,event)

func _on_btn1124_gui_input(event):
	onBtn(1,1,2,4,event)

func _on_btn1131_gui_input(event):
	onBtn(1,1,3,1,event)

func _on_btn1132_gui_input(event):
	onBtn(1,1,3,2,event)

func _on_btn1133_gui_input(event):
	onBtn(1,1,3,3,event)

func _on_btn1134_gui_input(event):
	onBtn(1,1,3,4,event)

func _on_btn1141_gui_input(event):
	onBtn(1,1,4,1,event)

func _on_btn1142_gui_input(event):
	onBtn(1,1,4,2,event)

func _on_btn1143_gui_input(event):
	onBtn(1,1,4,3,event)

func _on_btn1144_gui_input(event):
	onBtn(1,1,4,4,event)

func _on_btn2111_gui_input(event):
	onBtn(2,1,1,1,event)

func _on_btn2112_gui_input(event):
	onBtn(2,1,1,2,event)

func _on_btn2113_gui_input(event):
	onBtn(2,1,1,3,event)

func _on_btn2114_gui_input(event):
	onBtn(2,1,1,4,event)

func _on_btn2121_gui_input(event):
	onBtn(2,1,2,1,event)

func _on_btn2122_gui_input(event):
	onBtn(2,1,2,2,event)

func _on_btn2123_gui_input(event):
	onBtn(2,1,2,3,event)

func _on_btn2124_gui_input(event):
	onBtn(2,1,2,4,event)

func _on_btn2131_gui_input(event):
	onBtn(2,1,3,1,event)

func _on_btn2132_gui_input(event):
	onBtn(2,1,3,2,event)

func _on_btn2133_gui_input(event):
	onBtn(2,1,3,3,event)

func _on_btn2134_gui_input(event):
	onBtn(2,1,3,4,event)

func _on_btn2141_gui_input(event):
	onBtn(2,1,4,1,event)

func _on_btn2142_gui_input(event):
	onBtn(2,1,4,2,event)

func _on_btn2143_gui_input(event):
	onBtn(2,1,4,3,event)

func _on_btn2144_gui_input(event):
	onBtn(2,1,4,4,event)

func _on_btn3111_gui_input(event):
	onBtn(3,1,1,1,event)

func _on_btn3112_gui_input(event):
	onBtn(3,1,1,2,event)

func _on_btn3113_gui_input(event):
	onBtn(3,1,1,3,event)

func _on_btn3114_gui_input(event):
	onBtn(3,1,1,4,event)

func _on_btn3121_gui_input(event):
	onBtn(3,1,2,1,event)

func _on_btn3122_gui_input(event):
	onBtn(3,1,2,2,event)

func _on_btn3123_gui_input(event):
	onBtn(3,1,2,3,event)

func _on_btn3124_gui_input(event):
	onBtn(3,1,2,4,event)

func _on_btn3131_gui_input(event):
	onBtn(3,1,3,1,event)

func _on_btn3132_gui_input(event):
	onBtn(3,1,3,2,event)

func _on_btn3133_gui_input(event):
	onBtn(3,1,3,3,event)

func _on_btn3134_gui_input(event):
	onBtn(3,1,3,4,event)

func _on_btn3141_gui_input(event):
	onBtn(3,1,4,1,event)

func _on_btn3142_gui_input(event):
	onBtn(3,1,4,2,event)

func _on_btn3143_gui_input(event):
	onBtn(3,1,4,3,event)

func _on_btn3144_gui_input(event):
	onBtn(3,1,4,4,event)

func _on_btn4111_gui_input(event):
	onBtn(4,1,1,1,event)

func _on_btn4112_gui_input(event):
	onBtn(4,1,1,2,event)

func _on_btn4113_gui_input(event):
	onBtn(4,1,1,3,event)

func _on_btn4114_gui_input(event):
	onBtn(4,1,1,4,event)

func _on_btn4121_gui_input(event):
	onBtn(4,1,2,1,event)

func _on_btn4122_gui_input(event):
	onBtn(4,1,2,2,event)

func _on_btn4123_gui_input(event):
	onBtn(4,1,2,3,event)

func _on_btn4124_gui_input(event):
	onBtn(4,1,2,4,event)

func _on_btn4131_gui_input(event):
	onBtn(4,1,3,1,event)

func _on_btn4132_gui_input(event):
	onBtn(4,1,3,2,event)

func _on_btn4133_gui_input(event):
	onBtn(4,1,3,3,event)

func _on_btn4134_gui_input(event):
	onBtn(4,1,3,4,event)

func _on_btn4141_gui_input(event):
	onBtn(4,1,4,1,event)

func _on_btn4142_gui_input(event):
	onBtn(4,1,4,2,event)

func _on_btn4143_gui_input(event):
	onBtn(4,1,4,3,event)

func _on_btn4144_gui_input(event):
	onBtn(4,1,4,4,event)

func _on_btn1211_gui_input(event):
	onBtn(1,2,1,1,event)

func _on_btn1212_gui_input(event):
	onBtn(1,2,1,2,event)

func _on_btn1213_gui_input(event):
	onBtn(1,2,1,3,event)

func _on_btn1214_gui_input(event):
	onBtn(1,2,1,4,event)

func _on_btn1221_gui_input(event):
	onBtn(1,2,2,1,event)

func _on_btn1222_gui_input(event):
	onBtn(1,2,2,2,event)

func _on_btn1223_gui_input(event):
	onBtn(1,2,2,3,event)

func _on_btn1224_gui_input(event):
	onBtn(1,2,2,4,event)

func _on_btn1231_gui_input(event):
	onBtn(1,2,3,1,event)

func _on_btn1232_gui_input(event):
	onBtn(1,2,3,2,event)

func _on_btn1233_gui_input(event):
	onBtn(1,2,3,3,event)

func _on_btn1234_gui_input(event):
	onBtn(1,2,3,4,event)

func _on_btn1241_gui_input(event):
	onBtn(1,2,4,1,event)

func _on_btn1242_gui_input(event):
	onBtn(1,2,4,2,event)

func _on_btn1243_gui_input(event):
	onBtn(1,2,4,3,event)

func _on_btn1244_gui_input(event):
	onBtn(1,2,4,4,event)

func _on_btn2211_gui_input(event):
	onBtn(2,2,1,1,event)

func _on_btn2212_gui_input(event):
	onBtn(2,2,1,2,event)

func _on_btn2213_gui_input(event):
	onBtn(2,2,1,3,event)

func _on_btn2214_gui_input(event):
	onBtn(2,2,1,4,event)

func _on_btn2221_gui_input(event):
	onBtn(2,2,2,1,event)

func _on_btn2222_gui_input(event):
	onBtn(2,2,2,2,event)

func _on_btn2223_gui_input(event):
	onBtn(2,2,2,3,event)

func _on_btn2224_gui_input(event):
	onBtn(2,2,2,4,event)

func _on_btn2231_gui_input(event):
	onBtn(2,2,3,1,event)

func _on_btn2232_gui_input(event):
	onBtn(2,2,3,2,event)

func _on_btn2233_gui_input(event):
	onBtn(2,2,3,3,event)

func _on_btn2234_gui_input(event):
	onBtn(2,2,3,4,event)

func _on_btn2241_gui_input(event):
	onBtn(2,2,4,1,event)

func _on_btn2242_gui_input(event):
	onBtn(2,2,4,2,event)

func _on_btn2243_gui_input(event):
	onBtn(2,2,4,3,event)

func _on_btn2244_gui_input(event):
	onBtn(2,2,4,4,event)

func _on_btn3211_gui_input(event):
	onBtn(3,2,1,1,event)

func _on_btn3212_gui_input(event):
	onBtn(3,2,1,2,event)

func _on_btn3213_gui_input(event):
	onBtn(3,2,1,3,event)

func _on_btn3214_gui_input(event):
	onBtn(3,2,1,4,event)

func _on_btn3221_gui_input(event):
	onBtn(3,2,2,1,event)

func _on_btn3222_gui_input(event):
	onBtn(3,2,2,2,event)

func _on_btn3223_gui_input(event):
	onBtn(3,2,2,3,event)

func _on_btn3224_gui_input(event):
	onBtn(3,2,2,4,event)

func _on_btn3231_gui_input(event):
	onBtn(3,2,3,1,event)

func _on_btn3232_gui_input(event):
	onBtn(3,2,3,2,event)

func _on_btn3233_gui_input(event):
	onBtn(3,2,3,3,event)

func _on_btn3234_gui_input(event):
	onBtn(3,2,3,4,event)

func _on_btn3241_gui_input(event):
	onBtn(3,2,4,1,event)

func _on_btn3242_gui_input(event):
	onBtn(3,2,4,2,event)

func _on_btn3243_gui_input(event):
	onBtn(3,2,4,3,event)

func _on_btn3244_gui_input(event):
	onBtn(3,2,4,4,event)

func _on_btn1311_gui_input(event):
	onBtn(1,3,1,1,event)

func _on_btn1312_gui_input(event):
	onBtn(1,3,1,2,event)

func _on_btn1313_gui_input(event):
	onBtn(1,3,1,3,event)

func _on_btn1314_gui_input(event):
	onBtn(1,3,1,4,event)

func _on_btn1321_gui_input(event):
	onBtn(1,3,2,1,event)

func _on_btn1322_gui_input(event):
	onBtn(1,3,2,2,event)

func _on_btn1323_gui_input(event):
	onBtn(1,3,2,3,event)

func _on_btn1324_gui_input(event):
	onBtn(1,3,2,4,event)

func _on_btn1331_gui_input(event):
	onBtn(1,3,3,1,event)

func _on_btn1332_gui_input(event):
	onBtn(1,3,3,2,event)

func _on_btn1333_gui_input(event):
	onBtn(1,3,3,3,event)

func _on_btn1334_gui_input(event):
	onBtn(1,3,3,4,event)

func _on_btn1341_gui_input(event):
	onBtn(1,3,4,1,event)

func _on_btn1342_gui_input(event):
	onBtn(1,3,4,2,event)

func _on_btn1343_gui_input(event):
	onBtn(1,3,4,3,event)

func _on_btn1344_gui_input(event):
	onBtn(1,3,4,4,event)

func _on_btn1411_gui_input(event):
	onBtn(1,4,1,1,event)

func _on_btn1412_gui_input(event):
	onBtn(1,4,1,2,event)

func _on_btn1413_gui_input(event):
	onBtn(1,4,1,3,event)

func _on_btn1414_gui_input(event):
	onBtn(1,4,1,4,event)

func _on_btn1421_gui_input(event):
	onBtn(1,4,2,1,event)

func _on_btn1422_gui_input(event):
	onBtn(1,4,2,2,event)

func _on_btn1423_gui_input(event):
	onBtn(1,4,2,3,event)

func _on_btn1424_gui_input(event):
	onBtn(1,4,2,4,event)

func _on_btn1431_gui_input(event):
	onBtn(1,4,3,1,event)

func _on_btn1432_gui_input(event):
	onBtn(1,4,3,2,event)

func _on_btn1433_gui_input(event):
	onBtn(1,4,3,3,event)

func _on_btn1434_gui_input(event):
	onBtn(1,4,3,4,event)

func _on_btn1441_gui_input(event):
	onBtn(1,4,4,1,event)

func _on_btn1442_gui_input(event):
	onBtn(1,4,4,2,event)

func _on_btn1443_gui_input(event):
	onBtn(1,4,4,3,event)

func _on_btn1444_gui_input(event):
	onBtn(1,4,4,4,event)

func _on_btn2311_gui_input(event):
	onBtn(2,3,1,1,event)

func _on_btn2312_gui_input(event):
	onBtn(2,3,1,2,event)

func _on_btn2313_gui_input(event):
	onBtn(2,3,1,3,event)

func _on_btn2314_gui_input(event):
	onBtn(2,3,1,4,event)

func _on_btn2321_gui_input(event):
	onBtn(2,3,2,1,event)

func _on_btn2322_gui_input(event):
	onBtn(2,3,2,2,event)

func _on_btn2323_gui_input(event):
	onBtn(2,3,2,3,event)

func _on_btn2324_gui_input(event):
	onBtn(2,3,2,4,event)

func _on_btn2331_gui_input(event):
	onBtn(2,3,3,1,event)

func _on_btn2332_gui_input(event):
	onBtn(2,3,3,2,event)

func _on_btn2333_gui_input(event):
	onBtn(2,3,3,3,event)

func _on_btn2334_gui_input(event):
	onBtn(2,3,3,4,event)

func _on_btn2341_gui_input(event):
	onBtn(2,3,4,1,event)

func _on_btn2342_gui_input(event):
	onBtn(2,3,4,2,event)

func _on_btn2343_gui_input(event):
	onBtn(2,3,4,3,event)

func _on_btn2344_gui_input(event):
	onBtn(2,3,4,4,event)

# Dialog
func updateDlg(inHeader, inContent, inType, bYes, bNo, bOK):
	bDlg = true
	iDlgType = inType
	$dlgCheck/VBoxContainer/Header.bbcode_text = "[center]" + inHeader
	$dlgCheck/VBoxContainer/Content.bbcode_text = "[center][valign px=-18]" + inContent

	if bYes:
		$dlgCheck/VBoxContainer/HBoxContainer/btnYes.visible = true
	else:
		$dlgCheck/VBoxContainer/HBoxContainer/btnYes.visible = false

	if bOK:
		$dlgCheck/VBoxContainer/HBoxContainer/btnOK.visible = true
	else:
		$dlgCheck/VBoxContainer/HBoxContainer/btnOK.visible = false

	if bNo:
		$dlgCheck/VBoxContainer/HBoxContainer/btnNo.visible = true
	else:
		$dlgCheck/VBoxContainer/HBoxContainer/btnNo.visible = false

	bDlgYes = false
	bDlgNo = false
	bDlgOK = false
	$dlgCheck.show()

# dlgCheck Buttons
func _on_btnYes_pressed():
	bDlgYes = true
	bDlgNo = false
	bDlgOK = false

func _on_btnOK_pressed():
	bDlgYes = false
	bDlgNo = false
	bDlgOK = true

func _on_btnNo_pressed():
	bDlgYes = false
	bDlgNo = true
	bDlgOK = false
