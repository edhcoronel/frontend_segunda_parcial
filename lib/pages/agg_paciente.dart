import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;


class Agg_paciente extends StatefulWidget {
  const Agg_paciente({Key? key}) : super(key: key);

  @override
  State<Agg_paciente> createState() => _Agg_pacienteState();
}

class _Agg_pacienteState extends State<Agg_paciente> {


 final _formKey = GlobalKey<FormState>();
 final nombreController = TextEditingController();
 final apellidoController = TextEditingController();
 final emailController = TextEditingController();
 final telefonoController = TextEditingController();
 final rucController = TextEditingController();
 final cedulaController = TextEditingController();
 final tipoPersonaController = TextEditingController();
 final diaController = TextEditingController();
 final mesController = TextEditingController();
 final anoController = TextEditingController();

 final headers = {"Content-Type":"application/json"};
 final url = Uri.parse("https://equipoyosh.com//stock-nutrinatalia/persona");

 @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Agregar Paciente"),
        ),
      body: ListView(
          padding: EdgeInsets.all(15),
          children: [
            Form(key: _formKey, child: Column(children: [
              Text("Datos del paciente",
                style: TextStyle(
                    color: Colors.blueGrey,
                    fontSize: 25.0,
                    fontWeight: FontWeight.bold
                ),
              ),
              SizedBox(height: 15,),
              TextFormField(
                controller: nombreController,
                validator: (value){
                  if(value!.isEmpty){
                    return "* Campo Obligatorio";
                  }
                  return null;
                },
                decoration: InputDecoration(
                    labelText: "Nombre",
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(50))
                    )
                ),
              ),
              SizedBox(height: 15,),
              TextFormField(
                controller: apellidoController,
                validator: (value){
                  if(value!.isEmpty){
                    return "* Campo Obligatorio";
                  }
                  return null;
                },
                decoration: InputDecoration(
                    labelText: "Apellido",
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(50))
                    )
                ),
              ),
              SizedBox(height: 15,),
              TextFormField(
                controller: emailController,
                keyboardType: TextInputType.emailAddress,
                validator: (value){
                  if(value!.isEmpty){
                    return "* Campo Obligatorio";
                  }
                  return null;
                },
                decoration: InputDecoration(
                    labelText: "Email",
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(50))
                    )
                ),
              ),
              SizedBox(height: 15,),
              TextFormField(
                controller: telefonoController,
                decoration: InputDecoration(
                    labelText: "Telefono",
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(50))
                    )
                ),
              ),
              SizedBox(height: 15,),
              TextFormField(
                controller: rucController,
                decoration: InputDecoration(
                    labelText: "Ruc",
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(50))
                    )
                ),
              ),
              SizedBox(height: 15,),
              TextFormField(
                controller: cedulaController,
                validator: (value){
                  if(value!.isEmpty){
                    return "* Campo Obligatorio";
                  }
                  return null;
                },
                decoration: InputDecoration(
                    labelText: "Cedula",
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(50))
                    )
                ),
              ),
              SizedBox(height: 15,),
              TextFormField(
                controller: tipoPersonaController,
                decoration: InputDecoration(
                    labelText: "Tipo de Persona",
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(50))
                    )
                ),
              ),
              SizedBox(height: 15,),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                      print("Cancelar");
                    },
                    child: Text('Cancelar'),
                  ),
                  SizedBox(width: 10,),
                  ElevatedButton(
                    onPressed: () {
                      if(_formKey.currentState!.validate()){
                        savePaciente();
                        Navigator.pop(context);
                        print("Guardar");
                      }
                    },
                    child: Text('Guardar'),
                  ),
                ],
              )
            ],
            )
            ),
          ],
      ),

    );
  }

  void savePaciente() async {

    final _newPaciente = {
      "nombre": nombreController.text,
      "apellido": apellidoController.text,
      "email": emailController.text,
      "telefono": telefonoController.text,
      "ruc": rucController.text,
      "cedula": cedulaController.text,
      "tipoPersona": tipoPersonaController.text,
      "fechaNacimiento": anoController.text+"-"+ mesController.text +"-"+diaController.text + " 00:00:00"
    };
    print(_newPaciente);
    print(await http.post(url, headers: headers,body: jsonEncode(_newPaciente)));
    nombreController.clear();
    apellidoController.clear();
    emailController.clear();
    telefonoController.clear();
    rucController.clear();
    cedulaController.clear();
    tipoPersonaController.clear();
    diaController.clear();
    mesController.clear();
    anoController.clear();
  }

}