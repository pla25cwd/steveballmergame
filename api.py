from flask import Flask, request 
from flask_cors import CORS
import math
import json
import time
from PIL import Image, ImageOps, ImageFont, ImageDraw2
import io
import subprocess

app = Flask(__name__)
CORS(app)

font = ImageDraw2.Font("#ffffff", "VNF-Comic-Sans.otf", 16)

@app.route("/feedback", methods=["POST"])
def feedback():
	data = json.loads(request.data)

	#check request sanity i guess
	if len(data) != 6:
		return "", 400
	
	key_set = {"image_data","image_width","image_height","image_format","message","unixtime"}
	if not key_set.issubset(data.keys()):
		return "", 400

	pil_image = Image.open(io.BytesIO(bytes(data["image_data"])))
	pil_image = ImageOps.pad(pil_image, (1152,668), Image.Resampling.NEAREST, "#000000", (0,0))
	draw = ImageDraw2.Draw(pil_image)
	draw.text((576, 648), data["message"], font)

	pil_image.save(f"/home/hmontana/sbgameapi/data/{data["unixtime"]}.png")

	print("\n" + data["message"] + "\n")

	with open("/home/hmontana/sbgameapi/data/absolutelyNoSQL.csv", "a") as data_file:
		data_file_line = f"\"{data["message"]}\",\"{data["unixtime"]}\""
		data_file.write(data_file_line + "\n")
		data_file.close()

	return ""
	
@app.route("/upload", methods=["POST"])
def upload():
	data = json.loads(request.data)

	# data """"verification""""
	if len(data) != 6:
		return ""

	key_set = {"replay","name","wphones","vistas","time","unixtime"}
	if not key_set.issubset(data.keys()):
		return "", 400

	type_dict = {"replay":str,"name":str,"wphones":int,"vistas":int,"unixtime":int}
	for i in type_dict.keys():
		if type_dict[i] is not type(data[i]):
			return "", 400

	# file length check
	with open("/tmp/sbgameapi_replay", "w") as tmp_file:
		tmp_file.write(data["replay"].split()[0] + "\n")
		tmp_file.flush()
		tproc = subprocess.run("/home/hmontana/sbgameapi/replayverify.x86_64 --no-header", shell=True, capture_output=True)
		tmp_file.close()
		if int(math.ceil(int(tproc.stdout)/100)) != int(math.ceil(data["time"]/10000)):
			return "", 400
	
	with open("/home/hmontana/sbgameapi/mkhtml/absolutelyNeverAnySQL.csv", "a") as leaderboard_file:
		leaderboard_file_line = f"{data["name"]},{data["time"]},{data["wphones"]},{data["vistas"]},{data["unixtime"]}"
		leaderboard_file.write(leaderboard_file_line + "\n")
		leaderboard_file.close()
	
	replay_path=f"/var/www/html/sbgame/replays/{data["name"]}_{data["unixtime"]}.bsr2005"
	with open(replay_path, "w") as replay_file:
		replay_file.write(data["replay"])
		replay_file.close()

	subprocess.run("/home/hmontana/sbgameapi/mkhtml/mkhtml.sh")

	return ""

