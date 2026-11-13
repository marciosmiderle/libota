#include <WiFi.h>
#include <OtaUpdater.hpp>
#include <Logger.hpp>
#include <LoggerSerial.hpp>

OtaUpdater ota;
LoggerSerial* logToSer0 = nullptr;

const char* ssid     = "Wokwi-GUEST";
const char* password = "";

void setupLogger() {
  logToSer0 = new LoggerSerial(Serial);
  Log.addLogger(logToSer0);
}

void setupNetwork() {
  WiFi.onEvent([](WiFiEvent_t event, WiFiEventInfo_t info) {
			if (event == ARDUINO_EVENT_WIFI_STA_GOT_IP) {
				ota.start();
			} else if (event == ARDUINO_EVENT_WIFI_STA_DISCONNECTED) {
				ota.stop();
			}
		});

  WiFi.begin(ssid, password);
}

void handleSerialCommands() {
  if (!Serial.available()) return;

  String cmdline = Serial.readStringUntil('\n');
  cmdline.trim();
  if (cmdline.isEmpty()) return;

  if (cmdline == "firmware_update_stop") {
    if (ota.stopUpdate()) {
      Serial.println("update cancelado");
    } else {
      Serial.println("não está em andamento");
    }
  } else if (cmdline.startsWith("firmware_update ")) {
    String url = cmdline.substring(16);
    url.trim();
    if (url.isEmpty()) {
      Serial.println("uso: firmware_update <url>");
      return;
    }
    if (ota.startUpdate(url.c_str())) {
      Serial.println("download iniciado");
    } else {
      Serial.println("já em andamento");
    }
  } else if (cmdline == "firmware_mark_ok") {
    if (ota.markOk()) {
      Serial.println("firmware marcado como valido");
    } else {
      Serial.println("mark ok falhou");
    }
  } else if (cmdline == "firmware_mark_invalid_reboot") {
    if (ota.markInvalidReboot()) {
      Serial.println("firmware marcado como valido, reboot");
    } else {
      Serial.println("firmware marcado como valido falhou");
    }
  } else if (cmdline == "firmware_version") {
    Serial.println("0.1");
  }
}

void setup() {
  Serial.begin(115200);
  setupLogger();
  setupNetwork();
}

void loop() {
  handleSerialCommands();
  ota.update();
  Log.update();
}
