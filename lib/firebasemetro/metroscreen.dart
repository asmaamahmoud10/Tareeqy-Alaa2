import 'package:flutter/material.dart';
import 'package:tareeqy_metro/QR-Code/generateQrCode.dart';
import 'package:tareeqy_metro/components/searchbar.dart';
import 'package:tareeqy_metro/firebasemetro/metroService.dart';
import 'package:tareeqy_metro/firebasemetro/tripdetailsScreen.dart';
import 'package:tareeqy_metro/maps/track_location.dart';

class MetroScreen extends StatefulWidget {
  const MetroScreen({super.key});

  @override
  State<MetroScreen> createState() => _MetroScreenState();
}

class _MetroScreenState extends State<MetroScreen> {
  String selectedValue1 = '';
  String selectedValue2 = '';
  bool isDataLoaded = false;
  late final metroService _metroService;

  @override
  void initState() {
    super.initState();
    _metroService = metroService();
    _loadStations();
  }

  Future<void> _loadStations() async {
    await _metroService.getStations();
    setState(() {
      isDataLoaded = true;
    }); // Update the UI with the loaded stations
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 5,
        backgroundColor: Colors.white,
        title: const Text(
          'Metro',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      backgroundColor: const Color.fromARGB(255, 255, 255, 255),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              const Image(
                image: AssetImage("assets/images/metroIconn.jpg"),
                height: 220,
                width: 220,
              ),
              if (!isDataLoaded) const CircularProgressIndicator(),
              if (isDataLoaded)
                Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: MyDropdownSearch(
                        fromto: 'From',
                        items: _metroService
                            .getStationNames()
                            .where((String x) => x != selectedValue2)
                            .toSet(),
                        selectedValue: selectedValue1,
                        onChanged: (value) {
                          setState(() {
                            selectedValue1 = value!;
                          });
                        },
                      ),
                    ),
                    const SizedBox(height: 10),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: MyDropdownSearch(
                        fromto: 'To',
                        items: _metroService
                            .getStationNames()
                            .where((String x) => x != selectedValue1)
                            .toSet(),
                        selectedValue: selectedValue2,
                        onChanged: (value) {
                          setState(() {
                            selectedValue2 = value!;
                          });
                        },
                      ),
                    ),
                  ],
                ),
              const SizedBox(height: 15),
              if (isDataLoaded)
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color.fromARGB(255, 40, 53, 173),
                        minimumSize: const Size(150, 50),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5),
                        ),
                      ),
                      onPressed: () {
                        setState(() {
                          selectedValue1 = '';
                          selectedValue2 = '';
                        });
                      },
                      child: const Text(
                        'Clear',
                        style: TextStyle(color: Colors.white, fontSize: 20),
                      ),
                    ),
                    Container(width: 20),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color.fromARGB(255, 40, 53, 173),
                        minimumSize: const Size(150, 50),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5),
                        ),
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const GenerateQrCode()),
                        );
                      },
                      child: const Text(
                        'Get a Ticket?',
                        style: TextStyle(color: Colors.white, fontSize: 20),
                      ),
                    ),
                  ],
                ),
              const SizedBox(height: 10),
              if (selectedValue1 != '' && selectedValue2 != '')
                Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      color: Colors.white),
                  height: 150,
                  child: Row(
                    children: [
                      const Spacer(flex: 1),
                      Container(
                        padding: const EdgeInsets.only(left: 15, top: 8),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const Icon(
                              Icons.attach_money,
                              size: 70,
                            ),
                            const Text(
                              'Ticket Price',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                              ),
                            ),
                            Container(
                              width: 80,
                              height: 30,
                              color: Colors.grey[300],
                              child: Center(
                                child: Text(
                                  _metroService.calculatePrice(
                                      selectedValue1, selectedValue2),
                                  style: const TextStyle(
                                    fontSize: 20,
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Spacer(flex: 1),
                      const VerticalDivider(
                        thickness: 1,
                        width: 20,
                        color: Colors.black,
                        endIndent: 10,
                        indent: 10,
                      ),
                      Container(
                        padding: const EdgeInsets.all(8),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const Icon(
                              Icons.timelapse,
                              size: 70,
                            ),
                            const Text(
                              'Estimated Time',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                              ),
                            ),
                            Container(
                              width: 80,
                              height: 30,
                              color: Colors.grey[300],
                              child: Center(
                                child: Text(
                                  _metroService.calculateTime(
                                      selectedValue1, selectedValue2),
                                  style: const TextStyle(
                                    fontSize: 20,
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Spacer(flex: 1),
                    ],
                  ),
                ),
              const SizedBox(height: 20),
              const SizedBox(height: 10),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const CircleAvatar(
                      backgroundColor: Colors.white,
                      child: Icon(
                        Icons.location_on_rounded,
                        size: 30,
                        color: Color.fromARGB(255, 14, 72, 171),
                      ),
                    ),
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10.0),
                          color: const Color.fromARGB(255, 14, 72, 171),
                        ),
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            minimumSize: const Size(double.infinity, 50),
                            backgroundColor:
                                const Color.fromARGB(255, 40, 53, 173),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 0, vertical: 5),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5),
                            ),
                          ),
                          onPressed: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) {
                                  return const TrackLocation();
                                },
                              ),
                            );
                          },
                          child: const Text(
                            'Nearest Station?',
                            style: TextStyle(color: Colors.white, fontSize: 18),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    if (selectedValue1 != '' && selectedValue2 != '')
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10.0),
                            color: const Color.fromARGB(255, 14, 72, 171),
                          ),
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor:
                                  const Color.fromARGB(255, 40, 53, 173),
                              minimumSize: const Size(double.infinity, 50),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 12),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5),
                              ),
                            ),
                            onPressed: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) {
                                    return TripDetails(
                                      route: _metroService.getRoute(
                                          selectedValue1, selectedValue2),
                                    );
                                  },
                                ),
                              );
                            },
                            child: const Text(
                              'Trip Details',
                              style:
                                  TextStyle(color: Colors.white, fontSize: 18),
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
