import 'package:flutter/material.dart';
import 'package:frontend_segunda_parcial/models/reserva.dart';
import 'package:http/http.dart' as http;
import 'package:frontend_segunda_parcial/models/persona.dart';
import 'dart:convert';

class OtrasReservas extends StatefulWidget {
  final List<Persona> profesionales;
  final Persona userLogueado;
  final DateTime fechaForListReservas;
  final Persona fisioterapeuta;
  const OtrasReservas({Key? key, required this.profesionales, required this.userLogueado, required this.fechaForListReservas, required this.fisioterapeuta}) : super(key: key);

  @override
  State<OtrasReservas> createState() => _OtrasReservasState();
}

class _OtrasReservasState extends State<OtrasReservas> {

  Future<List<Reserva>>? _listadoReservas;
  Future<List<Reserva>> _getReservas(url) async {
    var id = widget.userLogueado.idPersona;
    print(id);
    DateTime dateToday =DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);
    print(dateToday);
    //print("id del usuario logueado: "+id.toString()+", la fecha de hoy es: "+dateToday.toString());

    final response = await http.get(Uri.parse(url));

    List<Reserva> reservas = [];

    print(response.statusCode);
    if (response.statusCode == 200) {
      String body = utf8.decode(response.bodyBytes);
      final jsonData = jsonDecode(body);
      //print(jsonData);

      for (var item in jsonData) {
        Reserva _r = Reserva(0, "", "", "", "", "", "", "");
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
          //print("entro aca empleado");
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
          //print("entro aca cliente");
          _r.cliente = item["idCliente"]["nombreCompleto"];
        }else{
          _r.cliente = "";
        }
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
  void callDatePicker() async{
    var selectedDate = await getDatePickerWidget();
    setState(() {
      _currentSelectedDate = selectedDate;
    });
    print(_currentSelectedDate);
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

  @override
  Widget build(BuildContext context) {
    var lisAux = widget.profesionales;
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
                                  itemCount: lisAux.length,
                                  //shrinkWrap: true,
                                  itemBuilder: (context,index){
                                    return ListTile(
                                      onTap: (){

                                        getDatePickerWidget;
                                      },
                                      title: Text(lisAux[index].nombreCompleto),
                                      subtitle: Text(lisAux[index].email!),
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
                    trailing: Icon(Icons.add),
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                      itemCount: _listaDeReservasAPI.length,
                      itemBuilder: (context,index){
                        return ListTile(
                          onTap: (){
                            showDialog(
                                context: context,
                                builder: (context) => AlertDialog(
                                  title: Text("Info de Reserva"),
                                  content: Text("Fecha: "+ _listaDeReservasAPI[index].fecha +"\nHora Inicio: "+ _listaDeReservasAPI[index].horaInicio
                                      +"\nHora Fin: "+ _listaDeReservasAPI[index].horaFin+"\nFisioterapeuta: "+ _listaDeReservasAPI[index].empleado+"\nPaciente: "+ _listaDeReservasAPI[index].cliente),
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
                          title: Text(_listaDeReservasAPI[index].horaInicio),
                          subtitle: Text("Fecha. "+ _listaDeReservasAPI[index].fecha),
                          leading: CircleAvatar(
                            child: Text(_listaDeReservasAPI[index].horaInicio.substring(0,2)),
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

  void initState() {

    DateTime fechaReservas = widget.fechaForListReservas;
    print(fechaReservas);
    var fechaReservasCadena;
    if(fechaReservas.day < 10 && fechaReservas.month < 10){
      fechaReservasCadena = fechaReservas.year.toString()+"0"+fechaReservas.month.toString()+"0"+fechaReservas.day.toString();
    }else if(fechaReservas.day < 10){
      fechaReservasCadena = fechaReservas.year.toString()+fechaReservas.month.toString()+"0"+fechaReservas.day.toString();
    }else if(fechaReservas.month < 10){
      fechaReservasCadena = fechaReservas.year.toString()+"0"+fechaReservas.month.toString()+fechaReservas.day.toString();
    }else{
      fechaReservasCadena = fechaReservas.year.toString()+fechaReservas.month.toString()+fechaReservas.day.toString();
    }
    print(fechaReservasCadena);
    var idfisio = widget.fisioterapeuta.idPersona;
    var url = "https://equipoyosh.com/stock-nutrinatalia/persona/$idfisio/agenda?fecha=$fechaReservasCadena";
    _listadoReservas = _getReservas(url);

  }
}
