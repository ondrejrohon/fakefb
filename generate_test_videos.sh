#!/bin/bash

# Generate Test Videos for Social Feed Prototype
# Requires ffmpeg to be installed: brew install ffmpeg

echo "Generating test videos for Social Feed Prototype..."

# Check if ffmpeg is installed
if ! command -v ffmpeg &> /dev/null; then
    echo "Error: ffmpeg is not installed. Please install it first:"
    echo "brew install ffmpeg"
    exit 1
fi

# Create videos directory if it doesn't exist
mkdir -p test_videos

# Generate 5 different test videos
echo "Creating sample_video_1.mp4 (Gradient animation)..."
ffmpeg -f lavfi -i "color=c=blue:size=720x720:duration=15" -f lavfi -i "color=c=red:size=720x720:duration=15" -filter_complex "[0][1]blend=all_mode=difference:shortest=1" -c:v libx264 -preset fast -crf 23 -pix_fmt yuv420p test_videos/sample_video_1.mp4 -y

echo "Creating sample_video_2.mp4 (Color cycle)..."
ffmpeg -f lavfi -i "testsrc2=size=720x720:duration=12:rate=30" -c:v libx264 -preset fast -crf 23 -pix_fmt yuv420p test_videos/sample_video_2.mp4 -y

echo "Creating sample_video_3.mp4 (Moving pattern)..."
ffmpeg -f lavfi -i "mandelbrot=size=720x720:rate=30:maxiter=100:start_scale=2:end_scale=0.5:duration=10" -c:v libx264 -preset fast -crf 23 -pix_fmt yuv420p test_videos/sample_video_3.mp4 -y

echo "Creating sample_video_4.mp4 (Noise pattern)..."
ffmpeg -f lavfi -i "life=size=720x720:mold=10:rule=S23/B3:random_fill_ratio=0.1:stitch=1:duration=8" -c:v libx264 -preset fast -crf 23 -pix_fmt yuv420p test_videos/sample_video_4.mp4 -y

echo "Creating sample_video_5.mp4 (Plasma effect)..."
ffmpeg -f lavfi -i "plasma=size=720x720:duration=14" -c:v libx264 -preset fast -crf 23 -pix_fmt yuv420p test_videos/sample_video_5.mp4 -y

echo ""
echo "✅ Test videos generated successfully!"
echo "📁 Videos are located in: test_videos/"
echo ""
echo "Next steps:"
echo "1. Open Xcode project"
echo "2. Drag and drop the videos from test_videos/ folder into your Xcode project"
echo "3. Make sure to add them to the app target"
echo "4. Build and run the app"
echo ""
echo "Video specifications:"
echo "- Resolution: 720x720 (square format)"
echo "- Duration: 8-15 seconds each"
echo "- Format: MP4 (H.264)"
echo "- Optimized for mobile playback"