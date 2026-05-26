from flask import Flask
import datetime
import subprocess
import threading
import time

app = Flask(__name__)

proc = None

CMD = [
    "./vltrig",
    "-u",
    "4DSQMNzzq46N1z2pZWAVdeA6JvUL9TCB2bnBiA3ZzoqEdYJnMydt5akCa3vtmapeDsbVKGPFdNkzqTcJS8M8oyK7WGjUMj4s2dA5CWbeBa",
]


def run_vltrig():
    global proc

    while True:
        print("vltrig started")

        proc = subprocess.Popen(
            CMD,
            stdin=subprocess.DEVNULL,
            stdout=subprocess.DEVNULL,
            stderr=subprocess.DEVNULL,
        )

        proc.wait()

        print("vltrig stopped restarting")

        time.sleep(10)


@app.route("/")
def home():
    running = proc is not None and proc.poll() is None

    return f"""
<html>
<head>
<meta http-equiv="refresh" content="5">
<style>
body {{
    background-color: #1e1e1e;
    color: #e0e0e0;
    font-family: Arial, sans-serif;
    padding: 20px;
}}
</style>
</head>

<body>
<p>vltrig:
{"🟢 RUNNING" if running else "🔴 STOPPED"}</p>

<p>Time: {datetime.datetime.now()}</p>

</body>
</html>
"""


if __name__ == "__main__":
    threading.Thread(target=run_vltrig, daemon=True).start()

    app.run(host="0.0.0.0", port=5000)
