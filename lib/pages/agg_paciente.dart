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
 final fechaNacimientoController = TextEditingController();
 final diaController = TextEditingController();
 final mesController = TextEditingController();
 final anoController = TextEditingController();

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
              SizedBox(height: 10,),
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
              SizedBox(height: 10,),
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
              SizedBox(height: 10,),
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
              SizedBox(height: 10,),
              TextFormField(
                controller: telefonoController,
                decoration: InputDecoration(
                    labelText: "Telefono",
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(50))
                    )
                ),
              ),
              SizedBox(height: 10,),
              TextFormField(
                controller: rucController,
                decoration: InputDecoration(
                    labelText: "Ruc",
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(50))
                    )
                ),
              ),
              SizedBox(height: 10,),
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
              SizedBox(height: 10,),
              TextFormField(
                controller: tipoPersonaController,
                decoration: InputDecoration(
                    labelText: "Tipo de Persona",
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(50))
                    )
                ),
              ),
              SizedBox(height: 10,),
              /*TextFormField(
                controller: fechaNacimientoController,
                decoration: InputDecoration(
                    labelText: "Fecha de nacimiento",
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(50))
                    )
                ),
              ),*/
            ],
            )
            ),
            Text("   Fecha de Nacimiento: ",style: TextStyle(fontSize: 16),),
            MaterialButton(
              onPressed: () {
                callDatePicker();
              },
              color: Colors.blue,
              padding: EdgeInsets.all(5),
              child: Text(
                "$dateToday                                                       ▼",
                style: TextStyle(color: Colors.white,fontSize: 18,),
              ),
            ),
            //showFechaNacimiento(_currentSelectedDate)/*Text("$_currentSelectedDate")*/,
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () {
                    //savePaciente();
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
      ),

    );
  }
 String dateToday = DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day).toString().substring(0,10);
 var _currentSelectedDate;
 //1. call de nuestro datapicker
 void callDatePicker() async{
   var selectedDate = await getDatePickerWidget();
   setState(() {
     _currentSelectedDate = selectedDate;
   });
   dateToday = _currentSelectedDate.toString().substring(0,10);
 }
 Future<DateTime?> getDatePickerWidget(){
   return showDatePicker(
     context: context,
     initialDate: DateTime.now(),
     firstDate: DateTime(1960),
     lastDate: DateTime(2025),
     builder: (context, child){
       return Theme(data: ThemeData.fallback(), child: child!);
     },
   );
 }
 final headers = {"Content-Type":"application/json"};
 final url = Uri.parse("https://equipoyosh.com/stock-nutrinatalia/persona");

  void savePaciente() async {

    final _newPaciente = {
      "nombre": nombreController.text,
      "apellido": apellidoController.text,
      "email": emailController.text,
      "telefono": telefonoController.text,
      "ruc": rucController.text,
      "cedula": cedulaController.text,
      "tipoPersona": tipoPersonaController.text,
      "fechaNacimiento": _currentSelectedDate.toString()
    };
    print(_newPaciente.runtimeType);
    //var dio = Dio();
    print(url);
    print(_newPaciente);
    var body = jsonEncode(_newPaciente);
    print(body.runtimeType);
    final response = await http.post(url,body: body,headers: headers);

    print(response.statusCode);
    if(response.statusCode == 201){
      print("Paciente agg correctamente");
    }else{
      print("Error al cargar datos");
    }
    nombreController.clear();
    apellidoController.clear();
    emailController.clear();
    telefonoController.clear();
    rucController.clear();
    cedulaController.clear();
    tipoPersonaController.clear();
    fechaNacimientoController.clear();
  }

}

Widget showFechaNacimiento(nacimiento){
  var _fCadena = nacimiento.toString();
  print(_fCadena);
  _fCadena = _fCadena.substring(0,10);
  return Center(child: Text(_fCadena, style: TextStyle(fontSize: 18),),);
}