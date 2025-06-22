import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:intl/intl.dart';

class LocationMessageBubble extends StatelessWidget {
  final bool isMe;
  final DateTime timestamp;
  final String locationName;

  const LocationMessageBubble({
    Key? key,
    required this.isMe,
    required this.timestamp,
    required this.locationName,
  }) : super(key: key);

  Future<void> _openLocation() async {
    final encodedAddress = Uri.encodeComponent(locationName);
    final url =
        'https://www.google.com/maps/search/?api=1&query=$encodedAddress';
    final uri = Uri.parse(url);

    if (await canLaunchUrl(uri)) {
      final success = await launchUrl(
        uri,
        mode: LaunchMode.externalApplication, // 👈 força abrir no app externo
      );
      if (!success) {
        print('⚠️ Falha ao abrir com externalApplication');
      }
    } else {
      print('❌ Não foi possível abrir o mapa');
    }
  }

  @override
  Widget build(BuildContext context) {
    final timeString = DateFormat('HH:mm').format(timestamp);

    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.75,
        ),
        decoration: BoxDecoration(
          color: isMe ? const Color(0xFF2196F3) : Colors.white,
          borderRadius: BorderRadius.circular(16).copyWith(
            bottomRight: isMe ? const Radius.circular(0) : null,
            bottomLeft: !isMe ? const Radius.circular(0) : null,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Map preview container
            GestureDetector(
              onTap: _openLocation,
              child: Container(
                height: 150,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(16),
                    topRight: Radius.circular(16),
                  ),
                ),
                child: Stack(
                  children: [
                    // Static map image (você pode usar Google Static Maps API)
                    Container(
                      width: double.infinity,
                      height: double.infinity,
                      decoration: BoxDecoration(
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(16),
                          topRight: Radius.circular(16),
                        ),
                        image: DecorationImage(
                          image: NetworkImage(
                            'https://maps.googleapis.com/maps/api/staticmap?'
                            'center=${Uri.encodeComponent(locationName)}'
                            '&zoom=15'
                            '&size=300x150'
                            '&markers=color:red%7C${Uri.encodeComponent(locationName)}'
                            '&key=${dotenv.env['GOOGLE_MAPS_API_KEY']}',
                          ),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),

                    // Overlay with location icon
                    Container(
                      width: double.infinity,
                      height: double.infinity,
                      decoration: BoxDecoration(
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(16),
                          topRight: Radius.circular(16),
                        ),
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.transparent,
                            Colors.black.withOpacity(0.3),
                          ],
                        ),
                      ),
                      child: const Center(
                        child: Icon(
                          Icons.location_on,
                          color: Colors.red,
                          size: 40,
                        ),
                      ),
                    ),

                    // Play button overlay
                    Positioned(
                      bottom: 8,
                      right: 8,
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.6),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.open_in_new,
                          color: Colors.white,
                          size: 16,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Location info
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.location_on,
                        color: isMe ? Colors.white : const Color(0xFF2196F3),
                        size: 16,
                      ),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          locationName ?? 'Localização compartilhada',
                          style: TextStyle(
                            color: isMe ? Colors.white : Colors.black87,
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Localização compartilhada',
                    style: TextStyle(
                      color:
                          isMe
                              ? Colors.white.withOpacity(0.8)
                              : Colors.grey[600],
                      fontSize: 11,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Toque para abrir no mapa',
                        style: TextStyle(
                          color:
                              isMe
                                  ? Colors.white.withOpacity(0.8)
                                  : Colors.grey[600],
                          fontSize: 12,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                      Text(
                        timeString,
                        style: TextStyle(
                          color:
                              isMe
                                  ? Colors.white.withOpacity(0.7)
                                  : Colors.grey[600],
                          fontSize: 10,
                        ),
                      ),
                    ],
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
