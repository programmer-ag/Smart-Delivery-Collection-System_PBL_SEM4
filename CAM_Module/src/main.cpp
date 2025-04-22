#include "esp_camera.h"
#include <WiFi.h>
#include "esp_https_server.h"
#include "mqttUtil.h"
#include "FLashLight.h"
#define CAMERA_MODEL_AI_THINKER

static esp_err_t stream_handler(httpd_req_t *req);
void startCameraServer() {
  httpd_config_t config = HTTPD_DEFAULT_CONFIG();
  httpd_handle_t server = NULL;  // Fix: Define a handle for the server

  // Start the HTTP server
  if (httpd_start(&server, &config) == ESP_OK) {  // Fix: Pass a pointer to `server`
      httpd_uri_t uri_get = {
          .uri = "/stream",
          .method = HTTP_GET,
          .handler = stream_handler,
          .user_ctx = NULL
      };

      // Register URI handler
      httpd_register_uri_handler(server, &uri_get);
  } else {
      Serial.println("Error starting server!");
  }
}

static esp_err_t stream_handler(httpd_req_t *req) {
  camera_fb_t *fb = NULL;
  esp_err_t res = ESP_OK;
  size_t jpg_buf_len = 0;
  uint8_t *jpg_buf = NULL;

  res = httpd_resp_set_type(req, "multipart/x-mixed-replace; boundary=frame");

  while (true) {
      fb = esp_camera_fb_get();
      if (!fb) {
          res = ESP_FAIL;
          break;
      }

      if (fb->format != PIXFORMAT_JPEG) {
          bool jpeg_converted = frame2jpg(fb, 80, &jpg_buf, &jpg_buf_len);
          if (!jpeg_converted) {
              Serial.println("JPEG compression failed");
              esp_camera_fb_return(fb);
              res = ESP_FAIL;
              break;
          }
      } else {
          jpg_buf = fb->buf;
          jpg_buf_len = fb->len;
      }

      char part_buf[64];
      size_t hlen = snprintf(part_buf, 64,
                             "--frame\r\nContent-Type: image/jpeg\r\n"
                             "Content-Length: %u\r\n\r\n",
                             jpg_buf_len);
      res = httpd_resp_send_chunk(req, part_buf, hlen);
      if (res == ESP_OK) {
          res = httpd_resp_send_chunk(req, (const char *)jpg_buf, jpg_buf_len);
      }
      if (res == ESP_OK) {
          res = httpd_resp_send_chunk(req, "\r\n", 2);
      }

      esp_camera_fb_return(fb);
      if (res != ESP_OK) {
          break;
      }
  }
  return res;
}


const char* ssid = "wifi2";
const char* password = "12345678";


#define PWDN_GPIO_NUM     32
#define RESET_GPIO_NUM    -1
#define XCLK_GPIO_NUM      0
#define SIOD_GPIO_NUM     26
#define SIOC_GPIO_NUM     27

#define Y9_GPIO_NUM       35
#define Y8_GPIO_NUM       34
#define Y7_GPIO_NUM       39
#define Y6_GPIO_NUM       36
#define Y5_GPIO_NUM       21
#define Y4_GPIO_NUM       19
#define Y3_GPIO_NUM       18
#define Y2_GPIO_NUM        5
#define VSYNC_GPIO_NUM    25
#define HREF_GPIO_NUM     23
#define PCLK_GPIO_NUM     22

void startCameraServer();

void setup() {


  camera_config_t config;
  config.ledc_channel = LEDC_CHANNEL_0;
  config.ledc_timer = LEDC_TIMER_0;
  config.pin_d0 = Y2_GPIO_NUM;
  config.pin_d1 = Y3_GPIO_NUM;
  config.pin_d2 = Y4_GPIO_NUM;
  config.pin_d3 = Y5_GPIO_NUM;
  config.pin_d4 = Y6_GPIO_NUM;
  config.pin_d5 = Y7_GPIO_NUM;
  config.pin_d6 = Y8_GPIO_NUM;
  config.pin_d7 = Y9_GPIO_NUM;
  config.pin_xclk = XCLK_GPIO_NUM;
  config.pin_pclk = PCLK_GPIO_NUM;
  config.pin_vsync = VSYNC_GPIO_NUM;
  config.pin_href = HREF_GPIO_NUM;
  config.pin_sccb_sda = SIOD_GPIO_NUM;
  config.pin_sccb_scl = SIOC_GPIO_NUM;
  config.pin_pwdn = PWDN_GPIO_NUM;
  config.pin_reset = RESET_GPIO_NUM;
  config.xclk_freq_hz = 20000000;
  config.pixel_format = PIXFORMAT_JPEG;
  //init with high specs to pre-allocate larger buffers
  if(psramFound()){
    config.frame_size = FRAMESIZE_UXGA;
    config.jpeg_quality = 10;
    config.fb_count = 2;
  } else {
    config.frame_size = FRAMESIZE_SVGA;
    config.jpeg_quality = 12;
    config.fb_count = 1;
  }

  // camera init
  esp_err_t err = esp_camera_init(&config);
  if (err != ESP_OK) {
    return;
  }

  //drop down frame size for higher initial frame rate
  sensor_t * s = esp_camera_sensor_get();
  s->set_framesize(s, FRAMESIZE_QVGA);

  WiFi.mode(WIFI_STA);  // Set ESP32 to station mode
  WiFi.begin(ssid, password);

  while (WiFi.status() != WL_CONNECTED) 
  {
      delay(500);    
  }

  // Check if connected
  if (WiFi.status() != WL_CONNECTED) 
  {   
      ESP.restart();
  }

  flash_setup();
  mqtt_setup();
  
  startCameraServer();
}

void loop() {
  while (WiFi.status() != WL_CONNECTED) 
  {
    delay(200);
  }
  subscribe_flash();

}


