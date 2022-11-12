import 'dart:convert';


import 'package:flutter/material.dart';
import 'package:frontend_segunda_parcial/models/reserva.dart';
import 'package:http/http.dart' as http;

import 'package:frontend_segunda_parcial/models/persona.dart';
import 'package:frontend_segunda_parcial/pages/reservas_otros.dart';

class Reservas extends StatefulWidget {
  final List<Persona> profesionales;
  final List<Persona> pacientes;
  final Persona userLogueado;
  const Reservas(this.userLogueado,{Key? key, required this.profesionales, required this.pacientes}) : super(key: key);

  @override
  State<Reservas> createState() => _ReservasState();
}

class _ReservasState extends State<Reservas> {


  Future<List<Reserva>>? _listadoReservas;
  Future<List<Reserva>> _getReservas(url) async {
    var id = widget.userLogueado.idPersona;
    print(id);
    DateTime dateToday =DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);
    //print("id del usuario logueado: "+id.toString()+", la fecha de hoy es: "+dateToday.toString());
    print(dateToday);

    final response = await http.get(Uri.parse(url));

    List<Reserva> reservas = [];

    print(response.statusCode);
    if (response.statusCode == 200) {
      String body = utf8.decode(response.bodyBytes);
      final jsonData = jsonDecode(body);
      //print(jsonData);

      for (var item in jsonData) {
        Reserva _r = Reserva(0, "", "", "", "", "", "", "", "","","");
        //print(item["idReserva"]);
        _r.idReserva = item["idReserva"];
        //print(item["fecha"]);
        _r.fecha = item["fecha"];
        //print(item["horaFin"]);
        _r.horaFin = item["horaFin"];
        //print(item["horaInicio"]);
        _r.horaInicio = item["horaInicio"];
        //print(item["idReserva"]);
        //_r.idEmpleado = item["idEmpleado"];
        //_r.idCliente = item["idCliente"];
        if(item["idEmpleado"] != null){
          //_r.idEmpleado = item["idEmpleado"];
          //print("entro aca empleado valor de id Empleado"+_r.idEmpleado.toString());
          if(item["idEmpleado"]["nombreCompleto"].toString() != "null"){
            _r.empleado = item["idEmpleado"]["nombreCompleto"];
            //print("Nombre del empleado "+ _r.empleado);
          }else{
            _r.empleado = "";
          }

        }else{
          _r.empleado = "";
        }
        if(item["idCliente"] != null){
          //_r.idCliente = item["idCliente"];
          //print("entro aca cliente");
          _r.cliente = item["idCliente"]["nombreCompleto"];
        }else{
          _r.cliente = "";
        }
        _r.fechaCadena = item["fechaCadena"];
        _r.horaInicioCadena = item["horaInicioCadena"];
        _r.horaFinCadena = item["horaFinCadena"];
        print("Datos reserva: id:" +_r.idReserva.toString() +" fecha: " +_r.fecha+ " ini: "+_r.horaInicio+" fin"+_r.horaFin+" Empleado: "+_r.empleado+" Cliente: "+_r.cliente);
        reservas.add(_r);

      }
      //print(reservas);
      return reservas;
    } else {
      throw Exception("Fallo la conexion");
    }

  }
  var _currentSelectedDate;
  //1. call de nuestro datapicker
  void callDatePicker(context,lisAux,index) async{
    var selectedDate = await getDatePickerWidget();
    setState(() {
      _currentSelectedDate = selectedDate;
    });
    Navigator.push(
        context,
        MaterialPageRoute(builder: (context)=> OtrasReservas(profesionales: widget.profesionales, userLogueado: widget.userLogueado, fechaForListReservas: _currentSelectedDate,fisioterapeuta: lisAux[index],),)
    );
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

  //2. crear widget datapicker
  @override
  Widget build(BuildContext context) {
    //3. boton que lanaza nuestro dialog datapicker
    var lisAuxEmpleados = widget.profesionales;
    var lisAuxClientes = widget.pacientes;
    return Scaffold(
        appBar: AppBar(
          title: Text("Agenda del dia"),
        ),
        body: FutureBuilder(
          future: _listadoReservas,
          builder: (context, snapshot){
            if(snapshot.hasData){
              //print(snapshot.data);
              final _listaDeReservasAPI = snapshot.data!;
              List<Reserva> ListaReservasCompletas = [];

              ListaReservasCompletas.addAll(_listaDeReservasAPI);

              //print(_listaDeReservasAPI);
              return Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(2.0),
                    child: ListTile(
                      onTap: (){
                        showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: Text("Seleccionar fisioterapeuta"),
                              content: Container(
                                height: 300,
                                width: 300,
                                child: ListView.builder(
                                    itemCount: lisAuxEmpleados.length,
                                    //shrinkWrap: true,
                                    itemBuilder: (context,index){
                                      return ListTile(
                                        onTap: (){
                                          callDatePicker(context,lisAuxEmpleados,index);
                                          print(_currentSelectedDate);
                                        },
                                        title: Text(lisAuxEmpleados[index].nombreCompleto),
                                        subtitle: Text(lisAuxEmpleados[index].email!),
                                        leading: const Icon(Icons.account_circle_outlined),
                                      );
                                    }),
                              ),
                              actions: [
                                Center(
                                  child:TextButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                      print("Cancelar");
                                    },
                                    child: Text('Cancelar'),
                                  ),
                                )
                              ],
                            ));
                      },
                      title: Text("Fisioterapeutas"),
                      trailing: Icon(Icons.assignment_rounded),
                    ),
                  ),
                  Expanded(
                    child: ListView.builder(
                        itemCount: _listaDeReservasAPI.length,
                        itemBuilder: (context,index){
                          return ListTile(
                            onTap: (){

                              var fisio = widget.userLogueado.usuarioLogin;
                              var fechaCadena = _listaDeReservasAPI[index].fechaCadena;
                              var iniCadena = _listaDeReservasAPI[index].horaInicioCadena;
                              var finCadena = _listaDeReservasAPI[index].horaFinCadena;
                              var idEmpleado = widget.userLogueado.idPersona;
                              var idCliente;

                              if(_listaDeReservasAPI[index].cliente == ""){
                                showDialog(
                                    context: context,
                                    builder: (context) => AlertDialog(
                                      title: Text("Info de Reserva"),
                                      content: getInfoReserva(_listaDeReservasAPI[index].fecha,_listaDeReservasAPI[index].horaInicioCadena,_listaDeReservasAPI[index].horaFinCadena,_listaDeReservasAPI[index].empleado,_listaDeReservasAPI[index].cliente)/*Text("Fecha: "+ _listaDeReservasAPI[index].fecha.substring(0,10) +"\nHora Inicio: "+ _listaDeReservasAPI[index].horaInicio
                                        +"\nHora Fin: "+ _listaDeReservasAPI[index].horaFin+"\nFisioterapeuta: "+ _listaDeReservasAPI[index].empleado+"\nPaciente: "+ _listaDeReservasAPI[index].cliente)*/,
                                      actions: [
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            TextButton(
                                              onPressed: () {
                                                Navigator.pop(context);
                                                print("Atras");
                                              },
                                              child: Text('Atras'),
                                            ),
                                            ElevatedButton(
                                              onPressed: () {
                                                showDialog(
                                                    context: context,
                                                    builder: (context) => AlertDialog(
                                                      title: Text("Seleccionar Paciente"),
                                                      content: Container(
                                                        height: 300,
                                                        width: 300,
                                                        child: ListView.builder(
                                                            itemCount: lisAuxClientes.length,
                                                            //shrinkWrap: true,
                                                            itemBuilder: (context,index){
                                                              return ListTile(
                                                                onTap: (){
                                                                  idCliente = lisAuxClientes[index].idPersona;
                                                                  //callDatePicker(context,lisAuxClientes,index);

                                                                  saveReserva(fisio,fechaCadena,iniCadena,finCadena,idEmpleado,idCliente);
                                                                  setState(() {
                                                                    initState();
                                                                  });
                                                                  },
                                                                title: Text(lisAuxClientes[index].nombreCompleto),
                                                                subtitle: Text(lisAuxClientes[index].email!),
                                                                leading: const Icon(Icons.account_circle_outlined),
                                                              );
                                                            }),
                                                      ),
                                                      actions: [
                                                        Center(
                                                          child:TextButton(
                                                            onPressed: () {
                                                              Navigator.pop(context);
                                                              print("Cancelar");
                                                            },
                                                            child: Text('Cancelar'),
                                                          ),
                                                        )
                                                      ],
                                                    ));
                                                //Navigator.pop(context);
                                              },
                                              child: Text('Reservar'),
                                            ),
                                          ],
                                        )
                                      ],
                                    ));
                              }else{
                                showDialog(
                                    context: context,
                                    builder: (context) => AlertDialog(
                                      title: Text("Info de Reserva"),
                                      content: getInfoReserva(_listaDeReservasAPI[index].fecha,_listaDeReservasAPI[index].horaInicioCadena,_listaDeReservasAPI[index].horaFinCadena,_listaDeReservasAPI[index].empleado,_listaDeReservasAPI[index].cliente)/*Text("Fecha: "+ _listaDeReservasAPI[index].fecha.substring(0,10) +"\nHora Inicio: "+ _listaDeReservasAPI[index].horaInicio
                                        +"\nHora Fin: "+ _listaDeReservasAPI[index].horaFin+"\nFisioterapeuta: "+ _listaDeReservasAPI[index].empleado+"\nPaciente: "+ _listaDeReservasAPI[index].cliente)*/,
                                      actions: [
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            TextButton(
                                              onPressed: () {
                                                Navigator.pop(context);
                                                print("Atras");
                                              },
                                              child: Text('Atras'),
                                            ),
                                            ElevatedButton(
                                              onPressed: () {
                                                showDialog(
                                                    context: context,
                                                    builder: (context) => AlertDialog(
                                                      title: Text("Cancelar Reserva"),
                                                      content: Text("Seguro que quieres cancelar la reserva?"),
                                                      actions: [
                                                        Row(
                                                          mainAxisAlignment: MainAxisAlignment.center,
                                                          children: [
                                                            TextButton(
                                                              onPressed: () {
                                                                Navigator.pop(context);
                                                                print("No");
                                                              },
                                                              child: Text('NO'),
                                                            ),
                                                            ElevatedButton(
                                                                onPressed: (){
                                                                  deleteReserva(_listaDeReservasAPI[index].idReserva);
                                                                  Navigator.pop(context);
                                                                  setState(() {
                                                                    initState();
                                                                  });
                                                                  //Navigator.pop(context);
                                                                },
                                                                child: Text("SI"),
                                                            )
                                                          ],
                                                        )
                                                      ],
                                                    ));
                                                //Navigator.pop(context);
                                              },
                                              child: Text('Cancelar Reserva'),
                                            ),
                                          ],
                                        )
                                      ],
                                    ));
                              }
                            },
                            title: getTituloReserva(_listaDeReservasAPI[index].cliente)/*Text(_listaDeReservasAPI[index].horaInicio)*/,
                                subtitle: getSubtituloReserva(_listaDeReservasAPI[index].horaInicioCadena,_listaDeReservasAPI[index].horaFinCadena)/*Text("Fecha. "+ _listaDeReservasAPI[index].fecha.substring(0,10))*/,
                                    leading: CircleAvatar(
                                      child: Text(_listaDeReservasAPI[index].horaInicioCadena.substring(0,2)),
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
        ),

    );
  }

  @override
  void initState() {

    print(_listadoReservas);
    DateTime dateToday =DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);
    print(dateToday);
    var fechaHoy;
    if(dateToday.day < 10 && dateToday.month < 10){
      fechaHoy = dateToday.year.toString()+"0"+dateToday.month.toString()+"0"+dateToday.day.toString();
    }else if(dateToday.day < 10){
      fechaHoy = dateToday.year.toString()+dateToday.month.toString()+"0"+dateToday.day.toString();
    }else if(dateToday.month < 10){
      fechaHoy = dateToday.year.toString()+"0"+dateToday.month.toString()+dateToday.day.toString();
    }else{
      fechaHoy = dateToday.year.toString()+dateToday.month.toString()+dateToday.day.toString();
    }
    print(fechaHoy);
    var id = widget.userLogueado.idPersona;
    var url = "https://equipoyosh.com/stock-nutrinatalia/persona/$id/agenda?fecha=$fechaHoy";
    print(url);
    _listadoReservas = _getReservas(url);

  }

  void deleteReserva(idReserva) async{
    idReserva = idReserva.toString();
    print(idReserva.runtimeType);
    final url = Uri.parse("https://equipoyosh.com/stock-nutrinatalia/reserva/266");
    print(url);
    final response = await http.delete(url);
    print(response.statusCode);
    print(response.body);
    if(response.statusCode == 200){
      print("Reserva cancelada");
    }else{
      print("La reserva no puede ser cancelada");
    }
  }



  void saveReserva(fisio,fechaCadena,iniCadena,finCadena,idEmpleado,idCliente) async{
    final headers = {
      "Content-Type":"application/json",
      "usuario":fisio.toString()};
    print(headers);
    final url = Uri.parse("https://equipoyosh.com/stock-nutrinatalia/reserva");
    //final url = "https://equipoyosh.com/stock-nutrinatalia/reserva";

    final _newReserva = {
      "fechaCadena": fechaCadena,
      "horaInicioCadena": iniCadena,
      "horaFinCadena": finCadena,
      "idEmpleado": {"idPersona":idEmpleado},
      "idCliente": {"idPersona":idCliente}
    };
    //Dio dio = Dio();
    print(_newReserva.runtimeType);
    print(url);
    print(_newReserva);
    var body = jsonEncode(_newReserva);
    print(body.runtimeType);
    final response = await http.post(url,body: body,headers: headers);

    print(response.statusCode);
    print(response.body);
    if(response.statusCode == 200){
      print("Reserva agg correctamente");
    }else{
      print("Error al cargar datos");
    }
  }
}

Widget getTituloReserva(idPersona){
  late String _title;
  if(idPersona == ""){
    _title = "Disponible";
  }else{
    _title = "Reservado";
  }
  return Text(_title);
}

Widget getSubtituloReserva(horaIni,horaFin){
  late String _subtitle;

  horaIni = horaIni.substring(0,2) +":"+ horaIni.substring(2,4) + " hs.";
  horaFin = horaFin.substring(0,2) +":"+ horaFin.substring(2,4) + " hs.";

  _subtitle = horaIni + " a "+ horaFin;

  return Text(_subtitle);
}



Widget getInfoReserva(fecha,horaIni,horaFin,fisio,cliente){

  var estado;

  fecha = fecha.substring(0, 10);
  horaIni = horaIni.substring(0,2) +":"+ horaIni.substring(2,4) + " hs.";
  horaFin = horaFin.substring(0,2) +":"+ horaFin.substring(2,4) + " hs.";

  if(cliente == ""){
    estado = "Sin Reservar";
  }else{
    estado = "Reservado";
  }

  return Text("Estado: "+ estado +"\nFecha: "+ fecha +"\nHora Inicio: "+ horaIni
      +"\nHora Fin: "+ horaFin+"\nFisioterapeuta: "+ fisio+"\nPaciente: "+ cliente);
}

