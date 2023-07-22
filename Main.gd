extends Node

var puzzle = ""	# Puzzle Generated Text from 'generate.py'
var sText1 = ""	# Basic Description
var aText = []	# Each Element
var aClues = []	# Each Clue
var aSol = []	# Each Solution
var aOne = []	# 1st Element
var aTwo = []	# 2nd Element
var aThree = []	# 3rd Element
var aFour = []	# 4th Element
var aFive = []	# 5th Element
var iSize = 4
var bEasy = true
var bDlgYes = false
var bDlgNo = false
var bDlgOK = false
var bDlg = false
var iDlgType = 0	# 1 == QUIT, 2 == OTHER

var scene5x5 = preload("res://Scenes/5x5.tscn").instance()
var scene4x4 = preload("res://Scenes/4x4.tscn").instance()

func _ready():
#	self.call_deferred("_started")
	pass

func _started():
	randomize()
	bDlgYes = false
	bDlgNo = false
	bDlgOK = false
	bDlg = false

	puzzle = ""	# Puzzle Generated Text from 'generate.py'
	sText1 = ""	# Basic Description
	aText = []	# Each Element
	aClues = []	# Each Clue
	aSol = []	# Each Solution
	aOne = []	# 1st Element
	aTwo = []	# 2nd Element
	aThree = []	# 3rd Element
	aFour = []	# 4th Element
	aFive = []	# 5th Element
	var stdout = []
	var path = "//addons//pythonscript//windows-64//python.exe"

	if OS.has_feature("editor"):
		var res = "res:" + path
		path = ProjectSettings.globalize_path(res)
	else:
		path = OS.get_executable_path().get_base_dir() + path

	var array = ["Python_Scripts\\generate.py", iSize]
	var args = PoolStringArray(array)
	var exit = OS.execute(path, args, true, stdout)

	if exit == OK:
		if bEasy:
			get_tree().get_root().add_child(scene4x4)
			$VBoxContainer.hide()
		else:
			get_tree().get_root().add_child(scene5x5)
			$VBoxContainer.hide()

		yield(get_tree().create_timer(0.1), "timeout")
		# TODO: Allow selection between 4x4 and 5x5
		if iSize == 5:
			load5x5(stdout)
		else:
			load4x4(stdout)
	else:
		# TODO: GENERATE ERROR MESSAGE
		pass

func _process(_delta):
	if bDlg:
		if bDlgYes:
			bDlg = false
			$dlgCheck.hide()

			if iDlgType == 1:
				get_tree().quit()
			else:
				iDlgType = 0
		elif bDlgNo:
			bDlg = false
			iDlgType = 0
			$dlgCheck.hide()
		elif bDlgOK:
			bDlg = false
			iDlgType = 0
			$dlgCheck.hide()

func load5x5(stdOut):
	puzzle = str(stdOut)

	sText1 = ""			# Basic Description
	aText = []			# Each Element
	aClues = []			# Each Clue
	Common.aSupp = []	# Each Supplemental Clue
	aSol = []			# Each Solution
	Common.aSolution = []

	var myStr = puzzle.split("\n", false)
	var iCount = 0
	var iTmp = 0
	var sTmp = ""

	for x in myStr:
		if x == "Narrowed puzzle":
			break

		iCount += 1

	iCount += 2

	sText1 = myStr[iCount].right(12)

	for y in range(1, 6):
		sTmp = myStr[iCount + y].lstrip("             - ")
		aText.append(sTmp)

	iCount += 7

	for x in range(iCount, iCount + 50):
		var sT = myStr[x]

		if sT == "Supplemental clues":
			iTmp = x
			break

	for x in range(iCount, iTmp - 1):
		sTmp = myStr[x].lstrip("            ")
		aClues.append(sTmp)

	for x in range(iTmp + 1, iTmp + 50):
		var sT = myStr[x]

		if sT.left(3) == " - ":
			Common.aSupp.append(sT.lstrip(3))
		elif sT == "--------":
			iTmp = x + 1
			break

	for x in range(iTmp, myStr.size() - 1):
		if myStr[x].left(1) == "-":
			aSol.append(myStr[x].right(2))

	var sPath = ""

	for x in range(5):
		var sT = aSol[x].split(".")
		sTmp = sT[0].strip_edges()
		sTmp = sTmp.capitalize()

		if x == 0:
			sPath = "Control/HBoxContainer/HBoxContainer/VBoxContainer/PanelContainer2/Panel/SideLabel1"
		elif x == 1:
			sPath = "Control/HBoxContainer/HBoxContainer/VBoxContainer/PanelContainer3/Panel/SideLabel2"
		elif x == 2:
			sPath = "Control/HBoxContainer/HBoxContainer/VBoxContainer/PanelContainer4/Panel/SideLabel3"
		elif x == 3:
			sPath = "Control/HBoxContainer/HBoxContainer/VBoxContainer/PanelContainer5/Panel/SideLabel4"
		else:
			sPath = "Control/HBoxContainer/HBoxContainer/VBoxContainer/PanelContainer6/Panel/SideLabel5"

		var node = get_tree().get_root().get_node(sPath)
		node.set_bbcode("[center][valign px=-2]" + sTmp)

		if x == 0:
			sPath = "Control/HBoxContainer/Column1/Panel/TopLabel1"
			sTmp = "House"
		elif x == 4:
			sPath = "Control/HBoxContainer/Column2/Panel/TopLabel1"
			sT = aSol[x].split(".")
			sTmp = sT[0].strip_edges()
			sTmp = sTmp.capitalize()
		elif x == 3:
			sPath = "Control/HBoxContainer/Column3/Panel/TopLabel1"
			sT = aSol[x].split(".")
			sTmp = sT[0].strip_edges()
			sTmp = sTmp.capitalize()
		elif x == 2:
			sPath = "Control/HBoxContainer/Column4/Panel/TopLabel1"
			sT = aSol[x].split(".")
			sTmp = sT[0].strip_edges()
			sTmp = sTmp.capitalize()
		else:
			sPath = "Control/HBoxContainer/Column5/Panel/TopLabel1"
			sT = aSol[x].split(".")
			sTmp = sT[0].strip_edges()
			sTmp = sTmp.capitalize()

		node = get_tree().get_root().get_node(sPath)
		node.set_bbcode("[center][valign px=-4]" + sTmp)

	var sPath1 = "Control/HBoxContainer/HBoxContainer/HLabels/Square"
	var sPath2 = "1/HBoxContainer"
	var sPath3 = "/PanelContainer/HBoxContainer/Panel2/HLabel"
	var tNode

	for x in range(5):
		for y in range(5):
			iTmp = x * 5 + y
			var sT = aSol[iTmp].split(".")
			sTmp = sT[1].strip_edges()
			sTmp = sTmp.capitalize()

			if y == 0:
				aOne.append(sTmp)
			elif y == 1:
				aTwo.append(sTmp)
			elif y == 2:
				aThree.append(sTmp)
			elif y == 3:
				aFour.append(sTmp)
			elif y == 4:
				aFive.append(sTmp)

	aOne.shuffle()
	aTwo.shuffle()
	aThree.shuffle()
	aFour.shuffle()
	aFive.shuffle()

	var sT = ""

	for x in range(5):
		for y in range(5):
			if y == 0:
				sT = aOne[x]
			elif y == 1:
				sT = aTwo[x]
			elif y == 2:
				sT = aThree[x]
			elif y == 3:
				sT = aFour[x]
			else:
				sT = aFive[x]

			sPath = sPath1 + str(y + 1) + sPath2 + str(x + 2) + sPath3 + str(y + 1) + str(x + 1)
			tNode = get_tree().get_root().get_node(sPath)
			tNode.set_bbcode("[right][valign px=-2]" + sT + " ")

	sPath = ""
	sPath1 = "Control/HBoxContainer/Column" 						# 1 -> 5
	sPath2 = "/Square1"												# 11 -> 15
	sPath3 = "/HBoxContainer/PanelContainer/HBoxContainer/Panel"	# 2 -> 6 in each Square
	var sPath4 = "/VLabel"											# x1 -> x5 in each Square

	sPath = sPath1 + "1" + sPath2 + "1" + sPath3

	for x in range(1, 6):
		var sPathA = sPath + str(x + 1) + sPath4 + "1" + str(x) 
		var node = get_tree().get_root().get_node(sPathA)

		if x == 1:
			sT = "One"
		elif x == 2:
			sT = "Two"
		elif x == 3:
			sT = "Three"
		elif x == 4:
			sT = "Four"
		else:
			sT = "Five"

		node.set_bbcode("[valign px=-2]  " + sT)

	iCount = 1

	for x in aTwo:
		sPath = "Control/HBoxContainer/Column5/Square15/HBoxContainer/PanelContainer/HBoxContainer/Panel"
		sPath = sPath + str(iCount + 1) + "/VLabel5" + str(iCount)
		var node = get_tree().get_root().get_node(sPath)
		node.set_bbcode("[valign px=-2]  " + x)
		iCount += 1

	iCount = 1

	for x in aThree:
		sPath = "Control/HBoxContainer/Column4/Square14/HBoxContainer/PanelContainer/HBoxContainer/Panel"
		sPath = sPath + str(iCount + 1) + "/VLabel4" + str(iCount)
		var node = get_tree().get_root().get_node(sPath)
		node.set_bbcode("[valign px=-2]  " + x)
		iCount += 1

	iCount = 1

	for x in aFour:
		sPath = "Control/HBoxContainer/Column3/Square13/HBoxContainer/PanelContainer/HBoxContainer/Panel"
		sPath = sPath + str(iCount + 1) + "/VLabel3" + str(iCount)
		var node = get_tree().get_root().get_node(sPath)
		node.set_bbcode("[valign px=-2]  " + x)
		iCount += 1

	iCount = 1

	for x in aFive:
		sPath = "Control/HBoxContainer/Column2/Square12/HBoxContainer/PanelContainer/HBoxContainer/Panel"
		sPath = sPath + str(iCount + 1) + "/VLabel2" + str(iCount)
		var node = get_tree().get_root().get_node(sPath)
		node.set_bbcode("[valign px=-2]  " + x)
		iCount += 1

	var node = get_tree().get_root().get_node("Control/HBoxContainer/CluesAndButtons/Clues")
	var sTxt = "CLUES:\n"

	for x in aClues:
		sTxt = sTxt + x + "\n"

	node.set_bbcode(sTxt)

	var u = 0

	for x in range(5):
		for y in range(0, aSol.size(), 5):
			var sT1 = aSol[y].split(".")
			sTmp = sT1[1].strip_edges()
			sTmp = sTmp.capitalize()

			if aOne[x] == sTmp:
# warning-ignore:integer_division
				u = int(y / 5) + 1
				sT = "11" + str(x + 1) + str(u)
				Common.aSolution.append(sT)
				sT1 = aSol[y + 4].split(".")
				sTmp = sT1[1].strip_edges()
				sTmp = sTmp.capitalize()

				for z in range(5):
					if aFive[z] == sTmp:
						sT = "12" + str(x + 1) + str(z + 1) 
						Common.aSolution.append(sT)

				sT1 = aSol[y + 3].split(".")
				sTmp = sT1[1].strip_edges()
				sTmp = sTmp.capitalize()

				for z in range(5):
					if aFour[z] == sTmp:
						sT = "13" + str(x + 1) + str(z + 1) 
						Common.aSolution.append(sT)

				sT1 = aSol[y + 2].split(".")
				sTmp = sT1[1].strip_edges()
				sTmp = sTmp.capitalize()

				for z in range(5):
					if aThree[z] == sTmp:
						sT = "14" + str(x + 1) + str(z + 1) 
						Common.aSolution.append(sT)

				sT1 = aSol[y + 1].split(".")
				sTmp = sT1[1].strip_edges()
				sTmp = sTmp.capitalize()

				for z in range(5):
					if aTwo[z] == sTmp:
						sT = "15" + str(x + 1) + str(z + 1) 
						Common.aSolution.append(sT)

	for x in range(5):
		for y in range(1, aSol.size(), 5):
			var sT1 = aSol[y].split(".")
			sTmp = sT1[1].strip_edges()
			sTmp = sTmp.capitalize()

			if aTwo[x] == sTmp:
# warning-ignore:integer_division
				u = int(y / 5) + 1
				sT = "21" + str(x + 1) + str(u)
				Common.aSolution.append(sT)

				sT1 = aSol[y + 3].split(".")
				sTmp = sT1[1].strip_edges()
				sTmp = sTmp.capitalize()

				for z in range(5):
					if aFive[z] == sTmp:
						sT = "22" + str(x + 1) + str(z + 1) 
						Common.aSolution.append(sT)

				sT1 = aSol[y + 2].split(".")
				sTmp = sT1[1].strip_edges()
				sTmp = sTmp.capitalize()

				for z in range(5):
					if aFour[z] == sTmp:
						sT = "23" + str(x + 1) + str(z + 1) 
						Common.aSolution.append(sT)

				sT1 = aSol[y + 1].split(".")
				sTmp = sT1[1].strip_edges()
				sTmp = sTmp.capitalize()

				for z in range(5):
					if aThree[z] == sTmp:
						sT = "24" + str(x + 1) + str(z + 1) 
						Common.aSolution.append(sT)

	for x in range(5):
		for y in range(2, aSol.size(), 5):
			var sT1 = aSol[y].split(".")
			sTmp = sT1[1].strip_edges()
			sTmp = sTmp.capitalize()

			if aThree[x] == sTmp:
# warning-ignore:integer_division
				u = int(y / 5) + 1
				sT = "31" + str(x + 1) + str(u)
				Common.aSolution.append(sT)

				sT1 = aSol[y + 2].split(".")
				sTmp = sT1[1].strip_edges()
				sTmp = sTmp.capitalize()

				for z in range(5):
					if aFive[z] == sTmp:
						sT = "32" + str(x + 1) + str(z + 1) 
						Common.aSolution.append(sT)

				sT1 = aSol[y + 1].split(".")
				sTmp = sT1[1].strip_edges()
				sTmp = sTmp.capitalize()

				for z in range(5):
					if aFour[z] == sTmp:
						sT = "33" + str(x + 1) + str(z + 1) 
						Common.aSolution.append(sT)


	for x in range(5):
		for y in range(3, aSol.size(), 5):
			var sT1 = aSol[y].split(".")
			sTmp = sT1[1].strip_edges()
			sTmp = sTmp.capitalize()

			if aFour[x] == sTmp:
# warning-ignore:integer_division
				u = int(y / 5) + 1
				sT = "41" + str(x + 1) + str(u)
				Common.aSolution.append(sT)

				sT1 = aSol[y + 1].split(".")
				sTmp = sT1[1].strip_edges()
				sTmp = sTmp.capitalize()

				for z in range(5):
					if aFive[z] == sTmp:
						sT = "42" + str(x + 1) + str(z + 1) 
						Common.aSolution.append(sT)

	for x in range(5):
		for y in range(4, aSol.size(), 5):
			var sT1 = aSol[y].split(".")
			sTmp = sT1[1].strip_edges()
			sTmp = sTmp.capitalize()

			if aFive[x] == sTmp:
# warning-ignore:integer_division
				u = int(y / 5) + 1
				sT = "51" + str(x + 1) + str(u)
				Common.aSolution.append(sT)

func load4x4(stdOut):
	puzzle = str(stdOut)

	sText1 = ""			# Basic Description
	aText = []			# Each Element
	aClues = []			# Each Clue
	Common.aSupp = []	# Each Supplemental Clue
	aSol = []			# Each Solution
	Common.aSolution = []

	var myStr = puzzle.split("\n", false)
	var iCount = 0
	var iTmp = 0
	var sTmp = ""

	for x in myStr:
		if x == "Narrowed puzzle":
			break

		iCount += 1

	iCount += 2

	sText1 = myStr[iCount].right(12)

	for y in range(1, 5):
		sTmp = myStr[iCount + y].lstrip("             - ")
		aText.append(sTmp)

	iCount += 6

	for x in range(iCount, iCount + 50):
		var sT = myStr[x]

		if sT == "Supplemental clues":
			iTmp = x
			break

	for x in range(iCount, iTmp - 1):
		sTmp = myStr[x].lstrip("            ")
		aClues.append(sTmp)

	for x in range(iTmp + 1, iTmp + 50):
		var sT = myStr[x]

		if sT.left(3) == " - ":
			Common.aSupp.append(sT.lstrip(3))
		elif sT == "--------":
			iTmp = x + 1
			break

	for x in range(iTmp, myStr.size() - 1):
		if myStr[x].left(1) == "-":
			aSol.append(myStr[x].right(2))

	var sPath = ""

	for x in range(4):
		var sT = aSol[x].split(".")
		sTmp = sT[0].strip_edges()
		sTmp = sTmp.capitalize()

		if x == 0:
			sPath = "Control/HBoxContainer/HBoxContainer/VBoxContainer/PanelContainer2/Panel/SideLabel1"
		elif x == 1:
			sPath = "Control/HBoxContainer/HBoxContainer/VBoxContainer/PanelContainer3/Panel/SideLabel2"
		elif x == 2:
			sPath = "Control/HBoxContainer/HBoxContainer/VBoxContainer/PanelContainer4/Panel/SideLabel3"
		else:
			sPath = "Control/HBoxContainer/HBoxContainer/VBoxContainer/PanelContainer5/Panel/SideLabel4"

		var node = get_tree().get_root().get_node(sPath)
		node.set_bbcode("[center][valign px=-2]" + sTmp)

		if x == 0:
			sPath = "Control/HBoxContainer/Column1/Panel/TopLabel1"
			sTmp = "House"
		elif x == 3:
			sPath = "Control/HBoxContainer/Column2/Panel/TopLabel1"
			sT = aSol[x].split(".")
			sTmp = sT[0].strip_edges()
			sTmp = sTmp.capitalize()
		elif x == 2:
			sPath = "Control/HBoxContainer/Column3/Panel/TopLabel1"
			sT = aSol[x].split(".")
			sTmp = sT[0].strip_edges()
			sTmp = sTmp.capitalize()
		else:
			sPath = "Control/HBoxContainer/Column4/Panel/TopLabel1"
			sT = aSol[x].split(".")
			sTmp = sT[0].strip_edges()
			sTmp = sTmp.capitalize()

		node = get_tree().get_root().get_node(sPath)
		node.set_bbcode("[center][valign px=-4]" + sTmp)

	var sPath1 = "Control/HBoxContainer/HBoxContainer/HLabels/Square"
	var sPath2 = "1/HBoxContainer"
	var sPath3 = "/PanelContainer/HBoxContainer/Panel2/HLabel"
	var tNode

	for x in range(4):
		for y in range(4):
			iTmp = x * 4 + y
			var sT = aSol[iTmp].split(".")
			sTmp = sT[1].strip_edges()
			sTmp = sTmp.capitalize()

			if y == 0:
				aOne.append(sTmp)
			elif y == 1:
				aTwo.append(sTmp)
			elif y == 2:
				aThree.append(sTmp)
			elif y == 3:
				aFour.append(sTmp)

	aOne.shuffle()
	aTwo.shuffle()
	aThree.shuffle()
	aFour.shuffle()

	var sT = ""

	for x in range(4):
		for y in range(4):
			if y == 0:
				sT = aOne[x]
			elif y == 1:
				sT = aTwo[x]
			elif y == 2:
				sT = aThree[x]
			else:
				sT = aFour[x]

			sPath = sPath1 + str(y + 1) + sPath2 + str(x + 2) + sPath3 + str(y + 1) + str(x + 1)
			tNode = get_tree().get_root().get_node(sPath)
			tNode.set_bbcode("[right][valign px=-2]" + sT + " ")

	sPath = ""
	sPath1 = "Control/HBoxContainer/Column" 						# 1 -> 5
	sPath2 = "/Square1"												# 11 -> 15
	sPath3 = "/HBoxContainer/PanelContainer/HBoxContainer/Panel"	# 2 -> 6 in each Square
	var sPath4 = "/VLabel"											# x1 -> x5 in each Square

	sPath = sPath1 + "1" + sPath2 + "1" + sPath3

	for x in range(1, 5):
		var sPathA = sPath + str(x + 1) + sPath4 + "1" + str(x) 
		var node = get_tree().get_root().get_node(sPathA)

		if x == 1:
			sT = "One"
		elif x == 2:
			sT = "Two"
		elif x == 3:
			sT = "Three"
		else:
			sT = "Four"

		node.set_bbcode("[valign px=-2]   " + sT)

	iCount = 1

	for x in aTwo:
		sPath = "Control/HBoxContainer/Column4/Square14/HBoxContainer/PanelContainer/HBoxContainer/Panel"
		sPath = sPath + str(iCount + 1) + "/VLabel4" + str(iCount)
		var node = get_tree().get_root().get_node(sPath)
		node.set_bbcode("[valign px=-2]   " + x)
		iCount += 1

	iCount = 1

	for x in aThree:
		sPath = "Control/HBoxContainer/Column3/Square13/HBoxContainer/PanelContainer/HBoxContainer/Panel"
		sPath = sPath + str(iCount + 1) + "/VLabel3" + str(iCount)
		var node = get_tree().get_root().get_node(sPath)
		node.set_bbcode("[valign px=-2]   " + x)
		iCount += 1

	iCount = 1

	for x in aFour:
		sPath = "Control/HBoxContainer/Column2/Square12/HBoxContainer/PanelContainer/HBoxContainer/Panel"
		sPath = sPath + str(iCount + 1) + "/VLabel2" + str(iCount)
		var node = get_tree().get_root().get_node(sPath)
		node.set_bbcode("[valign px=-2]   " + x)
		iCount += 1

	var node = get_tree().get_root().get_node("Control/HBoxContainer/CluesAndButtons/Clues")
	var sTxt = "CLUES:\n"

	for x in aClues:
		sTxt = sTxt + x + "\n"

	node.set_bbcode(sTxt)

	var u = 0

	for x in range(4):
		for y in range(0, aSol.size(), 4):
			var sT1 = aSol[y].split(".")
			sTmp = sT1[1].strip_edges()
			sTmp = sTmp.capitalize()

			if aOne[x] == sTmp:
# warning-ignore:integer_division
				u = int(y / 4) + 1
				sT = "11" + str(x + 1) + str(u)
				Common.aSolution.append(sT)
				sT1 = aSol[y + 3].split(".")
				sTmp = sT1[1].strip_edges()
				sTmp = sTmp.capitalize()

				for z in range(4):
					if aFour[z] == sTmp:
						sT = "12" + str(x + 1) + str(z + 1) 
						Common.aSolution.append(sT)

				sT1 = aSol[y + 2].split(".")
				sTmp = sT1[1].strip_edges()
				sTmp = sTmp.capitalize()

				for z in range(4):
					if aThree[z] == sTmp:
						sT = "13" + str(x + 1) + str(z + 1) 
						Common.aSolution.append(sT)

				sT1 = aSol[y + 1].split(".")
				sTmp = sT1[1].strip_edges()
				sTmp = sTmp.capitalize()

				for z in range(4):
					if aTwo[z] == sTmp:
						sT = "14" + str(x + 1) + str(z + 1) 
						Common.aSolution.append(sT)

	for x in range(4):
		for y in range(1, aSol.size(), 4):
			var sT1 = aSol[y].split(".")
			sTmp = sT1[1].strip_edges()
			sTmp = sTmp.capitalize()

			if aTwo[x] == sTmp:
# warning-ignore:integer_division
				u = int(y / 4) + 1
				sT = "21" + str(x + 1) + str(u)
				Common.aSolution.append(sT)

				sT1 = aSol[y + 2].split(".")
				sTmp = sT1[1].strip_edges()
				sTmp = sTmp.capitalize()

				for z in range(4):
					if aFour[z] == sTmp:
						sT = "22" + str(x + 1) + str(z + 1) 
						Common.aSolution.append(sT)

				sT1 = aSol[y + 1].split(".")
				sTmp = sT1[1].strip_edges()
				sTmp = sTmp.capitalize()

				for z in range(4):
					if aThree[z] == sTmp:
						sT = "23" + str(x + 1) + str(z + 1) 
						Common.aSolution.append(sT)

	for x in range(4):
		for y in range(2, aSol.size(), 4):
			var sT1 = aSol[y].split(".")
			sTmp = sT1[1].strip_edges()
			sTmp = sTmp.capitalize()

			if aTwo[x] == sTmp:
# warning-ignore:integer_division
				u = int(y / 4) + 1
				sT = "31" + str(x + 1) + str(u)
				Common.aSolution.append(sT)

				sT1 = aSol[y + 1].split(".")
				sTmp = sT1[1].strip_edges()
				sTmp = sTmp.capitalize()

				for z in range(4):
					if aFour[z] == sTmp:
						sT = "32" + str(x + 1) + str(z + 1) 
						Common.aSolution.append(sT)

	for x in range(4):
		for y in range(3, aSol.size(), 4):
			var sT1 = aSol[y].split(".")
			sTmp = sT1[1].strip_edges()
			sTmp = sTmp.capitalize()

			if aThree[x] == sTmp:
# warning-ignore:integer_division
				u = int(y / 4) + 1
				sT = "41" + str(x + 1) + str(u)
				Common.aSolution.append(sT)

	print(Common.aSolution)
	print(aSol)
#	print(puzzle)

func _on_btnStart_pressed():
	if bEasy:
		iSize = 4
	else:
		iSize = 5

	_started()

func _on_btnQuit_pressed():
	updateDlg("Are you sure?", "Are you sure you want to exit the game?", 1, true, true, false)

func _on_cbEasy_pressed():
	bEasy = true

func _on_cbHard_pressed():
	bEasy = false

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
