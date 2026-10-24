import 'dart:async';
import 'package:flutter/material.dart';

void main() {
  runApp(const NetBattleApp());
}

// ---------------------------------------------------------------------------
// DATABASE LOKAL BERBASIS EMAIL
// ---------------------------------------------------------------------------
class UserDatabase {
  static final Map<String, Map<String, String>> _accounts = {
    'student@netbattle.com': {'name': 'Satria Coder', 'password': '123'},
  };

  static bool isValidEmail(String email) {
    final emailRegExp = RegExp(r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$");
    return emailRegExp.hasMatch(email.trim());
  }

  static bool isEmailRegistered(String email) {
    return _accounts.containsKey(email.trim().toLowerCase());
  }

  static bool registerUser(String email, String name, String password) {
    String cleanEmail = email.trim().toLowerCase();
    if (isEmailRegistered(cleanEmail)) return false;

    _accounts[cleanEmail] = {
      'name': name.trim(),
      'password': password.trim(),
    };
    return true;
  }

  static bool validateLogin(String email, String password) {
    String cleanEmail = email.trim().toLowerCase();
    String cleanPass = password.trim();

    if (!isEmailRegistered(cleanEmail)) return false;
    return _accounts[cleanEmail]?['password'] == cleanPass;
  }

  static String getUserName(String email) {
    return _accounts[email.trim().toLowerCase()]?['name'] ?? 'Siswa Coder';
  }
}

// ---------------------------------------------------------------------------
// APP ROOT & THEME STATE
// ---------------------------------------------------------------------------
class NetBattleApp extends StatefulWidget {
  const NetBattleApp({super.key});

  static NetBattleAppState of(BuildContext context) =>
      context.findAncestorStateOfType<NetBattleAppState>()!;

  @override
  State<NetBattleApp> createState() => NetBattleAppState();
}

class NetBattleAppState extends State<NetBattleApp> {
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
                color: Colors.white.withValues(alpha: 0.2),
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
            const Text('Belajar Pemrograman Dasar & Logika Koding!', style: TextStyle(fontSize: 14, color: Colors.white70)),
            const SizedBox(height: 48),
            const CircularProgressIndicator(color: Colors.amberAccent),
          ],
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// 2. AUTH LOGIN & REGISTRASI EMAIL
// ---------------------------------------------------------------------------
class AuthLoginScreen extends StatefulWidget {
  const AuthLoginScreen({super.key});

  @override
  State<AuthLoginScreen> createState() => _AuthLoginScreenState();
}

class _AuthLoginScreenState extends State<AuthLoginScreen> {
  bool _isSignUp = false;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();

  void _handleAuth() {
    String email = _emailController.text.trim();
    String password = _passwordController.text.trim();
    String name = _nameController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Email dan Password wajib diisi!')),
      );
      return;
    }

    if (!UserDatabase.isValidEmail(email)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Format email tidak valid! Masukkan email yang benar (contoh: siswa@domain.com).'),
          backgroundColor: Colors.redAccent,
        ),
      );
      return;
    }

    if (_isSignUp) {
      if (name.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Masukkan Nama Lengkapmu!')),
        );
        return;
      }

      bool success = UserDatabase.registerUser(email, name, password);
      if (!success) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Email sudah terdaftar! Silakan langsung login.'), backgroundColor: Colors.orange),
        );
        return;
      }

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => AvatarCustomizerScreen(username: name, email: email, isInitialSetup: true),
        ),
      );
    } else {
      if (!UserDatabase.isEmailRegistered(email)) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Email belum terdaftar! Silakan daftar akun dulu.'), backgroundColor: Colors.redAccent),
        );
        return;
      }

      if (!UserDatabase.validateLogin(email, password)) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Password salah!'), backgroundColor: Colors.redAccent),
        );
        return;
      }

      String studentName = UserDatabase.getUserName(email);
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomeScreen(studentName: studentName, studentEmail: email)),
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
                Icon(Icons.alternate_email_rounded, size: 70, color: themeColor),
                const SizedBox(height: 12),
                Text(
                  _isSignUp ? 'Daftar Akun Siswa (Email)' : 'Login Portal Siswa',
                  style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Color(0xFF2D3142)),
                ),
                const SizedBox(height: 6),
                const Text(
                  'Gunakan email aktif yang valid untuk masuk',
                  style: TextStyle(fontSize: 12, color: Colors.black54),
                ),
                const SizedBox(height: 28),
                if (_isSignUp) ...[
                  TextField(
                    controller: _nameController,
                    decoration: InputDecoration(labelText: 'Nama Lengkap', prefixIcon: const Icon(Icons.person_outline), border: OutlineInputBorder(borderRadius: BorderRadius.circular(14))),
                  ),
                  const SizedBox(height: 16),
                ],
                TextField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(labelText: 'Alamat Email', hintText: 'contoh: student@netbattle.com', prefixIcon: const Icon(Icons.email_outlined), border: OutlineInputBorder(borderRadius: BorderRadius.circular(14))),
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
                    child: Text(_isSignUp ? 'DAFTAR & BUAT MASKOT' : 'MASUK KE ARENA', style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.white)),
                  ),
                ),
                const SizedBox(height: 16),
                TextButton(
                  onPressed: () => setState(() => _isSignUp = !_isSignUp),
                  child: Text(_isSignUp ? 'Sudah punya akun? Login di sini' : 'Belum punya akun? Daftar dengan Email', style: TextStyle(color: themeColor, fontWeight: FontWeight.bold)),
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
  final String email;
  final bool isInitialSetup;
  final IconData? currentHat;
  final IconData? currentFace;
  final IconData? currentOutfit;

  const AvatarCustomizerScreen({super.key, required this.username, required this.email, this.isInitialSetup = false, this.currentHat, this.currentFace, this.currentOutfit});

  @override
  State<AvatarCustomizerScreen> createState() => _AvatarCustomizerScreenState();
}

class _AvatarCustomizerScreenState extends State<AvatarCustomizerScreen> {
  int _hatIndex = 0;
  final int _faceIndex = 0;
  final int _outfitIndex = 0;
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
      appBar: AppBar(title: Text(widget.isInitialSetup ? 'Rakit Maskot Coder' : 'Edit Avatar'), centerTitle: true),
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
                  color: activeColor.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(color: activeColor, width: 3),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(height: 28, child: _hats[_hatIndex] != null ? Icon(_hats[_hatIndex], size: 30, color: Colors.amber.shade800) : const SizedBox()),
                    Icon(_faces[_faceIndex], size: 65, color: activeColor),
                    const SizedBox(height: 2),
                    Icon(_outfits[_outfitIndex], size: 70, color: activeColor.withValues(alpha: 0.9)),
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
              const Text('Pilih Aksesori Topi/Kepala:', style: TextStyle(fontWeight: FontWeight.bold)),
              Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: List.generate(_hats.length, (i) => ChoiceChip(label: _hats[i] == null ? const Text('Tanpa', style: TextStyle(fontSize: 11)) : Icon(_hats[i], size: 20), selected: _hatIndex == i, onSelected: (v) => setState(() => _hatIndex = i)))),
              const SizedBox(height: 16),
              const Text('Pilih Warna Tema:', style: TextStyle(fontWeight: FontWeight.bold)),
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
                          studentEmail: widget.email,
                          hatIcon: _hats[_hatIndex],
                          faceIcon: _faces[_faceIndex],
                          outfitIcon: _outfits[_outfitIndex],
                          themeColor: activeColor,
                        ),
                      ),
                    );
                  },
                  child: const Text('SIMPAN & MASUK DASHBOARD', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
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
// 4. HOME SCREEN (DILENGKAPI TOMBOL PROFIL)
// ---------------------------------------------------------------------------
class HomeScreen extends StatefulWidget {
  final String studentName;
  final String studentEmail;
  final IconData? hatIcon;
  final IconData faceIcon;
  final IconData outfitIcon;
  final Color themeColor;

  const HomeScreen({super.key, required this.studentName, required this.studentEmail, this.hatIcon, this.faceIcon = Icons.face_rounded, this.outfitIcon = Icons.checkroom_rounded, this.themeColor = const Color(0xFF6C63FF)});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _userXP = 0;
  int _unlockedStageIndex = 0;
  late String _currentName;

  int get level => (_userXP / 300).floor() + 1;

  @override
  void initState() {
    super.initState();
    _currentName = widget.studentName;
  }

  void _addXP(int points) {
    setState(() => _userXP += points);
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
        actions: [
          IconButton(
            icon: Icon(Icons.account_circle, color: widget.themeColor, size: 32),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ProfileScreen(
                    currentEmail: widget.studentEmail,
                    currentName: _currentName,
                    userXP: _userXP,
                    level: level,
                    themeColor: widget.themeColor,
                    onProfileUpdated: (newName) {
                      setState(() {
                        _currentName = newName;
                      });
                    },
                  ),
                ),
              );
            },
          ),
        ],
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
                gradient: LinearGradient(colors: [widget.themeColor, widget.themeColor.withValues(alpha: 0.75)]),
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
                        Text(_currentName, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
                        const SizedBox(height: 4),
                        Text('Level $level • $_userXP XP', style: const TextStyle(fontSize: 13, color: Colors.white70)),
                        const SizedBox(height: 8),
                        LinearProgressIndicator(value: (_userXP % 300) / 300, color: Colors.amberAccent, backgroundColor: Colors.white24),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.checkroom, color: Colors.white),
                    onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => AvatarCustomizerScreen(username: _currentName, email: widget.studentEmail, currentHat: widget.hatIcon, currentFace: widget.faceIcon, currentOutfit: widget.outfitIcon))),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            const Text('Menu Misi Belajar Pemrograman', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF2D3142))),
            const SizedBox(height: 14),

            _buildGameCard(
              context,
              title: 'Quest: Modul Materi (8 Babak)',
              subtitle: 'Pelajari konsep mendalam & jawab checkpoint untuk membuka babak',
              icon: Icons.menu_book_rounded,
              color: Colors.green,
              xp: '+150 XP/Babak',
              onTap: () async {
                await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => QuestScreen(
                      unlockedStageIndex: _unlockedStageIndex,
                      onStageCompleted: (newUnlockedIndex, xpGained) {
                        setState(() {
                          if (newUnlockedIndex > _unlockedStageIndex) {
                            _unlockedStageIndex = newUnlockedIndex;
                          }
                        });
                        _addXP(xpGained);
                      },
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 12),

            _buildGameCard(
              context,
              title: 'Battle Tarik Tambang (1v1)',
              subtitle: 'Lengkapi sintaks koding rumpang untuk menarik tali!',
              icon: Icons.sports_kabaddi_rounded,
              color: Colors.orange,
              xp: '+200 XP',
              onTap: () async {
                final xp = await Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => CustomRoomScreen(currentUserName: _currentName)),
                );
                if (xp != null && xp is int) _addXP(xp);
              },
            ),
            const SizedBox(height: 12),

            _buildGameCard(
              context,
              title: 'Battle Kuis Kilat (10 Soal Solo)',
              subtitle: 'Tantangan kuis cepat 10 soal logika & koding',
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
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 8, offset: const Offset(0, 3))]),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Container(padding: const EdgeInsets.all(14), decoration: BoxDecoration(color: color.withValues(alpha: 0.15), borderRadius: BorderRadius.circular(14)), child: Icon(icon, color: color, size: 30)),
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
// 5. QUEST SCREEN (DILENGKAPI CHECKPOINT & KODING RUMPANG)
// ---------------------------------------------------------------------------
class QuestScreen extends StatefulWidget {
  final int unlockedStageIndex;
  final Function(int newUnlockedIndex, int xpGained) onStageCompleted;

  const QuestScreen({
    super.key,
    required this.unlockedStageIndex,
    required this.onStageCompleted,
  });

  @override
  State<QuestScreen> createState() => _QuestScreenState();
}

class _QuestScreenState extends State<QuestScreen> {
  late int currentUnlocked = widget.unlockedStageIndex;

  final List<Map<String, dynamic>> stages = [
    {
      'title': 'Babak 1: Konsep Algoritma, Memori & Variabel',
      'desc': 'Modul Lengkap: Memahami wadah memori, aturan penamaan variabel, dan Output.',
      'sections': [
        {
          'header': '1. Apa itu Algoritma dan Variabel?',
          'body': 'Dalam dunia komputer, Algoritma adalah langkah-langkah logis berurutan untuk menyelesaikan masalah.\n\nKetika program berjalan, data (seperti nama, skor, atau harga) perlu disimpan di dalam RAM komputer. Wadah penyimpanan sementara di dalam memori inilah yang disebut Variabel.'
        },
        {
          'header': '2. Aturan Penamaan Variabel (Naming Convention)',
          'body': '- Menggunakan camelCase (contoh: namaLengkap, skorPemain).\n- Tidak boleh diawali angka (contoh salah: 1nama).\n- Tidak boleh menggunakan spasi (contoh salah: nama saya).\n- Bersifat Case-Sensitive (nama dan Nama dianggap dua variabel yang berbeda).'
        },
        {
          'header': '3. Contoh Kode Koding Nyata (Dart/Java/C++)',
          'isCode': true,
          'body': 'String namaSiswa = "Satria Coder";\nint nilaiUjian = 95;\n\n// Menampilkan output ke konsol\nprint("Nama: " + namaSiswa);\nprint("Nilai: " + nilaiUjian.toString());'
        }
      ],
      'checkpoint': {
        'question': 'Pertanyaan Checkpoint:\nAturan penamaan variabel manakah yang BENAR berdasarkan materi di atas?',
        'options': ['1namaSiswa', 'nama lengkap', 'skorPemain', 'nama-siswa'],
        'correctIndex': 2,
        'explanation': 'Aturan penamaan variabel yang benar harus menggunakan format camelCase (seperti skorPemain), tidak boleh menggunakan spasi, dan tidak boleh diawali dengan angka.'
      },
      'xp': 150
    },
    {
      'title': 'Babak 2: Tipe Data Dasar & Operator Aritmatika',
      'desc': 'Modul Lengkap: int, double, String, bool, serta perhitungan matematika.',
      'sections': [
        {
          'header': '1. Pengenalan Tipe Data Statis',
          'body': 'Tipe data menentukan jenis nilai apa yang boleh disimpan dalam sebuah variabel:\n- int (Integer): Bilangan bulat positif/negatif.\n- double: Angka desimal bertitik (contoh: 3.14).\n- String: Deretan karakter teks di dalam tanda petik.\n- bool: Nilai logika true atau false.'
        },
        {
          'header': '2. Studi Kasus Perhitungan Toko',
          'isCode': true,
          'body': 'int hargaBarang = 15000;\nint jumlahBeli = 3;\nint totalHarga = hargaBarang * jumlahBeli;\nprint("Total: " + totalHarga.toString());'
        }
      ],
      'checkpoint': {
        'question': 'Pertanyaan Checkpoint:\nTipe data apakah yang paling tepat untuk menyimpan angka desimal 3.14?',
        'options': ['int', 'double', 'String', 'bool'],
        'correctIndex': 1,
        'explanation': 'Tipe data double digunakan khusus untuk menampung nilai angka pecahan atau desimal yang memiliki titik koma/desimal.'
      },
      'xp': 150
    },
    {
      'title': 'Babak 3: Percabangan Logika (If - Else)',
      'desc': 'Modul Lengkap: Pengambilan keputusan otomatis berdasarkan ekspresi Boolean.',
      'sections': [
        {
          'header': '1. Mengapa Perlu Percabangan?',
          'body': 'Program cerdas mengambil keputusan berbeda menggunakan kondisi IF. Operator perbandingan meliputi ==, !=, >, <, >=, dan <=.'
        },
        {
          'header': '2. Kode Sistem Kelulusan Ujian',
          'isCode': true,
          'body': 'int nilaiSiswa = 78;\nif (nilaiSiswa >= 75) {\n  print("LULUS");\n} else {\n  print("REMIDI");\n}'
        }
      ],
      'checkpoint': {
        'question': 'Pertanyaan Checkpoint:\nSimbol apa yang digunakan untuk membandingkan dua nilai "SAMA DENGAN"?',
        'options': ['=', '==', '!=', '=>'],
        'correctIndex': 1,
        'explanation': 'Simbol tanda sama dengan ganda (==) adalah operator perbandingan kesetaraan, sedangkan tanda (=) tunggal digunakan untuk proses assignment (pengisian nilai).'
      },
      'xp': 200
    },
    {
      'title': 'Babak 4: Percabangan Majemuk (Else If & Logical Operators)',
      'desc': 'Modul Lengkap: Logika DAN (&&), ATAU (||), serta pengkondisian bersarang.',
      'sections': [
        {
          'header': '1. Operator Logika Kombinasi',
          'body': '- AND (&&): Kedua syarat HARUS bernilai TRUE.\n- OR (||): Cukup SALAH SATU syarat bernilai TRUE.'
        }
      ],
      'checkpoint': {
        'question': 'Pertanyaan Checkpoint:\nOperator logika manakah yang mengharuskan KEDUA syarat bernilai TRUE?',
        'options': ['||', '&&', '!', '=='],
        'correctIndex': 1,
        'explanation': 'Operator AND (&&) menghasilkan nilai true hanya jika seluruh kondisi yang dihubungkan bernilai true secara bersamaan.'
      },
      'xp': 200
    },
    {
      'title': 'Babak 5: Perulangan Terhitung (For Loop)',
      'desc': 'Modul Lengkap: Otomatisasi tugas berulang dengan counter increment.',
      'sections': [
        {
          'header': '1. Struktur For Loop',
          'body': 'for (inisialisasi; kondisi_batas; iterasi) { ... }\nContoh: int i = 1; i <= 5; i++'
        }
      ],
      'checkpoint': {
        'question': 'Pertanyaan Checkpoint:\nBagian manakah pada For Loop yang berfungsi menambahkan nilai hitungan setiap putaran?',
        'options': ['Inisialisasi', 'Kondisi batas', 'Iterasi (i++)', 'Blok cetak'],
        'correctIndex': 2,
        'explanation': 'Bagian iterasi (seperti i++) dieksekusi di akhir setiap putaran loop untuk menambah atau mengubah nilai penghitung.'
      },
      'xp': 250
    },
    {
      'title': 'Babak 6: Perulangan Kondisional (While Loop)',
      'desc': 'Modul Lengkap: Loop berbasis kondisi dinamis dan Infinite Loop Hazard.',
      'sections': [
        {
          'header': '1. Bahaya Infinite Loop',
          'body': 'Jika kondisi dalam While selalu bernilai true tanpa ada pembaruan variabel, aplikasi akan mengalami crash/hang.'
        }
      ],
      'checkpoint': {
        'question': 'Pertanyaan Checkpoint:\nApa akibat jika pengkondisian While bernilai true terus-menerus tanpa henti?',
        'options': ['Program berjalan sangat cepat', 'Infinite Loop (Crash)', 'Data tersimpan otomatis', 'Tidak terjadi apa-apa'],
        'correctIndex': 1,
        'explanation': 'Kondisi true tanpa henti memicu Infinite Loop yang menghabiskan sumber daya memori dan membuat aplikasi mengalami crash.'
      },
      'xp': 250
    },
    {
      'title': 'Babak 7: Fungsi / Subprogram (Method)',
      'desc': 'Modul Lengkap: Pemrograman modular, parameter, dan nilai kembalian.',
      'sections': [
        {
          'header': '1. Void vs Return Function',
          'body': '- Void: Fungsi tanpa nilai kembalian.\n- Return: Fungsi yang mengolah data lalu mengembalikan nilai hasil.'
        }
      ],
      'checkpoint': {
        'question': 'Pertanyaan Checkpoint:\nKata kunci apa yang digunakan untuk mengembalikan nilai dari sebuah fungsi?',
        'options': ['print', 'void', 'return', 'main'],
        'correctIndex': 2,
        'explanation': 'Kata kunci return berfungsi untuk mengalirkan hasil keluaran data kembali ke bagian pemanggil fungsi tersebut.'
      },
      'xp': 300
    },
    {
      'title': 'Babak 8: Struktur Data Array / List',
      'desc': 'Modul Lengkap: Koleksi data sejenis dan elemen Zero-Indexed.',
      'sections': [
        {
          'header': '1. Konsep Zero-Indexed',
          'body': 'Komputer selalu menghitung urutan elemen dalam List dimulai dari angka 0, bukan 1.'
        }
      ],
      'checkpoint': {
        'question': 'Pertanyaan Checkpoint:\nBerapakah indeks elemen pertama dari sebuah List di dalam pemrograman?',
        'options': ['Indeks [1]', 'Indeks [0]', 'Indeks [-1]', 'Indeks [first]'],
        'correctIndex': 1,
        'explanation': 'Sistem komputer menggunakan konsep zero-indexed, di mana elemen pertama dalam memori array/list selalu dimulai dari indeks angka 0.'
      },
      'xp': 300
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Peta Petualangan Materi', style: TextStyle(color: Color(0xFF2D3142), fontWeight: FontWeight.bold)), backgroundColor: Colors.white, elevation: 0),
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
              leading: CircleAvatar(radius: 26, backgroundColor: badgeColor.withValues(alpha: 0.15), child: Icon(statusIcon, color: badgeColor, size: 28)),
              title: Text(stage['title'], style: TextStyle(fontWeight: FontWeight.bold, color: isUnlocked ? const Color(0xFF2D3142) : Colors.grey)),
              subtitle: Text(stage['desc'], style: TextStyle(fontSize: 12, color: isUnlocked ? Colors.grey.shade600 : Colors.grey.shade400)),
              trailing: isUnlocked ? const Icon(Icons.arrow_forward_ios_rounded, size: 18) : const Icon(Icons.lock),
              onTap: () {
                if (!isUnlocked) {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Selesaikan babak sebelumnya terlebih dahulu!')));
                } else {
                  _showSingleBoxMaterialDialog(
                    context,
                    index,
                    stage['title'],
                    stage['sections'] as List<Map<String, dynamic>>,
                    stage['checkpoint'] as Map<String, dynamic>,
                    stage['xp'],
                  );
                }
              },
            ),
          );
        },
      ),
    );
  }

  void _showSingleBoxMaterialDialog(
    BuildContext context,
    int index,
    String title,
    List<Map<String, dynamic>> sections,
    Map<String, dynamic> checkpoint,
    int xp,
  ) {
    int? selectedAnswer;
    bool isAnswerChecked = false;
    bool isAnswerCorrect = false;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: Row(
            children: [
              Icon(Icons.menu_book_rounded, color: Theme.of(context).primaryColor),
              const SizedBox(width: 10),
              Expanded(child: Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16))),
            ],
          ),
          content: SizedBox(
            width: double.maxFinite,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.all(18),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade50,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: Colors.grey.shade300),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: List.generate(sections.length, (i) {
                        final sec = sections[i];
                        final bool isCode = sec['isCode'] == true;

                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              sec['header']!,
                              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Color(0xFF2D3142)),
                            ),
                            const SizedBox(height: 6),
                            if (isCode)
                              Container(
                                width: double.infinity,
                                padding: const EdgeInsets.all(14),
                                margin: const EdgeInsets.symmetric(vertical: 6),
                                decoration: BoxDecoration(color: const Color(0xFF1E1E2E), borderRadius: BorderRadius.circular(12)),
                                child: Text(
                                  sec['body']!,
                                  style: const TextStyle(fontSize: 13, height: 1.4, fontFamily: 'monospace', color: Color(0xFFA6ADC8)),
                                ),
                              )
                            else
                              Text(
                                sec['body']!,
                                style: const TextStyle(fontSize: 13, height: 1.5, color: Colors.black87),
                              ),
                            if (i < sections.length - 1) ...[
                              const SizedBox(height: 14),
                              Divider(color: Colors.grey.shade300, height: 1),
                              const SizedBox(height: 14),
                            ],
                          ],
                        );
                      }),
                    ),
                  ),
                  const SizedBox(height: 20),

                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.blue.shade50,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: Colors.blue.shade200, width: 1.5),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Icon(Icons.quiz_rounded, color: Colors.blue, size: 20),
                            const SizedBox(width: 8),
                            const Text('VERIFIKASI BACAAN MATERI', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Colors.blue)),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Text(
                          checkpoint['question'],
                          style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Color(0xFF2D3142)),
                        ),
                        const SizedBox(height: 10),
                        ...List.generate((checkpoint['options'] as List).length, (optIdx) {
                          return RadioListTile<int>(
                            dense: true,
                            contentPadding: EdgeInsets.zero,
                            title: Text(checkpoint['options'][optIdx], style: const TextStyle(fontSize: 13)),
                            value: optIdx,
                            groupValue: selectedAnswer,
                            onChanged: (val) {
                              setDialogState(() {
                                selectedAnswer = val;
                              });
                            },
                          );
                        }),
                        const SizedBox(height: 8),
                        SizedBox(
                          width: double.infinity,
                          child: OutlinedButton(
                            style: OutlinedButton.styleFrom(
                              backgroundColor: Colors.white,
                              side: BorderSide(color: Colors.blue.shade400),
                            ),
                            onPressed: selectedAnswer == null
                                ? null
                                : () {
                                    setDialogState(() {
                                      isAnswerChecked = true;
                                      isAnswerCorrect = (selectedAnswer == checkpoint['correctIndex']);
                                    });
                                  },
                            child: const Text('CEK JAWABAN CHECKPOINT', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                          ),
                        ),
                        if (isAnswerChecked) ...[
                          const SizedBox(height: 8),
                          Center(
                            child: Text(
                              isAnswerCorrect ? 'BENAR! Tombol buka babak telah aktif.' : 'SALAH! Silakan baca kembali materi di atas.',
                              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: isAnswerCorrect ? Colors.green : Colors.red),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Center(
                            child: TextButton.icon(
                              icon: const Icon(Icons.menu_book, size: 16),
                              label: const Text('Lihat Penjelasan Materi'),
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => DiscussionScreen(
                                      history: [
                                        QuizDiscussionItem(
                                          question: checkpoint['question'],
                                          options: List<String>.from(checkpoint['options']),
                                          selectedIndex: selectedAnswer ?? 0,
                                          correctIndex: checkpoint['correctIndex'],
                                          explanation: checkpoint['explanation'],
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Batal', style: TextStyle(color: Colors.grey)),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: isAnswerCorrect ? Theme.of(context).primaryColor : Colors.grey.shade400,
              ),
              onPressed: !isAnswerCorrect
                  ? null
                  : () {
                      Navigator.pop(context);

                      setState(() {
                        if (index == currentUnlocked && currentUnlocked < stages.length - 1) {
                          currentUnlocked = index + 1;
                        }
                      });

                      widget.onStageCompleted(currentUnlocked, xp);

                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Babak Selesai! +$xp XP & Babak Selanjutnya Terbuka!')),
                      );
                    },
              child: const Text('PAHAM & BUKA BABAK BERIKUTNYA', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
            ),
          ],
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// 6. QUIZ BATTLE SCREEN
// ---------------------------------------------------------------------------
class QuizBattleScreen extends StatefulWidget {
  const QuizBattleScreen({super.key});

  @override
  State<QuizBattleScreen> createState() => _QuizBattleScreenState();
}

class _QuizBattleScreenState extends State<QuizBattleScreen> {
  int _correctCount = 0;
  int _currentIndex = 0;
  int? _selectedOption;

  final List<QuizDiscussionItem> _quizHistory = [];

  final List<Map<String, dynamic>> _questions = [
    {
      'question': 'Lengkapi sintaks deklarasi variabel teks berikut:\n\n____ nama = "NetBattle";',
      'options': ['String', 'int', 'bool', 'double'],
      'answer': 0,
      'explanation': 'Tipe data String digunakan khusus untuk menyimpan nilai berupa teks atau kumpulan karakter di dalam tanda petik.'
    },
    {
      'question': 'Lengkapi perintah pengkondisian IF di bawah ini:\n\n____ (skor >= 80) {\n  print("Lulus");\n}',
      'options': ['if', 'when', 'check', 'loop'],
      'answer': 0,
      'explanation': 'Kata kunci if digunakan untuk melakukan percabangan keputusan bersyarat di dalam struktur bahasa pemrograman Dart/Java.'
    },
    {
      'question': 'Kata kunci apa yang digunakan sebagai alternatif jika kondisi IF bernilai FALSE?',
      'options': ['then', 'else', 'other', 'default'],
      'answer': 1,
      'explanation': 'Blok else dijalankan apabila kondisi pada pernyataan if utama bernilai false (tidak terpenuhi).'
    },
    {
      'question': 'Sintaks deklarasi variabel bilangan bulat berangka 25:\n\n____ umur = 25;',
      'options': ['String', 'bool', 'int', 'double'],
      'answer': 2,
      'explanation': 'Tipe data int (integer) digunakan untuk mendeklarasikan variabel yang menyimpan angka bilangan bulat.'
    },
    {
      'question': 'Manakah operator yang digunakan untuk membandingkan dua nilai "SAMA DENGAN"?',
      'options': ['=', '==', '!=', '=>'],
      'answer': 1,
      'explanation': 'Operator kesetaraan (==) membandingkan apakah dua buah nilai bernilai sama persis.'
    },
    {
      'question': 'Kata kunci yang digunakan untuk menghentikan perulangan (loop) secara paksa:',
      'options': ['stop', 'exit', 'break', 'return'],
      'answer': 2,
      'explanation': 'Perintah break digunakan untuk menghentikan alur perulangan secara paksa.'
    },
    {
      'question': 'Tipe data yang hanya bernilai benar (true) atau salah (false) adalah:',
      'options': ['int', 'bool', 'String', 'char'],
      'answer': 1,
      'explanation': 'Tipe data bool menampung nilai kebenaran logika boolean true atau false.'
    },
    {
      'question': 'Kata kunci yang digunakan untuk mendefinisikan sebuah fungsi tanpa mengembalikan nilai (return):',
      'options': ['null', 'empty', 'void', 'static'],
      'answer': 2,
      'explanation': 'Void menyatakan bahwa fungsi mengeksekusi perintah tanpa memberikan nilai kembalian.'
    },
    {
      'question': 'Bagaimanakah cara mengambil jumlah elemen pada variabel List bernama angka?',
      'options': ['angka.size', 'angka.length', 'angka.count', 'angka.total'],
      'answer': 1,
      'explanation': 'Properti .length digunakan pada tipe data List untuk mengetahui jumlah total elemen yang tersimpan.'
    },
    {
      'question': 'Simbol apa yang digunakan untuk menambahkan komentar satu baris pada kode Dart/Java?',
      'options': ['//', '<!--', '#', '/*'],
      'answer': 0,
      'explanation': 'Garis miring ganda (//) berfungsi sebagai penanda komentar baris tunggal.'
    },
  ];

  void _answer(int optionIndex) {
    setState(() {
      _selectedOption = optionIndex;
      bool isCorrect = optionIndex == _questions[_currentIndex]['answer'];
      if (isCorrect) {
        _correctCount++;
      }

      _quizHistory.add(
        QuizDiscussionItem(
          question: _questions[_currentIndex]['question'],
          options: List<String>.from(_questions[_currentIndex]['options']),
          selectedIndex: optionIndex,
          correctIndex: _questions[_currentIndex]['answer'],
          explanation: _questions[_currentIndex]['explanation'] ?? 'Pahami kembali materi dasar mengenai logika pemrograman terkait soal ini.',
        ),
      );
    });

    Future.delayed(const Duration(seconds: 1), () {
      if (_currentIndex < _questions.length - 1) {
        setState(() {
          _currentIndex++;
          _selectedOption = null;
        });
      } else {
        _showFinalScoreDialog();
      }
    });
  }

  void _showFinalScoreDialog() {
    int finalScore = (_correctCount / _questions.length * 100).toInt();
    int xpGained = finalScore * 2;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(22)),
        title: const Text('KUIS SOLO SELESAI', textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.bold)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.emoji_events_rounded, size: 70, color: Colors.amber),
            const SizedBox(height: 12),
            Text(
              '$finalScore',
              style: TextStyle(fontSize: 48, fontWeight: FontWeight.bold, color: Theme.of(context).primaryColor),
            ),
            const Text('SKOR AKHIR KAMU', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.black54)),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(color: Colors.green.shade50, borderRadius: BorderRadius.circular(12)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.check_circle_rounded, color: Colors.green, size: 20),
                  const SizedBox(width: 8),
                  Text('Benar $_correctCount dari ${_questions.length} Soal (+$xpGained XP)', style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.green)),
                ],
              ),
            ),
            const SizedBox(height: 16),
            OutlinedButton.icon(
              style: OutlinedButton.styleFrom(
                foregroundColor: Colors.blue.shade800,
                side: BorderSide(color: Colors.blue.shade300),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              icon: const Icon(Icons.menu_book_rounded),
              label: const Text('LIHAT PEMBAHASAN JAWABAN'),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => DiscussionScreen(history: _quizHistory),
                  ),
                );
              },
            ),
          ],
        ),
        actions: [
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Theme.of(context).primaryColor),
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context, xpGained);
            },
            child: const Text('KLAIM XP & KEMBALI', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final q = _questions[_currentIndex];

    return Scaffold(
      appBar: AppBar(
        title: Text('Kuis Solo ${_currentIndex + 1}/${_questions.length}', style: const TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            LinearProgressIndicator(
              value: (_currentIndex + 1) / _questions.length,
              color: Theme.of(context).primaryColor,
              backgroundColor: Colors.grey.shade200,
              minHeight: 8,
              borderRadius: BorderRadius.circular(10),
            ),
            const SizedBox(height: 24),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: const Color(0xFF1E1E2E),
                borderRadius: BorderRadius.circular(18),
                boxShadow: [
                  BoxShadow(color: Colors.black.withValues(alpha: 0.1), blurRadius: 10, offset: const Offset(0, 4)),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(width: 10, height: 10, decoration: const BoxDecoration(color: Colors.redAccent, shape: BoxShape.circle)),
                      const SizedBox(width: 6),
                      Container(width: 10, height: 10, decoration: const BoxDecoration(color: Colors.amberAccent, shape: BoxShape.circle)),
                      const SizedBox(width: 6),
                      Container(width: 10, height: 10, decoration: const BoxDecoration(color: Colors.greenAccent, shape: BoxShape.circle)),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    q['question'],
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFFA6ADC8),
                      fontFamily: 'monospace',
                      height: 1.5,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            Expanded(
              child: ListView.builder(
                itemCount: (q['options'] as List).length,
                itemBuilder: (context, index) {
                  bool isSelected = _selectedOption == index;
                  bool isCorrect = index == q['answer'];

                  Color btnBgColor = Colors.white;
                  Color borderColor = Colors.grey.shade200;

                  if (isSelected) {
                    btnBgColor = isCorrect ? Colors.green.shade50 : Colors.red.shade50;
                    borderColor = isCorrect ? Colors.green : Colors.red;
                  }

                  return Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    decoration: BoxDecoration(
                      color: btnBgColor,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: borderColor, width: 1.5),
                      boxShadow: [
                        BoxShadow(color: Colors.black.withValues(alpha: 0.02), blurRadius: 6, offset: const Offset(0, 2)),
                      ],
                    ),
                    child: ListTile(
                      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
                      title: Text(
                        q['options'][index],
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: isSelected ? (isCorrect ? Colors.green.shade800 : Colors.red.shade800) : const Color(0xFF2D3142),
                        ),
                      ),
                      trailing: isSelected
                          ? Icon(isCorrect ? Icons.check_circle_rounded : Icons.cancel_rounded, color: isCorrect ? Colors.green : Colors.red)
                          : null,
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
// 7. MULTIPLAYER ROOM CREATION & LOBBY SCREEN
// ---------------------------------------------------------------------------
class CustomRoomScreen extends StatefulWidget {
  final String currentUserName;
  const CustomRoomScreen({super.key, required this.currentUserName});

  @override
  State<CustomRoomScreen> createState() => _CustomRoomScreenState();
}

class _CustomRoomScreenState extends State<CustomRoomScreen> {
  final TextEditingController _codeController = TextEditingController();

  void _startMultiplayerGame(String roomCode, bool isHost, String opponentName) async {
    final xp = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => TugOfWarMultiplayerScreen(
          roomCode: roomCode,
          playerName: widget.currentUserName,
          opponentName: opponentName,
          isHost: isHost,
        ),
      ),
    );

    if (xp != null && xp is int && mounted) {
      Navigator.pop(context, xp);
    }
  }

  void _showWaitingLobbyDialog(String roomCode) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('WAITING LOBBY (HOST)', textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.bold)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Bagikan Kode Room ini ke lawanmu:', style: TextStyle(fontSize: 12)),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              decoration: BoxDecoration(color: Colors.purple.shade50, borderRadius: BorderRadius.circular(12)),
              child: Text(roomCode, style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold, letterSpacing: 4, color: Colors.purple)),
            ),
            const SizedBox(height: 20),
            const CircularProgressIndicator(),
            const SizedBox(height: 12),
            const Text('Menunggu Teman/Pemain 2 Masuk...', style: TextStyle(fontSize: 12, color: Colors.black54, fontStyle: FontStyle.italic)),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal', style: TextStyle(color: Colors.grey)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Theme.of(context).primaryColor),
            onPressed: () {
              Navigator.pop(context);
              _startMultiplayerGame(roomCode, true, 'Budi (Lawan)');
            },
            child: const Text('SIMULASI LAWAN MASUK', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Battle Tarik Tambang 1v1', style: TextStyle(color: Color(0xFF2D3142), fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Theme.of(context).primaryColor, Theme.of(context).primaryColor.withValues(alpha: 0.7)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                children: [
                  const Icon(Icons.sports_kabaddi_rounded, size: 50, color: Colors.white),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text('Adu Tanding Real-Time', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
                        SizedBox(height: 4),
                        Text('Buat room dan undang temanmu atau masukkan kode!', style: TextStyle(fontSize: 12, color: Colors.white70)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 28),

            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(18), border: Border.all(color: Colors.grey.shade200)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('1. Buat Ruang Pertandingan (Host)', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 6),
                  const Text('Dapatkan kode unik untuk dibagikan ke HP temanmu.', style: TextStyle(fontSize: 12, color: Colors.black54)),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(backgroundColor: Theme.of(context).primaryColor, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
                      onPressed: () => _showWaitingLobbyDialog('NET889'),
                      child: const Text('BUAT ROOM & DAPATKAN KODE', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(18), border: Border.all(color: Colors.grey.shade200)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('2. Gabung Room Teman (Guest)', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 16),
                  TextField(
                    controller: _codeController,
                    textCapitalization: TextCapitalization.characters,
                    decoration: InputDecoration(
                      hintText: 'Masukkan Kode Room (Contoh: NET889)',
                      prefixIcon: const Icon(Icons.key_rounded),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
                      onPressed: () {
                        if (_codeController.text.trim().isNotEmpty) {
                          _startMultiplayerGame(_codeController.text.toUpperCase(), false, 'Host Room');
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Masukkan kode room terlebih dahulu!')));
                        }
                      },
                      child: const Text('GABUNG DAN BATTLE SEKARANG!', style: TextStyle(fontWeight: FontWeight.bold)),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// 8. TUG OF WAR MULTIPLAYER ENGINE
// ---------------------------------------------------------------------------
class TugOfWarMultiplayerScreen extends StatefulWidget {
  final String roomCode;
  final String playerName;
  final String opponentName;
  final bool isHost;

  const TugOfWarMultiplayerScreen({
    super.key,
    required this.roomCode,
    required this.playerName,
    required this.opponentName,
    required this.isHost,
  });

  @override
  State<TugOfWarMultiplayerScreen> createState() => _TugOfWarMultiplayerScreenState();
}

class _TugOfWarMultiplayerScreenState extends State<TugOfWarMultiplayerScreen> {
  double _ropePosition = 0.5;
  int _currentIndex = 0;
  int? _selectedOption;

  int _startCountdown = 3;
  bool _isGameStarted = false;
  int _questionTimer = 10;
  Timer? _timer;

  final List<Map<String, dynamic>> _questions = [
    {
      'question': 'Lengkapi sintaks deklarasi variabel teks di Dart/Java:\n\n____ namaSiswa = "Satria";',
      'options': ['String', 'int', 'bool', 'double'],
      'answer': 0,
    },
    {
      'question': 'Lengkapi struktur pengkondisian IF berikut:\n\n____ (skor >= 70) {\n  print("Lulus");\n}',
      'options': ['if', 'while', 'for', 'switch'],
      'answer': 0,
    },
    {
      'question': 'Operator logika mana yang digunakan untuk menyatakan "TIDAK SAMA DENGAN"?\n\nif (a ____ b)',
      'options': ['==', '!=', '>=', '<='],
      'answer': 1,
    },
    {
      'question': 'Kata kunci yang digunakan untuk menjalankan perulangan berdasarkan jumlah hitungan tertentu:\n\n____ (int i = 0; i < 5; i++)',
      'options': ['while', 'if', 'for', 'do'],
      'answer': 2,
    },
    {
      'question': 'Lengkapi sintaks variabel bernilai boolean (benar/salah) berikut:\n\n____ isLulus = true;',
      'options': ['int', 'bool', 'String', 'var'],
      'answer': 1,
    },
    {
      'question': 'Sintaks alternatif dalam IF yang dieksekusi ketika kondisi bernilai FALSE:\n\nif (x > 0) {\n  ...\n} ____ {\n  ...\n}',
      'options': ['then', 'or', 'else', 'case'],
      'answer': 2,
    },
    {
      'question': 'Bagaimana cara menambahkan nilai 1 secara langsung pada variabel x dalam perulangan?',
      'options': ['x++', 'x--', 'x==1', 'x+1'],
      'answer': 0,
    },
    {
      'question': 'Tipe data manakah yang cocok untuk menyimpan nilai desimal seperti 3.14?',
      'options': ['int', 'String', 'double', 'bool'],
      'answer': 2,
    },
    {
      'question': 'Kata kunci yang digunakan dalam fungsi untuk mengembalikan nilai hasil perhitungan:\n\nint tambah(int a, int b) {\n  ____ a + b;\n}',
      'options': ['print', 'return', 'break', 'void'],
      'answer': 1,
    },
    {
      'question': 'Bagaimana cara mengambil elemen pertama dalam sebuah Array/List bernama angka?',
      'options': ['angka[1]', 'angka[0]', 'angka.first()', 'angka[first]'],
      'answer': 1,
    },
  ];

  @override
  void initState() {
    super.initState();
    _runStartCountdown();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _runStartCountdown() {
    Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) return;
      if (_startCountdown > 1) {
        setState(() => _startCountdown--);
      } else {
        timer.cancel();
        setState(() => _isGameStarted = true);
        _startQuestionTimer();
      }
    });
  }

  void _startQuestionTimer() {
    _timer?.cancel();
    setState(() => _questionTimer = 10);

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) return;
      if (_questionTimer > 0) {
        setState(() => _questionTimer--);
      } else {
        _handleTimeOut();
      }
    });
  }

  void _handleTimeOut() {
    _timer?.cancel();
    setState(() {
      _selectedOption = -1;
      _ropePosition = (_ropePosition + 0.1).clamp(0.0, 1.0);
    });

    _nextQuestionOrFinish();
  }

  void _answer(int optionIndex) {
    _timer?.cancel();

    setState(() {
      _selectedOption = optionIndex;
      bool isCorrect = optionIndex == _questions[_currentIndex]['answer'];

      if (isCorrect) {
        _ropePosition = (_ropePosition - 0.1).clamp(0.0, 1.0);
      } else {
        _ropePosition = (_ropePosition + 0.1).clamp(0.0, 1.0);
      }
    });

    _nextQuestionOrFinish();
  }

  void _nextQuestionOrFinish() {
    Future.delayed(const Duration(milliseconds: 1000), () {
      if (!mounted) return;

      if (_ropePosition <= 0.0 || _ropePosition >= 1.0) {
        _finishGame();
        return;
      }

      if (_currentIndex < _questions.length - 1) {
        setState(() {
          _currentIndex++;
          _selectedOption = null;
        });
        _startQuestionTimer();
      } else {
        _finishGame();
      }
    });
  }

  void _finishGame() {
    _timer?.cancel();
    bool isWinner = _ropePosition < 0.5;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(
          isWinner ? 'VICTORY! KAMU MENANG!' : 'DEFEAT! LAWAN MENANG!',
          textAlign: TextAlign.center,
          style: TextStyle(fontWeight: FontWeight.bold, color: isWinner ? Colors.green : Colors.red),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(isWinner ? Icons.emoji_events : Icons.sports_kabaddi, size: 70, color: isWinner ? Colors.amber : Colors.red),
            const SizedBox(height: 12),
            Text(
              isWinner
                  ? 'Luar biasa! Kamu berhasil mengalahkan ${widget.opponentName} di Room ${widget.roomCode}.\n\nBonus XP: +200 XP'
                  : 'Tetap semangat! ${widget.opponentName} lebih cepat dan tepat kali ini.\n\nBonus XP: +50 XP',
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 13, color: Colors.black54),
            ),
          ],
        ),
        actions: [
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Theme.of(context).primaryColor),
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context, isWinner ? 200 : 50);
            },
            child: const Text('KEMBALI KE HUB', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (!_isGameStarted) {
      return Scaffold(
        backgroundColor: Theme.of(context).primaryColor,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('PERSIAPAN BATTLE!', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white, letterSpacing: 2)),
              const SizedBox(height: 20),
              CircleAvatar(
                radius: 50,
                backgroundColor: Colors.amberAccent,
                child: Text('$_startCountdown', style: TextStyle(fontSize: 48, fontWeight: FontWeight.bold, color: Theme.of(context).primaryColor)),
              ),
              const SizedBox(height: 20),
              Text('Room: ${widget.roomCode} • Tarik Tambang 1v1', style: const TextStyle(color: Colors.white70)),
            ],
          ),
        ),
      );
    }

    final q = _questions[_currentIndex];

    return Scaffold(
      appBar: AppBar(
        title: Text('Arena Room: ${widget.roomCode}', style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF2D3142))),
        backgroundColor: Colors.white,
        elevation: 0,
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 16),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(color: Colors.red.shade50, borderRadius: BorderRadius.circular(12)),
            child: Row(
              children: [
                const Icon(Icons.timer, color: Colors.red, size: 18),
                const SizedBox(width: 4),
                Text('$_questionTimer s', style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.red)),
              ],
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            color: Colors.amber.shade50,
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        const CircleAvatar(backgroundColor: Colors.blue, radius: 14, child: Icon(Icons.face, size: 16, color: Colors.white)),
                        const SizedBox(width: 6),
                        Text(widget.playerName, style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.blue)),
                      ],
                    ),
                    Row(
                      children: [
                        Text(widget.opponentName, style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.red)),
                        const SizedBox(width: 6),
                        const CircleAvatar(backgroundColor: Colors.red, radius: 14, child: Icon(Icons.person, size: 16, color: Colors.white)),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Stack(
                  alignment: Alignment.center,
                  children: [
                    Container(height: 10, width: double.infinity, decoration: BoxDecoration(color: Colors.brown.shade300, borderRadius: BorderRadius.circular(5))),
                    Container(height: 24, width: 3, color: Colors.redAccent),
                    AnimatedAlign(
                      duration: const Duration(milliseconds: 500),
                      curve: Curves.easeOutBack,
                      alignment: Alignment((_ropePosition * 2) - 1, 0),
                      child: Container(
                        padding: const EdgeInsets.all(6),
                        decoration: const BoxDecoration(color: Colors.red, shape: BoxShape.circle),
                        child: const Icon(Icons.sports_score, size: 18, color: Colors.white),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  'Kekuatan Tarikan Kamu: ${((1 - _ropePosition) * 100).toInt()}%',
                  style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.black54),
                ),
              ],
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Soal ${_currentIndex + 1} dari ${_questions.length}', style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.grey)),
                  const SizedBox(height: 8),

                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(18),
                    decoration: BoxDecoration(
                      color: const Color(0xFF1E1E2E),
                      borderRadius: BorderRadius.circular(18),
                      boxShadow: [
                        BoxShadow(color: Colors.black.withValues(alpha: 0.1), blurRadius: 10, offset: const Offset(0, 4)),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(width: 10, height: 10, decoration: const BoxDecoration(color: Colors.redAccent, shape: BoxShape.circle)),
                            const SizedBox(width: 6),
                            Container(width: 10, height: 10, decoration: const BoxDecoration(color: Colors.amberAccent, shape: BoxShape.circle)),
                            const SizedBox(width: 6),
                            Container(width: 10, height: 10, decoration: const BoxDecoration(color: Colors.greenAccent, shape: BoxShape.circle)),
                          ],
                        ),
                        const SizedBox(height: 14),
                        Text(
                          q['question'],
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFFA6ADC8),
                            fontFamily: 'monospace',
                            height: 1.5,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),

                  Expanded(
                    child: ListView.builder(
                      itemCount: (q['options'] as List).length,
                      itemBuilder: (context, index) {
                        final optionText = q['options'][index];
                        final isSelected = _selectedOption == index;
                        final isCorrect = index == q['answer'];

                        Color btnColor = Colors.white;
                        Color borderColor = Colors.grey.shade200;

                        if (isSelected) {
                          btnColor = isCorrect ? Colors.green.shade50 : Colors.red.shade50;
                          borderColor = isCorrect ? Colors.green : Colors.red;
                        }

                        return Container(
                          margin: const EdgeInsets.only(bottom: 10),
                          decoration: BoxDecoration(
                            color: btnColor,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: borderColor, width: 1.5),
                          ),
                          child: ListTile(
                            contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 4),
                            title: Text(optionText, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 15)),
                            trailing: isSelected
                                ? Icon(isCorrect ? Icons.check_circle : Icons.cancel, color: isCorrect ? Colors.green : Colors.red)
                                : null,
                            onTap: _selectedOption == null ? () => _answer(index) : null,
                          ),
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

// ---------------------------------------------------------------------------
// 9. MODEL & HALAMAN PEMBAHASAN JAWABAN
// ---------------------------------------------------------------------------
class QuizDiscussionItem {
  final String question;
  final List<String> options;
  final int selectedIndex;
  final int correctIndex;
  final String explanation;

  QuizDiscussionItem({
    required this.question,
    required this.options,
    required this.selectedIndex,
    required this.correctIndex,
    required this.explanation,
  });

  bool get isCorrect => selectedIndex == correctIndex;
}

class DiscussionScreen extends StatelessWidget {
  final List<QuizDiscussionItem> history;

  const DiscussionScreen({super.key, required this.history});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pembahasan Jawaban', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        foregroundColor: const Color(0xFF2D3142),
        elevation: 0,
      ),
      body: history.isEmpty
          ? const Center(child: Text('Belum ada riwayat pembahasan.'))
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: history.length,
              itemBuilder: (context, index) {
                final item = history[index];
                return Card(
                  margin: const EdgeInsets.only(bottom: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  elevation: 2,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                              decoration: BoxDecoration(
                                color: item.isCorrect ? Colors.green.shade100 : Colors.red.shade100,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                'Soal ${index + 1} • ${item.isCorrect ? 'BENAR' : 'SALAH'}',
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color: item.isCorrect ? Colors.green.shade900 : Colors.red.shade900,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Text(
                          item.question,
                          style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Color(0xFF2D3142)),
                        ),
                        const SizedBox(height: 12),
                        Column(
                          children: List.generate(item.options.length, (optIdx) {
                            bool isUserChoice = optIdx == item.selectedIndex;
                            bool isCorrectChoice = optIdx == item.correctIndex;

                            Color tileBg = Colors.grey.shade100;
                            Color borderColor = Colors.transparent;

                            if (isCorrectChoice) {
                              tileBg = Colors.green.shade50;
                              borderColor = Colors.green;
                            } else if (isUserChoice && !item.isCorrect) {
                              tileBg = Colors.red.shade50;
                              borderColor = Colors.red;
                            }

                            return Container(
                              margin: const EdgeInsets.only(bottom: 8),
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: tileBg,
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(color: borderColor, width: 1.5),
                              ),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      item.options[optIdx],
                                      style: TextStyle(
                                        fontSize: 13,
                                        fontWeight: isUserChoice || isCorrectChoice ? FontWeight.bold : FontWeight.normal,
                                      ),
                                    ),
                                  ),
                                  if (isCorrectChoice)
                                    const Icon(Icons.check_circle, color: Colors.green, size: 20)
                                  else if (isUserChoice && !item.isCorrect)
                                    const Icon(Icons.cancel, color: Colors.red, size: 20),
                                ],
                              ),
                            );
                          }),
                        ),
                        const SizedBox(height: 8),
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.blue.shade50,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Icon(Icons.lightbulb_outline, color: Colors.blue.shade800, size: 20),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  'Pembahasan:\n${item.explanation}',
                                  style: TextStyle(fontSize: 12, color: Colors.blue.shade900),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}

// ---------------------------------------------------------------------------
// 10. HALAMAN PROFIL PENGGUNA (BISA DIEDIT & LOGOUT)
// ---------------------------------------------------------------------------
class ProfileScreen extends StatefulWidget {
  final String currentEmail;
  final String currentName;
  final int userXP;
  final int level;
  final Color themeColor;
  final Function(String newName) onProfileUpdated;

  const ProfileScreen({
    super.key,
    required this.currentEmail,
    required this.currentName,
    required this.userXP,
    required this.level,
    required this.themeColor,
    required this.onProfileUpdated,
  });

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late TextEditingController _nameController;
  late TextEditingController _passwordController;
  bool _isEditing = false;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.currentName);
    _passwordController = TextEditingController();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _saveProfileChanges() {
    String newName = _nameController.text.trim();
    String newPassword = _passwordController.text.trim();

    if (newName.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Nama tidak boleh kosong!')),
      );
      return;
    }

    if (UserDatabase.isEmailRegistered(widget.currentEmail)) {
      UserDatabase.registerUser(widget.currentEmail, newName, newPassword.isNotEmpty ? newPassword : '123');
    }

    widget.onProfileUpdated(newName);

    setState(() {
      _isEditing = false;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Profil berhasil diperbarui!'),
        backgroundColor: Colors.green,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profil Pengguna', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        foregroundColor: const Color(0xFF2D3142),
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(_isEditing ? Icons.cancel : Icons.edit_note, color: widget.themeColor, size: 28),
            onPressed: () {
              setState(() {
                _isEditing = !_isEditing;
              });
            },
          )
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            CircleAvatar(
              radius: 50,
              backgroundColor: widget.themeColor.withValues(alpha: 0.15),
              child: Icon(Icons.person_rounded, size: 60, color: widget.themeColor),
            ),
            const SizedBox(height: 16),
            Text(
              _nameController.text,
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Color(0xFF2D3142)),
            ),
            const SizedBox(height: 4),
            Text(
              widget.currentEmail,
              style: const TextStyle(fontSize: 13, color: Colors.black54),
            ),
            const SizedBox(height: 24),

            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(18),
                boxShadow: [
                  BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 10, offset: const Offset(0, 4)),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Column(
                    children: [
                      const Text('LEVEL', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.grey)),
                      const SizedBox(height: 4),
                      Text('Lv. ${widget.level}', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: widget.themeColor)),
                    ],
                  ),
                  Container(width: 1, height: 35, color: Colors.grey.shade300),
                  Column(
                    children: [
                      const Text('TOTAL XP', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.grey)),
                      const SizedBox(height: 4),
                      Text('${widget.userXP} XP', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.amber)),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 28),

            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: Colors.grey.shade200),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Detail Informasi Akun', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 16),
                  TextField(
                    controller: _nameController,
                    enabled: _isEditing,
                    decoration: InputDecoration(
                      labelText: 'Nama Lengkap',
                      prefixIcon: const Icon(Icons.person_outline),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: _passwordController,
                    enabled: _isEditing,
                    obscureText: true,
                    decoration: InputDecoration(
                      labelText: _isEditing ? 'Password Baru (Opsional)' : 'Password',
                      hintText: _isEditing ? 'Masukkan password baru' : '••••••••',
                      prefixIcon: const Icon(Icons.lock_outline),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                  ),
                  if (_isEditing) ...[
                    const SizedBox(height: 20),
                    SizedBox(
                      width: double.infinity,
                      height: 48,
                      child: ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: widget.themeColor,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                        icon: const Icon(Icons.save_rounded, color: Colors.white),
                        label: const Text('SIMPAN PERUBAHAN', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
                        onPressed: _saveProfileChanges,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(height: 28),

            SizedBox(
              width: double.infinity,
              height: 48,
              child: OutlinedButton.icon(
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.red,
                  side: const BorderSide(color: Colors.redAccent),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                icon: const Icon(Icons.logout_rounded),
                label: const Text('KELUAR / LOGOUT AKUN', style: TextStyle(fontWeight: FontWeight.bold)),
                onPressed: () {
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => const AuthLoginScreen()),
                    (route) => false,
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