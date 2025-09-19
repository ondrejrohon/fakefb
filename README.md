# Social Feed Prototype - iOS Performance Testing App

A native iOS app prototype designed to test scrolling performance and video autoplay functionality on iPhone 8 hardware.

## Features

- **Vertical scrolling feed** using UITableView with efficient cell reusing
- **Auto-play videos** when cells are visible, pause when scrolled out of view
- **Mixed content types**: text posts, images, and videos in random order
- **60fps scrolling performance** optimized for iPhone 8 (iOS 16)
- **Hardware-accelerated video playback** using AVPlayerLayer
- **Memory-efficient video management** with proper player lifecycle
- **FPS counter** for real-time performance monitoring

## Architecture

### Core Components

1. **FeedViewController** - Main view controller with UITableView
2. **VideoManager** - Handles video autoplay logic and memory management
3. **Custom Table View Cells**:
   - `TextPostCell` - For text-only posts
   - `ImagePostCell` - For posts with images
   - `VideoPostCell` - For video posts with autoplay
4. **FeedDataSource** - Manages mock data and cell configuration
5. **PostModel** - Data structure for feed posts
6. **FPSCounter** - Real-time performance monitoring

### Performance Optimizations

- **Efficient cell reusing** to prevent memory issues
- **Video preloading strategy** for upcoming cells
- **Hardware-accelerated video playback** with AVPlayerLayer
- **Proper video player lifecycle management** (create/destroy as needed)
- **Memory management** with automatic cleanup of unused video players
- **Background/foreground handling** with automatic pause/resume

## Adding Sample Videos

To add sample videos to the app:

1. Create MP4 video files named:
   - `sample_video_1.mp4`
   - `sample_video_2.mp4` 
   - `sample_video_3.mp4`
   - `sample_video_4.mp4`
   - `sample_video_5.mp4`

2. Add them to the Xcode project bundle (drag & drop into project navigator)

3. Keep file sizes reasonable for iPhone 8 performance:
   - Resolution: 720p or lower
   - Duration: 10-30 seconds
   - Bitrate: 1-3 Mbps

### Generating Test Videos (Optional)

Use the included `generate_test_videos.sh` script to create simple test videos:

```bash
# Requires ffmpeg installed
brew install ffmpeg
chmod +x generate_test_videos.sh
./generate_test_videos.sh
```

## Building and Running

1. Open `fakefb.xcodeproj` in Xcode
2. Select iPhone 8 simulator or device
3. Set deployment target to iOS 16.0
4. Build and run (⌘+R)

## Performance Testing

- **FPS Counter**: Displays in top-right corner
  - Green: 58+ FPS (excellent)
  - Yellow: 45-57 FPS (good)
  - Red: <45 FPS (needs optimization)

- **Memory Usage**: Monitor in Xcode Debug Navigator
- **Video Playback**: Should start/stop smoothly as cells enter/exit viewport

## iPhone 8 Specific Optimizations

- iOS 16.0 minimum deployment target
- Optimized for A11 Bionic chip performance
- Memory-conscious video management
- Hardware-accelerated video rendering
- Efficient table view scrolling

## Technical Details

### Video Management Strategy

- **Auto-play**: Videos play when >60% of cell is visible
- **Preloading**: Up to 3 videos preloaded ahead of current position
- **Memory cleanup**: Unused players automatically deallocated
- **Muted by default**: Tap speaker icon to unmute
- **Loop playback**: Videos restart automatically when finished

### Cell Reusing Implementation

- Proper `prepareForReuse()` implementation
- Video player cleanup on cell reuse
- Memory-efficient image handling
- Fast cell configuration

### Performance Monitoring

- Real-time FPS counter
- Color-coded performance indicators
- Memory usage tracking available in Xcode

## Troubleshooting

**Videos not playing:**
- Ensure MP4 files are added to Xcode project bundle
- Check file names match exactly: `sample_video_1.mp4`, etc.
- Verify iOS simulator/device supports video format

**Poor scrolling performance:**
- Check FPS counter for real-time feedback
- Monitor memory usage in Xcode Debug Navigator
- Reduce video file sizes/bitrates

**Build errors:**
- Ensure all Swift files are included in project target
- Check iOS deployment target is set to 16.0
- Verify all required frameworks are linked

## Next Steps for Production

1. Add network video loading with caching
2. Implement progressive video quality based on network
3. Add social interactions (likes, comments, shares)
4. Implement pull-to-refresh and infinite scroll
5. Add video upload and compression capabilities
6. Optimize for additional device sizes and iOS versions