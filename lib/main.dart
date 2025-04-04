import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      //debugShowCheckedModeBanner: false,
      title: 'Flutter Lab Exercise 10',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: HomeScreen(),
    );
  }
}

/// First Screen
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final usdController = TextEditingController();
  final cadController = TextEditingController();
  final double exchangeRate = 1.35;

  @override
  void dispose() {
    usdController.dispose();
    cadController.dispose();
    super.dispose();
  }

  void _showErrorMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.redAccent,
        duration: Duration(seconds: 2),
      ),
    );
  }


  void _navigateToSummaryPage(){

    final usdText = usdController.text.trim();
    final cadText = cadController.text.trim();

    if (usdText.isEmpty && cadText.isEmpty) {
      _showErrorMessage("Please enter a value in either USD or CAD.");
      return;
    }

    double? usd = double.tryParse(usdText);
    double? cad = double.tryParse(cadText);

    if ((usdText.isNotEmpty && usd == null) || (cadText.isNotEmpty && cad == null)) {
      _showErrorMessage("Please enter a valid number.");
      return;
    }

    if (usd == null && cad != null) {
      usd = cad / exchangeRate;
    }

    if (cad == null && usd != null) {
      cad = usd * exchangeRate;
    }
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SummaryScreen(
          usdValue: usd!,
          cadValue: cad!,
          exchangeRate: exchangeRate,
        ),
      ),
    );

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Currency Converter')),
      body: Padding(padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          TextField(
            controller: usdController,
            decoration: InputDecoration(
              labelText: 'USD',
              border: OutlineInputBorder(),
            ),
            onChanged: (value) {
              final usd = double.tryParse(value);
              if (usd != null) {
                final cad = (usd * exchangeRate).toStringAsFixed(2);
                cadController.text = cad;
              } else {
                cadController.text = '';
              }
            }
          ),
          SizedBox(height:20,),
          TextField(
            controller: cadController,
            decoration: InputDecoration(
              labelText: 'CAD',
              border: OutlineInputBorder(),
            ),
            onChanged: (value) {
              final cad = double.tryParse(value);
              if (cad != null) {
                final usd = (cad / exchangeRate).toStringAsFixed(2);
                usdController.text = usd;
              } else {
                usdController.text = '';
              }
            },
          ),

          SizedBox(height: 50,),
          ElevatedButton(onPressed: _navigateToSummaryPage , child: Text('View Summary'))
        ],
      )
    ));
  }
}



/// Second Screen
class SummaryScreen extends StatelessWidget {
  final double usdValue;
  final double cadValue;
  final double exchangeRate;

  const SummaryScreen({super.key, required this.usdValue, required this.cadValue, required this.exchangeRate });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Summary Screen')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Converted Values:',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            Text(
              'USD: \$${usdValue.toStringAsFixed(2)}',
              style: TextStyle(fontSize: 18),
            ),
            Text(
              'CAD: \$${cadValue.toStringAsFixed(2)}',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 20),
            Text(
              'Exchange Rate: 1 USD = ${exchangeRate.toStringAsFixed(2)} CAD',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 50),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Back to Conversion'),
            ),
          ],
        ),
      ),
    );
  }
}

