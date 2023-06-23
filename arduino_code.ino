// const int firstPin = 0;
// const int lastPin = 13;
// const int numberOfPins = lastPin - firstPin + 1;

// void setup() {
//   Serial.begin(115200); 

//   for (int i = firstPin; i <= lastPin; i++) {
//     pinMode(i, OUTPUT); 
//   }
// }

// void loop() {
//   if (Serial.available() >= numberOfPins) {
//     for (int i = firstPin; i <= lastPin; i++) {
//       int state = Serial.read();
//       digitalWrite(i, state);
//     }
//   }
// }
