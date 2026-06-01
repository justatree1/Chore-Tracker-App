import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

const Color backgroundColor = Color(0xFFFFF7CC);

enum Mood { neutral, happy, angry, guilty }

class Chore {
  String name;
  String assignedTo;
  String? completedBy; // NEW
  bool isDone;

  Chore({
    required this.name,
    required this.assignedTo,
    this.completedBy,
    this.isDone = false,
  });
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  await Hive.openBox('choresBox');
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Your Home',
      theme: ThemeData(
        scaffoldBackgroundColor: backgroundColor,
        appBarTheme: const AppBarTheme(
          backgroundColor: backgroundColor,
          elevation: 0,
          iconTheme: IconThemeData(color: Colors.black),
          titleTextStyle: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
      ),
      home: const SplashScreen(),
    );
  }
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 2), _navigateNext);
  }

  void _navigateNext() {
    final box = Hive.box('choresBox');
    final hasProfile = box.get('profileName') != null;

    if (hasProfile) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const HomeScreen()),
      );
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const WelcomeScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: const [
              Text(
                '🌼 Your Home',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 36,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              SizedBox(height: 24),
              Icon(Icons.home, size: 120, color: Colors.black54),
              SizedBox(height: 24),
              Text(
                'Making chores fair',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 18, color: Colors.black87),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                '🌼 Welcome Home',
                style: TextStyle(
                  fontSize: 34,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'A cozy way to share chores with the people you live with.',
                style: TextStyle(
                  fontSize: 18,
                  height: 1.4,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 40),
              const Center(
                child: Icon(
                  Icons.family_restroom,
                  size: 140,
                  color: Colors.black54,
                ),
              ),
              const SizedBox(height: 40),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const CreateProfileScreen(),
                    ),
                  );
                },
                child: const Text(
                  'Get Started',
                  style: TextStyle(fontSize: 18),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CreateProfileScreen extends StatefulWidget {
  final String? initialName;
  final String? initialCharacter;

  const CreateProfileScreen({
    super.key,
    this.initialName,
    this.initialCharacter,
  });

  @override
  State<CreateProfileScreen> createState() => _CreateProfileScreenState();
}

class _CreateProfileScreenState extends State<CreateProfileScreen> {
  late String profileName;
  late TextEditingController _nameController;

  @override
  void initState() {
    super.initState();
    profileName = widget.initialName ?? '';
    _nameController = TextEditingController(text: profileName);
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                'What should we call you?',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 24),
              TextField(
                controller: _nameController,
                onChanged: (value) {
                  setState(() {
                    profileName = value.trim();
                  });
                },
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  hintText: 'Enter your name',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFFFD1D6),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                onPressed: profileName.isEmpty
                    ? null
                    : () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => ChooseCharacterScreen(
                              profileName: profileName,
                              initialCharacter: widget.initialCharacter,
                            ),
                          ),
                        );
                      },
                child: const Text(
                  'Continue',
                  style: TextStyle(fontSize: 18, color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ChooseCharacterScreen extends StatefulWidget {
  final String profileName;
  final String? initialCharacter;

  const ChooseCharacterScreen({
    super.key,
    required this.profileName,
    this.initialCharacter,
  });

  @override
  State<ChooseCharacterScreen> createState() => _ChooseCharacterScreenState();
}

class _ChooseCharacterScreenState extends State<ChooseCharacterScreen> {
  late String? selectedCharacter;
  final List<String> characterOptions = ['🌱', '🍓', '☁️', '🐻', '🐰', '🐱'];

  @override
  void initState() {
    super.initState();
    selectedCharacter = widget.initialCharacter;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            children: [
              const SizedBox(height: 24),
              const Text(
                'Choose your little roommate',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 24),
              Expanded(
                child: GridView.count(
                  crossAxisCount: 3,
                  mainAxisSpacing: 16,
                  crossAxisSpacing: 16,
                  children: characterOptions.map((character) {
                    final isSelected = character == selectedCharacter;
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          selectedCharacter = character;
                        });
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: isSelected
                                ? Colors.black
                                : Colors.transparent,
                            width: 3,
                          ),
                        ),
                        child: Center(
                          child: Text(
                            character,
                            style: const TextStyle(fontSize: 40),
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFFFD1D6),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onPressed: selectedCharacter == null
                      ? null
                      : () async {
                          final navigator = Navigator.of(context);
                          final box = Hive.box('choresBox');
                          await box.put('profileName', widget.profileName);
                          await box.put('profileCharacter', selectedCharacter);

                          if (!Hive.box('choresBox').containsKey('chores')) {
                            await box.put('chores', []);
                          }

                          if (!mounted) return;
                          navigator.pushReplacement(
                            MaterialPageRoute(
                              builder: (_) => const HomeScreen(),
                            ),
                          );
                        },
                  child: const Text(
                    'Continue',
                    style: TextStyle(fontSize: 18, color: Colors.white),
                  ),
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<String> members = ["Trisha", "Tanvi", "Nida"];
  String currentUser = "Trisha";
  String selectedCharacter = '🌱';
  int selectedTab = 0; // 0 = Home, 1 = Logs
  List<Chore> chores = [];
  List<String> activityLog = [];
  Map<String, Mood> memberMoods = {
    "Trisha": Mood.neutral,
    "Tanvi": Mood.neutral,
    "Nida": Mood.neutral,
  };

  @override
  void initState() {
    super.initState();
    loadProfile();
    loadChores();
  }

  void loadProfile() {
    final box = Hive.box('choresBox');
    final storedName = box.get('profileName') as String?;
    final storedCharacter = box.get('profileCharacter') as String?;

    setState(() {
      currentUser = storedName ?? currentUser;
      selectedCharacter = storedCharacter ?? selectedCharacter;

      if (!members.contains(currentUser)) {
        members.insert(0, currentUser);
      }
    });
  }

  Future<void> loadChores() async {
    final box = Hive.box('choresBox');
    final choreData = box.get('chores') as List<dynamic>?;
    final logData = box.get('activityLog') as List<dynamic>?;

    setState(() {
      if (choreData != null) {
        chores = choreData.map((item) {
          final map = Map<String, dynamic>.from(item as Map);
          return Chore(
            name: map['name'] as String,
            assignedTo: map['assignedTo'] as String,
            completedBy: map['completedBy'] as String?,
            isDone: map['isDone'] as bool,
          );
        }).toList();
      }
      if (logData != null) {
        activityLog = List<String>.from(logData);
      }
    });
  }

  Future<void> saveChores() async {
    final box = Hive.box('choresBox');
    // Convert Chore objects to JSON-serializable maps
    final choreData = chores
        .map(
          (chore) => {
            'name': chore.name,
            'assignedTo': chore.assignedTo,
            'completedBy': chore.completedBy,
            'isDone': chore.isDone,
          },
        )
        .toList();
    await box.put('chores', choreData);
    await box.put('activityLog', activityLog);
  }

  void addChore(String chore, String assignedTo) {
    setState(() {
      chores.add(Chore(name: chore, assignedTo: assignedTo));
    });
  }

  void showAddChoreDialog() {
    String newChore = "";
    String selectedMember = members[0];

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: const Text("Add Chore"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                onChanged: (value) {
                  newChore = value;
                },
                decoration: const InputDecoration(hintText: "Enter chore name"),
              ),
              const SizedBox(height: 10),
              DropdownButton<String>(
                value: selectedMember,
                isExpanded: true,
                items: members.map((member) {
                  return DropdownMenuItem(value: member, child: Text(member));
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    selectedMember = value!;
                  });
                },
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: () {
                if (newChore.isNotEmpty) {
                  this.setState(() {
                    chores.add(
                      Chore(name: newChore, assignedTo: selectedMember),
                    );
                  });
                  saveChores();
                }
                Navigator.pop(context);
              },
              child: const Text("Add"),
            ),
          ],
        ),
      ),
    );
  }

  void showEditChoreDialog(int index) {
    String updatedChore = chores[index].name;
    String selectedMember = chores[index].assignedTo;

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: const Text("Edit Chore"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: TextEditingController(text: updatedChore),
                onChanged: (value) {
                  updatedChore = value;
                },
              ),
              const SizedBox(height: 10),
              DropdownButton<String>(
                value: selectedMember,
                isExpanded: true,
                items: members.map((member) {
                  return DropdownMenuItem(value: member, child: Text(member));
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    selectedMember = value!;
                  });
                },
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: () {
                if (updatedChore.isNotEmpty) {
                  this.setState(() {
                    chores[index].name = updatedChore;
                    chores[index].assignedTo = selectedMember;
                  });
                  saveChores();
                }
                Navigator.pop(context);
              },
              child: const Text("Save"),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final pageTitle = selectedTab == 0 ? 'Your Home' : 'Logs';

    return Scaffold(
      backgroundColor: const Color(0xFFFFF7CC),
      drawer: Drawer(
        child: SafeArea(
          child: Column(
            children: [
              ListTile(
                leading: const Icon(Icons.home),
                title: const Text('Home'),
                selected: selectedTab == 0,
                onTap: () {
                  setState(() {
                    selectedTab = 0;
                  });
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: const Icon(Icons.list),
                title: const Text('Logs'),
                selected: selectedTab == 1,
                onTap: () {
                  setState(() {
                    selectedTab = 1;
                  });
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: const Icon(Icons.person),
                title: const Text('Profile'),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => CreateProfileScreen(
                        initialName: currentUser,
                        initialCharacter: selectedCharacter,
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),

      appBar: AppBar(
        backgroundColor: const Color(0xFFFFF7CC),
        elevation: 0,
        title: Text(
          pageTitle,
          style: const TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),

      body: Container(
        color: backgroundColor,
        child: selectedTab == 0
            ? Stack(
                children: [
                  Column(
                    children: [
                      const SizedBox(height: 16),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: const Color.fromRGBO(255, 255, 255, 0.95),
                            borderRadius: BorderRadius.circular(24),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black12,
                                blurRadius: 12,
                                offset: const Offset(0, 6),
                              ),
                            ],
                          ),
                          child: Row(
                            children: [
                              Text(
                                selectedCharacter,
                                style: const TextStyle(fontSize: 42),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Welcome back, $currentUser',
                                      style: const TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(height: 6),
                                    const Text(
                                      'Ready to make chores fair?',
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: Colors.black54,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Expanded(
                        child: chores.isEmpty
                            ? Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    SizedBox(
                                      height: 400,
                                      width: double.infinity,
                                      child: Image.asset(
                                        'assets/home screen picture.png',
                                        fit: BoxFit.contain,
                                        errorBuilder:
                                            (context, error, stackTrace) {
                                              return const Icon(
                                                Icons
                                                    .cleaning_services_outlined,
                                                size: 120,
                                                color: Colors.black26,
                                              );
                                            },
                                      ),
                                    ),
                                    const SizedBox(height: 6),
                                    const Text(
                                      "No chores yet",
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.black54,
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            : ListView.builder(
                                padding: const EdgeInsets.all(12),
                                itemCount: chores.length,
                                itemBuilder: (context, index) {
                                  final chore = chores[index];

                                  return Dismissible(
                                    key: Key('${chore.name}-$index'),
                                    direction: DismissDirection.endToStart,
                                    background: Container(
                                      margin: const EdgeInsets.only(bottom: 12),
                                      padding: const EdgeInsets.all(16),
                                      decoration: BoxDecoration(
                                        color: Colors.red.shade300,
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      alignment: Alignment.centerRight,
                                      child: const Icon(
                                        Icons.delete,
                                        color: Colors.white,
                                      ),
                                    ),
                                    onDismissed: (_) {
                                      setState(() {
                                        chores.removeAt(index);
                                      });
                                      saveChores();
                                    },
                                    child: Container(
                                      margin: const EdgeInsets.only(bottom: 12),
                                      padding: const EdgeInsets.all(16),
                                      decoration: BoxDecoration(
                                        color: const Color(0xFFFFE4E1),
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      child: Row(
                                        children: [
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  chore.name,
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    decoration: chore.isDone
                                                        ? TextDecoration
                                                              .lineThrough
                                                        : null,
                                                  ),
                                                ),
                                                Text(
                                                  "Assigned to: ${chore.assignedTo}",
                                                ),
                                                if (chore.completedBy != null)
                                                  Text(
                                                    "Done by ${chore.completedBy}",
                                                  ),
                                              ],
                                            ),
                                          ),
                                          Checkbox(
                                            value: chore.isDone,
                                            onChanged: (value) {
                                              setState(() {
                                                chore.isDone = value!;

                                                if (value) {
                                                  String assigned =
                                                      chore.assignedTo;
                                                  String doer = currentUser;

                                                  chore.completedBy = doer;
                                                  activityLog.add(
                                                    "$doer completed ${chore.name}",
                                                  );

                                                  memberMoods.updateAll(
                                                    (key, value) =>
                                                        Mood.neutral,
                                                  );

                                                  if (assigned == doer) {
                                                    memberMoods[doer] =
                                                        Mood.happy;
                                                  } else {
                                                    memberMoods[doer] =
                                                        Mood.happy;
                                                    memberMoods[assigned] =
                                                        Mood.guilty;

                                                    memberMoods.forEach((
                                                      key,
                                                      value,
                                                    ) {
                                                      if (key != doer &&
                                                          key != assigned) {
                                                        memberMoods[key] =
                                                            Mood.angry;
                                                      }
                                                    });
                                                  }
                                                } else {
                                                  chore.completedBy = null;
                                                }
                                              });
                                              saveChores();
                                            },
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              ),
                      ),
                    ],
                  ),

                  // 🧸 FLOATING CHARACTER (BOTTOM-LEFT)
                  Positioned(
                    bottom: 16,
                    left: 16,
                    child: Container(
                      width: 100,
                      height: 160,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      decoration: BoxDecoration(
                        color: const Color.fromRGBO(255, 255, 255, 0.95),
                        borderRadius: BorderRadius.circular(32),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black12,
                            blurRadius: 16,
                            offset: const Offset(0, 8),
                          ),
                        ],
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          _buildCharacterIcon(),
                          const SizedBox(height: 12),
                          const Text(
                            "Your\ncharacter",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              color: Colors.black87,
                              height: 1.1,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              )
            : _buildLogsPage(),
      ),

      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFFFFD6A5),
        onPressed: showAddChoreDialog,
        elevation: 6,
        child: const Icon(Icons.add, color: Colors.black),
      ),
    );
  }

  // Helper method to build character icon based on mood
  Widget _buildCharacterIcon() {
    return Text(selectedCharacter, style: const TextStyle(fontSize: 48));
  }

  Widget _buildLogsPage() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: 16),
          const Text(
            'Activity Logs',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 10),
          Expanded(
            child: activityLog.isEmpty
                ? Center(
                    child: Text(
                      'No activity yet',
                      style: TextStyle(color: Colors.black54, fontSize: 16),
                    ),
                  )
                : ListView.builder(
                    itemCount: activityLog.length,
                    itemBuilder: (context, index) {
                      return Container(
                        margin: const EdgeInsets.only(bottom: 10),
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: const Color.fromRGBO(255, 255, 255, 0.9),
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black12,
                              blurRadius: 8,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        child: Text(activityLog[index]),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
