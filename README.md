# redmane-auth
Authentication service for REDMANE - Data commons for the WEHI Internship 2025 Summer

## 1. Set up your local machine or a VM with necessarily tools like Docker and Make. 

## 2. Clone this repository

## 3. Get your NGROK_AUTH_TOKEN from Ngrok Dashboard and paste it into your .env.local 

## 4. Check what make commands are available 

`make help`

## 5. Compose and build Containers

`sudo make up`

## 6. Check logs

`sudo make logs`

## 7. Check public url and visit your Keycloak terminal 

`make ngrok-url`
