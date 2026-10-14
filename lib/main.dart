import 'package:flutter/material.dart';

void main() {
  runApp(const NetBattleApp());
}

// ---------------------------------------------------------------------------
// DATABASE LOKAL (LOGIN BERBASIS NIS)
// ---------------------------------------------------------------------------
class UserDatabase {
  static final Map<String, Map<String, String>> _registeredUsers = {
    '12345': {'name': 'Satria Coder', 'password': '123'},
  };

  static bool isNisRegistered(String nis) {
    return _registeredUsers.containsKey(nis.trim());
  }

  static bool registerUser(String nis, String name, String password) {
    if (isNisRegistered(nis)) return false;
    _registeredUsers[nis.trim()] = {'name': name, 'password': password};
    return true;
  }

  static bool validateLogin(String nis, String password) {
    if (!isNisRegistered(nis)) return false;
    return _registeredUsers[nis.trim()]?['password'] == password;
  }

  static String getUserName(String nis) {
    return _registeredUsers[nis.trim()]?['name'] ?? 'Siswa Coder';
  }
}

// ---------------------------------------------------------------------------
// APP ROOT & THEME STATE
// ---------------------------------------------------------------------------
class NetBattleApp extends StatefulWidget {
  const NetBattleApp({super.key});

  static _NetBattleAppState of(BuildContext context) =>
      context.findAncestorStateOfType<_NetBattleAppState>()!;

  @override
  State<NetBattleApp> createState() => _NetBattleAppState();
}

class _NetBattleAppState extends State<NetBattleApp> {
  Color _primaryThemeColor = const Color(0xFF6C63FF);

  void updateThemeColor(Color newColor) {
    setState(() {
      _primaryThemeColor = newColor;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'NetBattle Code Arena',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.light,
        primaryColor: _primaryThemeColor,
        colorScheme: ColorScheme.fromSeed(
          seedColor: _primaryThemeColor,
          primary: _primaryThemeColor,
        ),
        scaffoldBackgroundColor: const Color(0xFFF4F6F9),
        useMaterial3: true,
      ),
      home: const SplashScreen(),
    );
  }
}

// ---------------------------------------------------------------------------
// 1. SPLASH SCREEN
// ---------------------------------------------------------------------------
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const AuthLoginScreen()),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.code_rounded, size: 90, color: Colors.white),
            ),
            const SizedBox(height: 24),
            const Text(
              'NETBATTLE CODE ARENA',
              style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold, letterSpacing: 2, color: Colors.white),
            ),
            const SizedBox(height: 8),
            const Text('Learn Programming, Master Logic!', style: TextStyle(fontSize: 14, color: Colors.white70)),
            const SizedBox(height: 48),
            const CircularProgressIndicator(color: Colors.amberAccent),
          ],
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// 2. AUTH LOGIN & REGISTRASI NIS
// ---------------------------------------------------------------------------
class AuthLoginScreen extends StatefulWidget {
  const AuthLoginScreen({super.key});

  @override
  State<AuthLoginScreen> createState() => _AuthLoginScreenState();
}

class _AuthLoginScreenState extends State<AuthLoginScreen> {
  bool _isSignUp = false;
  final TextEditingController _nisController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();

  void _handleAuth() {
    String nis = _nisController.text.trim();
    String password = _passwordController.text.trim();
    String name = _nameController.text.trim();

    if (nis.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('⚠️ NIS and Password are required!')),
      );
      return;
    }

    if (_isSignUp) {
      if (name.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('⚠️ Enter your Full Name!')),
        );
        return;
      }

      bool success = UserDatabase.registerUser(nis, name, password);
      if (!success) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('⚠️ NIS is already registered! Please login directly.')),
        );
        return;
      }

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => AvatarCustomizerScreen(username: name, isInitialSetup: true),
        ),
      );
    } else {
      if (!UserDatabase.isNisRegistered(nis)) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('❌ NIS not found! Please register an account first.'), backgroundColor: Colors.redAccent),
        );
        return;
      }

      if (!UserDatabase.validateLogin(nis, password)) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('❌ Incorrect Password!'), backgroundColor: Colors.redAccent),
        );
        return;
      }

      String studentName = UserDatabase.getUserName(nis);
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomeScreen(studentName: studentName)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeColor = Theme.of(context).primaryColor;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(28.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.terminal_rounded, size: 70, color: themeColor),
                const SizedBox(height: 12),
                Text(
                  _isSignUp ? 'Student Registration (NIS)' : 'Student Portal Login',
                  style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Color(0xFF2D3142)),
                ),
                const SizedBox(height: 32),
                if (_isSignUp) ...[
                  TextField(
                    controller: _nameController,
                    decoration: InputDecoration(labelText: 'Full Name', prefixIcon: const Icon(Icons.person_outline), border: OutlineInputBorder(borderRadius: BorderRadius.circular(14))),
                  ),
                  const SizedBox(height: 16),
                ],
                TextField(
                  controller: _nisController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(labelText: 'NIS (Student ID)', hintText: 'e.g. 12345', prefixIcon: const Icon(Icons.badge_outlined), border: OutlineInputBorder(borderRadius: BorderRadius.circular(14))),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: _passwordController,
                  obscureText: true,
                  decoration: InputDecoration(labelText: 'Password', prefixIcon: const Icon(Icons.lock_outline), border: OutlineInputBorder(borderRadius: BorderRadius.circular(14))),
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(backgroundColor: themeColor, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14))),
                    onPressed: _handleAuth,
                    child: Text(_isSignUp ? 'REGISTER & CREATE AVATAR 🚀' : 'LOGIN TO ARENA 🔓', style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.white)),
                  ),
                ),
                const SizedBox(height: 16),
                TextButton(
                  onPressed: () => setState(() => _isSignUp = !_isSignUp),
                  child: Text(_isSignUp ? 'Already registered? Login here' : 'New student? Register with NIS', style: TextStyle(color: themeColor, fontWeight: FontWeight.bold)),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// 3. MASKOT AVATAR CUSTOMIZER
// ---------------------------------------------------------------------------
class AvatarCustomizerScreen extends StatefulWidget {
  final String username;
  final bool isInitialSetup;
  final IconData? currentHat;
  final IconData? currentFace;
  final IconData? currentOutfit;

  const AvatarCustomizerScreen({super.key, required this.username, this.isInitialSetup = false, this.currentHat, this.currentFace, this.currentOutfit});

  @override
  State<AvatarCustomizerScreen> createState() => _AvatarCustomizerScreenState();
}

class _AvatarCustomizerScreenState extends State<AvatarCustomizerScreen> {
  int _hatIndex = 0;
  int _faceIndex = 0;
  int _outfitIndex = 0;
  int _colorIndex = 0;

  final List<IconData?> _hats = [null, Icons.sports_esports, Icons.school_rounded, Icons.military_tech];
  final List<IconData> _faces = [Icons.face_rounded, Icons.sentiment_very_satisfied_rounded, Icons.face_retouching_natural, Icons.smart_toy_rounded];
  final List<IconData> _outfits = [Icons.checkroom_rounded, Icons.shield_outlined, Icons.sports_kabaddi, Icons.dry_cleaning_rounded];
  final List<Map<String, dynamic>> _themeColors = [
    {'name': 'Cyber Indigo', 'color': const Color(0xFF6C63FF)},
    {'name': 'Blaze Orange', 'color': Colors.orange},
    {'name': 'Matrix Green', 'color': const Color(0xFF00B09B)},
    {'name': 'Royal Purple', 'color': const Color(0xFF8E2DE2)},
    {'name': 'Ruby Red', 'color': const Color(0xFFE53935)},
  ];

  @override
  Widget build(BuildContext context) {
    Color activeColor = _themeColors[_colorIndex]['color'];

    return Scaffold(
      appBar: AppBar(title: Text(widget.isInitialSetup ? 'Customize Your Coder Avatar' : 'Edit Avatar'), centerTitle: true),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            children: [
              Text('Coder: ${widget.username}', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 20),
              Container(
                width: 200,
                height: 240,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: activeColor.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(color: activeColor, width: 3),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(height: 28, child: _hats[_hatIndex] != null ? Icon(_hats[_hatIndex], size: 30, color: Colors.amber.shade800) : const SizedBox()),
                    Icon(_faces[_faceIndex], size: 65, color: activeColor),
                    const SizedBox(height: 2),
                    Icon(_outfits[_outfitIndex], size: 70, color: activeColor.withOpacity(0.9)),
                    const SizedBox(height: 4),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(width: 14, height: 20, decoration: BoxDecoration(color: activeColor, borderRadius: BorderRadius.circular(4))),
                        const SizedBox(width: 12),
                        Container(width: 14, height: 20, decoration: BoxDecoration(color: activeColor, borderRadius: BorderRadius.circular(4))),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              const Text('Select Hat/Accessory:', style: TextStyle(fontWeight: FontWeight.bold)),
              Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: List.generate(_hats.length, (i) => ChoiceChip(label: _hats[i] == null ? const Text('None', style: TextStyle(fontSize: 11)) : Icon(_hats[i], size: 20), selected: _hatIndex == i, onSelected: (v) => setState(() => _hatIndex = i)))),
              const SizedBox(height: 16),
              const Text('Select Theme Color:', style: TextStyle(fontWeight: FontWeight.bold)),
              Wrap(spacing: 8, children: List.generate(_themeColors.length, (i) {
                Color c = _themeColors[i]['color'];
                return ChoiceChip(
                  avatar: CircleAvatar(backgroundColor: c, radius: 8),
                  label: Text(_themeColors[i]['name'], style: const TextStyle(fontSize: 11)),
                  selected: _colorIndex == i,
                  onSelected: (v) {
                    setState(() => _colorIndex = i);
                    NetBattleApp.of(context).updateThemeColor(c);
                  },
                );
              })),
              const SizedBox(height: 28),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: activeColor),
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => HomeScreen(
                          studentName: widget.username,
                          hatIcon: _hats[_hatIndex],
                          faceIcon: _faces[_faceIndex],
                          outfitIcon: _outfits[_outfitIndex],
                          themeColor: activeColor,
                        ),
                      ),
                    );
                  },
                  child: const Text('SAVE & ENTER DASHBOARD 🚀', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// 4. HOME SCREEN (DASHBOARD DENGAN STAGE UNLOCK YANG STABIL)
// ---------------------------------------------------------------------------
class HomeScreen extends StatefulWidget {
  final String studentName;
  final IconData? hatIcon;
  final IconData faceIcon;
  final IconData outfitIcon;
  final Color themeColor;

  const HomeScreen({super.key, required this.studentName, this.hatIcon, this.faceIcon = Icons.face_rounded, this.outfitIcon = Icons.checkroom_rounded, this.themeColor = const Color(0xFF6C63FF)});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _userXP = 150;
  int _unlockedStageIndex = 0; // Menyimpan progres babak materi terbuka

  int get level => (_userXP / 300).floor() + 1;

  void _addXP(int points) {
    setState(() => _userXP += points);
  }

  void _unlockNextStage(int completedIndex) {
    if (completedIndex >= _unlockedStageIndex) {
      setState(() {
        _unlockedStageIndex = completedIndex + 1;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: const [
            Icon(Icons.code, color: Colors.amber, size: 28),
            SizedBox(width: 8),
            Text('NetBattle Code Arena', style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF2D3142))),
          ],
        ),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                gradient: LinearGradient(colors: [widget.themeColor, widget.themeColor.withOpacity(0.75)]),
                borderRadius: BorderRadius.circular(22),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(color: Colors.white24, borderRadius: BorderRadius.circular(16)),
                    child: Column(
                      children: [
                        if (widget.hatIcon != null) Icon(widget.hatIcon, size: 20, color: Colors.amberAccent),
                        Icon(widget.faceIcon, size: 26, color: Colors.white),
                        Icon(widget.outfitIcon, size: 26, color: Colors.white),
                      ],
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(widget.studentName, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
                        const SizedBox(height: 4),
                        Text('Level $level • $_userXP XP', style: const TextStyle(fontSize: 13, color: Colors.white70)),
                        const SizedBox(height: 8),
                        LinearProgressIndicator(value: (_userXP % 300) / 300, color: Colors.amberAccent, backgroundColor: Colors.white24),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.checkroom, color: Colors.white),
                    onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => AvatarCustomizerScreen(username: widget.studentName, currentHat: widget.hatIcon, currentFace: widget.faceIcon, currentOutfit: widget.outfitIcon))),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            const Text('Programming Mission Hub', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF2D3142))),
            const SizedBox(height: 14),

            // 1. QUEST PETUALANGAN MATERI PEMROGRAMAN DASAR
            _buildGameCard(
              context,
              title: 'Quest: Basic Programming & If-Else',
              subtitle: 'Learn syntax & unlock next stages automatically',
              icon: Icons.menu_book_rounded,
              color: Colors.green,
              xp: '+150 XP',
              onTap: () async {
                // Menunggu hasil kembali dari QuestScreen untuk memperbarui babak terbuka & XP
                final result = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => QuestScreen(unlockedStageIndex: _unlockedStageIndex),
                  ),
                );
                if (result != null && result is Map) {
                  _unlockNextStage(result['stageIndex']);
                  _addXP(result['xp']);
                }
              },
            ),
            const SizedBox(height: 12),

            // 2. BATTLE TARIK TAMBANG (CODE COMPLETION BATTLE)
            _buildGameCard(
              context,
              title: 'Code Tug-of-War (1v1)',
              subtitle: 'Fill in missing code snippets to pull the rope!',
              icon: Icons.sports_kabaddi_rounded,
              color: Colors.orange,
              xp: '+200 XP',
              onTap: () async {
                final xp = await Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const TugOfWarQuizScreen(roomCode: 'CODE99')),
                );
                if (xp != null && xp is int) _addXP(xp);
              },
            ),
            const SizedBox(height: 12),

            // 3. SOLO CODE QUIZ RUMPANG
            _buildGameCard(
              context,
              title: 'Solo Code Challenge',
              subtitle: 'English & Coding logic puzzle questions',
              icon: Icons.flash_on_rounded,
              color: widget.themeColor,
              xp: '+100 XP',
              onTap: () async {
                final xp = await Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const QuizBattleScreen()),
                );
                if (xp != null && xp is int) _addXP(xp);
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGameCard(BuildContext context, {required String title, required String subtitle, required IconData icon, required Color color, required String xp, required VoidCallback onTap}) {
    return Container(
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 8, offset: const Offset(0, 3))]),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Container(padding: const EdgeInsets.all(14), decoration: BoxDecoration(color: color.withOpacity(0.15), borderRadius: BorderRadius.circular(14)), child: Icon(icon, color: color, size: 30)),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(child: Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF2D3142)))),
                          Container(padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4), decoration: BoxDecoration(color: Colors.amber.shade100, borderRadius: BorderRadius.circular(8)), child: Text(xp, style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.amber.shade900))),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Text(subtitle, style: TextStyle(fontSize: 12, color: Colors.grey.shade600)),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// 5. QUEST SCREEN (MATERI PEMROGRAMAN DASAR & AUTO UNLOCK)
// ---------------------------------------------------------------------------
class QuestScreen extends StatefulWidget {
  final int unlockedStageIndex;
  const QuestScreen({super.key, required this.unlockedStageIndex});

  @override
  State<QuestScreen> createState() => _QuestScreenState();
}

class _QuestScreenState extends State<QuestScreen> {
  late int currentUnlocked = widget.unlockedStageIndex;

  final List<Map<String, dynamic>> stages = [
    {
      'title': 'Stage 1: Variable & Print Statement',
      'desc': 'Learn how to store values and print outputs in English syntax.',
      'content': 'In programming, a variable stores data. Example in Dart/Python:\n\nString title = "Hello World";\nprint(title);\n\nQuestion: What keyword is used to show output on screen?',
      'xp': 150
    },
    {
      'title': 'Stage 2: Conditional If-Else Statement',
      'desc': 'Making decisions in code using logical conditions.',
      'content': 'If-Else allows your program to make choices based on conditions.\n\nif (score > 75) {\n  print("Passed");\n} else {\n  print("Failed");\n}\n\nEnglish Logic: If the score is greater than 75, print Passed!',
      'xp': 200
    },
    {
      'title': 'Stage 3: Basic Loops (For & While)',
      'desc': 'Repeating tasks automatically without rewriting code.',
      'content': 'Loops execute code multiple times. For example, counting from 1 to 5:\n\nfor (int i = 1; i <= 5; i++) {\n  print(i);\n}\n\nEnglish Logic: Repeat printing numbers until condition is met.',
      'xp': 250
    },
    {
      'title': 'Stage 4: Functions & Methods',
      'desc': 'Reusing blocks of code efficiently.',
      'content': 'Functions encapsulate logic so you can call them anytime:\n\nint addNumbers(int a, int b) {\n  return a + b;\n}\n\nEnglish Logic: Pass arguments a and b, return their sum.',
      'xp': 300
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Programming Quest Map', style: TextStyle(color: Color(0xFF2D3142), fontWeight: FontWeight.bold)), backgroundColor: Colors.white, elevation: 0),
      body: ListView.builder(
        padding: const EdgeInsets.all(20.0),
        itemCount: stages.length,
        itemBuilder: (context, index) {
          final stage = stages[index];
          bool isUnlocked = index <= currentUnlocked;
          bool isCompleted = index < currentUnlocked;

          Color badgeColor = isCompleted ? Colors.green : (isUnlocked ? Colors.orange : Colors.grey);
          IconData statusIcon = isCompleted ? Icons.check_circle_rounded : (isUnlocked ? Icons.play_circle_fill_rounded : Icons.lock_outline_rounded);

          return Container(
            margin: const EdgeInsets.only(bottom: 16),
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(18), border: Border.all(color: isUnlocked ? Colors.orange : Colors.grey.shade200, width: isUnlocked ? 2 : 1)),
            child: ListTile(
              contentPadding: const EdgeInsets.all(16),
              leading: CircleAvatar(radius: 26, backgroundColor: badgeColor.withOpacity(0.15), child: Icon(statusIcon, color: badgeColor, size: 28)),
              title: Text(stage['title'], style: TextStyle(fontWeight: FontWeight.bold, color: isUnlocked ? const Color(0xFF2D3142) : Colors.grey)),
              subtitle: Text(stage['desc'], style: TextStyle(fontSize: 12, color: isUnlocked ? Colors.grey.shade600 : Colors.grey.shade400)),
              trailing: isUnlocked ? const Icon(Icons.arrow_forward_ios_rounded, size: 18) : const Icon(Icons.lock),
              onTap: () {
                if (!isUnlocked) {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('🔒 Complete previous stage to unlock!')));
                } else {
                  _showMaterialDialog(context, index, stage['title'], stage['content'], stage['xp']);
                }
              },
            ),
          );
        },
      ),
    );
  }

  void _showMaterialDialog(BuildContext context, int index, String title, String content, int xp) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        content: SingleChildScrollView(child: Text(content, style: const TextStyle(fontSize: 13, height: 1.4))),
        actions: [
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Theme.of(context).primaryColor),
            onPressed: () {
              setState(() {
                if (index >= currentUnlocked) currentUnlocked = index + 1;
              });
              Navigator.pop(context);
              // Kirim balik data stageIndex dan XP ke HomeScreen agar langsung terbuka babak berikutnya
              Navigator.pop(context, {'stageIndex': index, 'xp': xp});
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('🎉 Stage Completed! +$xp XP & Next Stage Unlocked!')));
            },
            child: const Text('COMPLETE & UNLOCK NEXT 🚀', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// 6. QUIZ BATTLE SCREEN (SOLO CODE RUMPANG / FILL-IN-THE-BLANK)
// ---------------------------------------------------------------------------
class QuizBattleScreen extends StatefulWidget {
  const QuizBattleScreen({super.key});

  @override
  State<QuizBattleScreen> createState() => _QuizBattleScreenState();
}

class _QuizBattleScreenState extends State<QuizBattleScreen> {
  int _score = 0;
  int _currentIndex = 0;
  int? _selectedOption;

  // SOAL BAHASA INGGRIS & PEMROGRAMAN RUMPANG
  final List<Map<String, dynamic>> _questions = [
    {
      'question': 'Complete the code to make an IF condition in Dart/Java:\n\n____ (score >= 60) {\n  print("Pass");\n}',
      'options': ['if', 'when', 'check', 'loop'],
      'answer': 0,
    },
    {
      'question': 'Which English keyword is used to handle the alternative condition if an IF statement fails?',
      'options': ['then', 'else', 'other', 'default'],
      'answer': 1,
    },
    {
      'question': 'Complete the code to declare an integer variable named age with value 17:\n\n____ age = 17;',
      'options': ['String', 'bool', 'int', 'float'],
      'answer': 2,
    },
  ];

  void _answer(int optionIndex) {
    setState(() {
      _selectedOption = optionIndex;
      if (optionIndex == _questions[_currentIndex]['answer']) {
        _score += 100;
      }
    });

    Future.delayed(const Duration(seconds: 1), () {
      if (_currentIndex < _questions.length - 1) {
        setState(() {
          _currentIndex++;
          _selectedOption = null;
        });
      } else {
        Navigator.pop(context, _score);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final q = _questions[_currentIndex];

    return Scaffold(
      appBar: AppBar(title: Text('Code Challenge ${_currentIndex + 1}/${_questions.length}'), backgroundColor: Colors.white),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), border: Border.all(color: Colors.grey.shade200)),
              child: Text(q['question'], style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, fontFamily: 'monospace')),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: (q['options'] as List).length,
                itemBuilder: (context, index) {
                  bool isSelected = _selectedOption == index;
                  bool isCorrect = index == q['answer'];
                  return Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    decoration: BoxDecoration(
                      color: isSelected ? (isCorrect ? Colors.green.shade50 : Colors.red.shade50) : Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: isSelected ? (isCorrect ? Colors.green : Colors.red) : Colors.grey.shade200, width: 1.5),
                    ),
                    child: ListTile(
                      title: Text(q['options'][index], style: const TextStyle(fontWeight: FontWeight.bold)),
                      onTap: _selectedOption == null ? () => _answer(index) : null,
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// 7. CUSTOM ROOM SCREEN & CODE TUG OF WAR
// ---------------------------------------------------------------------------
class CustomRoomScreen extends StatelessWidget {
  const CustomRoomScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Code Tug-of-War (1v1)')),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Theme.of(context).primaryColor),
              onPressed: () async {
                final xp = await Navigator.push(context, MaterialPageRoute(builder: (context) => const TugOfWarQuizScreen(roomCode: 'CODE99')));
                if (xp != null && xp is int && context.mounted) Navigator.pop(context, xp);
              },
              child: const Text('CREATE / START CODE BATTLE ROOM 🎮', style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }
}

class TugOfWarQuizScreen extends StatefulWidget {
  final String roomCode;
  const TugOfWarQuizScreen({super.key, required this.roomCode});

  @override
  State<TugOfWarQuizScreen> createState() => _TugOfWarQuizScreenState();
}

class _TugOfWarQuizScreenState extends State<TugOfWarQuizScreen> {
  double _ropePosition = 0.5;
  int _currentIndex = 0;
  int? _selectedOption;

  final List<Map<String, dynamic>> _questions = [
    {'question': 'What keyword starts a loop that runs a specific number of times?', 'options': ['for', 'if', 'return', 'class'], 'answer': 0},
    {'question': 'Complete the boolean expression for "X is NOT equal to Y":\n\nx ____ y', 'options': ['==', '!=', '>=', '<='], 'answer': 1},
  ];

  void _answer(int optionIndex) {
    setState(() {
      _selectedOption = optionIndex;
      if (optionIndex == _questions[_currentIndex]['answer']) {
        _ropePosition = (_ropePosition - 0.3).clamp(0.0, 1.0);
      } else {
        _ropePosition = (_ropePosition + 0.3).clamp(0.0, 1.0);
      }
    });

    Future.delayed(const Duration(milliseconds: 1000), () {
      if (_currentIndex < _questions.length - 1 && _ropePosition > 0.0 && _ropePosition < 1.0) {
        setState(() {
          _currentIndex++;
          _selectedOption = null;
        });
      } else {
        bool isWinner = _ropePosition < 0.5;
        Navigator.pop(context, isWinner ? 200 : 50);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final q = _questions[_currentIndex];

    return Scaffold(
      appBar: AppBar(title: Text('Battle Room: ${widget.roomCode}')),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            color: Colors.amber.shade50,
            child: Stack(
              alignment: Alignment.center,
              children: [
                Container(height: 10, width: double.infinity, decoration: BoxDecoration(color: Colors.brown.shade300, borderRadius: BorderRadius.circular(5))),
                AnimatedAlign(
                  duration: const Duration(milliseconds: 500),
                  alignment: Alignment((_ropePosition * 2) - 1, 0),
                  child: const CircleAvatar(radius: 12, backgroundColor: Colors.red),
                ),
              ],
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  Text(q['question'], style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  const SizedBox(height: 16),
                  Expanded(
                    child: ListView.builder(
                      itemCount: (q['options'] as List).length,
                      itemBuilder: (context, index) {
                        return ListTile(
                          title: Text(q['options'][index]),
                          onTap: _selectedOption == null ? () => _answer(index) : null,
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}