import 'dart:convert';
import 'dart:typed_data';
import 'package:http/http.dart' as http;
import '../models/servicio.dart';
import '../models/noticia.dart';
import '../models/video_educativo.dart';
import '../models/area_protegida.dart';
import '../models/medida_ambiental.dart';
import '../models/personal.dart';
import '../models/normativa.dart';
import '../models/reporte.dart';
import '../models/voluntario.dart';
import '../models/user.dart';

class ApiService {
  static const String baseUrl = 'https://adamix.net/medioambiente/def';

  // Headers comunes
  Map<String, String> get _headers => {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  };

  // Autenticación
  Future<User?> login(String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/usuarios.php'),
        headers: _headers,
        body: json.encode({
          'accion': 'login',
          'email': email,
          'password': password,
        }),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['exito'] == true) {
          return User.fromJson(data['usuario']);
        }
      }
      return null;
    } catch (e) {
      print('Error en login: $e');
      return null;
    }
  }

  Future<bool> recuperarPassword(String email) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/usuarios.php'),
        headers: _headers,
        body: json.encode({'accion': 'recuperar_password', 'email': email}),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return data['exito'] == true;
      }
      return false;
    } catch (e) {
      print('Error en recuperar password: $e');
      return false;
    }
  }

  Future<bool> cambiarPassword(
    String usuarioId,
    String passwordActual,
    String passwordNueva,
  ) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/usuarios.php'),
        headers: _headers,
        body: json.encode({
          'accion': 'cambiar_password',
          'usuario_id': usuarioId,
          'password_actual': passwordActual,
          'password_nueva': passwordNueva,
        }),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return data['exito'] == true;
      }
      return false;
    } catch (e) {
      print('Error en cambiar password: $e');
      return false;
    }
  }

  // Servicios
  Future<List<Servicio>> getServicios() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/servicios.php'),
        headers: _headers,
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['exito'] == true) {
          return (data['servicios'] as List)
              .map((servicio) => Servicio.fromJson(servicio))
              .toList();
        }
      }
      return [];
    } catch (e) {
      print('Error al obtener servicios: $e');
      return [];
    }
  }

  // Noticias
  Future<List<Noticia>> getNoticias() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/noticias.php'),
        headers: _headers,
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['exito'] == true) {
          return (data['noticias'] as List)
              .map((noticia) => Noticia.fromJson(noticia))
              .toList();
        }
      }
      return [];
    } catch (e) {
      print('Error al obtener noticias: $e');
      return [];
    }
  }

  // Videos Educativos
  Future<List<VideoEducativo>> getVideos() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/videos.php'),
        headers: _headers,
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['exito'] == true) {
          return (data['videos'] as List)
              .map((video) => VideoEducativo.fromJson(video))
              .toList();
        }
      }
      return [];
    } catch (e) {
      print('Error al obtener videos: $e');
      return [];
    }
  }

  // Áreas Protegidas
  Future<List<AreaProtegida>> getAreasProtegidas() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/areas.php'),
        headers: _headers,
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['exito'] == true) {
          return (data['areas'] as List)
              .map((area) => AreaProtegida.fromJson(area))
              .toList();
        }
      }
      return [];
    } catch (e) {
      print('Error al obtener áreas protegidas: $e');
      return [];
    }
  }

  Future<AreaProtegida?> getAreaProtegida(int id) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/areas.php?id=$id'),
        headers: _headers,
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['exito'] == true) {
          return AreaProtegida.fromJson(data['area']);
        }
      }
      return null;
    } catch (e) {
      print('Error al obtener área protegida: $e');
      return null;
    }
  }

  // Medidas Ambientales
  Future<List<MedidaAmbiental>> getMedidas() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/medidas.php'),
        headers: _headers,
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['exito'] == true) {
          return (data['medidas'] as List)
              .map((medida) => MedidaAmbiental.fromJson(medida))
              .toList();
        }
      }
      return [];
    } catch (e) {
      print('Error al obtener medidas ambientales: $e');
      return [];
    }
  }

  Future<MedidaAmbiental?> getMedida(int id) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/medidas.php?id=$id'),
        headers: _headers,
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['exito'] == true) {
          return MedidaAmbiental.fromJson(data['medida']);
        }
      }
      return null;
    } catch (e) {
      print('Error al obtener medida ambiental: $e');
      return null;
    }
  }

  // Personal del Ministerio
  Future<List<Personal>> getPersonal() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/equipo.php'),
        headers: _headers,
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['exito'] == true) {
          return (data['personal'] as List)
              .map((persona) => Personal.fromJson(persona))
              .toList();
        }
      }
      return [];
    } catch (e) {
      print('Error al obtener personal: $e');
      return [];
    }
  }

  // Voluntariado
  Future<bool> registrarVoluntario(Voluntario voluntario) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/voluntarios.php'),
        headers: _headers,
        body: json.encode(voluntario.toJson()),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return data['exito'] == true;
      }
      return false;
    } catch (e) {
      print('Error al registrar voluntario: $e');
      return false;
    }
  }

  // Normativas (requiere autenticación)
  Future<List<Normativa>> getNormativas(String token) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/normativas.php'),
        headers: {..._headers, 'Authorization': 'Bearer $token'},
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['exito'] == true) {
          return (data['normativas'] as List)
              .map((normativa) => Normativa.fromJson(normativa))
              .toList();
        }
      }
      return [];
    } catch (e) {
      print('Error al obtener normativas: $e');
      return [];
    }
  }

  // Reportes (requiere autenticación)
  Future<bool> crearReporte(Reporte reporte, String token) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/reportes.php'),
        headers: {..._headers, 'Authorization': 'Bearer $token'},
        body: json.encode(reporte.toJson()),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return data['exito'] == true;
      }
      return false;
    } catch (e) {
      print('Error al crear reporte: $e');
      return false;
    }
  }

  Future<List<Reporte>> getReportesUsuario(
    String usuarioId,
    String token,
  ) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/reportes.php?usuario_id=$usuarioId'),
        headers: {..._headers, 'Authorization': 'Bearer $token'},
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['exito'] == true) {
          return (data['reportes'] as List)
              .map((reporte) => Reporte.fromJson(reporte))
              .toList();
        }
      }
      return [];
    } catch (e) {
      print('Error al obtener reportes del usuario: $e');
      return [];
    }
  }

  // Convertir imagen a base64
  String imageToBase64(Uint8List imageBytes) {
    return base64Encode(imageBytes);
  }
}
