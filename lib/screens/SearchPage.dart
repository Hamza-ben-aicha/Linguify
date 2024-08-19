import 'package:flutter/material.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:Linguify/Constants/Constants.dart';
import 'package:country_picker/country_picker.dart';
import 'ConversationPage.dart';

class SearchPage extends StatefulWidget {
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  PanelController _panelController = PanelController();
  List<String> selectedFilters = [];
  List<Map<String, dynamic>> searchResults = [];
  String selectedCountry = '';
  String selectedNativeLanguage = '';
  String selectedLearningLanguage = '';
  DocumentSnapshot? lastDocument;
  bool isLoading = false;
  bool hasMore = true;
  String currentQuery = '';

  final List<String> languages = [
    // (list of languages)
  ];

  void _onFilterSelected(String filter) {
    setState(() {
      if (selectedFilters.contains(filter)) {
        selectedFilters.remove(filter);
        if (filter == 'country') {
          selectedCountry = '';
        } else if (filter == 'native language') {
          selectedNativeLanguage = '';
        } else if (filter == 'language to learn') {
          selectedLearningLanguage = '';
        }
      } else {
        if (filter == 'country') {
          _selectCountry();
        } else if (filter == 'native language') {
          _selectNativeLanguage();
        } else if (filter == 'language to learn') {
          _selectLearningLanguage();
        } else {
          selectedFilters.add(filter);
        }
      }
      searchResults.clear();
      lastDocument = null;
      hasMore = true;
    });

    if (currentQuery.isNotEmpty) {
      _searchUsers(currentQuery);
    }
  }

  void _selectCountry() {
    showCountryPicker(
      context: context,
      showPhoneCode: false,
      onSelect: (Country country) {
        setState(() {
          selectedCountry = country.name;
          if (!selectedFilters.contains('country')) {
            selectedFilters.add('country');
          }
          searchResults.clear();
          lastDocument = null;
          hasMore = true;
        });

        if (currentQuery.isNotEmpty) {
          _searchUsers(currentQuery);
        }
      },
    );
  }

  void _selectNativeLanguage() {
    _showLanguagePicker('native language');
  }

  void _selectLearningLanguage() {
    _showLanguagePicker('language to learn');
  }

  void _showLanguagePicker(String filterType) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return SafeArea(
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                  title: Text('Select Language', style: TextStyle(fontWeight: FontWeight.bold)),
                ),
                Container(
                  height: MediaQuery.of(context).size.height * 0.8,
                  child: ListView.builder(
                    itemCount: languages.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        title: Text(languages[index]),
                        onTap: () {
                          setState(() {
                            if (filterType == 'native language') {
                              selectedNativeLanguage = languages[index];
                              if (!selectedFilters.contains('native language')) {
                                selectedFilters.add('native language');
                              }
                            } else {
                              selectedLearningLanguage = languages[index];
                              if (!selectedFilters.contains('language to learn')) {
                                selectedFilters.add('language to learn');
                              }
                            }
                            searchResults.clear();
                            lastDocument = null;
                            hasMore = true;
                          });
                          Navigator.pop(context);

                          if (currentQuery.isNotEmpty) {
                            _searchUsers(currentQuery);
                          }
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.0)),
      ),
      isScrollControlled: true,
    );
  }

  Future<void> _searchUsers(String query, {bool isLoadMore = false}) async {
    if (isLoading || !hasMore) return;

    setState(() {
      isLoading = true;
    });

    try {
      Query queryRef = FirebaseFirestore.instance.collection('users');

      if (selectedFilters.contains('country') && selectedCountry.isNotEmpty) {
        queryRef = queryRef.where('country', isEqualTo: selectedCountry);
      }

      if (selectedFilters.contains('native language') && selectedNativeLanguage.isNotEmpty) {
        queryRef = queryRef.where('native_language', isEqualTo: selectedNativeLanguage);
      }

      if (selectedFilters.contains('language to learn') && selectedLearningLanguage.isNotEmpty) {
        queryRef = queryRef.where('learning_language', isEqualTo: selectedLearningLanguage);
      }

      if (query.isNotEmpty) {
        queryRef = queryRef
            .where('full_name', isGreaterThanOrEqualTo: query)
            .where('full_name', isLessThanOrEqualTo: query + '\uf8ff')
            .orderBy('full_name');
      }

      if (lastDocument != null) {
        queryRef = queryRef.startAfterDocument(lastDocument!);
      }

      queryRef = queryRef.limit(20);

      QuerySnapshot userSnapshot = await queryRef.get();

      if (userSnapshot.docs.isEmpty) {
        setState(() {
          hasMore = false;
        });
      } else {
        setState(() {
          lastDocument = userSnapshot.docs.last;
          searchResults.addAll(userSnapshot.docs.map((doc) {
            final data = doc.data() as Map<String, dynamic>?; // Cast to Map<String, dynamic> with null safety
            return {
              'user_id': doc.id, // Document ID as user_id
              'full_name': data?['full_name'] ?? 'Unknown User',
              'email': data?['email'] ?? 'No Email',
              'account_image': data?.containsKey('account_image') == true ? data!['account_image'] : null,
              'country': data?['country'] ?? 'Unknown Country',
              'native_language': data?['native_language'] ?? 'Unknown Language',
              'learning_language': data?['learning_language'] ?? 'Unknown Language',
            };
          }).toList());
        });
      }
    } catch (e) {
      print('Error: $e');
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: PRIMARY_COLOR,
      body: SafeArea(
        child: Stack(
          children: [
            Column(
              children: [
                SizedBox(height: 10),
                Center(
                  child: Text(
                    'Search',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                      fontSize: 20,
                    ),
                  ),
                ),
              ],
            ),
            Column(
              children: [
                SizedBox(height: 40),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 24.0),
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: 'Search',
                      hintStyle: TextStyle(color: PRIMARY_COLOR),
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide: BorderSide.none,
                      ),
                      prefixIcon: Icon(Icons.search, color: PRIMARY_COLOR),
                    ),
                    style: TextStyle(color: PRIMARY_COLOR),
                    onSubmitted: (query) {
                      if (query.trim().isNotEmpty) {
                        setState(() {
                          currentQuery = query;
                          searchResults.clear();
                          lastDocument = null;
                          hasMore = true;
                        });
                        _searchUsers(query);
                      } else {
                        setState(() {
                          searchResults.clear();
                          currentQuery = '';
                        });
                      }
                    },
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    _panelController.open();
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Center(
                          child: Text(
                            'Filter',
                            style: TextStyle(
                              color: Colors.blue,
                              fontSize: 18.0,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: NotificationListener<ScrollNotification>(
                    onNotification: (ScrollNotification scrollInfo) {
                      if (!isLoading && scrollInfo.metrics.pixels == scrollInfo.metrics.maxScrollExtent && hasMore) {
                        _searchUsers(currentQuery, isLoadMore: true);
                      }
                      return false;
                    },
                    child: searchResults.isEmpty
                        ? Center(
                      child: Text(
                        'No results found',
                        style: TextStyle(color: Colors.white),
                      ),
                    )
                        : ListView.builder(
                      padding: EdgeInsets.only(top: 10),
                      itemCount: searchResults.length,
                      itemBuilder: (context, index) {
                        final user = searchResults[index];
                        return GestureDetector(
                          onTap: () async {
                            User? currentUser = _auth.currentUser;

                            String receiverId = user['user_id'];
                            String receiverName = user['full_name'] ?? 'Unknown User';
                            String receiverImage = user['account_image'] ?? ''; // Ensure the receiver image is passed

                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ConversationPage(
                                  receiverId: receiverId,
                                  receiverName: receiverName,
                                  currentUserId: currentUser?.uid ?? '',
                                  receiverImage: receiverImage, // Pass the receiverImage here
                                ),
                              ),
                            );
                          },
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
                            child: Container(
                              padding: EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(15),
                              ),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  CircleAvatar(
                                    backgroundImage: user['account_image'] != null
                                        ? NetworkImage(user['account_image'])
                                        : AssetImage('assets/images/default_profile.png'),
                                    radius: 30, // Adjust the radius as needed
                                  ),
                                  SizedBox(width: 10), // Space between the avatar and the text
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          user['full_name'] ?? 'Unknown User',
                                          style: TextStyle(
                                            color: PRIMARY_COLOR,
                                            fontSize: 18.0,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        SizedBox(height: 5),
                                        Text(
                                          user['country'] ?? 'Unknown Country',
                                          style: TextStyle(color: PRIMARY_COLOR),
                                        ),
                                        SizedBox(height: 5),
                                        Text(
                                          user['native_language'] ?? 'No native language specified',
                                          style: TextStyle(color: PRIMARY_COLOR),
                                        ),
                                        SizedBox(height: 5),
                                        Text(
                                          user['learning_language'] ?? 'No language to learn specified',
                                          style: TextStyle(color: PRIMARY_COLOR),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
            SlidingUpPanel(
              controller: _panelController,
              minHeight: 0,
              maxHeight: MediaQuery.of(context).size.height * 0.6,
              panel: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Text(
                        'Filters',
                        style: TextStyle(
                          color: PRIMARY_COLOR,
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                      ),
                    ),
                    SizedBox(height: 16),
                    FilterChip(
                      label: Text(selectedCountry.isEmpty ? 'Country' : 'Country: $selectedCountry'),
                      selected: selectedFilters.contains('country'),
                      onSelected: (isSelected) => _onFilterSelected('country'),
                    ),
                    SizedBox(height: 10),
                    FilterChip(
                      label: Text(selectedNativeLanguage.isEmpty ? 'Native Language' : 'Native Language: $selectedNativeLanguage'),
                      selected: selectedFilters.contains('native language'),
                      onSelected: (isSelected) => _onFilterSelected('native language'),
                    ),
                    SizedBox(height: 10),
                    FilterChip(
                      label: Text(selectedLearningLanguage.isEmpty ? 'Language to Learn' : 'Language to Learn: $selectedLearningLanguage'),
                      selected: selectedFilters.contains('language to learn'),
                      onSelected: (isSelected) => _onFilterSelected('language to learn'),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
