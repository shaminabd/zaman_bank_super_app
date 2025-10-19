#!/bin/bash

echo "Starting Flutter Web App with Proxy Configuration..."
echo "Backend API: http://localhost:8080"
echo "Flutter App: http://localhost:8081"
echo ""
echo "Proxy Configuration:"
echo "- All /api/* requests will be forwarded to http://localhost:8080"
echo "- Flutter app will run on http://localhost:8081"
echo ""

cd /Users/shynggys/Downloads/super_app_zaman/zaman_bank_super_app

echo "Starting Flutter web development server..."
flutter run -d chrome --web-port=8081 --web-hostname=localhost
