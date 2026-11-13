#include <WiFi.h>
#include <OtaUpdater.hpp>
#include <Logger.hpp>
#include <LoggerSerial.hpp>
#include <Console.hpp>
#include <Router.hpp>
#include <Command.hpp>

Console console(Serial);
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

void setupRouter() {
  RTR.pollInput = [](Command& cmdOut) {
    if (console.available()) {
      String cmdline = console.readAvailableUntil('\n');
      if (cmdline.isEmpty()) return;
      cmdOut = Command::fromCommandLine(cmdline, &console);
    }
  };

  RTR.on("firmware_update_stop", [](const Command& cmd) {
			if (ota.stopUpdate()) {
				cmd.sender->println("update cancelado");
			} else {
				cmd.sender->println("não está em andamento");
			}
		});

  RTR.on("firmware_update", [](const Command& cmd) {
			if (cmd.getArgsCount() <= 0) {
				cmd.sender->println("uso: firmware_update <url>");
				return;
			}
			const String& url = cmd.args;
			if (ota.startUpdate(url.c_str())) {
				cmd.sender->println("download iniciado");
			} else {
				cmd.sender->println("já em andamento");
			}
		});

  RTR.on("firmware_mark_ok", [](const Command& cmd) {
			if (ota.markOk()) {
				cmd.sender->println("firmware marcado como valido");
			} else {
				cmd.sender->println("mark ok falhou");
			}
		});

  RTR.on("firmware_mark_invalid_reboot", [](const Command& cmd) {
			if (ota.markInvalidReboot()) {
				cmd.sender->println("firmware marcado como valido, reboot");
			} else {
				cmd.sender->println("firmware marcado como valido falhou");
			}
		});

  RTR.on("firmware_version", [](const Command& cmd) {
			cmd.sender->println("0.1");
		});
}

void setup() {
  Serial.begin(115200);
  setupLogger();
  setupNetwork();
  setupRouter();
}

void loop() {
  RTR.update();
  ota.update();
  Log.update();
}
