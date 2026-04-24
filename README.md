# yut-teerayut-microservice-homework-aj-jojo-day2

Monorepo นี้ มี Project 7 ภาษา
1. rust
2. go
3. java
4. php
5. c#
6. dart
7. javascript

### วิธี run project
- cd project
- copy .env.example > .env
- รัน ไฟล์ ./automation.bash

โดยทำ 2 เรื่องหลักดังนี้

## A. ปรับประสิทธิภาพ ของ Dockerfile และ source code

ประกอบด้วย Dockerfile ในรูปแบบ Multistage มีการปรับประสิทธิภาพ เพื่อลดขนาด Image ลง ให้มีขนาดไม่เกิน 100 MB 

### สิ่งที่ทำในแต่ละภาษามีดังนี้

1. Event Driven (รันตลอดเวลา)
2. เมื่อ Get / request เข้ามาจะ return เป็น json 
3. [environment variable] json ที่ return จะมี 1 field ดังนี้
...
   "config": {
      "database_url": <ค่าเปลี่ยนตาม key DATABASE_URI>,
      "redis_endpoint": <ค่าเปลี่ยนตาม key REDIS_ENDPOINT>
   },
...
4. Live Reload โดยการตั้งค่า `-v "$(pwd)/.env:/app/.env:ro"` (docker run) สามารถเปลี่ยนค่า "database_url", "redis_endpoint" ใน file .env แล้วเรียก request ใหม่ ค่าจะเปลี่ยนทันที โดยไม่ต้อง reload docker ใหม่

### ขนาด Images ที่ Publish บน Docker hub
![alt text](image.png)


## B. ทำ Automation ทุก Project ที่ไฟล์ automation.bash พร้อมทั้งวาดภาพประกอบ อยู่ใน folder docs
automation.bash ทุก project ประกอบด้วย stage เหล่านี้
1. Lint
2. Test
3. Build & Publish
4. Deploy

### Rust Dockerfile Multi Stage
![alt text](rust/docs/rust-dockerfile-multistage.png)

### Rust CI/CD
![alt text](rust/docs/rust-automation-bash.png)

___________________________________________________________________

### PHP Dockerfile Multi Stage
![alt text](php/docs/php-dockerfile-multistage.png)

### PHP CI/CD
![alt text](php/docs/php-automation-bash.png)

___________________________________________________________________

### JS Dockerfile Multi Stage
![alt text](js/docs/js-dockerfile-multistage.png)

### JS CI/CD
![alt text](js/docs/js-automation-bash.png)

___________________________________________________________________

### JAVA Dockerfile Multi Stage
![alt text](java/docs/java-dockerfile-multistage.png)

### JAVA CI/CD
![alt text](java/docs/java-automation-bash.png)

___________________________________________________________________

### GO Dockerfile Multi Stage
![alt text](go/docs/go-dockerfile-multistage.png)

### GO CI/CD
![alt text](go/docs/go-automation-bash.png)

___________________________________________________________________

### Dart Dockerfile Multi Stage
![alt text](dart/docs/dart-dockerfile-multistage.png)

### Dart CI/CD
![alt text](dart/docs/dart-automation-bash.png)

___________________________________________________________________

### csharp Dockerfile Multi Stage
![alt text](csharp/docs/csharp-dockerfile-multistage.png)

### csharp CI/CD
![alt text](csharp/docs/csharp-automation-bash.png)
