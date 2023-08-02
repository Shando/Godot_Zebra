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
				clearBoard()
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
	time_elapsed = 0
	bTimer = true

	$HBoxContainer/CluesAndButtons/Buttons/VBoxContainer/HBoxContainer2/btnSupp.disabled = false
	$HBoxContainer/CluesAndButtons/Buttons/VBoxContainer/HBoxContainer2/btnGiveUp.disabled = false
	$HBoxContainer/CluesAndButtons/Buttons/VBoxContainer/HBoxContainer/btnCheck.disabled = false

	# Clues
	$HBoxContainer/CluesAndButtons/Clues.bbcode_text = " CLUES:\n Clue 1:"

	# Top Left TextBox
	$HBoxContainer/HBoxContainer/HLabels/Square11/HBoxContainer/PanelContainer/HBoxContainer/Panel2/LblTopLeft.text = ""

	# Side Labels:
	$HBoxContainer/HBoxContainer/VBoxContainer/PanelContainer2/Panel/SideLabel1.bbcode_text = ""
	$HBoxContainer/HBoxContainer/VBoxContainer/PanelContainer3/Panel/SideLabel2.bbcode_text = ""
	$HBoxContainer/HBoxContainer/VBoxContainer/PanelContainer4/Panel/SideLabel3.bbcode_text = ""
	$HBoxContainer/HBoxContainer/VBoxContainer/PanelContainer5/Panel/SideLabel4.bbcode_text = ""
	$HBoxContainer/HBoxContainer/VBoxContainer/PanelContainer6/Panel/SideLabel5.bbcode_text = ""

	# Top Labels:
	$HBoxContainer/Column1/Panel/TopLabel1.bbcode_text = ""
	$HBoxContainer/Column2/Panel/TopLabel1.bbcode_text = ""
	$HBoxContainer/Column3/Panel/TopLabel1.bbcode_text = ""
	$HBoxContainer/Column4/Panel/TopLabel1.bbcode_text = ""
	$HBoxContainer/Column5/Panel/TopLabel1.bbcode_text = ""

	# Vertical Labels
	sNode1 = "Control/HBoxContainer/Column"
	sNode2 = "/Square1"
	sNode3 = "/HBoxContainer/PanelContainer/HBoxContainer/Panel"
	sNode4 = "/VLabel"

	for x in range(1, 6):
		sNode5 = sNode1 + str(x) + sNode2 + str(x) + sNode3

		for y in range(1, 6):
			sNode = sNode5 + str(y + 1) + sNode4 + str(x) + str(y)
			tNode = get_tree().get_root().get_node(sNode)
			tNode.set_text("")

	# Horizontal Labels
	sNode1 = "Control/HBoxContainer/HBoxContainer/HLabels/Square"
	sNode2 = "1/HBoxContainer"
	sNode3 = "/PanelContainer/HBoxContainer/Panel2/HLabel"
	sNode4 = ""
	
	for x in range(1, 6):
		sNode = sNode1 + str(x) + sNode2

		for y in range(1, 6):
			sNode4 = sNode + str(y + 1) + sNode3 + str(x) + str(y)
			tNode = get_tree().get_root().get_node(sNode4)
			tNode.set_text("")

	# Buttons
	sNode1 = "Control/HBoxContainer/Column"
	sNode2 = "/Square"
	sNode3 = "/HBoxContainer"
	sNode4 = "/PanelContainer/HBoxContainer/Panel"

	for x in range(1, 6):		#ROW
		for y in range(1, 6):	#COLUMN
			sX = str(x)
			sY = str(y)

			if x == 1 or (x == 2 and y < 5) or (x == 3 and y < 4) or (x == 4 and y < 3) or (x == 5 and y == 1):
				sNodeL = sNode1 + sY + sNode2 + sX + sY + sNode3

				for r in range(1, 6):
					sTmp = str(r + 1)

					for c in range(1, 6):
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
	elif inType == 2:
		tBtns[inS] = "cross"
		sTex = "res://Textures/cross.png"
	else:
		tBtns[inS] = "tcross"	# this is for crosses placed by ticks!
		sTex = "res://Textures/cross.png"

	tNode.set_normal_texture(load(sTex))

func popSquare(inRow, inCol, inNode):
	for x in range(1, 6):
		for y in range(1, 6):
			var sTmp1 = str(inRow) + str(inCol) + str(x) + str(y)

			if tBtns[sTmp1] == "tick":
				var sNode1 = inNode + str(x + 1) + "/PanelContainer/HBoxContainer/Panel"
				sNode1 = sNode1 + str(y + 1) + "/btn" + sTmp1
				setCell(sTmp1, 1, sNode1)

				for z in range(1, 6):
					if z != x:
						sTmp1 = str(inRow) + str(inCol) + str(z) + str(y)
						sNode1 = inNode + str(z + 1) + "/PanelContainer/HBoxContainer/Panel"
						sNode1 = sNode1 + str(y + 1) + "/btn" + sTmp1
						setCell(sTmp1, 3, sNode1)

				for z in range(1, 6):
					if z != y:
						sTmp1 = str(inRow) + str(inCol) + str(x) + str(z)
						sNode1 = inNode + str(x + 1) + "/PanelContainer/HBoxContainer/Panel"
						sNode1 = sNode1 + str(z + 1) + "/btn" + sTmp1
						setCell(sTmp1, 3, sNode1)
			elif tBtns[sTmp1] == "cross":
				sTmp1 = str(inRow) + str(inCol) + str(x) + str(y)
				var sNode1 = inNode + str(x + 1) + "/PanelContainer/HBoxContainer/Panel"
				sNode1 = sNode1 + str(y + 1) + "/btn" + sTmp1
				setCell(sTmp1, 2, sNode1)

func clearSquare(inRow, inCol, inNode):
	for x in range(1, 6):
		for y in range(1, 6):
			var sTmp1 = str(inRow) + str(inCol) + str(x) + str(y)
			var sNode2 = inNode + str(x + 1) + "/PanelContainer/HBoxContainer/Panel"
			sNode2 = sNode2 + str(y + 1) + "/btn" + sTmp1
			var tNode = get_tree().get_root().get_node(sNode2)
			var sTex = "res://Textures/blank.png"
			tNode.set_normal_texture(load(sTex))

			if tBtns[sTmp1] == "tcross":
				tBtns[sTmp1] = "blank"

func onBtn(BRow, BColumn, Row, Column, inEvent):
	var sTmp = str(BRow) + str(BColumn) + str(Row) + str(Column)

	if inEvent is InputEventMouseButton and inEvent.pressed:
		var sTmp1 = ""
		var sNode = "Control/HBoxContainer/Column" + str(BColumn) + "/Square" + str(BRow) + str(BColumn)
		sNode = sNode + "/HBoxContainer"
		var sNode1 = sNode + str(Row + 1) + "/PanelContainer/HBoxContainer/Panel"
		sNode1 = sNode1 + str(Column + 1) + "/btn" + sTmp

		match inEvent.button_index:
			BUTTON_LEFT:
				# left button clicked
				clearSquare(BRow, BColumn, sNode)

				if tBtns[sTmp] == "tick":
					pass
				elif tBtns[sTmp] == "cross":
					setCell(sTmp, 1, sNode1)
				else:
					setCell(sTmp, 1, sNode1)

					for x in range(1, 6):
						sTmp1 = str(BRow) + str(BColumn) + str(x) + str(Column)

						if x != Row:
							if tBtns[sTmp1] == "tick":
								tBtns[sTmp1] = "blank"

					for x in range(1, 6):
						sTmp1 = str(BRow) + str(BColumn) + str(Row) + str(x)

						if x != Column:
							if tBtns[sTmp1] == "tick":
								tBtns[sTmp1] = "blank"

				popSquare(BRow, BColumn, sNode)
			BUTTON_RIGHT:
				# right button clicked
				print("RIGHT: " + str(Row) + ":" + str(Column))
				if tBtns[sTmp] == "blank":
					setCell(sTmp, 2, sNode1)
				elif tBtns[sTmp] == "cross" or tBtns[sTmp] == "tick":
					setCell(sTmp, 0, sNode1)
				else:	# tcross
					for x in range(1, 6):
						sTmp1 = str(BRow) + str(BColumn) + str(x) + str(Column)

						if x != Row:
							if tBtns[sTmp1] == "tick":
								tBtns[sTmp1] = "blank"

					for x in range(1, 6):
						sTmp1 = str(BRow) + str(BColumn) + str(Row) + str(x)

						if x != Column:
							if tBtns[sTmp1] == "tick":
								tBtns[sTmp1] = "blank"

				clearSquare(BRow, BColumn, sNode)
				popSquare(BRow, BColumn, sNode)

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

func _on_btnGiveUp_pressed():
	$HBoxContainer/CluesAndButtons/Buttons/VBoxContainer/HBoxContainer2/btnSupp.disabled = true
	$HBoxContainer/CluesAndButtons/Buttons/VBoxContainer/HBoxContainer2/btnGiveUp.disabled = true
	$HBoxContainer/CluesAndButtons/Buttons/VBoxContainer/HBoxContainer/btnCheck.disabled = true

	bTimer = false
	var iT = 0
	var sT1 = "SOLUTION:\n\n"
	var sT = ""
	var sTmp = ""

	for x in range(5):
		iT = x * 5

		if x == 0:
			sT1 = sT1 + "HOUSE 1:\n"
		elif x == 1:
			sT1 = sT1 + "\nHOUSE 2:\n"
		elif x == 2:
			sT1 = sT1 + "\nHOUSE 3:\n"
		else:
			sT1 = sT1 + "\nHOUSE 4:\n"

		for y in range(5):
			sT = Common.aSol[iT + y].split(".")
			sTmp = sT[0].strip_edges().capitalize()
			sT1 = sT1 + sTmp + " = "
			sTmp = sT[1].strip_edges().capitalize()
			sT1 = sT1 + sTmp + "\n"

		$HBoxContainer/CluesAndButtons/Clues.set_bbcode(sT1)

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

func _on_btn2441_gui_input(event):
	onBtn(2,4,4,1,event)

func _on_btn2442_gui_input(event):
	onBtn(2,4,4,2,event)

func _on_btn2443_gui_input(event):
	onBtn(2,4,4,3,event)

func _on_btn2444_gui_input(event):
	onBtn(2,4,4,4,event)

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

func _on_btn2344_gui_input(event):
	onBtn(2,3,4,4,event)

func _on_btn2343_gui_input(event):
	onBtn(2,3,4,3,event)

func _on_btn2342_gui_input(event):
	onBtn(2,3,4,2,event)

func _on_btn2341_gui_input(event):
	onBtn(2,3,4,1,event)

func _on_btn1115_gui_input(event):
	onBtn(1,1,1,5,event)

func _on_btn1125_gui_input(event):
	onBtn(1,1,2,5,event)

func _on_btn1135_gui_input(event):
	onBtn(1,1,3,5,event)

func _on_btn1145_gui_input(event):
	onBtn(1,1,4,5,event)

func _on_btn1155_gui_input(event):
	onBtn(1,1,5,5,event)

func _on_btn2115_gui_input(event):
	onBtn(2,1,1,5,event)

func _on_btn2125_gui_input(event):
	onBtn(2,1,2,5,event)

func _on_btn2135_gui_input(event):
	onBtn(2,1,3,5,event)

func _on_btn2145_gui_input(event):
	onBtn(2,1,4,5,event)

func _on_btn2155_gui_input(event):
	onBtn(2,1,5,5,event)

func _on_btn3115_gui_input(event):
	onBtn(3,1,1,5,event)

func _on_btn3125_gui_input(event):
	onBtn(3,1,2,5,event)

func _on_btn3135_gui_input(event):
	onBtn(3,1,3,5,event)

func _on_btn3145_gui_input(event):
	onBtn(3,1,4,5,event)

func _on_btn3155_gui_input(event):
	onBtn(3,1,5,5,event)

func _on_btn1151_gui_input(event):
	onBtn(1,1,5,1,event)

func _on_btn1152_gui_input(event):
	onBtn(1,1,5,2,event)

func _on_btn1153_gui_input(event):
	onBtn(1,1,5,3,event)

func _on_btn1154_gui_input(event):
	onBtn(1,1,5,4,event)

func _on_btn2151_gui_input(event):
	onBtn(2,1,5,1,event)

func _on_btn2152_gui_input(event):
	onBtn(2,1,5,2,event)

func _on_btn2153_gui_input(event):
	onBtn(2,1,5,3,event)

func _on_btn2154_gui_input(event):
	onBtn(2,1,5,4,event)

func _on_btn3151_gui_input(event):
	onBtn(3,1,5,1,event)

func _on_btn3152_gui_input(event):
	onBtn(3,1,5,2,event)

func _on_btn3153_gui_input(event):
	onBtn(3,1,5,3,event)

func _on_btn3154_gui_input(event):
	onBtn(3,1,5,4,event)

func _on_btn4115_gui_input(event):
	onBtn(4,1,1,5,event)

func _on_btn4125_gui_input(event):
	onBtn(4,1,2,5,event)

func _on_btn4135_gui_input(event):
	onBtn(4,1,3,5,event)

func _on_btn4145_gui_input(event):
	onBtn(4,1,4,5,event)

func _on_btn4151_gui_input(event):
	onBtn(4,1,5,1,event)

func _on_btn4152_gui_input(event):
	onBtn(4,1,5,2,event)

func _on_btn4153_gui_input(event):
	onBtn(4,1,5,3,event)

func _on_btn4154_gui_input(event):
	onBtn(4,1,5,4,event)

func _on_btn4155_gui_input(event):
	onBtn(4,1,5,5,event)

func _on_btn5111_gui_input(event):
	onBtn(5,1,1,1,event)

func _on_btn5112_gui_input(event):
	onBtn(5,1,1,2,event)

func _on_btn5113_gui_input(event):
	onBtn(5,1,1,3,event)

func _on_btn5114_gui_input(event):
	onBtn(5,1,1,4,event)

func _on_btn5115_gui_input(event):
	onBtn(5,1,1,5,event)

func _on_btn5121_gui_input(event):
	onBtn(5,1,2,1,event)

func _on_btn5122_gui_input(event):
	onBtn(5,1,2,2,event)

func _on_btn5123_gui_input(event):
	onBtn(5,1,2,3,event)

func _on_btn5124_gui_input(event):
	onBtn(5,1,2,4,event)

func _on_btn5125_gui_input(event):
	onBtn(5,1,2,5,event)

func _on_btn5131_gui_input(event):
	onBtn(5,1,3,1,event)

func _on_btn5132_gui_input(event):
	onBtn(5,1,3,2,event)

func _on_btn5133_gui_input(event):
	onBtn(5,1,3,3,event)

func _on_btn5134_gui_input(event):
	onBtn(5,1,3,4,event)

func _on_btn5135_gui_input(event):
	onBtn(5,1,3,5,event)

func _on_btn5141_gui_input(event):
	onBtn(5,1,4,1,event)

func _on_btn5142_gui_input(event):
	onBtn(5,1,4,2,event)

func _on_btn5143_gui_input(event):
	onBtn(5,1,4,3,event)

func _on_btn5144_gui_input(event):
	onBtn(5,1,4,4,event)

func _on_btn5145_gui_input(event):
	onBtn(5,1,4,5,event)

func _on_btn5151_gui_input(event):
	onBtn(5,1,5,1,event)

func _on_btn5152_gui_input(event):
	onBtn(5,1,5,2,event)

func _on_btn5153_gui_input(event):
	onBtn(5,1,5,3,event)

func _on_btn5154_gui_input(event):
	onBtn(5,1,5,4,event)

func _on_btn5155_gui_input(event):
	onBtn(5,1,5,5,event)

func _on_btn1215_gui_input(event):
	onBtn(1,2,1,5,event)

func _on_btn1225_gui_input(event):
	onBtn(1,2,2,5,event)

func _on_btn1235_gui_input(event):
	onBtn(1,2,3,5,event)

func _on_btn1245_gui_input(event):
	onBtn(1,2,4,5,event)

func _on_btn1251_gui_input(event):
	onBtn(1,2,5,1,event)

func _on_btn1252_gui_input(event):
	onBtn(1,2,5,2,event)

func _on_btn1253_gui_input(event):
	onBtn(1,2,5,3,event)

func _on_btn1254_gui_input(event):
	onBtn(1,2,5,4,event)

func _on_btn1255_gui_input(event):
	onBtn(1,2,5,5,event)

func _on_btn2215_gui_input(event):
	onBtn(2,2,1,5,event)

func _on_btn2225_gui_input(event):
	onBtn(2,2,2,5,event)

func _on_btn2235_gui_input(event):
	onBtn(2,2,3,5,event)

func _on_btn2245_gui_input(event):
	onBtn(2,2,4,5,event)

func _on_btn2251_gui_input(event):
	onBtn(2,2,5,1,event)

func _on_btn2252_gui_input(event):
	onBtn(2,2,5,2,event)

func _on_btn2253_gui_input(event):
	onBtn(2,2,5,3,event)

func _on_btn2254_gui_input(event):
	onBtn(2,2,5,4,event)

func _on_btn2255_gui_input(event):
	onBtn(2,2,5,5,event)

func _on_btn3215_gui_input(event):
	onBtn(3,2,1,5,event)

func _on_btn3225_gui_input(event):
	onBtn(3,2,2,5,event)

func _on_btn3235_gui_input(event):
	onBtn(3,2,3,5,event)

func _on_btn3245_gui_input(event):
	onBtn(3,2,4,5,event)

func _on_btn3251_gui_input(event):
	onBtn(3,2,5,1,event)

func _on_btn3252_gui_input(event):
	onBtn(3,2,5,2,event)

func _on_btn3253_gui_input(event):
	onBtn(3,2,5,3,event)

func _on_btn3254_gui_input(event):
	onBtn(3,2,5,4,event)

func _on_btn3255_gui_input(event):
	onBtn(3,2,5,5,event)

func _on_btn4211_gui_input(event):
	onBtn(4,2,1,1,event)

func _on_btn4212_gui_input(event):
	onBtn(4,2,1,2,event)

func _on_btn4213_gui_input(event):
	onBtn(4,2,1,3,event)

func _on_btn4214_gui_input(event):
	onBtn(4,2,1,4,event)

func _on_btn4215_gui_input(event):
	onBtn(4,2,1,5,event)

func _on_btn4221_gui_input(event):
	onBtn(4,2,2,1,event)

func _on_btn4222_gui_input(event):
	onBtn(4,2,2,2,event)

func _on_btn4223_gui_input(event):
	onBtn(4,2,2,3,event)

func _on_btn4224_gui_input(event):
	onBtn(4,2,2,4,event)

func _on_btn4225_gui_input(event):
	onBtn(4,2,2,5,event)

func _on_btn4231_gui_input(event):
	onBtn(4,2,3,1,event)

func _on_btn4232_gui_input(event):
	onBtn(4,2,3,2,event)

func _on_btn4233_gui_input(event):
	onBtn(4,2,3,3,event)

func _on_btn4234_gui_input(event):
	onBtn(4,2,3,4,event)

func _on_btn4235_gui_input(event):
	onBtn(4,2,3,5,event)

func _on_btn4241_gui_input(event):
	onBtn(4,2,4,1,event)

func _on_btn4242_gui_input(event):
	onBtn(4,2,4,2,event)

func _on_btn4243_gui_input(event):
	onBtn(4,2,4,3,event)

func _on_btn4244_gui_input(event):
	onBtn(4,2,4,4,event)

func _on_btn4245_gui_input(event):
	onBtn(4,2,4,5,event)

func _on_btn4251_gui_input(event):
	onBtn(4,2,5,1,event)

func _on_btn4252_gui_input(event):
	onBtn(4,2,5,2,event)

func _on_btn4253_gui_input(event):
	onBtn(4,2,5,3,event)

func _on_btn4254_gui_input(event):
	onBtn(4,2,5,4,event)

func _on_btn4255_gui_input(event):
	onBtn(4,2,5,5,event)

func _on_btn1315_gui_input(event):
	onBtn(1,3,1,5,event)

func _on_btn1325_gui_input(event):
	onBtn(1,3,2,5,event)

func _on_btn1335_gui_input(event):
	onBtn(1,3,3,5,event)

func _on_btn1345_gui_input(event):
	onBtn(1,3,4,5,event)

func _on_btn1351_gui_input(event):
	onBtn(1,3,5,1,event)

func _on_btn1352_gui_input(event):
	onBtn(1,3,5,2,event)

func _on_btn1353_gui_input(event):
	onBtn(1,3,5,3,event)

func _on_btn1354_gui_input(event):
	onBtn(1,3,5,4,event)

func _on_btn1355_gui_input(event):
	onBtn(1,3,5,5,event)

func _on_btn2315_gui_input(event):
	onBtn(2,3,1,5,event)

func _on_btn2325_gui_input(event):
	onBtn(2,3,2,5,event)

func _on_btn2335_gui_input(event):
	onBtn(2,3,3,5,event)

func _on_btn2345_gui_input(event):
	onBtn(2,3,4,5,event)

func _on_btn2351_gui_input(event):
	onBtn(2,3,5,1,event)

func _on_btn2352_gui_input(event):
	onBtn(2,3,5,2,event)

func _on_btn2353_gui_input(event):
	onBtn(2,3,5,3,event)

func _on_btn2354_gui_input(event):
	onBtn(2,3,5,4,event)

func _on_btn2355_gui_input(event):
	onBtn(2,3,5,5,event)

func _on_btn3311_gui_input(event):
	onBtn(3,3,1,1,event)

func _on_btn3312_gui_input(event):
	onBtn(3,3,1,2,event)

func _on_btn3313_gui_input(event):
	onBtn(3,3,1,3,event)

func _on_btn3314_gui_input(event):
	onBtn(3,3,1,4,event)

func _on_btn3315_gui_input(event):
	onBtn(3,3,1,5,event)

func _on_btn3321_gui_input(event):
	onBtn(3,3,2,1,event)

func _on_btn3322_gui_input(event):
	onBtn(3,3,2,2,event)

func _on_btn3323_gui_input(event):
	onBtn(3,3,2,3,event)

func _on_btn3324_gui_input(event):
	onBtn(3,3,2,4,event)

func _on_btn3325_gui_input(event):
	onBtn(3,3,2,5,event)

func _on_btn3331_gui_input(event):
	onBtn(3,3,3,1,event)

func _on_btn3332_gui_input(event):
	onBtn(3,3,3,2,event)

func _on_btn3333_gui_input(event):
	onBtn(3,3,3,3,event)

func _on_btn3334_gui_input(event):
	onBtn(3,3,3,4,event)

func _on_btn3335_gui_input(event):
	onBtn(3,3,3,5,event)

func _on_btn3341_gui_input(event):
	onBtn(3,3,4,1,event)

func _on_btn3342_gui_input(event):
	onBtn(3,3,4,2,event)

func _on_btn3343_gui_input(event):
	onBtn(3,3,4,3,event)

func _on_btn3344_gui_input(event):
	onBtn(3,3,4,4,event)

func _on_btn3345_gui_input(event):
	onBtn(3,3,4,5,event)

func _on_btn3351_gui_input(event):
	onBtn(3,3,5,1,event)

func _on_btn3352_gui_input(event):
	onBtn(3,3,5,2,event)

func _on_btn3353_gui_input(event):
	onBtn(3,3,5,3,event)

func _on_btn3354_gui_input(event):
	onBtn(3,3,5,4,event)

func _on_btn3355_gui_input(event):
	onBtn(3,3,5,5,event)

func _on_btn1415_gui_input(event):
	onBtn(1,4,1,5,event)

func _on_btn1425_gui_input(event):
	onBtn(1,4,2,5,event)

func _on_btn1435_gui_input(event):
	onBtn(1,4,3,5,event)

func _on_btn1445_gui_input(event):
	onBtn(1,4,4,5,event)

func _on_btn1451_gui_input(event):
	onBtn(1,4,5,1,event)

func _on_btn1452_gui_input(event):
	onBtn(1,4,5,2,event)

func _on_btn1453_gui_input(event):
	onBtn(1,4,5,3,event)

func _on_btn1454_gui_input(event):
	onBtn(1,4,5,4,event)

func _on_btn1455_gui_input(event):
	onBtn(1,4,5,5,event)

func _on_btn2411_gui_input(event):
	onBtn(2,4,1,1,event)

func _on_btn2412_gui_input(event):
	onBtn(2,4,1,2,event)

func _on_btn2413_gui_input(event):
	onBtn(2,4,1,3,event)

func _on_btn2414_gui_input(event):
	onBtn(2,4,1,4,event)

func _on_btn2415_gui_input(event):
	onBtn(2,4,1,5,event)

func _on_btn2421_gui_input(event):
	onBtn(2,4,2,1,event)

func _on_btn2422_gui_input(event):
	onBtn(2,4,2,2,event)

func _on_btn2423_gui_input(event):
	onBtn(2,4,2,3,event)

func _on_btn2424_gui_input(event):
	onBtn(2,4,2,4,event)

func _on_btn2425_gui_input(event):
	onBtn(2,4,2,5,event)

func _on_btn2431_gui_input(event):
	onBtn(2,4,3,1,event)

func _on_btn2432_gui_input(event):
	onBtn(2,4,3,2,event)

func _on_btn2433_gui_input(event):
	onBtn(2,4,3,3,event)

func _on_btn2434_gui_input(event):
	onBtn(2,4,3,4,event)

func _on_btn2435_gui_input(event):
	onBtn(2,4,3,5,event)

func _on_btn2445_gui_input(event):
	onBtn(2,4,4,5,event)

func _on_btn2451_gui_input(event):
	onBtn(2,4,5,1,event)

func _on_btn2452_gui_input(event):
	onBtn(2,4,5,2,event)

func _on_btn2453_gui_input(event):
	onBtn(2,4,5,3,event)

func _on_btn2454_gui_input(event):
	onBtn(2,4,5,4,event)

func _on_btn2455_gui_input(event):
	onBtn(2,4,5,5,event)

func _on_btn1511_gui_input(event):
	onBtn(1,5,1,1,event)

func _on_btn1512_gui_input(event):
	onBtn(1,5,1,2,event)

func _on_btn1513_gui_input(event):
	onBtn(1,5,1,3,event)

func _on_btn1514_gui_input(event):
	onBtn(1,5,1,4,event)

func _on_btn1515_gui_input(event):
	onBtn(1,5,1,5,event)

func _on_btn1521_gui_input(event):
	onBtn(1,5,2,1,event)

func _on_btn1522_gui_input(event):
	onBtn(1,5,2,2,event)

func _on_btn1523_gui_input(event):
	onBtn(1,5,2,3,event)

func _on_btn1524_gui_input(event):
	onBtn(1,5,2,4,event)

func _on_btn1525_gui_input(event):
	onBtn(1,5,2,5,event)

func _on_btn1531_gui_input(event):
	onBtn(1,5,3,1,event)

func _on_btn1532_gui_input(event):
	onBtn(1,5,3,2,event)

func _on_btn1533_gui_input(event):
	onBtn(1,5,3,3,event)

func _on_btn1534_gui_input(event):
	onBtn(1,5,3,4,event)

func _on_btn1535_gui_input(event):
	onBtn(1,5,3,5,event)

func _on_btn1541_gui_input(event):
	onBtn(1,5,4,1,event)

func _on_btn1542_gui_input(event):
	onBtn(1,5,4,2,event)

func _on_btn1543_gui_input(event):
	onBtn(1,5,4,3,event)

func _on_btn1544_gui_input(event):
	onBtn(1,5,4,4,event)

func _on_btn1545_gui_input(event):
	onBtn(1,5,4,5,event)

func _on_btn1551_gui_input(event):
	onBtn(1,5,5,1,event)

func _on_btn1552_gui_input(event):
	onBtn(1,5,5,2,event)

func _on_btn1553_gui_input(event):
	onBtn(1,5,5,3,event)

func _on_btn1554_gui_input(event):
	onBtn(1,5,5,4,event)

func _on_btn1555_gui_input(event):
	onBtn(1,5,5,5,event)

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
