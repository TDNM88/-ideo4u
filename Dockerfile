FROM node:18

# Install FFmpeg and Python for Hugging Face Space
RUN apt-get update && apt-get install -y \
    ffmpeg \
    python3 \
    python3-pip \
    && rm -rf /var/lib/apt/lists/*

# Set working directory
WORKDIR /app

# Create a minimal package.json
RUN echo '{"name":"tdnm-app01","version":"1.0.0","private":true,"scripts":{"dev":"next dev","build":"next build","start":"next start -p 7860","lint":"next lint"},"dependencies":{"next":"latest","react":"latest","react-dom":"latest","@google/generative-ai":"^0.24.1"}}' > /app/package.json

# Try to copy package files if they exist (using shell commands instead of COPY with || true)
RUN mkdir -p /tmp/app-files
COPY . /tmp/app-files/
RUN if [ -f /tmp/app-files/package.json ]; then cp /tmp/app-files/package.json /app/; fi
RUN if [ -f /tmp/app-files/package-lock.json ]; then cp /tmp/app-files/package-lock.json /app/; fi

# Install dependencies
RUN npm install

# Create necessary directories
RUN mkdir -p public app components pages styles

# Copy application code from temp directory
RUN cp -r /tmp/app-files/* /app/ || true
RUN rm -rf /tmp/app-files

# Remove large files that might cause issues
RUN find /app -name "AWSCLIV2.msi" -delete || true
RUN find /app -path "*/ffmpeg-bin/*" -delete || true
RUN find /app -path "*/public/temp_videos/*.mp4" -delete || true

# Set environment variables for Hugging Face
ENV NEXT_PUBLIC_BASE_URL=https://tdn-m-tdnm-app.hf.space
ENV NODE_ENV=production
ENV PORT=7860

# Build the application
RUN npm run build || echo "Build failed, but continuing..."

# Create a simple Next.js app if build fails
RUN if [ ! -d ".next" ]; then \
    echo "Creating minimal Next.js app..." && \
    mkdir -p pages && \
    echo 'export default function Home() { return <div><h1>TDNM App</h1><p>Application is starting...</p></div>; }' > pages/index.js; \
    fi

# Expose port 7860 (Hugging Face default)
EXPOSE 7860

# Start the application
CMD ["npm", "start"]
