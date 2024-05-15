import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:e_commerce_app/layout/cubit.dart';
import 'package:e_commerce_app/layout/states.dart';
import 'package:webview_flutter_platform_interface/webview_flutter_platform_interface.dart';

class PowerBiFrameScreen extends StatefulWidget {
  const PowerBiFrameScreen({super.key});

  @override
  State<PowerBiFrameScreen> createState() => _PowerBiFrameScreenState();
}

class _PowerBiFrameScreenState extends State<PowerBiFrameScreen> {
  int currentIndex = 0;
  List<String> powerBiLinks = [
    'https://app.powerbi.com/view?r=eyJrIjoiNWU2ZDUwZDYtZWJjNS00ZTAzLTk5ZDItM2UxOGYzNDE0MGY3IiwidCI6ImRmODY3OWNkLWE4MGUtNDVkOC05OWFjLWM4M2VkN2ZmOTVhMCJ9&pageName=ReportSection394d7c9bf32db4462965',
    'https://app.powerbi.com/view?r=eyJrIjoiZGQ2NGYwYzYtZjZjNi00YTNhLWE3NDktYWYyMTgyOGY5ZDkxIiwidCI6ImRmODY3OWNkLWE4MGUtNDVkOC05OWFjLWM4M2VkN2ZmOTVhMCJ9&pageName=ReportSection0d2b79eb4d698587cdd6',
    'https://app.powerbi.com/view?r=eyJrIjoiZGQ2NGYwYzYtZjZjNi00YTNhLWE3NDktYWYyMTgyOGY5ZDkxIiwidCI6ImRmODY3OWNkLWE4MGUtNDVkOC05OWFjLWM4M2VkN2ZmOTVhMCJ9&pageName=ReportSection329d8bacc0a59f3c632a',
    'https://app.powerbi.com/view?r=eyJrIjoiN2RlNGFiNTItNGRiZS00OTQzLWI4ZDYtMTQzMjhhZmQxMTE1IiwidCI6ImRmODY3OWNkLWE4MGUtNDVkOC05OWFjLWM4M2VkN2ZmOTVhMCJ9&pageName=ReportSection82c0e7e09dc734017938',
    'https://app.powerbi.com/view?r=eyJrIjoiN2RlNGFiNTItNGRiZS00OTQzLWI4ZDYtMTQzMjhhZmQxMTE1IiwidCI6ImRmODY3OWNkLWE4MGUtNDVkOC05OWFjLWM4M2VkN2ZmOTVhMCJ9&pageName=ReportSectionb4441927ecc7d885f45a',
  ];

  @override
  Widget build(BuildContext context) {
    PlatformWebViewController controller = PlatformWebViewController(
      const PlatformWebViewControllerCreationParams(),
    )..loadRequest(
      LoadRequestParams(
        uri: Uri.parse(
          powerBiLinks[currentIndex],
        ),
      ),
    );
    //var cubit = ShopCubit.get(context);
    return BlocConsumer<ShopCubit, ShopStates>(
      listener: (context, state) {},
      builder: (context, state) {
        return Padding(
          padding: const EdgeInsets.only(right: 20.0),
          child: Scaffold(
            appBar: AppBar(
              title: const Text('Power BI'),
              actions: [
                Container(
                  color: currentIndex == 0 ? Colors.blue:Colors.grey,
                  child: TextButton(
                      onPressed: () {
                        setState(() {
                          currentIndex = 0;
                        });
                      },
                      child: const Text('1')),
                ),
                const SizedBox(
                  width: 10,
                ),
                Container(
                  color: currentIndex == 1 ? Colors.blue:Colors.grey,
                  child: TextButton(
                      onPressed: () {
                        setState(() {
                          currentIndex = 1;
                        });
                      },
                      child: const Text('2')),
                ),
                const SizedBox(
                  width: 10,
                ),
                Container(
                  color: currentIndex == 2 ? Colors.blue:Colors.grey,

                  child: TextButton(
                      onPressed: () {
                        setState(() {
                          currentIndex = 2;
                        });
                      },
                      child: const Text('3')),
                ),
                const SizedBox(
                  width: 10,
                ),
                Container(
                  color: currentIndex == 3 ? Colors.blue:Colors.grey,
                  child: TextButton(
                      onPressed: () {
                        setState(() {
                          currentIndex = 3;
                        });
                      },
                      child: const Text('4')),
                ),
                const SizedBox(
                  width: 10,
                ),
                Container(
                  color: currentIndex == 4 ? Colors.blue:Colors.grey,
                  child: TextButton(
                      onPressed: () {
                        setState(() {
                          currentIndex = 4;
                        });
                      },
                      child: const Text('5')),
                ),
              ],
            ),
            body: Column(
              children: [
                Expanded(
                  child: Row(
                    children: [
                      Expanded(
                        child: PlatformWebViewWidget(
                          PlatformWebViewWidgetCreationParams(
                              controller: controller),
                        ).build(context),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

