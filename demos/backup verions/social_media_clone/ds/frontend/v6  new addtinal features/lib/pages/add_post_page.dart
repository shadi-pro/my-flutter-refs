import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../core/providers/post_provider.dart';

class AddPostPage extends StatefulWidget {
  const AddPostPage({super.key});

  @override
  State<AddPostPage> createState() => _AddPostPageState();
}

class _AddPostPageState extends State<AddPostPage> {
  final TextEditingController _captionController = TextEditingController();
  bool _hasMockImage = false;
  bool _isPosting = false;

  void _toggleMockImage() {
    setState(() {
      _hasMockImage = !_hasMockImage;
    });
  }

  Future<void> _submitPost() async {
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

    setState(() => _isPosting = true);
    await Future.delayed(const Duration(seconds: 1));

    // Get the PostProvider and add the post
    final postProvider = Provider.of<PostProvider>(context, listen: false);

    postProvider.addPost(
      text: caption,
      imageUrl: _hasMockImage ? 'mock_image_url' : null,
    );

    // Success message
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.check_circle, color: Colors.white, size: 20),
            const SizedBox(width: 8),
            Text(
              _hasMockImage ? 'Image post published!' : 'Text post published!',
            ),
          ],
        ),
        backgroundColor: Colors.green,
        behavior: SnackBarBehavior.floating,
      ),
    );

    // Clear form
    _captionController.clear();
    setState(() {
      _hasMockImage = false;
      _isPosting = false;
    });

    // Optionally navigate back to feed after posting
    // You can add navigation logic here if needed
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
        title: const Text('Create Post'),
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () {
            if (_captionController.text.isNotEmpty || _hasMockImage) {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('Discard post?'),
                  content: const Text('Your post will be lost.'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Cancel'),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                        _captionController.clear();
                        setState(() => _hasMockImage = false);
                      },
                      child: const Text('Discard'),
                    ),
                  ],
                ),
              );
            } else {
              _captionController.clear();
              setState(() => _hasMockImage = false);
            }
          },
          tooltip: 'Close',
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // User header
            Row(
              children: [
                const CircleAvatar(
                  radius: 20,
                  backgroundColor: Colors.blue,
                  child: Icon(Icons.person, color: Colors.white),
                ),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'You',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text(
                      'Posting to Feed',
                      style: TextStyle(color: Colors.grey[600], fontSize: 12),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Caption field
            TextField(
              controller: _captionController,
              decoration: InputDecoration(
                hintText: "What's on your mind?",
                border: InputBorder.none,
                hintStyle: TextStyle(color: Colors.grey[500], fontSize: 18),
              ),
              style: const TextStyle(fontSize: 16),
              maxLines: null,
            ),

            const SizedBox(height: 16),

            // Image toggle area
            GestureDetector(
              onTap: _toggleMockImage,
              child: Container(
                width: double.infinity,
                height: _hasMockImage ? 200 : 100,
                decoration: BoxDecoration(
                  color: _hasMockImage
                      ? Colors.green.shade50
                      : Colors.grey.shade100,
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
                        color: _hasMockImage
                            ? Colors.green
                            : Colors.grey.shade600,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 32),

            // Action buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildActionButton(
                  icon: Icons.photo_library,
                  label: 'Photo',
                  color: Colors.green,
                  onPressed: _toggleMockImage,
                ),
                _buildActionButton(
                  icon: Icons.tag_faces,
                  label: 'Feeling',
                  color: Colors.orange,
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Feeling feature coming soon'),
                      ),
                    );
                  },
                ),
                _buildActionButton(
                  icon: Icons.location_on,
                  label: 'Location',
                  color: Colors.red,
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Location feature coming soon'),
                      ),
                    );
                  },
                ),
              ],
            ),

            const SizedBox(height: 40),
          ],
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: ElevatedButton.icon(
            onPressed: _isPosting ? null : _submitPost,
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
            label: Text(_isPosting ? 'Posting...' : 'Publish Post'),
            style: ElevatedButton.styleFrom(
              minimumSize: const Size(double.infinity, 50),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onPressed,
  }) {
    return Column(
      children: [
        CircleAvatar(
          radius: 26,
          backgroundColor: color.withOpacity(0.1),
          child: IconButton(
            icon: Icon(icon, color: color),
            onPressed: onPressed,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(color: Colors.grey.shade700, fontSize: 12),
        ),
      ],
    );
  }
}
