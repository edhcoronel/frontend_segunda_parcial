import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:frontend_segunda_parcial/pages/menu_pag.dart';
import 'package:frontend_segunda_parcial/models/persona.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(const MyApp());

}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mi App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
          appBar: AppBar(
            title: Text("Mi app"),
          ),
          body: login()
      ),//const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}


//-----------------------------------------------------------------------------



class login extends StatefulWidget {
  const login({Key? key}) : super(key: key);

  @override
  State<login> createState() => _loginState();
}

class _loginState extends State<login> {

  Future<List<Persona>>? _listadoPersonas;

  List<Persona> usersValidos =[];

  Future<List<Persona>> _getPersonas(url) async{
    try {
      //final url = "https://equipoyosh.com/stock-nutrinatalia/persona";

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
          _p.tipoPersona = item["tipoPersona"];
          if(item["usuarioLogin"] != null){
            _p.usuarioLogin = item["usuarioLogin"];
          }
          _p.nombreCompleto = item["nombreCompleto"];
          if(item["fechaNacimiento"] != null){
            _p.fechaNacimiento = item["fechaNacimiento"];
          }
          print(_p.idPersona.toString() + " "+ _p.nombreCompleto + " "+ _p.email.toString()+ " "+ _p.telefono.toString()+ " "+ _p.ruc.toString()
              + " "+ _p.cedula.toString()+ " "+ _p.tipoPersona.toString()+ " "+ _p.usuarioLogin.toString()+ " "+ _p.fechaNacimiento.toString());
          personas.add(_p);
          usersValidos.add(_p);
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
  Widget build(BuildContext context) {

    TextEditingController userController = TextEditingController(text: "");
    TextEditingController passController = TextEditingController(text: "");
    final passwordValid = "1234";
    var checkUser = false;


    final _formKey = GlobalKey<FormState>();  //para verificacion de los cambos de carga de texto

    Persona userLogueado = Persona(0, "", "", "", "", "", "", "", "", "", "");   //objeto persona para el usuario que va loguearse

    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(image: NetworkImage("https://img.freepik.com/foto-gratis/cerca-persona-que-trabaja-como-enfermera-smartphone-pantalla-tactil-estudio-asistente-medico-estetoscopio-uniforme-azul-guantes-mientras-usa-telefono-celular-sobre-fondo-aislado_482257-28983.jpg?w=360&t=st=1666895082~exp=1666895682~hmac=67b850c561ad652767620b88093ae26cf2fdd0b0548aeea3ed96ab55bc0b6cc4"),
          fit: BoxFit.cover
        )
      ),
      child: Center(
        child: Form(key: _formKey,child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Sing In",
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 35.0,
                  fontWeight: FontWeight.bold
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
              child: TextFormField(
                validator: (value){
                  if(value!.isEmpty){
                    return "* Ingrese su usuario";
                  }
                  return null;
                },
                controller: userController,
                decoration: InputDecoration(
                  hintText: "User",
                  fillColor: Colors.white,
                  filled: true,
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
              child: TextFormField(
                controller: passController,
                validator: (value){
                  if(value!.isEmpty){
                    return "* Ingrese su password";
                  }
                  return null;
                },
                obscureText: true,
                decoration: InputDecoration(
                  hintText: "Password",
                  fillColor: Colors.white,
                  filled: true,
                ),
              ),
            ),
            SizedBox(height: 10),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  if(_formKey.currentState!.validate()) {

                    for(var item in usersValidos){
                      if(item.usuarioLogin == userController.text){
                        userLogueado = item;
                        checkUser = true;
                        if(passwordValid != passController.text){
                          showDialog(
                              context: context,
                              builder: (context){
                                return AlertDialog(
                                  title: Text("Contraseña incorrecta"),
                                  content: Text("Acceso Invalido. Por favor, intentelo otra vez"),
                                  actions: [
                                    Center(
                                      child: ElevatedButton(
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                        child: Text('Ok'),
                                      ),
                                    ),
                                  ],
                                );
                              });
                          break;
                        }else {
                          Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => Menu(userLogueado,profesionales: usersValidos,))
                          );
                          break;
                        }
                      }
                    }
                    if(checkUser == false){
                      showDialog(
                          context: context,
                          builder: (context){
                            return AlertDialog(
                              title: Text("Usuario no valido"),
                              content: Text("El usuario ingresado no es valido. Por favor, intentelo otra vez"),
                              actions: [
                                Center(
                                  child: ElevatedButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    child: Text('Ok'),
                                  ),
                                ),
                              ],
                            );
                          });
                    }

                    print('Button pressed');
                  }
                },
                child: Text('ENTRAR'),
              ),
            ),
          ],
        ),)
      ),
      );
  }

  @override
  void initState() {
    // TODO: implement initState
    final url = "https://equipoyosh.com/stock-nutrinatalia/persona?ejemplo=%7B%22soloUsuariosDelSistema%22%3Atrue%7D";
    _listadoPersonas = _getPersonas(url);

    print(_listadoPersonas);
  }

}
