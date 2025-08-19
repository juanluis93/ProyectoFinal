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
  // Registro de usuario usando el endpoint actual
  Future<bool> register(User user) async {
    try {
      final Map<String, String> formHeaders = {
        'Content-Type': 'application/x-www-form-urlencoded',
        'Accept': 'application/json',
      };
      final formBody =
          'cedula=${Uri.encodeComponent(user.cedula.toString())}'
          '&nombre=${Uri.encodeComponent(user.nombre.toString())}'
          '&apellido=${Uri.encodeComponent(user.apellido.toString())}'
          '&correo=${Uri.encodeComponent(user.email.toString())}'
          '&password=${Uri.encodeComponent(user.password.toString())}'
          '&telefono=${Uri.encodeComponent(user.telefono.toString())}'
          '&matricula=${Uri.encodeComponent(user.id.toString())}';
      final response = await http.post(
        Uri.parse('$baseUrl/auth/register'),
        headers: formHeaders,
        body: formBody,
      );

      print('Registro usuario status: ${response.statusCode}');
      print('Registro usuario body: ${response.body}');

      if (response.statusCode == 201) {
        final data = json.decode(response.body);
        return data['token'] != null && data['usuario'] != null;
      }
      return false;
    } catch (e) {
      print('Error al registrar usuario: $e');
      return false;
    }
  }

  static const String baseUrl = 'https://adamix.net/medioambiente';

  // Headers comunes
  Map<String, String> get _headers => {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  };

  // Login usando el endpoint actual
  Future<User?> login(String email, String password) async {
    try {
      print('Intentando login con: correo=$email, password=$password');
      final Map<String, String> formHeaders = {
        'Content-Type': 'application/x-www-form-urlencoded',
        'Accept': 'application/json',
      };
      final formBody =
          'correo=${Uri.encodeComponent(email)}&password=${Uri.encodeComponent(password)}';
      final response = await http.post(
        Uri.parse('$baseUrl/auth/login'),
        headers: formHeaders,
        body: formBody,
      );
      print('Respuesta status: ${response.statusCode}');
      print('Respuesta body: ${response.body}');

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        print('Respuesta decodificada: $data');
        if (data['token'] != null && data['usuario'] != null) {
          // Guardar el token en el modelo User
          final user = User.fromJson(data['usuario']);
          return User(
            id: user.id,
            cedula: user.cedula,
            nombre: user.nombre,
            password: user.password,
            apellido: user.apellido,
            email: user.email,
            telefono: user.telefono,
            token: data['token'],
          );
        }
      } else {
        print(
          'Error en login: status=${response.statusCode}, body=${response.body}',
        );
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
        Uri.parse('$baseUrl/servicios'),
        headers: _headers,
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        // La API devuelve directamente un array
        if (data is List) {
          return data.map((servicio) => Servicio.fromJson(servicio)).toList();
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
        Uri.parse('$baseUrl/noticias'),
        headers: _headers,
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        // La API devuelve directamente un array
        if (data is List) {
          return data.map((noticia) => Noticia.fromJson(noticia)).toList();
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
        Uri.parse('$baseUrl/videos'),
        headers: _headers,
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        // La API devuelve directamente un array
        if (data is List) {
          return data.map((video) => VideoEducativo.fromJson(video)).toList();
        }
      }
      return [];
    } catch (e) {
      print('Error al obtener videos: $e');
      return [];
    }
  }

  // Áreas Protegidas - Endpoint no disponible en la API
  Future<List<AreaProtegida>> getAreasProtegidas() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/areas_protegidas'),
        headers: _headers,
      );
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.map((json) => AreaProtegida.fromJson(json)).toList();
      } else {
        print('Error al obtener áreas protegidas: ${response.statusCode}');
        return [];
      }
    } catch (e) {
      print('Error al obtener áreas protegidas: $e');
      return [];
    }
  }

  Future<AreaProtegida?> getAreaProtegida(int id) async {
    try {
      // El endpoint /areas no existe en la API
      print('Endpoint de área protegida no disponible');
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
        Uri.parse('$baseUrl/medidas'),
        headers: _headers,
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        // La API devuelve directamente un array, no un objeto con "exito"
        if (data is List) {
          return data
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
        Uri.parse('$baseUrl/medidas?id=$id'),
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
        Uri.parse('$baseUrl/equipo'),
        headers: _headers,
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        // La API devuelve directamente un array, no un objeto con "exito"
        if (data is List) {
          return data.map((persona) => Personal.fromJson(persona)).toList();
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
      final voluntarioJson = voluntario.toJson();

      print('Registrando voluntario con datos: $voluntarioJson');
      print('URL: $baseUrl/voluntarios');

      // Intentar con application/x-www-form-urlencoded primero
      final Map<String, String> formHeaders = {
        'Content-Type': 'application/x-www-form-urlencoded',
        'Accept': 'application/json',
      };

      final formBody = voluntarioJson.entries
          .map(
            (e) =>
                '${Uri.encodeComponent(e.key)}=${Uri.encodeComponent(e.value.toString())}',
          )
          .join('&');

      print('Form headers: $formHeaders');
      print('Form body: $formBody');

      final response = await http.post(
        Uri.parse('$baseUrl/voluntarios'),
        headers: formHeaders,
        body: formBody,
      );

      print('Respuesta API voluntarios - Status: ${response.statusCode}');
      print('Respuesta API voluntarios - Body: ${response.body}');
      print('Respuesta API voluntarios - Headers: ${response.headers}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        try {
          final data = json.decode(response.body);
          print('Respuesta completa: $data');

          // La API devuelve: {"mensaje": "...", "voluntario": {...}}
          bool isSuccess =
              data['mensaje'] != null &&
                  data['mensaje'].toString().toLowerCase().contains(
                    'exitosamente',
                  ) ||
              data['voluntario'] != null ||
              data['success'] == true ||
              data['exito'] == true ||
              data['estado'] == 'success' ||
              data['id'] != null;

          print('Registro de voluntario exitoso: $isSuccess');
          return isSuccess;
        } catch (e) {
          print('Error parsing response: $e');
          // Si no podemos parsear la respuesta pero el código es 200/201, asumimos éxito
          return true;
        }
      } else if (response.statusCode == 409) {
        // Email ya registrado
        throw Exception(
          'Este correo electrónico ya está registrado como voluntario',
        );
      } else {
        // Otros errores
        try {
          final data = json.decode(response.body);
          final errorMessage = data['error'] ?? 'Error desconocido';
          throw Exception(errorMessage);
        } catch (e) {
          throw Exception('Error en el registro: ${response.statusCode}');
        }
      }
    } catch (e) {
      print('Error al registrar voluntario: $e');
      return false;
    }
  }

  // Normativas (requiere autenticación)
  Future<List<Normativa>> getNormativas(String token) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/normativas'),
        headers: {..._headers, 'Authorization': 'Bearer $token'},
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        // La API puede devolver un array directamente
        if (data is List) {
          return data
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
      final reporteJson = reporte.toJson();

      print('Enviando reporte con token: ${token.isNotEmpty ? "Sí" : "No"}');
      print('Datos del reporte: $reporteJson');

      final Map<String, String> formHeaders = {
        'Content-Type': 'application/x-www-form-urlencoded',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      };

      final formBody = reporteJson.entries
          .map(
            (e) =>
                '${Uri.encodeComponent(e.key)}=${Uri.encodeComponent(e.value.toString())}',
          )
          .join('&');

      print('Form headers: $formHeaders');
      print('Form body: $formBody');

      final response = await http.post(
        Uri.parse('$baseUrl/reportes'),
        headers: formHeaders,
        body: formBody,
      );

      print('Respuesta API reportes - Status: ${response.statusCode}');
      print('Respuesta API reportes - Body: ${response.body}');

      // Considerar éxito si el status code es 200, 201 o 202
      if (response.statusCode == 200 ||
          response.statusCode == 201 ||
          response.statusCode == 202) {
        try {
          final data = json.decode(response.body);
          // Verificar diferentes formatos de respuesta exitosa
          if (data['exito'] == true ||
              data['success'] == true ||
              data['mensaje'] != null ||
              data['reporte'] != null) {
            return true;
          }
        } catch (e) {
          // Si no es JSON válido pero el status code indica éxito, considerar exitoso
          print(
            'Response no es JSON válido, pero status code indica éxito: ${response.statusCode}',
          );
          return true;
        }
      }

      // Verificar si hay algún mensaje de éxito en texto plano
      if (response.body.toLowerCase().contains('exitoso') ||
          response.body.toLowerCase().contains('creado') ||
          response.body.toLowerCase().contains('guardado')) {
        return true;
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
        Uri.parse('$baseUrl/reportes'),
        headers: {..._headers, 'Authorization': 'Bearer $token'},
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        // La API devuelve directamente un array de reportes
        if (data is List) {
          return data.map((reporte) => Reporte.fromJson(reporte)).toList();
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
