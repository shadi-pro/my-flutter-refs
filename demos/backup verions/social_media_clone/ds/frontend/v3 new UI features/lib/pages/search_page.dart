import 'package:flutter/material.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController _searchController = TextEditingController();
  List<Map<String, dynamic>> _searchResults = [];
  bool _isSearching = false;
  bool _hasSearched = false;

  // Mock data for search
  final List<Map<String, dynamic>> _mockUsers = [
    {
      'id': '1',
      'username': 'flutter_dev',
      'name': 'Alex Johnson',
      'avatar': 'U',
      'bio': 'Senior Flutter Developer • Open Source Contributor',
      'followers': 1240,
      'isFollowing': false,
    },
    {
      'id': '2',
      'username': 'ui_designer',
      'name': 'Sarah Chen',
      'avatar': 'S',
      'bio': 'UI/UX Designer • Design System Specialist',
      'followers': 890,
      'isFollowing': true,
    },
    {
      'id': '3',
      'username': 'code_wizard',
      'name': 'Mike Rodriguez',
      'avatar': 'M',
      'bio': 'Full Stack Developer • Tech Lead',
      'followers': 2150,
      'isFollowing': false,
    },
    {
      'id': '4',
      'username': 'mobile_guru',
      'name': 'Priya Sharma',
      'avatar': 'P',
      'bio': 'Mobile App Architect • Flutter & React Native',
      'followers': 1780,
      'isFollowing': false,
    },
    {
      'id': '5',
      'username': 'design_thinking',
      'name': 'David Kim',
      'avatar': 'D',
      'bio': 'Product Designer • Design Thinking Coach',
      'followers': 950,
      'isFollowing': true,
    },
  ];

  final List<Map<String, dynamic>> _mockPosts = [
    {
      'id': 'p1',
      'type': 'post',
      'username': 'flutter_dev',
      'content':
          'Just published my new Flutter package on pub.dev! State management made easy.',
      'likes': 142,
      'comments': 28,
      'time': '2 hours ago',
    },
    {
      'id': 'p2',
      'type': 'post',
      'username': 'ui_designer',
      'content': 'Creating beautiful animations in Flutter is so satisfying!',
      'likes': 89,
      'comments': 15,
      'time': '1 day ago',
    },
    {
      'id': 'p3',
      'type': 'post',
      'username': 'code_wizard',
      'content':
          'Tips for optimizing Flutter app performance:\n1. Use const widgets\n2. Implement lazy loading\n3. Optimize images',
      'likes': 210,
      'comments': 42,
      'time': '3 days ago',
    },
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _performSearch(String query) {
    if (query.trim().isEmpty) {
      setState(() {
        _searchResults = [];
        _hasSearched = false;
      });
      return;
    }

    setState(() {
      _isSearching = true;
      _hasSearched = true;
    });

    // Simulate API delay
    Future.delayed(const Duration(milliseconds: 500), () {
      final lowerQuery = query.toLowerCase();

      final userResults = _mockUsers.where((user) {
        return user['username'].toLowerCase().contains(lowerQuery) ||
            user['name'].toLowerCase().contains(lowerQuery) ||
            user['bio'].toLowerCase().contains(lowerQuery);
      }).toList();

      final postResults = _mockPosts.where((post) {
        return post['content'].toLowerCase().contains(lowerQuery) ||
            post['username'].toLowerCase().contains(lowerQuery);
      }).toList();

      setState(() {
        _searchResults = [...userResults, ...postResults];
        _isSearching = false;
      });
    });
  }

  void _clearSearch() {
    _searchController.clear();
    setState(() {
      _searchResults = [];
      _hasSearched = false;
    });
  }

  void _toggleFollow(int index) {
    setState(() {
      if (_searchResults[index].containsKey('isFollowing')) {
        _searchResults[index]['isFollowing'] =
            !_searchResults[index]['isFollowing'];
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Search'), centerTitle: true),
      body: Column(
        children: [
          // Search Bar
          Container(
            padding: const EdgeInsets.all(16),
            color: Theme.of(context).appBarTheme.backgroundColor,
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(24),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: TextField(
                      controller: _searchController,
                      decoration: InputDecoration(
                        hintText: 'Search users or posts...',
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 16,
                        ),
                        prefixIcon: const Icon(
                          Icons.search,
                          color: Colors.grey,
                        ),
                        suffixIcon: _searchController.text.isNotEmpty
                            ? IconButton(
                                icon: const Icon(Icons.close, size: 20),
                                onPressed: _clearSearch,
                              )
                            : null,
                      ),
                      onChanged: (value) {
                        if (value.length >= 2) {
                          _performSearch(value);
                        } else if (value.isEmpty) {
                          _clearSearch();
                        }
                      },
                      onSubmitted: _performSearch,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                ElevatedButton(
                  onPressed: () {
                    if (_searchController.text.isNotEmpty) {
                      _performSearch(_searchController.text);
                    }
                  },
                  child: const Text('Search'),
                ),
              ],
            ),
          ),

          // Search Results
          Expanded(child: _buildResults()),
        ],
      ),
    );
  }

  Widget _buildResults() {
    if (_isSearching) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 16),
            Text('Searching...'),
          ],
        ),
      );
    }

    if (!_hasSearched) {
      return _buildRecentSearches();
    }

    if (_searchResults.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.search_off, size: 80, color: Colors.grey[400]),
            const SizedBox(height: 16),
            Text(
              'No results found',
              style: TextStyle(fontSize: 20, color: Colors.grey[600]),
            ),
            const SizedBox(height: 8),
            Text(
              'Try different keywords',
              style: TextStyle(color: Colors.grey[500]),
            ),
          ],
        ),
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: _searchResults.length,
      separatorBuilder: (context, index) => const Divider(height: 24),
      itemBuilder: (context, index) {
        final item = _searchResults[index];

        if (item.containsKey('isFollowing')) {
          return _buildUserResult(item, index);
        } else {
          return _buildPostResult(item);
        }
      },
    );
  }

  Widget _buildUserResult(Map<String, dynamic> user, int index) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: CircleAvatar(
        backgroundColor: Colors.blue,
        radius: 28,
        child: Text(
          user['avatar'],
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            user['name'],
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          const SizedBox(height: 2),
          Text(
            '@${user['username']}',
            style: TextStyle(color: Colors.grey[600]),
          ),
        ],
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 4),
          Text(
            user['bio'],
            style: const TextStyle(fontSize: 14),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 8),
          Text(
            '${user['followers']} followers',
            style: TextStyle(fontSize: 12, color: Colors.grey[600]),
          ),
        ],
      ),
      trailing: SizedBox(
        width: 100,
        child: ElevatedButton(
          onPressed: () => _toggleFollow(index),
          style: ElevatedButton.styleFrom(
            backgroundColor: user['isFollowing']
                ? Colors.grey[200]
                : Colors.blue,
            foregroundColor: user['isFollowing'] ? Colors.black : Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          ),
          child: Text(
            user['isFollowing'] ? 'Following' : 'Follow',
            style: const TextStyle(fontSize: 12),
          ),
        ),
      ),
    );
  }

  Widget _buildPostResult(Map<String, dynamic> post) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  backgroundColor: Colors.blue,
                  radius: 16,
                  child: Text(
                    post['username'][0].toUpperCase(),
                    style: const TextStyle(fontSize: 12, color: Colors.white),
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  '@${post['username']}',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                const Spacer(),
                Text(
                  post['time'],
                  style: TextStyle(color: Colors.grey[600], fontSize: 12),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(post['content'], style: const TextStyle(fontSize: 14)),
            const SizedBox(height: 12),
            Row(
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.favorite_border,
                      size: 18,
                      color: Colors.grey[600],
                    ),
                    const SizedBox(width: 4),
                    Text('${post['likes']}'),
                  ],
                ),
                const SizedBox(width: 16),
                Row(
                  children: [
                    Icon(
                      Icons.comment_outlined,
                      size: 18,
                      color: Colors.grey[600],
                    ),
                    const SizedBox(width: 4),
                    Text('${post['comments']}'),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRecentSearches() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.fromLTRB(16, 24, 16, 8),
          child: Text(
            'Recent Searches',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
        Expanded(
          child: ListView(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            children: [
              _buildRecentItem('Flutter'),
              _buildRecentItem('UI Design'),
              _buildRecentItem('Mobile Development'),
              _buildRecentItem('State Management'),
              _buildRecentItem('Animation'),
            ],
          ),
        ),
        const Padding(
          padding: EdgeInsets.fromLTRB(16, 24, 16, 8),
          child: Text(
            'Popular Now',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _buildPopularChip('#Flutter'),
              _buildPopularChip('#UIUX'),
              _buildPopularChip('#Programming'),
              _buildPopularChip('#MobileApps'),
              _buildPopularChip('#OpenSource'),
              _buildPopularChip('#Tech'),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildRecentItem(String text) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: const Icon(Icons.history, color: Colors.grey),
      title: Text(text),
      trailing: IconButton(
        icon: const Icon(Icons.close, size: 18),
        onPressed: () {},
      ),
      onTap: () {
        _searchController.text = text;
        _performSearch(text);
      },
    );
  }

  Widget _buildPopularChip(String text) {
    return Chip(
      label: Text(text),
      backgroundColor: Colors.blue[50],
      side: BorderSide(color: Colors.blue[100]!),
      labelStyle: const TextStyle(color: Colors.blue),
      onDeleted: () {},
      deleteIcon: const Icon(Icons.add, size: 16),
    );
  }
}
