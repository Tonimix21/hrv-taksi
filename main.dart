
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

void main() => runApp(HrvTaksiApp());

class HrvTaksiApp extends StatefulWidget {
  @override
  _HrvTaksiAppState createState() => _HrvTaksiAppState();
}

class _HrvTaksiAppState extends State<HrvTaksiApp> {
  ThemeMode _themeMode = ThemeMode.system;

  void _toggleTheme(bool isDark) {
    setState(() {
      _themeMode = isDark ? ThemeMode.dark : ThemeMode.light;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'HrvTaksi',
      theme: ThemeData(
        brightness: Brightness.light,
        primarySwatch: Colors.red,
        fontFamily: 'OpenSans',
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        primarySwatch: Colors.red,
        fontFamily: 'OpenSans',
      ),
      themeMode: _themeMode,
      home: HomePage(
        onThemeChanged: _toggleTheme,
      ),
    );
  }
}

class HomePage extends StatefulWidget {
  final Function(bool) onThemeChanged;

  HomePage({required this.onThemeChanged});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late GoogleMapController mapController;
  final LatLng _center = LatLng(45.8150, 15.9819); // Zagreb
  bool _darkTheme = false;

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  List<String> pastRides = [
    '12.05.2025 - Trg Bana Jelačića - 50 kn',
    '10.05.2025 - Glavni kolodvor - 35 kn',
    '08.05.2025 - Zračna luka - 80 kn',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('HrvTaksi'),
        actions: [
          IconButton(
            icon: Icon(_darkTheme ? Icons.dark_mode : Icons.light_mode),
            onPressed: () {
              setState(() {
                _darkTheme = !_darkTheme;
                widget.onThemeChanged(_darkTheme);
              });
            },
          ),
          IconButton(
            icon: Icon(Icons.settings),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => SettingsPage(
                  darkTheme: _darkTheme,
                  onThemeChanged: (val) {
                    setState(() {
                      _darkTheme = val;
                      widget.onThemeChanged(val);
                    });
                  },
                )),
              );
            },
          ),
        ],
      ),
      body: Stack(
        children: [
          GoogleMap(
            onMapCreated: _onMapCreated,
            initialCameraPosition: CameraPosition(
              target: _center,
              zoom: 14.0,
            ),
          ),
          Positioned(
            top: 20,
            left: 15,
            right: 15,
            child: Column(
              children: [
                TextField(
                  decoration: InputDecoration(
                    hintText: 'Odakle?',
                    fillColor: Colors.white,
                    filled: true,
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 10),
                TextField(
                  decoration: InputDecoration(
                    hintText: 'Kamo?',
                    fillColor: Colors.white,
                    filled: true,
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 20),
                DropdownButtonFormField<String>(
                  decoration: InputDecoration(
                    labelText: 'Prošle vožnje',
                    border: OutlineInputBorder(),
                    fillColor: Colors.white,
                    filled: true,
                  ),
                  items: pastRides.map((ride) {
                    return DropdownMenuItem<String>(
                      value: ride,
                      child: Text(ride),
                    );
                  }).toList(),
                  onChanged: (value) {},
                ),
              ],
            ),
          ),
          Positioned(
            bottom: 20,
            left: 15,
            right: 15,
            child: ElevatedButton(
              onPressed: () {
                // TODO: implement ride request logic
              },
              child: Text('Zatraži vožnju'),
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: 16),
                textStyle: TextStyle(fontSize: 18),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class SettingsPage extends StatefulWidget {
  final bool darkTheme;
  final Function(bool) onThemeChanged;

  SettingsPage({required this.darkTheme, required this.onThemeChanged});

  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  late bool _darkTheme;

  @override
  void initState() {
    super.initState();
    _darkTheme = widget.darkTheme;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Postavke')),
      body: ListView(
        children: [
          SwitchListTile(
            title: Text('Tamna tema'),
            value: _darkTheme,
            onChanged: (val) {
              setState(() {
                _darkTheme = val;
                widget.onThemeChanged(val);
              });
            },
          ),
          ListTile(
            title: Text('Verzija aplikacije'),
            subtitle: Text('1.0.0'),
          ),
        ],
      ),
    );
  }
}
