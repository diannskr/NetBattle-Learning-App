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

  static _NetBattleAppState of(BuildContext context) =>
      context.findAncestorStateOfType<_NetBattleAppState>()!;

  @override
  State<NetBattleApp> createState() => _NetBattleAppState();
}

class _NetBattleAppState extends State<NetBattleApp> {
  Color _primaryThemeColor = const Color(0xFF3B82F6);

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
        scaffoldBackgroundColor: const Color(0xFFF8FAFC),
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
                color: Colors.white.withOpacity(0.15),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.terminal_rounded, size: 80, color: Colors.white),
            ),
            const SizedBox(height: 24),
            const Text(
              'NETBATTLE CODE ARENA',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, letterSpacing: 1.5, color: Colors.white),
            ),
            const SizedBox(height: 8),
            const Text('Platform Pembelajaran Logika & Pemrograman', style: TextStyle(fontSize: 13, color: Colors.white70)),
            const SizedBox(height: 48),
            const SizedBox(width: 28, height: 28, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 3)),
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
        const SnackBar(content: Text('Email dan Password wajib diisi.')),
      );
      return;
    }

    if (!UserDatabase.isValidEmail(email)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Format email tidak valid (contoh: nama@domain.com).'),
          backgroundColor: Colors.redAccent,
        ),
      );
      return;
    }

    if (_isSignUp) {
      if (name.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Nama lengkap wajib diisi.')),
        );
        return;
      }

      bool success = UserDatabase.registerUser(email, name, password);
      if (!success) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Email sudah terdaftar. Silakan login.'), backgroundColor: Colors.orange),
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
      if (!UserDatabase.isEmailRegistered(email)) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Email belum terdaftar. Silakan registrasi terlebih dahulu.'), backgroundColor: Colors.redAccent),
        );
        return;
      }

      if (!UserDatabase.validateLogin(email, password)) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Password yang Anda masukkan salah.'), backgroundColor: Colors.redAccent),
        );
        return;
      }

      String studentName = UserDatabase.getUserName(email);
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
            padding: const EdgeInsets.all(32.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(child: Icon(Icons.code_rounded, size: 60, color: themeColor)),
                const SizedBox(height: 16),
                Center(
                  child: Text(
                    _isSignUp ? 'Pendaftaran Akun Baru' : 'Portal Masuk Siswa',
                    style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Color(0xFF1E293B)),
                  ),
                ),
                const SizedBox(height: 6),
                const Center(
                  child: Text(
                    'Masukkan kredensial akun akademik Anda',
                    style: TextStyle(fontSize: 13, color: Color(0xFF64748B)),
                  ),
                ),
                const SizedBox(height: 32),
                if (_isSignUp) ...[
                  const Text('Nama Lengkap', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Color(0xFF475569))),
                  const SizedBox(height: 6),
                  TextField(
                    controller: _nameController,
                    decoration: InputDecoration(hintText: 'Masukkan nama lengkap', prefixIcon: const Icon(Icons.person_outline, size: 20), border: OutlineInputBorder(borderRadius: BorderRadius.circular(10))),
                  ),
                  const SizedBox(height: 16),
                ],
                const Text('Alamat Email', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Color(0xFF475569))),
                const SizedBox(height: 6),
                TextField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(hintText: 'nama@sekolah.sch.id', prefixIcon: const Icon(Icons.email_outlined, size: 20), border: OutlineInputBorder(borderRadius: BorderRadius.circular(10))),
                ),
                const SizedBox(height: 16),
                const Text('Kata Sandi', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Color(0xFF475569))),
                const SizedBox(height: 6),
                TextField(
                  controller: _passwordController,
                  obscureText: true,
                  decoration: InputDecoration(hintText: '••••••••', prefixIcon: const Icon(Icons.lock_outline, size: 20), border: OutlineInputBorder(borderRadius: BorderRadius.circular(10))),
                ),
                const SizedBox(height: 28),
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(backgroundColor: themeColor, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
                    onPressed: _handleAuth,
                    child: Text(_isSignUp ? 'DAFTAR AKUN' : 'MASUK APLIKASI', style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white)),
                  ),
                ),
                const SizedBox(height: 16),
                Center(
                  child: TextButton(
                    onPressed: () => setState(() => _isSignUp = !_isSignUp),
                    child: Text(_isSignUp ? 'Sudah memiliki akun? Masuk di sini' : 'Belum memiliki akun? Daftar baru', style: TextStyle(color: themeColor, fontWeight: FontWeight.w600)),
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
    {'name': 'Professional Blue', 'color': const Color(0xFF3B82F6)},
    {'name': 'Emerald Dark', 'color': const Color(0xFF059669)},
    {'name': 'Slate Gray', 'color': const Color(0xFF475569)},
    {'name': 'Indigo Navy', 'color': const Color(0xFF4F46E5)},
    {'name': 'Crimson Red', 'color': const Color(0xFFDC2626)},
  ];

  @override
  Widget build(BuildContext context) {
    Color activeColor = _themeColors[_colorIndex]['color'];

    return Scaffold(
      appBar: AppBar(title: const Text('Konfigurasi Profil & Avatar', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)), centerTitle: true),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            children: [
              Text('Pengguna: ${widget.username}', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Color(0xFF334155))),
              const SizedBox(height: 16),
              Container(
                width: 180,
                height: 220,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: activeColor.withOpacity(0.08),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: activeColor, width: 2),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(height: 28, child: _hats[_hatIndex] != null ? Icon(_hats[_hatIndex], size: 28, color: activeColor) : const SizedBox()),
                    Icon(_faces[_faceIndex], size: 60, color: activeColor),
                    const SizedBox(height: 2),
                    Icon(_outfits[_outfitIndex], size: 65, color: activeColor.withOpacity(0.8)),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              const Align(alignment: Alignment.centerLeft, child: Text('Aksesoris Kepala:', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Color(0xFF475569)))),
              const SizedBox(height: 8),
              Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: List.generate(_hats.length, (i) => ChoiceChip(label: _hats[i] == null ? const Text('Standar', style: TextStyle(fontSize: 11)) : Icon(_hats[i], size: 18), selected: _hatIndex == i, onSelected: (v) => setState(() => _hatIndex = i)))),
              const SizedBox(height: 16),
              const Align(alignment: Alignment.centerLeft, child: Text('Skema Warna Tema:', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Color(0xFF475569)))),
              const SizedBox(height: 8),
              Wrap(spacing: 8, children: List.generate(_themeColors.length, (i) {
                Color c = _themeColors[i]['color'];
                return ChoiceChip(
                  avatar: CircleAvatar(backgroundColor: c, radius: 6),
                  label: Text(_themeColors[i]['name'], style: const TextStyle(fontSize: 11)),
                  selected: _colorIndex == i,
                  onSelected: (v) {
                    setState(() => _colorIndex = i);
                    NetBattleApp.of(context).updateThemeColor(c);
                  },
                );
              })),
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: activeColor, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
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
                  child: const Text('SIMPAN & LANJUTKAN KE DASHBOARD', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13)),
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
// 4. HOME SCREEN (XP & LEVEL AWAL KOSONG = 0)
// ---------------------------------------------------------------------------
class HomeScreen extends StatefulWidget {
  final String studentName;
  final IconData? hatIcon;
  final IconData faceIcon;
  final IconData outfitIcon;
  final Color themeColor;

  const HomeScreen({super.key, required this.studentName, this.hatIcon, this.faceIcon = Icons.face_rounded, this.outfitIcon = Icons.checkroom_rounded, this.themeColor = const Color(0xFF3B82F6)});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _userXP = 0; // Mulai dari 0 kosong
  int _unlockedStageIndex = 0;

  int get level => (_userXP / 300).floor() + 1;

  void _addXP(int points) {
    setState(() => _userXP += points);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: const [
            Icon(Icons.terminal, color: Color(0xFF3B82F6), size: 24),
            SizedBox(width: 8),
            Text('NetBattle Code Arena', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF1E293B))),
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
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: widget.themeColor,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(color: Colors.white.withOpacity(0.15), borderRadius: BorderRadius.circular(12)),
                    child: Column(
                      children: [
                        if (widget.hatIcon != null) Icon(widget.hatIcon, size: 18, color: Colors.white),
                        Icon(widget.faceIcon, size: 24, color: Colors.white),
                        Icon(widget.outfitIcon, size: 24, color: Colors.white),
                      ],
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(widget.studentName, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
                        const SizedBox(height: 2),
                        Text('Level $level • $_userXP XP', style: const TextStyle(fontSize: 12, color: Colors.white70)),
                        const SizedBox(height: 8),
                        LinearProgressIndicator(value: (_userXP % 300) / 300, color: Colors.white, backgroundColor: Colors.white24),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.settings_outlined, color: Colors.white),
                    onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => AvatarCustomizerScreen(username: widget.studentName, currentHat: widget.hatIcon, currentFace: widget.faceIcon, currentOutfit: widget.outfitIcon))),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            const Text('Menu Utama Pembelajaran', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Color(0xFF1E293B))),
            const SizedBox(height: 12),

            _buildGameCard(
              context,
              title: 'Modul Materi Pembelajaran (8 Babak)',
              subtitle: 'Pelajari konsep komprehensif algoritma & pemrograman',
              icon: Icons.menu_book_rounded,
              color: Colors.teal,
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
              title: 'Simulasi Tarik Tambang (1v1 Arena)',
              subtitle: 'Uji kecepatan logika koding rumpang bersama rekan',
              icon: Icons.sports_kabaddi_rounded,
              color: Colors.blueAccent,
              xp: '+200 XP',
              onTap: () async {
                final xp = await Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => CustomRoomScreen(currentUserName: widget.studentName)),
                );
                if (xp != null && xp is int) _addXP(xp);
              },
            ),
            const SizedBox(height: 12),

            _buildGameCard(
              context,
              title: 'Evaluasi Kuis Mandiri (10 Soal)',
              subtitle: 'Uji pemahaman mandiri dengan penilaian langsung',
              icon: Icons.assignment_turned_in_rounded,
              color: widget.themeColor,
              xp: '+Skor XP',
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
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), border: Border.all(color: Colors.grey.shade200)),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Container(padding: const EdgeInsets.all(12), decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(10)), child: Icon(icon, color: color, size: 24)),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(child: Text(title, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF1E293B)))),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(color: Colors.grey.shade100, borderRadius: BorderRadius.circular(6)),
                            child: Text(xp, style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.grey.shade700)),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
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
// 5. QUEST SCREEN (PROFESSIONAL SINGLE BOX MATERIAL)
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
      'desc': 'Modul: Memahami wadah memori, aturan penamaan variabel, dan output.',
      'sections': [
        {
          'header': '1. Definisi Algoritma dan Variabel',
          'body': 'Algoritma adalah prosedur langkah demi langkah yang terstruktur untuk menyelesaikan komputasi. Variabel bertindak sebagai alokasi memori sementara di RAM untuk menyimpan data nilai.'
        },
        {
          'header': '2. Aturan Penamaan Variabel (Naming Convention)',
          'body': '- Gunakan format camelCase (contoh: nilaiUjian, namaSiswa).\n- Tidak boleh diawali angka atau mengandung spasi.\n- Sensitif terhadap huruf kapital (Case-Sensitive).'
        },
        {
          'header': '3. Contoh Implementasi Kode',
          'isCode': true,
          'body': 'String namaSiswa = "Budi Santoso";\nint nilaiUjian = 88;\nprint("Siswa: " + namaSiswa);\nprint("Nilai: " + nilaiUjian.toString());'
        }
      ],
      'xp': 150
    },
    {
      'title': 'Babak 2: Tipe Data Dasar & Operator Aritmatika',
      'desc': 'Modul: int, double, String, bool, serta operasi aritmatika.',
      'sections': [
        {
          'header': '1. Jenis Tipe Data',
          'body': '- int: Bilangan bulat.\n- double: Bilangan desimal.\n- String: Data teks.\n- bool: Kebenaran logika (true/false).'
        },
        {
          'header': '2. Contoh Perhitungan',
          'isCode': true,
          'body': 'int harga = 10000;\nint qty = 3;\nint total = harga * qty;\nprint("Total: " + total.toString());'
        }
      ],
      'xp': 150
    },
    {
      'title': 'Babak 3: Percabangan Logika (If - Else)',
      'desc': 'Modul: Pengambilan keputusan kondisional.',
      'sections': [
        {
          'header': '1. Struktur Percabangan',
          'body': 'Struktur pengkondisian memungkinkan program mengeksekusi blok kode berbeda berdasarkan evaluasi kondisi boolean.'
        },
        {
          'header': '2. Contoh Kode',
          'isCode': true,
          'body': 'int skor = 80;\nif (skor >= 75) {\n  print("Status: LULUS");\n} else {\n  print("Status: TIDAK LULUS");\n}'
        }
      ],
      'xp': 200
    },
    {
      'title': 'Babak 4: Percabangan Majemuk (Else If & Logika)',
      'desc': 'Modul: Evaluasi kondisi bertingkat & operator logika.',
      'sections': [
        {
          'header': '1. Penggunaan Else If',
          'body': 'Digunakan saat terdapat lebih dari dua jalur alternatif keputusan.'
        },
        {
          'header': '2. Contoh Kode',
          'isCode': true,
          'body': 'int nilai = 85;\nif (nilai >= 85) {\n  print("Predikat: A");\n} else {\n  print("Predikat: B");\n}'
        }
      ],
      'xp': 200
    },
    {
      'title': 'Babak 5: Perulangan Terhitung (For Loop)',
      'desc': 'Modul: Iterasi berulang dengan counter.',
      'sections': [
        {
          'header': '1. Struktur For Loop',
          'body': 'Digunakan untuk mengeksekusi blok kode berulang kali dalam rentang hitungan yang pasti.'
        },
        {
          'header': '2. Contoh Kode',
          'isCode': true,
          'body': 'for (int i = 1; i <= 3; i++) {\n  print("Iterasi ke-" + i.toString());\n}'
        }
      ],
      'xp': 250
    },
    {
      'title': 'Babak 6: Perulangan Kondisional (While Loop)',
      'desc': 'Modul: Iterasi berbasis kondisi boolean dinamis.',
      'sections': [
        {
          'header': '1. Konsep While',
          'body': 'Perulangan berjalan terus menerus selama ekspresi kondisi bernilai true.'
        },
        {
          'header': '2. Contoh Kode',
          'isCode': true,
          'body': 'int x = 2;\nwhile (x > 0) {\n  print("Running...");\n  x--;\n}'
        }
      ],
      'xp': 250
    },
    {
      'title': 'Babak 7: Fungsi / Subprogram (Method)',
      'desc': 'Modul: Modularisasi kode dan parameter.',
      'sections': [
        {
          'header': '1. Definisi Fungsi',
          'body': 'Fungsi membungkus logika operasional agar dapat digunakan kembali secara efisien.'
        },
        {
          'header': '2. Contoh Kode',
          'isCode': true,
          'body': 'int kali(int a, int b) {\n  return a * b;\n}'
        }
      ],
      'xp': 300
    },
    {
      'title': 'Babak 8: Struktur Data Array / List',
      'desc': 'Modul: Koleksi data berindeks nol.',
      'sections': [
        {
          'header': '1. Konsep List',
          'body': 'Menyimpan sekumpulan data dalam satu variabel tunggal dengan indeks berbasis nol.'
        },
        {
          'header': '2. Contoh Kode',
          'isCode': true,
          'body': 'List<String> items = ["Data A", "Data B"];\nprint(items[0]);'
        }
      ],
      'xp': 300
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Modul Materi Pembelajaran', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)), backgroundColor: Colors.white, elevation: 0),
      body: ListView.builder(
        padding: const EdgeInsets.all(20.0),
        itemCount: stages.length,
        itemBuilder: (context, index) {
          final stage = stages[index];
          bool isUnlocked = index <= currentUnlocked;
          bool isCompleted = index < currentUnlocked;

          Color badgeColor = isCompleted ? Colors.green : (isUnlocked ? Colors.blue : Colors.grey);
          IconData statusIcon = isCompleted ? Icons.check_circle_rounded : (isUnlocked ? Icons.play_circle_fill_rounded : Icons.lock_outline_rounded);

          return Container(
            margin: const EdgeInsets.only(bottom: 12),
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), border: Border.all(color: isUnlocked ? Colors.blue.shade200 : Colors.grey.shade200)),
            child: ListTile(
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              leading: Icon(statusIcon, color: badgeColor, size: 26),
              title: Text(stage['title'], style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: isUnlocked ? const Color(0xFF1E293B) : Colors.grey)),
              subtitle: Text(stage['desc'], style: TextStyle(fontSize: 11, color: isUnlocked ? Colors.grey.shade600 : Colors.grey.shade400)),
              trailing: isUnlocked ? const Icon(Icons.arrow_forward_ios_rounded, size: 14) : const Icon(Icons.lock, size: 16),
              onTap: () {
                if (!isUnlocked) {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Babak sebelumnya harus diselesaikan terlebih dahulu.')));
                } else {
                  _showSingleBoxMaterialDialog(context, index, stage['title'], stage['sections'] as List<Map<String, dynamic>>, stage['xp']);
                }
              },
            ),
          );
        },
      ),
    );
  }

  void _showSingleBoxMaterialDialog(BuildContext context, int index, String title, List<Map<String, dynamic>> sections, int xp) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(title, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
        content: SizedBox(
          width: double.maxFinite,
          child: SingleChildScrollView(
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey.shade200),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: List.generate(sections.length, (i) {
                  final sec = sections[i];
                  final bool isCode = sec['isCode'] == true;

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(sec['header']!, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Color(0xFF1E293B))),
                      const SizedBox(height: 4),
                      if (isCode)
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(12),
                          margin: const EdgeInsets.symmetric(vertical: 4),
                          decoration: BoxDecoration(color: const Color(0xFF1E1E2E), borderRadius: BorderRadius.circular(8)),
                          child: Text(sec['body']!, style: const TextStyle(fontSize: 12, height: 1.4, fontFamily: 'monospace', color: Color(0xFFA6ADC8))),
                        )
                      else
                        Text(sec['body']!, style: const TextStyle(fontSize: 12, height: 1.4, color: Color(0xFF475569))),
                      if (i < sections.length - 1) ...[
                        const SizedBox(height: 12),
                        Divider(color: Colors.grey.shade200, height: 1),
                        const SizedBox(height: 12),
                      ],
                    ],
                  );
                }),
              ),
            ),
          ),
        ),
        actions: [
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Theme.of(context).primaryColor, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))),
            onPressed: () {
              Navigator.pop(context);
              setState(() {
                if (index == currentUnlocked && currentUnlocked < stages.length - 1) {
                  currentUnlocked = index + 1;
                }
              });
              widget.onStageCompleted(currentUnlocked, xp);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Babak selesai! Ditambahkan +$xp XP.')),
              );
            },
            child: const Text('SELESAI & LANJUT', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12)),
          ),
        ],
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

  final List<Map<String, dynamic>> _questions = [
    {
      'question': 'Lengkapi sintaks deklarasi variabel teks berikut:\n\n____ nama = "NetBattle";',
      'options': ['String', 'int', 'bool', 'double'],
      'answer': 0,
    },
    {
      'question': 'Lengkapi perintah pengkondisian IF di bawah ini:\n\n____ (skor >= 80) {\n  print("Lulus");\n}',
      'options': ['if', 'when', 'check', 'loop'],
      'answer': 0,
    },
    {
      'question': 'Kata kunci alternatif jika kondisi IF bernilai FALSE:',
      'options': ['then', 'else', 'other', 'default'],
      'answer': 1,
    },
    {
      'question': 'Sintaks deklarasi variabel bilangan bulat berangka 25:\n\n____ umur = 25;',
      'options': ['String', 'bool', 'int', 'double'],
      'answer': 2,
    },
    {
      'question': 'Operator perbandingan untuk "SAMA DENGAN":',
      'options': ['=', '==', '!=', '=>'],
      'answer': 1,
    },
    {
      'question': 'Kata kunci penghenti perulangan paksa:',
      'options': ['stop', 'exit', 'break', 'return'],
      'answer': 2,
    },
    {
      'question': 'Tipe data logika benar/salah:',
      'options': ['int', 'bool', 'String', 'char'],
      'answer': 1,
    },
    {
      'question': 'Fungsi tanpa nilai kembalian (return):',
      'options': ['null', 'empty', 'void', 'static'],
      'answer': 2,
    },
    {
      'question': 'Properti untuk mengambil panjang elemen List:',
      'options': ['angka.size', 'angka.length', 'angka.count', 'angka.total'],
      'answer': 1,
    },
    {
      'question': 'Simbol komentar satu baris:',
      'options': ['//', '<!--', '#', '/*'],
      'answer': 0,
    },
  ];

  void _answer(int optionIndex) {
    setState(() {
      _selectedOption = optionIndex;
      if (optionIndex == _questions[_currentIndex]['answer']) {
        _correctCount++;
      }
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
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Evaluasi Selesai', textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.verified_rounded, size: 50, color: Colors.blue),
            const SizedBox(height: 12),
            Text('$finalScore', style: TextStyle(fontSize: 36, fontWeight: FontWeight.bold, color: Theme.of(context).primaryColor)),
            const Text('NILAI EVALUASI', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.grey)),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(color: Colors.blue.shade50, borderRadius: BorderRadius.circular(8)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.check_circle_outline, color: Colors.blue, size: 18),
                  const SizedBox(width: 6),
                  Text('Benar $_correctCount dari ${_questions.length} (+$xpGained XP)', style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.blue, fontSize: 12)),
                ],
              ),
            ),
          ],
        ),
        actions: [
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Theme.of(context).primaryColor, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))),
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context, xpGained);
            },
            child: const Text('KLAIM XP & KEMBALI', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12)),
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
        title: Text('Evaluasi Soal ${_currentIndex + 1}/${_questions.length}', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
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
              minHeight: 6,
              borderRadius: BorderRadius.circular(6),
            ),
            const SizedBox(height: 20),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFF1E1E2E),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                q['question'],
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFFA6ADC8),
                  fontFamily: 'monospace',
                  height: 1.4,
                ),
              ),
            ),
            const SizedBox(height: 16),
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
                    margin: const EdgeInsets.only(bottom: 10),
                    decoration: BoxDecoration(
                      color: btnBgColor,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: borderColor, width: 1.2),
                    ),
                    child: ListTile(
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                      title: Text(
                        q['options'][index],
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: isSelected ? (isCorrect ? Colors.green.shade800 : Colors.red.shade800) : const Color(0xFF1E293B),
                        ),
                      ),
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
// 7. MULTIPLAYER ROOM & LOBBY SCREEN
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
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Lobby Ruang Simulasi', textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Bagikan Kode Akses Ruang:', style: TextStyle(fontSize: 12, color: Colors.grey)),
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              decoration: BoxDecoration(color: Colors.grey.shade100, borderRadius: BorderRadius.circular(8)),
              child: Text(roomCode, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, letterSpacing: 2, color: Color(0xFF1E293B))),
            ),
            const SizedBox(height: 16),
            const SizedBox(width: 24, height: 24, child: CircularProgressIndicator(strokeWidth: 2)),
            const SizedBox(height: 10),
            const Text('Menunggu partisipan lain bergabung...', style: TextStyle(fontSize: 11, color: Colors.grey)),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal', style: TextStyle(color: Colors.grey, fontSize: 12)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Theme.of(context).primaryColor, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))),
            onPressed: () {
              Navigator.pop(context);
              _startMultiplayerGame(roomCode, true, 'Rekan Diskusi');
            },
            child: const Text('SIMULASI MULAI', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Simulasi Tarik Tambang 1v1', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)), backgroundColor: Colors.white, elevation: 0),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), border: Border.all(color: Colors.grey.shade200)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('1. Buat Ruang Simulasi Baru', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF1E293B))),
                  const SizedBox(height: 4),
                  const Text('Buat kode sesi untuk diakses rekan Anda.', style: TextStyle(fontSize: 12, color: Colors.grey)),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    height: 42,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(backgroundColor: Theme.of(context).primaryColor, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))),
                      onPressed: () => _showWaitingLobbyDialog('NET889'),
                      child: const Text('BUAT RUANG SESI', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 12)),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), border: Border.all(color: Colors.grey.shade200)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('2. Gabung Ruang Sesi', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF1E293B))),
                  const SizedBox(height: 12),
                  TextField(
                    controller: _codeController,
                    textCapitalization: TextCapitalization.characters,
                    decoration: InputDecoration(
                      hintText: 'Masukkan Kode Sesi',
                      prefixIcon: const Icon(Icons.vpn_key_outlined, size: 18),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                    ),
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    height: 42,
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))),
                      onPressed: () {
                        if (_codeController.text.trim().isNotEmpty) {
                          _startMultiplayerGame(_codeController.text.toUpperCase(), false, 'Host Sesi');
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Masukkan kode ruang terlebih dahulu.')));
                        }
                      },
                      child: const Text('GABUNG SESI', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
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
      'question': 'Operator logika untuk menyatakan "TIDAK SAMA DENGAN":\n\nif (a ____ b)',
      'options': ['==', '!=', '>=', '<='],
      'answer': 1,
    },
    {
      'question': 'Kata kunci perulangan berdasarkan hitungan tertentu:\n\n____ (int i = 0; i < 5; i++)',
      'options': ['while', 'if', 'for', 'do'],
      'answer': 2,
    },
    {
      'question': 'Sintaks variabel boolean (benar/salah):\n\n____ isLulus = true;',
      'options': ['int', 'bool', 'String', 'var'],
      'answer': 1,
    },
    {
      'question': 'Sintaks alternatif dalam IF kondisi FALSE:\n\nif (x > 0) {\n  ...\n} ____ {\n  ...\n}',
      'options': ['then', 'or', 'else', 'case'],
      'answer': 2,
    },
    {
      'question': 'Cara inkrementasi nilai 1 pada variabel x:',
      'options': ['x++', 'x--', 'x==1', 'x+1'],
      'answer': 0,
    },
    {
      'question': 'Tipe data untuk menyimpan nilai desimal (3.14):',
      'options': ['int', 'String', 'double', 'bool'],
      'answer': 2,
    },
    {
      'question': 'Kata kunci pengembalian nilai fungsi:\n\nint tambah(int a, int b) {\n  ____ a + b;\n}',
      'options': ['print', 'return', 'break', 'void'],
      'answer': 1,
    },
    {
      'question': 'Indeks awal elemen pertama dalam Array/List:',
      'options': ['angka[1]', 'angka[0]', 'angka.first()', 'angka.start'],
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
      _ropePosition = (_ropePosition + 0.15).clamp(0.0, 1.0);
    });
    _nextQuestionOrFinish();
  }

  void _answer(int optionIndex) {
    _timer?.cancel();
    int timeSpent = 10 - _questionTimer;

    setState(() {
      _selectedOption = optionIndex;
      bool isCorrect = optionIndex == _questions[_currentIndex]['answer'];

      if (isCorrect) {
        double pullForce = timeSpent <= 3 ? 0.25 : 0.15;
        _ropePosition = (_ropePosition - pullForce).clamp(0.0, 1.0);
      } else {
        _ropePosition = (_ropePosition + 0.15).clamp(0.0, 1.0);
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
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(
          isWinner ? 'Sesi Simulasi Berhasil' : 'Sesi Selesai',
          textAlign: TextAlign.center,
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: isWinner ? Colors.green.shade700 : Colors.orange.shade800),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(isWinner ? Icons.task_alt_rounded : Icons.info_outline_rounded, size: 50, color: isWinner ? Colors.green : Colors.orange),
            const SizedBox(height: 12),
            Text(
              isWinner
                  ? 'Anda berhasil mengungguli sesi di ruang ${widget.roomCode}.\n\nXP Diperoleh: +200 XP'
                  : 'Sesi berakhir pada ruang ${widget.roomCode}.\n\nXP Diperoleh: +50 XP',
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 12, color: Color(0xFF475569)),
            ),
          ],
        ),
        actions: [
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Theme.of(context).primaryColor, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))),
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context, isWinner ? 200 : 50);
            },
            child: const Text('KEMBALI', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (!_isGameStarted) {
      return Scaffold(
        backgroundColor: const Color(0xFF1E293B),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('MEMULAI SESI...', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white, letterSpacing: 1.2)),
              const SizedBox(height: 16),
              CircleAvatar(
                radius: 36,
                backgroundColor: Colors.white10,
                child: Text('$_startCountdown', style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.white)),
              ),
              const SizedBox(height: 16),
              Text(
                'Kode Sesi: ${widget.roomCode}',
                style: const TextStyle(fontSize: 12, color: Colors.white70),
              ),
            ],
          ),
        ),
      );
    }

    final q = _questions[_currentIndex];

    return Scaffold(
      appBar: AppBar(
        title: Text('Sesi Ruang: ${widget.roomCode}', style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        elevation: 0,
        actions: [
          Center(
            child: Container(
              margin: const EdgeInsets.only(right: 16),
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(color: Colors.grey.shade100, borderRadius: BorderRadius.circular(6)),
              child: Text('$_questionTimer dtk', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Colors.red)),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            color: Colors.white,
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(widget.playerName, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Colors.blue)),
                    Text(widget.opponentName, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Colors.grey)),
                  ],
                ),
                const SizedBox(height: 8),
                Stack(
                  alignment: Alignment.center,
                  children: [
                    Container(height: 8, width: double.infinity, decoration: BoxDecoration(color: Colors.grey.shade200, borderRadius: BorderRadius.circular(4))),
                    AnimatedAlign(
                      duration: const Duration(milliseconds: 400),
                      alignment: Alignment((_ropePosition * 2) - 1, 0),
                      child: Container(width: 14, height: 14, decoration: const BoxDecoration(color: Color(0xFF3B82F6), shape: BoxShape.circle)),
                    ),
                  ],
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
                  Text('Pertanyaan ${_currentIndex + 1} dari ${_questions.length}', style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Colors.grey)),
                  const SizedBox(height: 8),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: const Color(0xFF1E1E2E),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      q['question'],
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFFA6ADC8),
                        fontFamily: 'monospace',
                        height: 1.4,
                      ),
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
                          margin: const EdgeInsets.only(bottom: 8),
                          decoration: BoxDecoration(
                            color: btnColor,
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: borderColor, width: 1.2),
                          ),
                          child: ListTile(
                            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
                            title: Text(optionText, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
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