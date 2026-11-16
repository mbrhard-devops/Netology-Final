from flask import Flask, jsonify
import os
import socket
import datetime

app = Flask(__name__)

# Версия приложения
APP_VERSION = os.environ.get("APP_VERSION", "dev")
APP_ENV = os.environ.get("APP_ENV", "development")


@app.route("/")
def home():
    """Информацией о приложении"""
    return jsonify({
        "status": "ok",
        "app": "Diploma Flask App",
        "version": APP_VERSION,
        "environment": APP_ENV,
        "hostname": socket.gethostname(),
        "timestamp": datetime.datetime.utcnow().isoformat()
    })


@app.route("/health")
def health():
    """Health check для Kubernetes liveness/readiness probes"""
    return jsonify({"status": "healthy"}), 200


@app.route("/ready")
def ready():
    """Readiness probe — проверяет готовность принимать трафик"""
    return jsonify({"ready": True}), 200


if __name__ == "__main__":
    port = int(os.environ.get("PORT", 5000))
    app.run(host="0.0.0.0", port=port, debug=False)
