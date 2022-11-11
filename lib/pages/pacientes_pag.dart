import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:frontend_segunda_parcial/models/persona.dart';
import 'package:http/http.dart' as http;
import 'package:frontend_segunda_parcial/pages/agg_paciente.dart';

class Pacientes extends StatefulWidget {

  const Pacientes({Key? key}) : super(key: key);


  @override
  State<Pacientes> createState() => _PacientesState();
}

class _PacientesState extends State<Pacientes> {

  late String name = "";
  late String lastName = "";
  late bool porName = false;

  TextEditingController editingController = TextEditingController();

  Future<List<Persona>>? _listadoPersonas;

  List<Persona> items =[];

  Future<List<Persona>> _getPersonas(url) async{
    try {
      //final url = "https://equipoyosh.com/stock-nutrinatalia/persona";

      final response = await http.get(Uri.parse(url));

      List<Persona> personas = [];

      print(response.statusCode);
      if(response.statusCode == 200){
        String body = utf8.decode(response.bodyBytes);
        final jsonData = jsonDecode(body);
        print(jsonData["lista"]);

        for (var item in jsonData["lista"]){
          Persona _p = Persona(0, "", "", "", "", "", "", "", "", "", "");
          _p.nombreCompleto = item["nombreCompleto"];
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
          personas.add(_p);
          print(_p.idPersona);
          print(_p.nombre);
          print(_p.apellido);
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

  bool buscador = false;
  bool buscar = false;
  late String v;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Pacientes"),
        actions: [
          GestureDetector(
            onTap: (){
              setState(() {
                buscador = !buscador;
                print(buscador);
              });
            },
            child: Icon(Icons.search),
          )
        ],
      ),
      body: getcuerpo(),
      floatingActionButton: botonAggPacientes(),
    );
  }



  @override
  void initState() {
    if(name == "" && lastName == "" && buscar == false){
      final url = "https://equipoyosh.com/stock-nutrinatalia/persona";
      _listadoPersonas = _getPersonas(url);
    }else if(name == "nombre" && buscar == false){
      final url = "https://equipoyosh.com/stock-nutrinatalia/persona?inicio=0&orderBy=nombre&orderDir=asce";
      _listadoPersonas = _getPersonas(url);
    }else if(lastName == "apellido" && buscar == false){
      final url = "https://equipoyosh.com/stock-nutrinatalia/persona?inicio=0&orderBy=apellido&orderDir=asce";
      _listadoPersonas = _getPersonas(url);
    }else if(buscar == true){
      var url = "https://equipoyosh.com/stock-nutrinatalia/persona?like=S&ejemplo=%7B%22apellido%22%3A%22$v%22%7D";
      _listadoPersonas = _getPersonas(url);
    }else if(buscar == true && porName){
      var url = "https://equipoyosh.com/stock-nutrinatalia/persona?like=S&ejemplo=%7B%22nombre%22%3A%22$v%22%7D";
      _listadoPersonas = _getPersonas(url);
    }



    print(_listadoPersonas);
  }


  Widget getcuerpo(){
    return FutureBuilder(
      future: _listadoPersonas,
      builder: (context, snapshot){
        if(snapshot.hasData){
          //print(snapshot.data);
          final _listaDePersonasAPI = snapshot.data!;
          List<Persona> listaNombresCompletos =[];

          listaNombresCompletos.addAll(_listaDePersonasAPI);
          items.addAll(listaNombresCompletos);

          //print(_listaDePersonasAPI);
          return Column(
            children: [
              (buscador)
                  ? Container(
                    height: 70,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(50),
                        bottomRight: Radius.circular(50)
                      )
                    ),
                    child: GestureDetector(
                      onTap: (){
                        FocusScopeNode currentFocus = FocusScope.of(context);
                        if (!currentFocus.hasPrimaryFocus) {
                          currentFocus.unfocus();
                        }
                      },
                      child: Padding(
                        child: TextField(
                          onChanged: (value){
                            buscar = true;
                            v = value;
                            print("La palabra ingresada es "+v);
                            //var url = "https://equipoyosh.com/stock-nutrinatalia/persona?like=S&ejemplo=%7B%22apellido%22%3A%22$v%22%7D";
                            //_listadoPersonas = _getPersonas(url);
                            setState(() {
                              initState();
                            });
                          },
                          controller: editingController,
                          decoration: const InputDecoration(
                              labelText: "Search",
                              hintText: "Search",
                              prefixIcon: Icon(Icons.search),
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.all(Radius.circular(25.0)))),
                        ),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 15,
                          vertical: 10
                        )
                      ),
                    ),
              ):Container(child: null),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: ListTile(
                  onTap: (){
                    showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: Text("Ordenar"),
                          content: Text("Seleccione el metodo de ordenado"),
                          actions: [
                            Center(
                              child: Column(
                                children: [
                                  ElevatedButton(
                                    onPressed: () {
                                      porName = true;
                                      name = "nombre";
                                      lastName = "";
                                      buscador = false;
                                      buscar = false;
                                      setState(() {
                                        initState();
                                        Navigator.pop(context);
                                      });
                                    },
                                    child: Text('Nombre'),
                                  ),
                                  ElevatedButton(
                                    onPressed: () {
                                      porName = false;
                                      name = "";
                                      lastName = "apellido";
                                      buscador = false;
                                      buscar = false;
                                      setState(() {
                                        initState();
                                        Navigator.pop(context);
                                      });

                                    },
                                    child: Text('Apellido'),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                      print("Cancelar");
                                    },
                                    child: Text('Cancelar'),
                                  ),
                                ],
                              ),
                            )
                          ],
                        ));
                  },
                  title: Text("Ordenar por"),
                  trailing: Icon(Icons.align_horizontal_left_rounded),
                ),
              ),
              Expanded(
                child: ListView.builder(
                    itemCount: _listaDePersonasAPI.length,
                    shrinkWrap: true,
                    itemBuilder: (context,index){
                      return ListTile(
                        onTap: (){
                          showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                title: Text("Datos del Paciente"),
                                content: Text("Nombre: "+ _listaDePersonasAPI[index].nombre +"\nApellido: "+ _listaDePersonasAPI[index].apellido!
                                    +"\nEmail: "+ _listaDePersonasAPI[index].email!+"\nTelefono: "+ _listaDePersonasAPI[index].telefono!
                                    +"\nRuc: "+ _listaDePersonasAPI[index].ruc!+"\nCedula: "+ _listaDePersonasAPI[index].cedula!),
                                actions: [
                                  ElevatedButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    child: Text('Aceptar'),
                                  )
                                ],
                              ));
                        },
                        title: Text(_listaDePersonasAPI[index].nombreCompleto),
                        subtitle: Text(""+ _listaDePersonasAPI[index].email!),
                        leading: CircleAvatar(
                          child: Text(_listaDePersonasAPI[index].nombre.substring(0,1)),
                        ),
                        trailing: Icon(Icons.arrow_forward_ios),
                      );

                    }),
              ),
            ],
          );
        }else if(snapshot.hasError){
          print(snapshot.error);
          return Text("Error");
        }
        return Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }

  Widget botonAggPacientes(){
    return FloatingActionButton(
      onPressed: () {
        Navigator.push(
            context,
            MaterialPageRoute(builder: (context)=> Agg_paciente())
        );
        print('Button pressed');
      },
      child: Icon(Icons.add),
    );
  }
}

