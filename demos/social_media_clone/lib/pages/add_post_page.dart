import 'package:flutter/material.dart';

class AddPostPage extends StatefulWidget {
  const AddPostPage({super.key});

  @override
  State<AddPostPage> createState() => _AddPostPageState();
}

class _AddPostPageState extends State<AddPostPage> {
  final _captionController = TextEditingController();
  bool _hasMockImage = false;
  bool _isPosting = false;

  void _toggleMockImage() {
    setState(() {
      _hasMockImage = !_hasMockImage;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          _hasMockImage ? 'Mock image added (UI demo)' : 'Mock image removed',
        ),
        duration: const Duration(seconds: 1),
      ),
    );
  }

  Future<void> _mockSubmitPost() async {
    final caption = _captionController.text.trim();

    if (caption.isEmpty && !_hasMockImage) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please add text or select a mock image'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    // Simulate API call delay
    setState(() => _isPosting = true);
    await Future.delayed(const Duration(seconds: 1));

    // Success message
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.check_circle, color: Colors.white, size: 20),
            const SizedBox(width: 8),
            Text(
              _hasMockImage
                  ? 'Mock image post created!'
                  : 'Mock text post created!',
            ),
          ],
        ),
        backgroundColor: Colors.green,
        behavior: SnackBarBehavior.floating,
      ),
    );

    // Reset form
    _captionController.clear();
    setState(() {
      _hasMockImage = false;
      _isPosting = false;
    });

    // Optional: Auto-navigate back after delay
    // Future.delayed(const Duration(seconds: 1), () {
    //   if (mounted) Navigator.pop(context);
    // });
  }

  void _showMockPreview() {
    final caption = _captionController.text.trim();
    if (caption.isEmpty && !_hasMockImage) return;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Post Preview (Mock)'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Mock user info
            const Row(
              children: [
                CircleAvatar(
                  radius: 16,
                  backgroundColor: Colors.blue,
                  child: Icon(Icons.person, size: 18, color: Colors.white),
                ),
                SizedBox(width: 8),
                Text('You', style: TextStyle(fontWeight: FontWeight.bold)),
              ],
            ),
            const SizedBox(height: 12),

            // Mock image preview
            if (_hasMockImage)
              Container(
                height: 120,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.photo_library, size: 40, color: Colors.grey),
                    SizedBox(height: 8),
                    Text('Image Preview', style: TextStyle(color: Colors.grey)),
                  ],
                ),
              ),

            // Caption preview
            if (caption.isNotEmpty) ...[
              if (_hasMockImage) const SizedBox(height: 12),
              Text(caption, style: const TextStyle(fontSize: 14)),
            ],

            // Mock engagement stats
            const SizedBox(height: 16),
            const Text(
              'This is a mock preview. In real app, this would post to feed.',
              style: TextStyle(fontSize: 12, color: Colors.grey),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Edit'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _mockSubmitPost();
            },
            child: const Text('Mock Post'),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _captionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Post (Mock)'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
          tooltip: 'Back to feed',
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.info_outline),
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('Mock Mode'),
                  content: const Text(
                    'This is UI-only mode. No real images are picked or posts sent.\n\n'
                    'Toggle the mock image button to simulate adding/removing photos.',
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Got it'),
                    ),
                  ],
                ),
              );
            },
            tooltip: 'About mock mode',
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Mock user info
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.blue[50],
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Row(
                children: [
                  Icon(Icons.info, color: Colors.blue, size: 18),
                  SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Mock mode: Posts are simulated for UI demonstration',
                      style: TextStyle(fontSize: 12, color: Colors.blue),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // User header
            const Row(
              children: [
                CircleAvatar(
                  radius: 24,
                  backgroundColor: Colors.blue,
                  child: Icon(Icons.person, color: Colors.white, size: 24),
                ),
                SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Demo User',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    Text(
                      'Post will appear in mock feed',
                      style: TextStyle(color: Colors.grey, fontSize: 12),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Caption field
            TextField(
              controller: _captionController,
              decoration: InputDecoration(
                hintText: "What's on your mind? (Mock text)",
                border: InputBorder.none,
                hintStyle: TextStyle(color: Colors.grey[500], fontSize: 18),
                contentPadding: EdgeInsets.zero,
              ),
              style: const TextStyle(fontSize: 16),
              maxLines: null,
              keyboardType: TextInputType.multiline,
            ),

            const SizedBox(height: 24),

            // Mock image toggle area
            GestureDetector(
              onTap: _toggleMockImage,
              child: Container(
                width: double.infinity,
                height: _hasMockImage ? 200 : 100,
                decoration: BoxDecoration(
                  color: _hasMockImage ? Colors.green[50] : Colors.grey[100],
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: _hasMockImage ? Colors.green : Colors.grey.shade300,
                    width: 2,
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      _hasMockImage
                          ? Icons.check_circle
                          : Icons.add_photo_alternate,
                      size: 40,
                      color: _hasMockImage ? Colors.green : Colors.grey,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      _hasMockImage
                          ? 'Mock Image Added ✓\nTap to remove'
                          : 'Add Mock Image',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: _hasMockImage ? Colors.green : Colors.grey[600],
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    if (_hasMockImage) ...[
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.green,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Text(
                          'DEMO MODE',
                          style: TextStyle(color: Colors.white, fontSize: 10),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),

            const SizedBox(height: 32),

            // Mock action buttons
            const Text(
              'Mock Actions (UI Only):',
              style: TextStyle(fontWeight: FontWeight.w500, color: Colors.grey),
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: [
                _buildMockActionChip(
                  icon: Icons.photo_library,
                  label: 'Gallery',
                  active: _hasMockImage,
                ),
                _buildMockActionChip(icon: Icons.camera_alt, label: 'Camera'),
                _buildMockActionChip(icon: Icons.tag_faces, label: 'Feeling'),
                _buildMockActionChip(
                  icon: Icons.location_on,
                  label: 'Location',
                ),
                _buildMockActionChip(icon: Icons.more_horiz, label: 'More'),
              ],
            ),

            const SizedBox(height: 40),
          ],
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border(top: BorderSide(color: Colors.grey[300]!)),
          ),
          child: Row(
            children: [
              // Preview button
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: _showMockPreview,
                  icon: const Icon(Icons.remove_red_eye_outlined),
                  label: const Text('Preview'),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              // Post button
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: _isPosting ? null : _mockSubmitPost,
                  icon: _isPosting
                      ? const SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : const Icon(Icons.send),
                  label: Text(_isPosting ? 'Mocking...' : 'Mock Post'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMockActionChip({
    required IconData icon,
    required String label,
    bool active = false,
  }) {
    return Chip(
      avatar: Icon(icon, size: 18, color: active ? Colors.blue : Colors.grey),
      label: Text(label),
      backgroundColor: active ? Colors.blue[50] : Colors.grey[100],
      side: BorderSide(color: active ? Colors.blue : Colors.grey[300]!),
    );
  }
}
