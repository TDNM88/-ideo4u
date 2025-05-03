# app.py - Hugging Face Space entry point
import os
import subprocess
import time

# Thông báo khởi động
print("🚀 Starting TDNM Application...")

# Chạy ứng dụng Next.js thông qua Dockerfile
# Hugging Face sẽ tự động sử dụng Dockerfile để build và chạy ứng dụng
print("✅ Docker container will handle the application startup")
print("✅ Application will be available at the Space URL")

# Giữ tiến trình chạy để Hugging Face không tắt container
while True:
    time.sleep(60)
    print("🔄 Application is running...")
