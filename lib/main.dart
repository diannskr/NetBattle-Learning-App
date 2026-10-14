import 'package:flutter/material.dart';

void main() {
  runApp(const NetBattleApp());
}

// ---------------------------------------------------------------------------
// APP ROOT & DYNAMIC THEME STATE MANAGEMENT
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
      title: 'NetBattle Learning',
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
              child: const Icon(
                Icons.sports_esports_rounded,
                size: 90,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'NETBATTLE ARENA',
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
                letterSpacing: 2,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Belajar Seru, Taklukkan Tantangan!',
              style: TextStyle(
                fontSize: 14,
                color: Colors.white70,
              ),
            ),
            const SizedBox(height: 48),
            const CircularProgressIndicator(
              color: Colors.amberAccent,
            ),
          ],
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// 2. FORM AUTHENTICATION (LOGIN & REGISTRASI BENERAN)
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
  final TextEditingController _usernameController = TextEditingController();

  void _handleAuth() {
    if (_emailController.text.trim().isEmpty || _passwordController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Mohon isi Email dan Password dengan lengkap!')),
      );
      return;
    }

    if (_isSignUp && _usernameController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Mohon isi Username untuk akun baru!')),
      );
      return;
    }

    // Alur Setelah Auth Berhasil: Ke Kustomisasi Maskot Yahoo
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => AvatarCustomizerScreen(
          username: _isSignUp ? _usernameController.text : (_emailController.text.split('@').first),
        ),
      ),
    );
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
                Icon(Icons.shield_moon_rounded, size: 70, color: themeColor),
                const SizedBox(height: 12),
                Text(
                  _isSignUp ? 'Buat Akun NetBattle' : 'Selamat Datang Kembali!',
                  style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Color(0xFF2D3142)),
                ),
                const SizedBox(height: 6),
                Text(
                  _isSignUp ? 'Daftar akun siswa untuk menyimpan seluruh progres' : 'Masuk untuk melanjutkan petualangan kuis',
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 12, color: Colors.black54),
                ),
                const SizedBox(height: 32),

                if (_isSignUp) ...[
                  TextField(
                    controller: _usernameController,
                    decoration: InputDecoration(
                      labelText: 'Username Siswa',
                      prefixIcon: const Icon(Icons.person_outline),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
                    ),
                  ),
                  const SizedBox(height: 16),
                ],

                TextField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    labelText: 'Email / ID NISN',
                    prefixIcon: const Icon(Icons.email_outlined),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
                  ),
                ),
                const SizedBox(height: 16),

                TextField(
                  controller: _passwordController,
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: 'Password',
                    prefixIcon: const Icon(Icons.lock_outline),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
                  ),
                ),
                const SizedBox(height: 24),

                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: themeColor,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                    ),
                    onPressed: _handleAuth,
                    child: Text(
                      _isSignUp ? 'DAFTAR AKUN BARU' : 'MASUK SEKARANG',
                      style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                TextButton(
                  onPressed: () {
                    setState(() {
                      _isSignUp = !_isSignUp;
                    });
                  },
                  child: Text(
                    _isSignUp ? 'Sudah punya akun? Login di sini' : 'Belum punya akun? Daftar sekarang',
                    style: TextStyle(color: themeColor, fontWeight: FontWeight.bold),
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
// 3. MASKOT YAHOO AVATAR CUSTOMIZER (FULL BODY & DYNAMIC THEMES)
// ---------------------------------------------------------------------------
class AvatarCustomizerScreen extends StatefulWidget {
  final String username;
  const AvatarCustomizerScreen({super.key, required this.username});

  @override
  State<AvatarCustomizerScreen> createState() => _AvatarCustomizerScreenState();
}

class _AvatarCustomizerScreenState extends State<AvatarCustomizerScreen> {
  int _headIndex = 0;
  int _outfitIndex = 0;
  int _colorIndex = 0;

  final List<IconData> _heads = [
    Icons.face,
    Icons.face_retouching_natural,
    Icons.smart_toy_outlined,
    Icons.sports_motorsports_rounded,
  ];

  final List<IconData> _outfits = [
    Icons.checkroom_rounded,
    Icons.shield_outlined,
    Icons.sports_esports_outlined,
    Icons.school_outlined,
  ];

  // Pilihan Warna Tema yang Mengubah Seluruh Tampilan Aplikasi
  final List<Map<String, dynamic>> _themeColors = [
    {'name': 'Indigo Hero', 'color': const Color(0xFF6C63FF)},
    {'name': 'Amber Blaze', 'color': Colors.orange},
    {'name': 'Emerald Cyber', 'color': const Color(0xFF00B09B)},
    {'name': 'Amethyst Royal', 'color': const Color(0xFF8E2DE2)},
    {'name': 'Crimson Warrior', 'color': const Color(0xFFE53935)},
  ];

  @override
  Widget build(BuildContext context) {
    Color activeColor = _themeColors[_colorIndex]['color'];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Rakit Maskot Avatar', style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            children: [
              Text(
                'Halo ${widget.username}!',
                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF2D3142)),
              ),
              const SizedBox(height: 4),
              const Text(
                'Pilih kostum maskot & warna elemen tema aplikasi kamu',
                style: TextStyle(fontSize: 12, color: Colors.black54),
              ),
              const SizedBox(height: 20),

              // VISUALISASI MASKOT FULL BODY (ALA YAHOO AVATAR)
              Container(
                width: 180,
                height: 220,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: activeColor.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(color: activeColor, width: 3),
                  boxShadow: [
                    BoxShadow(color: activeColor.withOpacity(0.2), blurRadius: 12, offset: const Offset(0, 6)),
                  ],
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Kepala Maskot
                    Icon(_heads[_headIndex], size: 70, color: activeColor),
                    const SizedBox(height: 2),
                    // Badan / Baju Maskot (Yahoo Style)
                    Icon(_outfits[_outfitIndex], size: 75, color: activeColor.withOpacity(0.85)),
                    const SizedBox(height: 4),
                    // Kaki Maskot
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(width: 14, height: 18, decoration: BoxDecoration(color: activeColor, borderRadius: BorderRadius.circular(4))),
                        const SizedBox(width: 10),
                        Container(width: 14, height: 18, decoration: BoxDecoration(color: activeColor, borderRadius: BorderRadius.circular(4))),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // PILIHAN MODEL KEPALA
              _buildSelectorTitle('1. Aksesori Kepala / Rambut:'),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: List.generate(_heads.length, (i) {
                  return ChoiceChip(
                    label: Icon(_heads[i], size: 20, color: _headIndex == i ? Colors.white : Colors.black87),
                    selected: _headIndex == i,
                    selectedColor: activeColor,
                    onSelected: (val) => setState(() => _headIndex = i),
                  );
                }),
              ),
              const SizedBox(height: 16),

              // PILIHAN KOSTUM BADAN
              _buildSelectorTitle('2. Kostum Pakaian Maskot:'),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: List.generate(_outfits.length, (i) {
                  return ChoiceChip(
                    label: Icon(_outfits[i], size: 20, color: _outfitIndex == i ? Colors.white : Colors.black87),
                    selected: _outfitIndex == i,
                    selectedColor: activeColor,
                    onSelected: (val) => setState(() => _outfitIndex = i),
                  );
                }),
              ),
              const SizedBox(height: 16),

              // PILIHAN WARNA & TEMA APLIKASI
              _buildSelectorTitle('3. Warna Aura (Tema Aplikasi):'),
              Wrap(
                spacing: 10,
                children: List.generate(_themeColors.length, (i) {
                  Color itemColor = _themeColors[i]['color'];
                  return ChoiceChip(
                    avatar: CircleAvatar(backgroundColor: itemColor, radius: 8),
                    label: Text(_themeColors[i]['name'], style: TextStyle(color: _colorIndex == i ? Colors.white : Colors.black87)),
                    selected: _colorIndex == i,
                    selectedColor: itemColor,
                    onSelected: (val) {
                      setState(() => _colorIndex = i);
                      // MENGUBAH TEMA GLOBAL APLIKASI
                      NetBattleApp.of(context).updateThemeColor(itemColor);
                    },
                  );
                }),
              ),
              const SizedBox(height: 28),

              // TOMBOL SIMPAN & KE DASHBOARD
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: activeColor,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                  ),
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => HomeScreen(
                          studentName: widget.username,
                          headIcon: _heads[_headIndex],
                          outfitIcon: _outfits[_outfitIndex],
                          themeColor: activeColor,
                        ),
                      ),
                    );
                  },
                  child: const Text('SIMPAN & MASUK DASHBOARD 🚀', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.white)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSelectorTitle(String text) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 8.0),
        child: Text(text, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// 4. HOME SCREEN (DASHBOARD DENGAN TEMA DINAMIS & MASKOT HASIL RAKITAN)
// ---------------------------------------------------------------------------
class HomeScreen extends StatelessWidget {
  final String studentName;
  final IconData headIcon;
  final IconData outfitIcon;
  final Color themeColor;

  const HomeScreen({
    super.key,
    required this.studentName,
    this.headIcon = Icons.face,
    this.outfitIcon = Icons.checkroom_rounded,
    this.themeColor = const Color(0xFF6C63FF),
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: const [
            Icon(Icons.bolt, color: Colors.amber, size: 28),
            SizedBox(width: 8),
            Text('NetBattle Quest', style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF2D3142))),
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
            // PROFIL MASKOT HASIL KUSTOMISASI DENGAN TEMA DINAMIS
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [themeColor, themeColor.withOpacity(0.75)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(22),
                boxShadow: [
                  BoxShadow(color: themeColor.withOpacity(0.35), blurRadius: 10, offset: const Offset(0, 5)),
                ],
              ),
              child: Row(
                children: [
                  // Mini Preview Maskot Utuh
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.white24,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(headIcon, size: 28, color: Colors.white),
                        Icon(outfitIcon, size: 28, color: Colors.white),
                      ],
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          studentName,
                          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                        ),
                        const SizedBox(height: 4),
                        const Text('Level 5 • 1,250 XP', style: TextStyle(fontSize: 13, color: Colors.white70)),
                        const SizedBox(height: 8),
                        const LinearProgressIndicator(
                          value: 0.7,
                          color: Colors.amberAccent,
                          backgroundColor: Colors.white24,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // STREAK BELAJAR
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.amber.shade50,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.amber.shade200),
              ),
              child: Row(
                children: [
                  const Icon(Icons.local_fire_department, color: Colors.orange, size: 36),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text('Streak Belajar: 3 Hari Beruntun!', style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF2D3142))),
                        SizedBox(height: 2),
                        Text('Ayo selesaikan 1 misi lagi hari ini untuk bonus XP!', style: TextStyle(fontSize: 12, color: Colors.black54)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            const Text('Pilih Misi Belajarmu', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF2D3142))),
            const SizedBox(height: 14),

            // 1. QUEST PETUALANGAN MATERI
            _buildGameCard(
              context,
              title: 'Quest Petualangan Materi',
              subtitle: 'Pelajari materi lewat cerita interaktif yang seru',
              icon: Icons.map_rounded,
              color: Colors.green,
              xp: '+150 XP',
              onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const QuestScreen())),
            ),
            const SizedBox(height: 12),

            // 2. BATTLE TARIK TAMBANG
            _buildGameCard(
              context,
              title: 'Battle Tarik Tambang (1v1)',
              subtitle: 'Buat room atau masukkan kode teman untuk tanding!',
              icon: Icons.sports_kabaddi_rounded,
              color: Colors.orange,
              xp: '+200 XP',
              onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const CustomRoomScreen())),
            ),
            const SizedBox(height: 12),

            // 3. BATTLE KUIS KILAT
            _buildGameCard(
              context,
              title: 'Battle Kuis Kilat (Solo)',
              subtitle: 'Jawab soal cepat berebut skor individu',
              icon: Icons.flash_on_rounded,
              color: themeColor,
              xp: '+100 XP',
              onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const QuizBattleScreen())),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGameCard(
    BuildContext context, {
    required String title,
    required String subtitle,
    required IconData icon,
    required Color color,
    required String xp,
    required VoidCallback onTap,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 8, offset: const Offset(0, 3)),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Icon(icon, color: color, size: 30),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF2D3142))),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: Colors.amber.shade100,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              xp,
                              style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.amber.shade900),
                            ),
                          ),
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
// 5. QUEST SCREEN
// ---------------------------------------------------------------------------
class QuestScreen extends StatelessWidget {
  const QuestScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> stages = [
      {'title': 'Babak 1: Dasar-Dasar Jaringan', 'desc': 'Pahami IP Address, Mac Address & Topologi', 'status': 'completed', 'xp': '150 XP'},
      {'title': 'Babak 2: Pengenalan Protokol HTTP & HTTPS', 'desc': 'Bagaimana cara web bekerja di balik layar', 'status': 'active', 'xp': '200 XP'},
      {'title': 'Babak 3: Keamanan Cyber & Firewall', 'desc': 'Lindungi data dari serangan hacker', 'status': 'locked', 'xp': '250 XP'},
      {'title': 'Babak 4: Routing & Switching Lanjutan', 'desc': 'Membaca peta jalan data lalu lintas internet', 'status': 'locked', 'xp': '300 XP'},
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Peta Petualangan Materi', style: TextStyle(color: Color(0xFF2D3142), fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
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
                  const Icon(Icons.explore_rounded, size: 50, color: Colors.white),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text('Dunia Jaringan Komputer', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
                        SizedBox(height: 4),
                        Text('Selesaikan setiap babak materi untuk membuka area baru!', style: TextStyle(fontSize: 12, color: Colors.white70)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            const Text('Daftar Babak (Stage)', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF2D3142))),
            const SizedBox(height: 16),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: stages.length,
              itemBuilder: (context, index) {
                final stage = stages[index];
                final status = stage['status'];

                Color badgeColor = status == 'completed' ? Colors.green : (status == 'active' ? Colors.orange : Colors.grey);
                IconData statusIcon = status == 'completed' ? Icons.check_circle_rounded : (status == 'active' ? Icons.play_circle_fill_rounded : Icons.lock_outline_rounded);

                return Container(
                  margin: const EdgeInsets.only(bottom: 16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(color: status == 'active' ? Colors.orange : Colors.grey.shade200, width: status == 'active' ? 2 : 1),
                  ),
                  child: ListTile(
                    contentPadding: const EdgeInsets.all(16),
                    leading: CircleAvatar(radius: 26, backgroundColor: badgeColor.withOpacity(0.15), child: Icon(statusIcon, color: badgeColor, size: 28)),
                    title: Text(stage['title'], style: TextStyle(fontWeight: FontWeight.bold, color: status == 'locked' ? Colors.grey : const Color(0xFF2D3142))),
                    subtitle: Text(stage['desc'], style: TextStyle(fontSize: 12, color: status == 'locked' ? Colors.grey.shade400 : Colors.grey.shade600)),
                    trailing: status == 'locked' ? const Icon(Icons.lock, color: Colors.grey) : const Icon(Icons.arrow_forward_ios_rounded, size: 18, color: Colors.grey),
                    onTap: () {
                      if (status == 'locked') {
                        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('🔒 Babak ini masih terkunci! Selesaikan babak sebelumnya dulu.')));
                      } else {
                        _showMaterialDialog(context, stage['title']);
                      }
                    },
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showMaterialDialog(BuildContext context, String title) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        content: const Text(
          'HTTP (Hypertext Transfer Protocol) adalah protokol tempat data dikirimkan antara browser dan website. Sedangkan HTTPS menggunakan enkripsi SSL/TLS agar data aman!',
          style: TextStyle(fontSize: 13, height: 1.4),
        ),
        actions: [
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Theme.of(context).primaryColor),
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('🎉 Selamat! Materi selesai dibaca, +200 XP!')));
            },
            child: const Text('SELESAIKAN QUEST', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// 6. QUIZ BATTLE SCREEN (SOLO)
// ---------------------------------------------------------------------------
class QuizBattleScreen extends StatefulWidget {
  const QuizBattleScreen({super.key});

  @override
  State<QuizBattleScreen> createState() => _QuizBattleScreenState();
}

class _QuizBattleScreenState extends State<QuizBattleScreen> {
  int _score = 0;
  int _currentQuestionIndex = 0;
  int? _selectedOption;

  final List<Map<String, dynamic>> _questions = [
    {'question': 'Protokol apa yang digunakan untuk mengirim pesan web secara aman?', 'options': ['HTTP', 'HTTPS', 'FTP', 'SSH'], 'answer': 1},
    {'question': 'Perangkat keras mana yang berfungsi menghubungkan dua jaringan berbeda?', 'options': ['Switch', 'Hub', 'Router', 'Kabel LAN'], 'answer': 2},
    {'question': 'Di bawah ini mana yang merupakan bahasa pemrograman Flutter?', 'options': ['Java', 'Python', 'Dart', 'PHP'], 'answer': 2},
  ];

  void _answerQuestion(int optionIndex) {
    setState(() {
      _selectedOption = optionIndex;
      if (optionIndex == _questions[_currentQuestionIndex]['answer']) {
        _score += 100;
      }
    });

    Future.delayed(const Duration(seconds: 1), () {
      if (_currentQuestionIndex < _questions.length - 1) {
        setState(() {
          _currentQuestionIndex++;
          _selectedOption = null;
        });
      } else {
        _showResultDialog();
      }
    });
  }

  void _showResultDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('🎉 PERTANDINGAN SELESAI!', textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.bold)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.emoji_events, size: 70, color: Colors.amber),
            const SizedBox(height: 12),
            Text('Total Skor Kamu:\n$_score XP', textAlign: TextAlign.center, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context);
            },
            child: const Text('KEMBALI KE HUB', style: TextStyle(fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final currentQ = _questions[_currentQuestionIndex];

    return Scaffold(
      appBar: AppBar(
        title: Text('Soal ${_currentQuestionIndex + 1} / ${_questions.length}', style: const TextStyle(color: Color(0xFF2D3142), fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            LinearProgressIndicator(value: (_currentQuestionIndex + 1) / _questions.length, color: Theme.of(context).primaryColor),
            const SizedBox(height: 24),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20), border: Border.all(color: Colors.grey.shade200)),
              child: Text(currentQ['question'], style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF2D3142))),
            ),
            const SizedBox(height: 24),
            Expanded(
              child: ListView.builder(
                itemCount: (currentQ['options'] as List).length,
                itemBuilder: (context, index) {
                  final isSelected = _selectedOption == index;
                  final isCorrect = index == currentQ['answer'];

                  return Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    decoration: BoxDecoration(
                      color: isSelected ? (isCorrect ? Colors.green.shade50 : Colors.red.shade50) : Colors.white,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: isSelected ? (isCorrect ? Colors.green : Colors.red) : Colors.grey.shade200, width: 1.5),
                    ),
                    child: ListTile(
                      title: Text(currentQ['options'][index], style: const TextStyle(fontWeight: FontWeight.w600)),
                      onTap: _selectedOption == null ? () => _answerQuestion(index) : null,
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
// 7. CUSTOM ROOM SCREEN
// ---------------------------------------------------------------------------
class CustomRoomScreen extends StatefulWidget {
  const CustomRoomScreen({super.key});

  @override
  State<CustomRoomScreen> createState() => _CustomRoomScreenState();
}

class _CustomRoomScreenState extends State<CustomRoomScreen> {
  final TextEditingController _codeController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Battle Tarik Tambang (Room)', style: TextStyle(color: Color(0xFF2D3142), fontWeight: FontWeight.bold)),
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
                        Text('Adu Tanding 1v1', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
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
                  const Text('Buat Ruang Pertandingan', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(backgroundColor: Theme.of(context).primaryColor, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
                      onPressed: () => _showCreatedRoomDialog(context),
                      child: const Text('BUAT ROOM TARIK TAMBANG', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
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
                  const Text('Gabung Room Teman', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 16),
                  TextField(
                    controller: _codeController,
                    textCapitalization: TextCapitalization.characters,
                    decoration: InputDecoration(
                      hintText: 'Contoh: NET889',
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
                          Navigator.push(context, MaterialPageRoute(builder: (context) => TugOfWarQuizScreen(roomCode: _codeController.text.toUpperCase())));
                        }
                      },
                      child: const Text('GABUNG DAN TARIK TAMBANG!'),
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

  void _showCreatedRoomDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('🎮 ROOM DIBUAT!', textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.bold)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Bagikan kode ini ke temanmu:', style: TextStyle(fontSize: 12)),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              decoration: BoxDecoration(color: Colors.purple.shade50, borderRadius: BorderRadius.circular(12)),
              child: const Text('NET889', style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, letterSpacing: 4, color: Colors.purple)),
            ),
          ],
        ),
        actions: [
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Theme.of(context).primaryColor),
            onPressed: () {
              Navigator.pop(context);
              Navigator.push(context, MaterialPageRoute(builder: (context) => const TugOfWarQuizScreen(roomCode: 'NET889')));
            },
            child: const Text('MASUK ARENA', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// 8. TUG OF WAR QUIZ SCREEN (TARIK TAMBANG)
// ---------------------------------------------------------------------------
class TugOfWarQuizScreen extends StatefulWidget {
  final String roomCode;
  const TugOfWarQuizScreen({super.key, required this.roomCode});

  @override
  State<TugOfWarQuizScreen> createState() => _TugOfWarQuizScreenState();
}

class _TugOfWarQuizScreenState extends State<TugOfWarQuizScreen> {
  double _ropePosition = 0.5;
  int _currentQuestionIndex = 0;
  int? _selectedOption;

  final List<Map<String, dynamic>> _questions = [
    {'question': 'Protokol apa yang digunakan untuk mengirim pesan web secara aman?', 'options': ['HTTP', 'HTTPS', 'FTP', 'SSH'], 'answer': 1},
    {'question': 'Perangkat keras mana yang berfungsi menghubungkan dua jaringan berbeda?', 'options': ['Switch', 'Hub', 'Router', 'Kabel LAN'], 'answer': 2},
    {'question': 'Di bawah ini mana yang merupakan bahasa pemrograman Flutter?', 'options': ['Java', 'Python', 'Dart', 'PHP'], 'answer': 2},
  ];

  void _answerQuestion(int optionIndex) {
    setState(() {
      _selectedOption = optionIndex;
      if (optionIndex == _questions[_currentQuestionIndex]['answer']) {
        _ropePosition = (_ropePosition - 0.25).clamp(0.0, 1.0);
      } else {
        _ropePosition = (_ropePosition + 0.25).clamp(0.0, 1.0);
      }
    });

    Future.delayed(const Duration(milliseconds: 1200), () {
      if (_currentQuestionIndex < _questions.length - 1 && _ropePosition > 0.0 && _ropePosition < 1.0) {
        setState(() {
          _currentQuestionIndex++;
          _selectedOption = null;
        });
      } else {
        _showMatchResult();
      }
    });
  }

  void _showMatchResult() {
    bool isWinner = _ropePosition < 0.5;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(isWinner ? '🎉 KAMU MENANG!' : '💥 TEMANMU MENANG!', textAlign: TextAlign.center, style: TextStyle(color: isWinner ? Colors.green : Colors.red, fontWeight: FontWeight.bold)),
        actions: [
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Theme.of(context).primaryColor),
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context);
              Navigator.pop(context);
            },
            child: const Text('KEMBALI KE HUB', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final currentQ = _questions[_currentQuestionIndex];

    return Scaffold(
      appBar: AppBar(
        title: Text('Arena Room: ${widget.roomCode}', style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF2D3142))),
        backgroundColor: Colors.white,
        elevation: 0,
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
                  children: const [
                    Text('Kamu', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blue)),
                    Text('Teman (Lawan)', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.red)),
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
              ],
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Soal ${_currentQuestionIndex + 1} / ${_questions.length}', style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.grey)),
                  const SizedBox(height: 8),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(18),
                    decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), border: Border.all(color: Colors.grey.shade200)),
                    child: Text(currentQ['question'], style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF2D3142))),
                  ),
                  const SizedBox(height: 16),
                  Expanded(
                    child: ListView.builder(
                      itemCount: (currentQ['options'] as List).length,
                      itemBuilder: (context, index) {
                        final isSelected = _selectedOption == index;
                        final isCorrect = index == currentQ['answer'];

                        return Container(
                          margin: const EdgeInsets.only(bottom: 10),
                          decoration: BoxDecoration(
                            color: isSelected ? (isCorrect ? Colors.green.shade50 : Colors.red.shade50) : Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: isSelected ? (isCorrect ? Colors.green : Colors.red) : Colors.grey.shade200, width: 1.5),
                          ),
                          child: ListTile(
                            title: Text(currentQ['options'][index], style: const TextStyle(fontWeight: FontWeight.w600)),
                            onTap: _selectedOption == null ? () => _answerQuestion(index) : null,
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