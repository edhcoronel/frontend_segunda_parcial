import 'package:flutter/material.dart';
import 'package:frontend_segunda_parcial/main.dart';
import 'package:frontend_segunda_parcial/pages/fichas_pag.dart';
import 'package:frontend_segunda_parcial/pages/pacientes_pag.dart';
import 'package:frontend_segunda_parcial/pages/reservas_pag.dart';
import 'package:frontend_segunda_parcial/models/persona.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Menu extends StatefulWidget {
  final List<Persona> profesionales;
  final Persona usuario;
  const Menu(this.usuario, {Key? key, required this.profesionales}) : super(key: key);

  @override
  State<Menu> createState() => _MenuState();
}

class _MenuState extends State<Menu> {

  late Persona userLogueado;
  Future<List<Persona>>? _listadoPersonas;

  Future<List<Persona>> _getPersonas() async{
    try {
      final url = "https://equipoyosh.com/stock-nutrinatalia/persona";

      final response = await http.get(Uri.parse(url));

      List<Persona> personas = [];

      print(response.statusCode);
      if(response.statusCode == 200){
        String body = utf8.decode(response.bodyBytes);
        final jsonData = jsonDecode(body);
        //print(jsonData["lista"]);

        for (var item in jsonData["lista"]){
          Persona _p = Persona(0, "", "", "", "", "", "", "", "", "", "");
          _p.idPersona = item["idPersona"];
          _p.nombre = item["nombre"];
          _p.tipoPersona = item["tipoPersona"];
          if(item["apellido"] != null){
            _p.apellido = item["apellido"];
          }
          if(item["email"] != null){
            _p.email = item["email"];
          }
          if(item["telefono"] != null){
            _p.telefono = item["telefono"];
          }
          if(item["ruc"] != null){
            _p.ruc = item["ruc"];
          }
          if(item["cedula"] != null){
            _p.cedula = item["cedula"];
          }
          if(item["fechaNacimiento"] != null){
            _p.fechaNacimiento = item["fechaNacimiento"];
          }
          if(item["usuarioLogin"] == widget.usuario){
            userLogueado = _p;
          }
          personas.add(_p);
        }
        //print(personas);
        return personas;

      }else{
        throw Exception("Fallo la conexion");
      }

    } catch (Exc) {
      print(Exc);
      rethrow;
    }

  }
  @override
  void initState() {
    _listadoPersonas = _getPersonas();
    userLogueado = widget.usuario;
    print(_listadoPersonas.runtimeType);
  }

  @override
  Widget build(BuildContext context) {
    print("El id del usuario logueado es "+widget.usuario.idPersona.toString());
    return Scaffold(
      appBar: AppBar(
        title: Text("Menu"),
      ),
      body: modulos(userLogueado,profesionales: widget.profesionales,),
    );
  }


}

class modulos extends StatefulWidget {
  final List<Persona> profesionales;
  final Persona userLogueado;
  const modulos(this.userLogueado,{Key? key, required this.profesionales}) : super(key: key);

  @override
  State<modulos> createState() => _modulosState();
}

class _modulosState extends State<modulos> {
  @override
  Widget build(BuildContext context) {
    print("user logueado en el menu "+ widget.userLogueado.idPersona.toString());
    return Container(
      decoration: BoxDecoration(
          image: DecorationImage(image: NetworkImage("https://img.freepik.com/foto-gratis/cerca-persona-que-trabaja-como-enfermera-smartphone-pantalla-tactil-estudio-asistente-medico-estetoscopio-uniforme-azul-guantes-mientras-usa-telefono-celular-sobre-fondo-aislado_482257-28983.jpg?w=360&t=st=1666895082~exp=1666895682~hmac=67b850c561ad652767620b88093ae26cf2fdd0b0548aeea3ed96ab55bc0b6cc4"),
              fit: BoxFit.cover
          )
      ),
      child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              botonPacientes(),
              SizedBox(height: 15),
              botonReservas(widget.userLogueado,profesionales: widget.profesionales,),
              SizedBox(height: 15),
              botonFicha(),
              SizedBox(height: 15),
              botonSalir(),
            ],
          )
      ),
    );
  }


}

class botonPacientes extends StatefulWidget {

  @override
  State<botonPacientes> createState() => _botonPacientesState();
}

class _botonPacientesState extends State<botonPacientes> {
  final ButtonStyle flatButtonStyle = TextButton.styleFrom(
    foregroundColor: Colors.white, minimumSize: Size(88, 44),
    padding: EdgeInsets.symmetric(horizontal: 16.0),
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(2.0)),
    ),
    backgroundColor: Colors.blue,
  );

  @override
  Widget build(BuildContext context) {
    return TextButton(
      style: flatButtonStyle,
      onPressed: () {
        Navigator.push(
            context,
            MaterialPageRoute(builder: (context)=> Pacientes())
        );
        print('Button pressed');
      },
      child: Text('PACIENTES'),
    );
  }
}


class botonReservas extends StatefulWidget {
  final List<Persona> profesionales;
  final Persona userLogueado;
  const botonReservas(this.userLogueado,{Key? key, required this.profesionales}) : super(key: key);

  @override
  State<botonReservas> createState() => _botonReservasState();
}

class _botonReservasState extends State<botonReservas> {
  final ButtonStyle flatButtonStyle = TextButton.styleFrom(
    foregroundColor: Colors.white, minimumSize: Size(88, 44),
    padding: EdgeInsets.symmetric(horizontal: 16.0),
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(2.0)),
    ),
    backgroundColor: Colors.blue,
  );

  @override
  Widget build(BuildContext context) {
    return TextButton(
      style: flatButtonStyle,
      onPressed: () {
        Navigator.push(
            context,
            MaterialPageRoute(builder: (context)=> Reservas(widget.userLogueado,profesionales: widget.profesionales,))
        );
        print('Button pressed');
      },
      child: Text('RESERVAS'),
    );
  }
}


class botonFicha extends StatelessWidget {

  final ButtonStyle flatButtonStyle = TextButton.styleFrom(
    foregroundColor: Colors.white, minimumSize: Size(88, 44),
    padding: EdgeInsets.symmetric(horizontal: 16.0),
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(2.0)),
    ),
    backgroundColor: Colors.blue,
  );

  @override
  Widget build(BuildContext context) {
    return TextButton(
      style: flatButtonStyle,
      onPressed: () {
        Navigator.push(
            context,
            MaterialPageRoute(builder: (context)=> Fichas())
        );
        print('Button pressed');
      },
      child: Text('FICHAS'),
    );
  }
}


class botonSalir extends StatelessWidget {

  final ButtonStyle flatButtonStyle = TextButton.styleFrom(
    foregroundColor: Colors.white, minimumSize: Size(88, 44),
    padding: EdgeInsets.symmetric(horizontal: 16.0),
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(2.0)),
    ),
    backgroundColor: Colors.blue,
  );

  @override
  Widget build(BuildContext context) {
    return TextButton(
      style: flatButtonStyle,
      onPressed: () {
        Navigator.push(
            context,
            MaterialPageRoute(builder: (context)=> MyApp())
        );
        print('Button pressed');
      },
      child: Text('SALIR'),
    );
  }


}