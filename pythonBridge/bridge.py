"""
Smart Parking – Python Bridge
Version : 2.0
Author  : Yasin Moridi
"""

import serial
import socket
import json
import threading
import time
from datetime import datetime

# ── Settings ──────────────────────────────────────────
SERIAL_PORT = 'COM2'      # com0com pair – Python side
BAUD_RATE   = 9600
TCP_HOST    = '0.0.0.0'
TCP_PORT    = 5000
MAX_HISTORY = 100
# ──────────────────────────────────────────────────────

latest_data = {
    "cars":      0,
    "capacity":  10,
    "available": 10,
    "status":    "available",
    "event":     "none"
}

history      = []
clients      = []
clients_lock = threading.Lock()
serial_conn  = None


def add_history(event):
    if event in ("none",):
        return
    entry = {
        "time":  datetime.now().strftime("%H:%M"),
        "event": event
    }
    history.append(entry)
    if len(history) > MAX_HISTORY:
        history.pop(0)


def build_payload():
    payload = dict(latest_data)
    payload["history"] = history[-50:]
    return json.dumps(payload) + '\n'


def broadcast(message):
    dead = []
    with clients_lock:
        for c in clients:
            try:
                c.sendall(message.encode())
            except:
                dead.append(c)
        for c in dead:
            clients.remove(c)


def serial_reader():
    global serial_conn
    while True:
        try:
            with serial.Serial(SERIAL_PORT, BAUD_RATE, timeout=2) as ser:
                serial_conn = ser
                print(f"[SERIAL] Connected on {SERIAL_PORT}")
                while True:
                    line = ser.readline()
                    decoded = line.decode('utf-8', errors='ignore').strip()
                    if not decoded:
                        continue
                    try:
                        data = json.loads(decoded)
                        latest_data.update(data)
                        add_history(data.get("event", "none"))
                        broadcast(build_payload())
                        print(f"[FROM AVR] {decoded}")
                    except json.JSONDecodeError as e:
                        print(f"[JSON ERROR] {e} | raw: '{decoded}'")
        except serial.SerialException as e:
            serial_conn = None
            print(f"[SERIAL ERROR] {e} — retrying in 3s")
            time.sleep(3)


def tcp_handler(conn, addr):
    print(f"[TCP] Android connected from {addr}")
    with clients_lock:
        clients.append(conn)

    try:
        conn.sendall(build_payload().encode())
    except:
        pass

    buf = ""
    while True:
        try:
            chunk = conn.recv(1024).decode('utf-8', errors='ignore')
            if not chunk:
                break
            buf += chunk
            while '\n' in buf:
                line, buf = buf.split('\n', 1)
                line = line.strip()
                if not line:
                    continue
                print(f"[FROM ANDROID] {line}")
                try:
                    cmd = json.loads(line)
                    if "cmd" in cmd:
                        if serial_conn and serial_conn.is_open:
                            forward = json.dumps({"cmd": cmd["cmd"]}) + '\n'
                            serial_conn.write(forward.encode())
                            print(f"[TO AVR] {forward.strip()}")
                        else:
                            print("[WARNING] Serial not available")
                except json.JSONDecodeError as e:
                    print(f"[JSON ERROR from Android] {e} | raw: '{line}'")
        except Exception as e:
            print(f"[TCP] Client {addr} error: {e}")
            break

    print(f"[TCP] Android disconnected: {addr}")
    with clients_lock:
        if conn in clients:
            clients.remove(conn)
    conn.close()


def tcp_server():
    srv = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
    srv.setsockopt(socket.SOL_SOCKET, socket.SO_REUSEADDR, 1)
    srv.bind((TCP_HOST, TCP_PORT))
    srv.listen(5)
    print(f"[TCP] Server listening on port {TCP_PORT}")
    while True:
        conn, addr = srv.accept()
        t = threading.Thread(target=tcp_handler, args=(conn, addr), daemon=True)
        t.start()


threading.Thread(target=serial_reader, daemon=True).start()
tcp_server()