import 'dart:convert';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:weather_app/additionalinfoItem.dart';
import 'package:weather_app/hourly_forecase.dart';
import 'package:weather_app/secret.dart';
import 'package:http/http.dart' as http;


class WeatherScreen extends StatefulWidget {
  const WeatherScreen({super.key});

  @override
  State<WeatherScreen> createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {

  late Future weather;

  Future<Map<String,dynamic>> getCurrentWeather() async{
    try{
      String cityName = 'Salem';
      final res = await http.get(
        Uri.parse(
          'https://api.openweathermap.org/data/2.5/forecast?q=$cityName,IN&APPID=$key',
        ),
      );

      final data = jsonDecode(res.body);

      if(data['cod'] != '200'){
        throw 'Unexpected error occurred';
      }

      return data;

    } catch(e){
      throw e.toString();
    }

  }

  @override
  void initState(){
    super.initState();
    weather = getCurrentWeather();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: AppBar(
        title: const Text(
          'Weather App',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: (){
              setState((){
                weather = getCurrentWeather();
              });
            },
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),

      body: FutureBuilder(
        future: getCurrentWeather(),
        builder: (context, snapshot) {

          if(snapshot.connectionState == ConnectionState.waiting){
            return const Center(
              child: CircularProgressIndicator.adaptive(),
            );
          }

          if(snapshot.hasError){
            return Center(
              child: Text(snapshot.error.toString()),
            );
          }
        

          final data = snapshot.data!;
          final currentTemp = (data['list'][0]['main']['temp'] - 273.15).toStringAsFixed(2);
          final currentSky = data['list'][0]['weather'][0]['main'];
          final currentHumidity = data['list'][0]['main']['humidity'];
          final currentPressure = data['list'][0]['main']['pressure'];
          final currentWindSpeed = data['list'][0]['wind']['speed'];

          return Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
          
                  //main card
                  SizedBox(
                    width: double.infinity,
                    child: Card(
                      elevation: 9,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: ClipRRect(
                        child: BackdropFilter(
                          filter: ImageFilter.blur(
                            sigmaX: 2.6,
                            sigmaY: 2.6,
                            tileMode: TileMode.clamp,
                          ),
                          child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            children: [
                              Text(
                                '$currentTemp°C' ,
                                style: const TextStyle(
                                  fontSize: 38,
                                  fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Icon(
                                  currentSky == 'Clouds' || currentSky == 'Clear' ? 
                                  Icons.cloud : Icons.sunny,  
                                  size: 64,
                                ),
                                Text(
                                  '$currentSky',
                                  style: const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w300,
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 25),
          
                  //secondary card
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Hourly Forecast',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 6),

                  // SingleChildScrollView(
                  //   scrollDirection: Axis.horizontal,
                  //   child: Row(
                  //     children: [
                  //       for(int i=0;i<5;i++)
                  //         HourlyForecast(
                  //         time: data['list'][i+1]['dt'].toString(), 
                  //         icon: data['list'][i+1]['weather'][0]['main'] == 'Clouds' || data['list'][i+1]['weather'][0]['main'] == 'Rain' ? Icons.cloud : Icons.sunny, 
                  //         temperature: data['list'][i+1]['main']['temp'].toString(),
                  //         ),
                  //     ],
                  //   ),
                  // ),

                  SizedBox(
                    height: 120,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: 5,
                      itemBuilder: (context, index) {
                        final hourlyForecast = data['list'][index+1];
                        final hourlyTemp = (hourlyForecast['main']['temp']- 273.15).toStringAsFixed(2).toString();
                        final hourlySky = data['list'][index+1]['weather'][0]['main'];
                        final time = DateTime.parse(hourlyForecast['dt_txt']);
                        return HourlyForecast(
                            time: DateFormat.Hm().format(time), 
                            icon:  hourlySky == 'Clouds' || hourlySky == 'Clear' ? 
                            Icons.cloud : Icons.sunny, 
                            temperature: '$hourlyTemp°C',
                          );
                      },
                    ),
                  ),

                  const SizedBox(height: 25),
          
                  //third card
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Additional Information', 
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                    ),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      additionalInfoItem(
                        tempData: '$currentHumidity', 
                        icon: Icons.water_drop, 
                        temperature: 'Humidity',
                        ),
                      additionalInfoItem(
                        tempData: '$currentWindSpeed', 
                        icon: Icons.air, 
                        temperature: 'Wind Speed',
                        ),
                      additionalInfoItem(
                        tempData: '$currentPressure', 
                        icon: Icons.beach_access, 
                        temperature: 'Pressure',),
                    ],
                  ),
                ],
              ),
            );
            
        }
      ),
    );
  }
}

