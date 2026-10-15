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
          builder: (context) => AvatarCustomizerScreen(username: name, isInitialSetup: true),
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
// 4. HOME SCREEN (XP & LEVEL KOSONG AWAL = 0)
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
  int _userXP = 0; // Dimulai dari 0
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
            const Text('Menu Misi Belajar Pemrograman', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF2D3142))),
            const SizedBox(height: 14),

            _buildGameCard(
              context,
              title: 'Quest: Modul Materi (8 Babak)',
              subtitle: 'Pelajari konsep mendalam & buka babak selanjutnya otomatis',
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
                  MaterialPageRoute(builder: (context) => CustomRoomScreen(currentUserName: widget.studentName)),
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
// 5. QUEST SCREEN (1 BOX DOKUMEN BERSIH TANPA STIKER)
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
        },
        {
          'header': '4. Kesalahan Umum (Common Errors)',
          'body': '1. Mengisi nilai teks tanpa tanda petik: String nama = Satria; (Harus "Satria")\n2. Lupa tanda titik koma (;) di akhir baris kode.'
        }
      ],
      'xp': 150
    },
    {
      'title': 'Babak 2: Tipe Data Dasar & Operator Aritmatika',
      'desc': 'Modul Lengkap: int, double, String, bool, serta perhitungan matematika.',
      'sections': [
        {
          'header': '1. Pengenalan Tipe Data Statis',
          'body': 'Tipe data menentukan jenis nilai apa yang boleh disimpan dalam sebuah variabel:\n- int (Integer): Bilangan bulat positif/negatif (contoh: 10, -5, 100).\n- double / float: Angka desimal bertitik (contoh: 3.14, 85.5).\n- String: Deretan karakter teks di dalam tanda petik.\n- bool (Boolean): Nilai logika yang hanya bernilai true atau false.'
        },
        {
          'header': '2. Operator Aritmatika Dasar',
          'body': 'Operasi Matematika dalam koding:\n- Penjumlahan (+)\n- Pengurangan (-)\n- Perkalian (*)\n- Pembagian (/)\n- Modulo / Sisa Bagi (%) : Menghitung sisa hasil pembagian.'
        },
        {
          'header': '3. Studi Kasus Perhitungan Toko',
          'isCode': true,
          'body': 'int hargaBarang = 15000;\nint jumlahBeli = 3;\nint totalHarga = hargaBarang * jumlahBeli;\n\ndouble pajak = totalHarga * 0.1; // Pajak 10%\ndouble totalBayar = totalHarga + pajak;\n\nprint("Total Akhir: Rp " + totalBayar.toString());'
        },
        {
          'header': '4. Rangkuman Logika Modulo (%)',
          'body': 'Operator modulo % sangat berguna untuk mengecek apakah suatu angka genap atau ganjil.\nContoh: 10 % 2 == 0 (Genap), sedangkan 7 % 2 == 1 (Ganjil).'
        }
      ],
      'xp': 150
    },
    {
      'title': 'Babak 3: Percabangan Logika (If - Else)',
      'desc': 'Modul Lengkap: Pengambilan keputusan otomatis berdasarkan ekspresi Boolean.',
      'sections': [
        {
          'header': '1. Mengapa Perlu Percabangan?',
          'body': 'Program yang cerdas harus bisa mengambil keputusan berbeda berdasarkan kondisi nyata. Contoh: Jika password benar maka izinkan masuk, jika salah maka tampilkan error.'
        },
        {
          'header': '2. Operator Perbandingan (Relational Operators)',
          'body': 'Kondisi IF dibentuk menggunakan operator relasional:\n- == (Sama dengan)\n- != (Tidak sama dengan)\n- > (Lebih besar)\n- < (Lebih kecil)\n- >= (Lebih besar atau sama dengan)\n- <= (Lebih kecil atau sama dengan)'
        },
        {
          'header': '3. Kode Sistem Kelulusan Ujian',
          'isCode': true,
          'body': 'int nilaiSiswa = 78;\nint batasLulus = 75;\n\nif (nilaiSiswa >= batasLulus) {\n  print("Selamat, Anda dinyatakan LULUS!");\n} else {\n  print("Mohon maaf, Anda harus mengikuti REMIDI.");\n}'
        },
        {
          'header': '4. Kesalahan Paling Sering Terjadi',
          'body': 'Tertukar antara = dan ==!\nSatu sama dengan (=) digunakan untuk MENGISI NILAI ke variabel.\nDua sama dengan (==) digunakan untuk MEMBANDINGKAN dua nilai.'
        }
      ],
      'xp': 200
    },
    {
      'title': 'Babak 4: Percabangan Majemuk (Else If & Logical Operators)',
      'desc': 'Modul Lengkap: Logika DAN (&&), ATAU (||), serta pengkondisian bersarang.',
      'sections': [
        {
          'header': '1. Menangani Lebih dari 2 Pilihan Kondisi',
          'body': 'Ketika pilihan hasil logika bertingkat (misal menentukan Nilai Huruf A, B, C, D, E), gunakan struktur Else If.'
        },
        {
          'header': '2. Operator Logika Kombinasi (&& dan ||)',
          'body': '- AND (&&): Kedua syarat HARUS bernilai TRUE agar kondisi terpenuhi.\n- OR (||): Cukup SALAH SATU syarat bernilai TRUE agar kondisi terpenuhi.\n- NOT (!): Membalikkan nilai logika (true menjadi false).'
        },
        {
          'header': '3. Contoh Penilaian Grade Akademik',
          'isCode': true,
          'body': 'int nilai = 88;\n\nif (nilai >= 85) {\n  print("Grade A - Sangat Memuaskan");\n} else if (nilai >= 75) {\n  print("Grade B - Baik");\n} else if (nilai >= 60) {\n  print("Grade C - Cukup");\n} else {\n  print("Grade D - Perlu Bimbingan");\n}'
        }
      ],
      'xp': 200
    },
    {
      'title': 'Babak 5: Perulangan Terhitung (For Loop)',
      'desc': 'Modul Lengkap: Otomasisasi tugas berulang dengan counter increment/decrement.',
      'sections': [
        {
          'header': '1. Efisiensi Eksekusi Berulang',
          'body': 'Bayangkan kamu diminta mencetak tulisan "Saya Tidak Akan Terlambat" sebanyak 100 kali. Tanpa loop, kamu harus menulis 100 baris print. Dengan For Loop, cukup 3 baris kode!'
        },
        {
          'header': '2. Structure For Loop',
          'body': 'for (inisialisasi; kondisi_batas; iterasi) {\n  // kode yang diulang\n}\n\n1. Inisialisasi: int i = 1 (Nilai awal hitungan).\n2. Kondisi: i <= 5 (Selama i kurang dari sama dengan 5, terus ulang).\n3. Iterasi: i++ (Tambahkan i sebesar 1 setiap kali 1 putaran selesai).'
        },
        {
          'header': '3. Contoh Kode Cetak Perkalian 5',
          'isCode': true,
          'body': 'for (int i = 1; i <= 10; i++) {\n  int hasil = 5 * i;\n  print("5 x " + i.toString() + " = " + hasil.toString());\n}'
        }
      ],
      'xp': 250
    },
    {
      'title': 'Babak 6: Perulangan Kondisional (While & Do-While)',
      'desc': 'Modul Lengkap: Loop tak terhitung berbasis kondisi dinamis dan Infinite Loop Hazard.',
      'sections': [
        {
          'header': '1. Kapan Menggunakan While Loop?',
          'body': 'While Loop digunakan ketika jumlah perulangan TIDAK DIKETAHUI secara pasti di awal, melainkan bergantung pada peristiwa saat program berjalan (contoh: mengulang input hingga user mengetik "stop").'
        },
        {
          'header': '2. Bahaya Infinite Loop (Perulangan Abadi)',
          'body': 'Jika kondisi dalam While selalu bernilai TRUE dan tidak ada pembaruan nilai variabel, aplikasi akan crash/hang karena kehabisan memori!'
        },
        {
          'header': '3. Contoh Game Nyawa Karakter',
          'isCode': true,
          'body': 'int nyawaPemain = 3;\n\nwhile (nyawaPemain > 0) {\n  print("Pemain bertarung... Nyawa tersisa: " + nyawaPemain.toString());\n  nyawaPemain--; // Mengurangi nyawa\n}\nprint("GAME OVER!");'
        }
      ],
      'xp': 250
    },
    {
      'title': 'Babak 7: Fungsi / Subprogram (Method & Return Value)',
      'desc': 'Modul Lengkap: Pemrograman modular, pemanggilan parameter, dan nilai kembalian.',
      'sections': [
        {
          'header': '1. Prinsip DRY (Don\'t Repeat Yourself)',
          'body': 'Fungsi adalah sekelompok baris kode yang diberi nama khusus untuk menjalankan tugas spesifik. Fungsi dapat dipanggil berulang kali dari bagian program mana pun.'
        },
        {
          'header': '2. Void vs Return Value Function',
          'body': '- Void Function: Fungsi yang HANYA menjalankan perintah tanpa mengembalikan nilai data hasil.\n- Return Function: Fungsi yang mengolah data lalu MENGEMBALIKAN (return) sebuah nilai hasil perhitungan.'
        },
        {
          'header': '3. Contoh Kode Fungsi Matematika',
          'isCode': true,
          'body': '// Definisi Fungsi\nint hitungLuasPersegi(int panjang, int lebar) {\n  return panjang * lebar;\n}\n\n// Pemanggilan Fungsi di Main Program\nvoid main() {\n  int hasilLuas = hitungLuasPersegi(10, 4);\n  print("Luas Tanah: " + hasilLuas.toString() + " m2");\n}'
        }
      ],
      'xp': 300
    },
    {
      'title': 'Babak 8: Struktur Data Array / List & Manipulasinya',
      'desc': 'Modul Lengkap: Koleksi data sejenis, elemen Zero-Indexed, dan looping elemen List.',
      'sections': [
        {
          'header': '1. Apa itu Array / List?',
          'body': 'Daripada membuat 10 variabel terpisah (siswa1, siswa2, ..., siswa10), kita bisa menyimpan kesepuluh nama siswa tersebut di dalam satu variabel List tunggal.'
        },
        {
          'header': '2. Konsep Indeks Nol (Zero-Indexed)',
          'body': 'Komputer selalu menghitung urutan elemen dalam List dimulai dari posisi angka 0, bukan 1!\n- Elemen ke-1 -> Indeks [0]\n- Elemen ke-2 -> Indeks [1]\n- Elemen ke-N -> Indeks [N-1]'
        },
        {
          'header': '3. Contoh Manipulasi List di Dart',
          'isCode': true,
          'body': 'List<String> daftarHero = ["Miya", "Layla", "Alucard"];\n\n// Menambah data baru\ndaftarHero.add("Zilong");\n\n// Mengakses elemen pertama\nprint("Hero Utama: " + daftarHero[0]); // Output: Miya\n\n// Menampilkan semua item menggunakan For Loop\nfor (int i = 0; i < daftarHero.length; i++) {\n  print("Hero " + i.toString() + ": " + daftarHero[i]);\n}'
        }
      ],
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
              leading: CircleAvatar(radius: 26, backgroundColor: badgeColor.withOpacity(0.15), child: Icon(statusIcon, color: badgeColor, size: 28)),
              title: Text(stage['title'], style: TextStyle(fontWeight: FontWeight.bold, color: isUnlocked ? const Color(0xFF2D3142) : Colors.grey)),
              subtitle: Text(stage['desc'], style: TextStyle(fontSize: 12, color: isUnlocked ? Colors.grey.shade600 : Colors.grey.shade400)),
              trailing: isUnlocked ? const Icon(Icons.arrow_forward_ios_rounded, size: 18) : const Icon(Icons.lock),
              onTap: () {
                if (!isUnlocked) {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Selesaikan babak sebelumnya terlebih dahulu!')));
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
            child: Container(
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
          ),
        ),
        actions: [
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Theme.of(context).primaryColor),
            onPressed: () {
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
      'question': 'Kata kunci apa yang digunakan sebagai alternatif jika kondisi IF bernilai FALSE?',
      'options': ['then', 'else', 'other', 'default'],
      'answer': 1,
    },
    {
      'question': 'Sintaks deklarasi variabel bilangan bulat berangka 25:\n\n____ umur = 25;',
      'options': ['String', 'bool', 'int', 'double'],
      'answer': 2,
    },
    {
      'question': 'Manakah operator yang digunakan untuk membandingkan dua nilai "SAMA DENGAN"?',
      'options': ['=', '==', '!=', '=>'],
      'answer': 1,
    },
    {
      'question': 'Kata kunci yang digunakan untuk menghentikan perulangan (loop) secara paksa:',
      'options': ['stop', 'exit', 'break', 'return'],
      'answer': 2,
    },
    {
      'question': 'Tipe data yang hanya bernilai benar (true) atau salah (false) adalah:',
      'options': ['int', 'bool', 'String', 'char'],
      'answer': 1,
    },
    {
      'question': 'Kata kunci yang digunakan untuk mendefinisikan sebuah fungsi tanpa mengembalikan nilai (return):',
      'options': ['null', 'empty', 'void', 'static'],
      'answer': 2,
    },
    {
      'question': 'Bagaimanakah cara mengambil jumlah elemen pada variabel List bernama angka?',
      'options': ['angka.size', 'angka.length', 'angka.count', 'angka.total'],
      'answer': 1,
    },
    {
      'question': 'Simbol apa yang digunakan untuk menambahkan komentar satu baris pada kode Dart/Java?',
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
                  BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 10, offset: const Offset(0, 4)),
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
                        BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 6, offset: const Offset(0, 2)),
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
                  colors: [Theme.of(context).primaryColor, Theme.of(context).primaryColor.withOpacity(0.7)],
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
// 8. TUG OF WAR MULTIPLAYER ENGINE (SEIMBANG: BUTUH MINIMAL 5 POINT UNTUK MENANG)
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
  double _ropePosition = 0.5; // Posisi awal persis di tengah
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

      // RUMUS TARIKAN SEIMBANG:
      // Dari tengah (0.5), dibutuhkan minimal 5 poin (0.1 x 5 = 0.5) untuk mencapai batas 0.0 (Menang).
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
                        BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 10, offset: const Offset(0, 4)),
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