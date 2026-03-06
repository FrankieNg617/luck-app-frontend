import 'package:flutter/material.dart';

class InfoEditScreen extends StatelessWidget {
  const InfoEditScreen({super.key, required this.title, required this.value});

  final String title;
  final String value;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      bottom: false,
      child: Align(
        alignment: Alignment.bottomCenter,
        child: Material(
          color: Colors.transparent,
          child: Container(
            height: MediaQuery.of(context).size.height * 0.95,
            width: double.infinity,
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(10)),
            ),
            child: Column(
              children: [
                const SizedBox(height: 4),

                // Threads-like nav row
                SizedBox(
                  height: 52,
                  child: Stack(
                    children: [
                      Align(
                        alignment: Alignment.centerLeft,
                        child: TextButton(
                          style: ButtonStyle(
                            overlayColor: WidgetStateProperty.all(
                              Colors.transparent,
                            ),

                            foregroundColor: WidgetStateProperty.resolveWith((
                              states,
                            ) {
                              if (states.contains(WidgetState.pressed)) {
                                return Colors.black.withValues(alpha: 0.45);
                              }
                              return Colors.black;
                            }),

                            textStyle: WidgetStateProperty.all(
                              const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ),
                          onPressed: () => Navigator.of(context).pop(),
                          child: const Text('Cancel'),
                        ),
                      ),
                      Align(
                        alignment: Alignment.center,
                        child: Text(
                          'Edit $title',
                          style: TextStyle(
                            fontWeight: FontWeight.w800,
                            fontSize: 16,
                          ),
                        ),
                      ),
                      Align(
                        alignment: Alignment.centerRight,
                        child: TextButton(
                          style: ButtonStyle(
                            overlayColor: WidgetStateProperty.all(
                              Colors.transparent,
                            ),

                            foregroundColor: WidgetStateProperty.resolveWith((
                              states,
                            ) {
                              if (states.contains(WidgetState.pressed)) {
                                return Colors.black.withValues(alpha: 0.45);
                              }
                              return Colors.black;
                            }),

                            textStyle: WidgetStateProperty.all(
                              const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          onPressed: () => Navigator.of(context).pop(),
                          child: const Text('Done'),
                        ),
                      ),
                    ],
                  ),
                ),

                Divider(
                  height: 1,
                  thickness: 0.7,
                  color: Colors.black.withValues(alpha: 0.65),
                ),


              ],
            ),
          ),
        ),
      ),
    );
  }
}
