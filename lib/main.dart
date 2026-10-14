import 'package:flutter/material.dart';

void main() {
  runApp(const NetBattleApp());
}

class NetBattleApp extends StatelessWidget {
  const NetBattleApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'NetBattle Learning',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.light,
        primarySwatch: Colors.amber,
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
          MaterialPageRoute(builder: (context) => const HomeScreen()),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF6C63FF),
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
// 2. HOME SCREEN (Dashboard Utama)
// ---------------------------------------------------------------------------
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: const [
            Icon(Icons.bolt, color: Colors.amber, size: 28),
            SizedBox(width: 8),
            Text(
              'NetBattle Quest',
              style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF2D3142)),
            ),
          ],
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.emoji_events, color: Colors.amber),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Profil Siswa
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF6C63FF), Color(0xFF4834DF)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF6C63FF).withOpacity(0.4),
                    blurRadius: 10,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: Row(
                children: [
                  const CircleAvatar(
                    radius: 32,
                    backgroundColor: Colors.white24,
                    child: Icon(Icons.face, size: 40, color: Colors.white),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text(
                          'Satria (Hero)',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          'Level 5 • 1,250 XP',
                          style: TextStyle(fontSize: 13, color: Colors.white70),
                        ),
                        SizedBox(height: 8),
                        LinearProgressIndicator(
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

            // Streak Belajar
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
                        Text(
                          'Streak Belajar: 3 Hari Beruntun!',
                          style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF2D3142)),
                        ),
                        SizedBox(height: 2),
                        Text(
                          'Ayo selesaikan 1 misi lagi hari ini untuk bonus XP!',
                          style: TextStyle(fontSize: 12, color: Colors.black54),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            const Text(
              'Pilih Misi Belajarmu',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF2D3142),
              ),
            ),
            const SizedBox(height: 14),

            // 1. QUEST PETUALANGAN MATERI
            _buildGameCard(
              context,
              title: 'Quest Petualangan Materi',
              subtitle: 'Pelajari materi lewat cerita interaktif yang seru',
              icon: Icons.map_rounded,
              color: Colors.green,
              xp: '+150 XP',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const QuestScreen()),
                );
              },
            ),
            const SizedBox(height: 12),

            // 2. BATTLE TARIK TAMBANG (Bisa via Kode Room)
            _buildGameCard(
              context,
              title: 'Battle Tarik Tambang (1v1)',
              subtitle: 'Buat room atau masukkan kode teman untuk tanding!',
              icon: Icons.sports_kabaddi_rounded,
              color: Colors.orange,
              xp: '+200 XP',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const CustomRoomScreen()),
                );
              },
            ),
            const SizedBox(height: 12),

            // 3. BATTLE KUIS KILAT
            _buildGameCard(
              context,
              title: 'Battle Kuis Kilat (Solo)',
              subtitle: 'Jawab soal cepat berebut skor individu',
              icon: Icons.flash_on_rounded,
              color: Colors.purple,
              xp: '+100 XP',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const QuizBattleScreen()),
                );
              },
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
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
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
                            child: Text(
                              title,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF2D3142),
                              ),
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: Colors.amber.shade100,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              xp,
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                                color: Colors.amber.shade900,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Text(
                        subtitle,
                        style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                      ),
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
// 3. QUEST SCREEN (Peta Petualangan)
// ---------------------------------------------------------------------------
class QuestScreen extends StatelessWidget {
  const QuestScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> stages = [
      {
        'title': 'Babak 1: Dasar-Dasar Jaringan',
        'desc': 'Pahami IP Address, Mac Address & Topologi',
        'status': 'completed',
        'stars': 3,
        'xp': '150 XP',
      },
      {
        'title': 'Babak 2: Pengenalan Protokol HTTP & HTTPS',
        'desc': 'Bagaimana cara web bekerja di balik layar',
        'status': 'active',
        'stars': 0,
        'xp': '200 XP',
      },
      {
        'title': 'Babak 3: Keamanan Cyber & Firewall',
        'desc': 'Lindungi data dari serangan hacker',
        'status': 'locked',
        'stars': 0,
        'xp': '250 XP',
      },
      {
        'title': 'Babak 4: Routing & Switching Lanjutan',
        'desc': 'Membaca peta jalan data lalu lintas internet',
        'status': 'locked',
        'stars': 0,
        'xp': '300 XP',
      },
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Peta Petualangan Materi',
          style: TextStyle(color: Color(0xFF2D3142), fontWeight: FontWeight.bold),
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
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF00B09B), Color(0xFF96C93D)],
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
                      children: [
                        const Text(
                          'Dunia Jaringan Komputer',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Selesaikan setiap babak materi untuk membuka area baru!',
                          style: TextStyle(fontSize: 12, color: Colors.white.withOpacity(0.9)),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'Daftar Babak (Stage)',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF2D3142),
              ),
            ),
            const SizedBox(height: 16),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: stages.length,
              itemBuilder: (context, index) {
                final stage = stages[index];
                final status = stage['status'];

                Color cardColor = Colors.white;
                Color badgeColor = Colors.grey;
                IconData statusIcon = Icons.lock_outline_rounded;

                if (status == 'completed') {
                  badgeColor = Colors.green;
                  statusIcon = Icons.check_circle_rounded;
                } else if (status == 'active') {
                  badgeColor = Colors.orange;
                  statusIcon = Icons.play_circle_fill_rounded;
                }

                return Container(
                  margin: const EdgeInsets.only(bottom: 16),
                  decoration: BoxDecoration(
                    color: cardColor,
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(
                      color: status == 'active' ? Colors.orange : Colors.grey.shade200,
                      width: status == 'active' ? 2 : 1,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.03),
                        blurRadius: 8,
                        offset: const Offset(0, 3),
                      )
                    ],
                  ),
                  child: ListTile(
                    contentPadding: const EdgeInsets.all(16),
                    leading: CircleAvatar(
                      radius: 26,
                      backgroundColor: badgeColor.withOpacity(0.15),
                      child: Icon(statusIcon, color: badgeColor, size: 28),
                    ),
                    title: Text(
                      stage['title'],
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: status == 'locked' ? Colors.grey : const Color(0xFF2D3142),
                      ),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 4),
                        Text(
                          stage['desc'],
                          style: TextStyle(
                            fontSize: 12,
                            color: status == 'locked' ? Colors.grey.shade400 : Colors.grey.shade600,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                              decoration: BoxDecoration(
                                color: Colors.amber.shade100,
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Text(
                                stage['xp'],
                                style: TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.amber.shade900,
                                ),
                              ),
                            ),
                            if (status == 'completed') ...[
                              const SizedBox(width: 8),
                              const Icon(Icons.star, color: Colors.amber, size: 16),
                              const Icon(Icons.star, color: Colors.amber, size: 16),
                              const Icon(Icons.star, color: Colors.amber, size: 16),
                            ],
                          ],
                        ),
                      ],
                    ),
                    trailing: status == 'locked'
                        ? const Icon(Icons.lock, color: Colors.grey)
                        : const Icon(Icons.arrow_forward_ios_rounded, size: 18, color: Colors.grey),
                    onTap: () {
                      if (status == 'locked') {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('🔒 Babak ini masih terkunci! Selesaikan babak sebelumnya dulu.'),
                          ),
                        );
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
        title: Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.blue.shade50,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Row(
                children: [
                  Icon(Icons.lightbulb, color: Colors.blue),
                  SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Materi Ringkas & Interaktif',
                      style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blue),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              'HTTP (Hypertext Transfer Protocol) adalah protokol tempat data dikirimkan antara browser dan website. Sedangkan HTTPS menggunakan enkripsi SSL/TLS agar data tidak bisa diintip hacker!',
              style: TextStyle(fontSize: 13, height: 1.4),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('BACA NANTI'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF6C63FF),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('🎉 Selamat! Materi selesai dibaca, +200 XP!')),
              );
            },
            child: const Text('SELESAIKAN QUEST', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// 4. QUIZ BATTLE SCREEN (Solo)
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
    {
      'question': 'Protokol apa yang digunakan untuk mengirim pesan web secara aman?',
      'options': ['HTTP', 'HTTPS', 'FTP', 'SSH'],
      'answer': 1,
    },
    {
      'question': 'Perangkat keras mana yang berfungsi menghubungkan dua jaringan berbeda?',
      'options': ['Switch', 'Hub', 'Router', 'Kabel LAN'],
      'answer': 2,
    },
    {
      'question': 'Di bawah ini mana yang merupakan bahasa pemrograman Flutter?',
      'options': ['Java', 'Python', 'Dart', 'PHP'],
      'answer': 2,
    },
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
        title: const Text(
          '🎉 PERTANDINGAN SELESAI!',
          textAlign: TextAlign.center,
          style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF6C63FF)),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.emoji_events, size: 70, color: Colors.amber),
            const SizedBox(height: 12),
            Text(
              'Total Skor Kamu:\n$_score XP',
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
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
        title: Text(
          'Soal ${_currentQuestionIndex + 1} / ${_questions.length}',
          style: const TextStyle(color: Color(0xFF2D3142), fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            LinearProgressIndicator(
              value: (_currentQuestionIndex + 1) / _questions.length,
              color: const Color(0xFF6C63FF),
              backgroundColor: Colors.grey.shade200,
              minHeight: 8,
              borderRadius: BorderRadius.circular(10),
            ),
            const SizedBox(height: 24),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.grey.shade200),
              ),
              child: Text(
                currentQ['question'],
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF2D3142)),
              ),
            ),
            const SizedBox(height: 24),
            Expanded(
              child: ListView.builder(
                itemCount: (currentQ['options'] as List).length,
                itemBuilder: (context, index) {
                  final optionText = currentQ['options'][index];
                  final isSelected = _selectedOption == index;
                  final isCorrect = index == currentQ['answer'];

                  Color btnColor = Colors.white;
                  Color borderColor = Colors.grey.shade200;

                  if (isSelected) {
                    btnColor = isCorrect ? Colors.green.shade50 : Colors.red.shade50;
                    borderColor = isCorrect ? Colors.green : Colors.red;
                  }

                  return Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    decoration: BoxDecoration(
                      color: btnColor,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: borderColor, width: 1.5),
                    ),
                    child: ListTile(
                      title: Text(optionText, style: const TextStyle(fontWeight: FontWeight.w600)),
                      trailing: isSelected
                          ? Icon(isCorrect ? Icons.check_circle : Icons.cancel, color: isCorrect ? Colors.green : Colors.red)
                          : null,
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
// 5. CUSTOM ROOM SCREEN (Menu Buat / Gabung Room Tarik Tambang)
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
        title: const Text(
          'Battle Tarik Tambang (Room)',
          style: TextStyle(color: Color(0xFF2D3142), fontWeight: FontWeight.bold),
        ),
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
                gradient: const LinearGradient(
                  colors: [Color(0xFF8E2DE2), Color(0xFF4A00E0)],
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
                        Text(
                          'Adu Tanding 1v1',
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                        ),
                        SizedBox(height: 4),
                        Text(
                          'Buat room dan undang temanmu atau masukkan kode untuk bertanding!',
                          style: TextStyle(fontSize: 12, color: Colors.white70),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 28),

            // Opsi 1: Buat Room Baru
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: Colors.purple.shade100),
                boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 8, offset: const Offset(0, 3))],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Buat Ruang Pertandingan', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  const Text('Dapatkan kode unik dan bagikan ke teman sebelahmu.', style: TextStyle(fontSize: 12, color: Colors.black54)),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF8E2DE2),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      onPressed: () => _showCreatedRoomDialog(context),
                      child: const Text('BUAT ROOM TARIK TAMBANG', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Opsi 2: Masukkan Kode Room Teman
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: Colors.grey.shade200),
                boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 8, offset: const Offset(0, 3))],
              ),
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
                      labelText: 'Masukkan Kode Room Teman',
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                    ),
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: Color(0xFF8E2DE2), width: 1.5),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      onPressed: () {
                        if (_codeController.text.trim().isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('⚠️ Masukkan kode room terlebih dahulu!')),
                          );
                        } else {
                          // Masuk ke Arena Tarik Tambang bersama Teman
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => TugOfWarQuizScreen(roomCode: _codeController.text.toUpperCase()),
                            ),
                          );
                        }
                      },
                      child: const Text('GABUNG DAN TARIK TAMBANG!', style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF8E2DE2))),
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
        title: const Text('🎮 ROOM BERHASIL DIBUAT!', textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF8E2DE2))),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Bagikan kode ini ke temanmu untuk tanding:', style: TextStyle(fontSize: 12, color: Colors.black54)),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              decoration: BoxDecoration(
                color: Colors.purple.shade50,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.purple.shade200),
              ),
              child: const Text('NET889', style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, letterSpacing: 4, color: Color(0xFF8E2DE2))),
            ),
          ],
        ),
        actions: [
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF8E2DE2)),
            onPressed: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const TugOfWarQuizScreen(roomCode: 'NET889'),
                ),
              );
            },
            child: const Text('MASUK ARENA', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// 6. TUG OF WAR QUIZ SCREEN (Arena Tarik Tambang 1v1)
// ---------------------------------------------------------------------------
class TugOfWarQuizScreen extends StatefulWidget {
  final String roomCode;
  const TugOfWarQuizScreen({super.key, required this.roomCode});

  @override
  State<TugOfWarQuizScreen> createState() => _TugOfWarQuizScreenState();
}

class _TugOfWarQuizScreenState extends State<TugOfWarQuizScreen> {
  double _ropePosition = 0.5; // 0.5 = Tengah, 0.0 = Kamu Menang, 1.0 = Teman Menang
  int _currentQuestionIndex = 0;
  int? _selectedOption;

  final List<Map<String, dynamic>> _questions = [
    {
      'question': 'Protokol apa yang digunakan untuk mengirim pesan web secara aman?',
      'options': ['HTTP', 'HTTPS', 'FTP', 'SSH'],
      'answer': 1,
    },
    {
      'question': 'Perangkat keras mana yang berfungsi menghubungkan dua jaringan berbeda?',
      'options': ['Switch', 'Hub', 'Router', 'Kabel LAN'],
      'answer': 2,
    },
    {
      'question': 'Di bawah ini mana yang merupakan bahasa pemrograman Flutter?',
      'options': ['Java', 'Python', 'Dart', 'PHP'],
      'answer': 2,
    },
  ];

  void _answerQuestion(int optionIndex) {
    setState(() {
      _selectedOption = optionIndex;
      // Jika benar tarik tali ke kiri (ke arah Kamu), jika salah tarik ke kanan (ke arah Teman)
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
        title: Text(
          isWinner ? '🎉 KAMU MENANG TARIK TAMBANG!' : '💥 TEMANMU YANG MENANG!',
          textAlign: TextAlign.center,
          style: TextStyle(fontWeight: FontWeight.bold, color: isWinner ? Colors.green : Colors.red),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(isWinner ? Icons.emoji_events : Icons.sports_kabaddi, size: 70, color: isWinner ? Colors.amber : Colors.red),
            const SizedBox(height: 12),
            Text(
              isWinner ? 'Hebat! Tarikanmu berhasil mengalahkan lawan di Room ${widget.roomCode}.' : 'Sayang sekali, lawan lebih cepat menarik tali di Room ${widget.roomCode}.',
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 13, color: Colors.black54),
            ),
          ],
        ),
        actions: [
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF6C63FF)),
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
          // VISUALISASI TARIK TAMBANG 1v1
          Container(
            padding: const EdgeInsets.all(16),
            color: Colors.amber.shade50,
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: const [
                    Row(
                      children: [
                        CircleAvatar(backgroundColor: Colors.blue, radius: 14, child: Icon(Icons.face, size: 16, color: Colors.white)),
                        SizedBox(width: 4),
                        Text('Kamu', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blue)),
                      ],
                    ),
                    Row(
                      children: [
                        Text('Teman (Lawan)', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.red)),
                        SizedBox(width: 4),
                        CircleAvatar(backgroundColor: Colors.red, radius: 14, child: Icon(Icons.person, size: 16, color: Colors.white)),
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
                  'Status Tali: ${((1 - _ropePosition) * 100).toInt()}% Ketarikan Kamu',
                  style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.black54),
                ),
              ],
            ),
          ),

          // PERTANYAAN KUIS
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
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: Colors.grey.shade200),
                    ),
                    child: Text(currentQ['question'], style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF2D3142))),
                  ),
                  const SizedBox(height: 16),
                  Expanded(
                    child: ListView.builder(
                      itemCount: (currentQ['options'] as List).length,
                      itemBuilder: (context, index) {
                        final optionText = currentQ['options'][index];
                        final isSelected = _selectedOption == index;
                        final isCorrect = index == currentQ['answer'];

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
                            title: Text(optionText, style: const TextStyle(fontWeight: FontWeight.w600)),
                            trailing: isSelected
                                ? Icon(isCorrect ? Icons.check_circle : Icons.cancel, color: isCorrect ? Colors.green : Colors.red)
                                : null,
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