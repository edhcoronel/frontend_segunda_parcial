import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:frontend_segunda_parcial/models/reserva.dart';
import 'package:http/http.dart' as http;
import 'package:frontend_segunda_parcial/models/persona.dart';

class Reservas extends StatefulWidget {
  final List<Persona> profesionales;
  final List<Persona> pacientes;
  final Persona userLogueado;
  const Reservas(this.userLogueado,{Key? key, required this.profesionales, required this.pacientes}) : super(key: key);

  @override
  State<Reservas> createState() => _ReservasState();
}
enum Asistio{si,no}
class _ReservasState extends State<Reservas> {

  DateTime hoy = DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);
  late bool allReservas = false;
  late bool porCliente = false;
  late bool porFisio = false;
  late int idFisio;
  late String userFisio;
  var idCliente;
  var nameCliente;
  late String nameFisio = widget.userLogueado.nombreCompleto;

  late bool misReservas = false;
  Future<List<Reserva>>? _listadoReservas;
  final myControllerOk = TextEditingController();
  final myControllerObs = TextEditingController();

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
      var contador = 0;
      print(allReservas == true || ((_fechaDesde != hoy || _fechaHasta != hoy) && allReservas == false) || porCliente == true);
      if(allReservas == true || ((_fechaDesde != hoy || _fechaHasta != hoy) && allReservas == false) || porCliente == true){
        for (var item in jsonData["lista"]) {
          print(contador++);
          Reserva _r = Reserva(0, "", "", "", "", "", "", "", "", "", "","","");
          //print(item["idReserva"]);
          if(item["flagAsistio"] != null){
            _r.flagAsistio = item["flagAsistio"];
          }else{
            _r.flagAsistio = "";
          }
          if(item["observacion"] != null){
            _r.observacion = item["observacion"];
          }else{
            _r.observacion = "";
          }
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
          //print("Datos reserva: id:" +_r.idReserva.toString() +" fecha: " +_r.fecha+ " ini: "+_r.horaInicio+" fin"+_r.horaFin+" Empleado: "+_r.empleado+" Cliente: "+_r.cliente);
          reservas.add(_r);

        }
      }else{
        for (var item in jsonData) {
          Reserva _r = Reserva(0, "", "", "", "", "", "", "", "", "", "","","");
          //print(item["idReserva"]);
          if(item["flagAsistio"] != null){
            _r.flagAsistio = item["flagAsistio"];
          }else{
            _r.flagAsistio = "";
          }
          if(item["observacion"] != null){
            _r.observacion = item["observacion"];
          }else{
            _r.observacion = "";
          }
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
      }

      //print(reservas);
      return reservas;
    } else {
      throw Exception("Fallo la conexion");
    }

  }
  var _currentSelectedDate;
  late DateTime _fechaDesde = hoy;
  late DateTime _fechaHasta = hoy;

  void getMensajeRangoNoValido(context,mensaje){
    showDialog(
        context: context,
        builder: (context){
          return AlertDialog(
            title: Text("Rango no valido"),
            content: Text(mensaje),
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


  void callDatePickerRango(contex,value) async{
    var selectedDate = await getDatePickerWidget();
    var aux1,aux2;
    setState(() {
      if(value == 1){
        if(selectedDate!.year > _fechaHasta.year){
          getMensajeRangoNoValido(context, "La fecha 'Desde' no puede ser MAYOR que la fecha 'Hasta'");
        }else if(selectedDate.year == _fechaHasta.year && selectedDate.month > _fechaHasta.month){
          getMensajeRangoNoValido(context, "La fecha 'Desde' no puede ser MAYOR que la fecha 'Hasta'");
        }else if(selectedDate.year == _fechaHasta.year && selectedDate.month == _fechaHasta.month && selectedDate.day > _fechaHasta.day){
          getMensajeRangoNoValido(context, "La fecha 'Desde' no puede ser MAYOR que la fecha 'Hasta'");
        }else{
          aux1 = selectedDate;
          _fechaDesde = aux1;
        }
        initState();
      }else if(value == 2){
        if(selectedDate!.year < _fechaDesde.year){
          getMensajeRangoNoValido(context, "La fecha 'Hasta' no puede ser MENOR que la fecha 'Desde'");
        }else if(selectedDate.year == _fechaDesde.year && selectedDate.month < _fechaDesde.month){
          getMensajeRangoNoValido(context, "La fecha 'Hasta' no puede ser MENOR que la fecha 'Desde'");
        }else if(selectedDate.year == _fechaDesde.year && selectedDate.month == _fechaDesde.month && selectedDate.day < _fechaDesde.day){
          getMensajeRangoNoValido(context, "La fecha 'Hasta' no puede ser MENOR que la fecha 'Desde'");
        }else{
          aux2 = selectedDate;
          _fechaHasta = aux2;
        }
        initState();
      }
    });
  }
  //1. call de nuestro datapicker
  void callDatePicker() async{
    var selectedDate = await getDatePickerWidget();
    setState(() {
      _currentSelectedDate = selectedDate;
    });

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
          title: getTitleAppBar(allReservas,porFisio,porCliente),
          actions: [
            PopupMenuButton<int>(
                //color: Colors.blue[100],
                onSelected: (value) {
                  if(value == 3){
                    showDialog(
                        context: context,
                        builder: (BuildContext context) => AlertDialog(
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
                                      nameCliente = lisAuxClientes[index].nombreCompleto;
                                      setState(() {
                                        initState();
                                      });
                                      Navigator.pop(context);
                                    },
                                    title: Text(lisAuxClientes[index].nombreCompleto),
                                    subtitle: Text(lisAuxClientes[index].email!),
                                    leading: const Icon(Icons.account_box_sharp),
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
                    print("Sale de onTap");
                  }
                  //Navigator.pop(context);
                },
                itemBuilder: (context) => [
                  PopupMenuItem(
                    value: 1,
                    child: Text("Todas las Reservas"),
                    onTap: (){
                      allReservas = true;
                      porCliente = false;
                      misReservas = false;
                      porFisio = false;
                      setState(() {
                        initState();
                      });
                      /*Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context)=> AllReservas(widget.userLogueado,profesionales: widget.profesionales,pacientes: widget.pacientes,))
                      );*/
                    },
                  ),
                  PopupMenuItem(
                    value: 2,
                    child: Text("Mis Reservas"),
                    onTap: (){
                      allReservas = false;
                      porCliente = false;
                      misReservas = true;
                      porFisio = false;
                      _fechaDesde = hoy;
                      _fechaHasta = hoy;
                      setState(() {
                        initState();
                      });
                    },
                  ),
                  PopupMenuItem(
                    value: 3,
                    child: Text("Por Cliente"),
                    onTap: (){
                      //var idCliente;
                      print("Entra en el onTap de la opcion por cliente");
                      allReservas = false;
                      porCliente = true;
                      misReservas = false;
                      porFisio = false;

                    },
                  ),

                ],)
          ],
        ),
        body: FutureBuilder(
          future: _listadoReservas,
          builder: (context, snapshot){
            if(snapshot.hasData){
              //print(snapshot.data);
              final _listaDeReservasAPI = snapshot.data!;
              List<Reserva> ListaReservasCompletas = [];
              var desde = _fechaDesde.toString().substring(0,10);
              var hasta = _fechaHasta.toString().substring(0,10);
              ListaReservasCompletas.addAll(_listaDeReservasAPI);

              //print(_listaDeReservasAPI);
              return Column(
                children: [
                (allReservas == false)
                  ? Container(
                    child: Row(
                      children: [
                        getNameAgenda(widget.userLogueado.nombreCompleto, nameFisio, porCliente,nameCliente),
                      ],
                    ),
                  ):Container(child: null),
                (allReservas == false && porCliente == false)
                 ? Container(
                   child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                      Text("Desde:  ",
                      style: TextStyle(fontSize: 16),),
                      MaterialButton(
                          onPressed: (){
                            callDatePickerRango(context,1);  //cargar en variable '_fechaDesde'
                          },
                          color: Colors.blue,
                          padding: EdgeInsets.all(5),
                          child: Text("$desde    ▼",
                              style: TextStyle(color: Colors.white,fontSize: 16,))
                      ),
                      Text("  Hasta:  ",
                        style: TextStyle(fontSize: 16),),
                      MaterialButton(
                          onPressed: (){
                            callDatePickerRango(context,2);   //cargar en variable '_fechaHasta'
                          },
                          color: Colors.blue,
                          padding: EdgeInsets.all(5),
                          child: Text("$hasta    ▼",
                              style: TextStyle(color: Colors.white,fontSize: 16,))
                      )
                    ],),
                 ):Container(child: null),
                (allReservas == false)
                 ? Container(
                   child: Padding(
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
                                            //callDatePicker();
                                            if(lisAuxEmpleados[index].idPersona == widget.userLogueado.idPersona){
                                              allReservas = false;
                                              porCliente = false;
                                              misReservas = true;
                                              porFisio = false;
                                              _fechaDesde = hoy;
                                              _fechaHasta = hoy;
                                              nameFisio = lisAuxEmpleados[index].nombreCompleto;
                                              setState(() {
                                                initState();
                                              });
                                            }else{
                                              allReservas = false;
                                              porCliente = false;
                                              misReservas = false;
                                              porFisio = true;
                                              idFisio = lisAuxEmpleados[index].idPersona;
                                              userFisio = lisAuxEmpleados[index].usuarioLogin;
                                              nameFisio = lisAuxEmpleados[index].nombreCompleto;
                                              _fechaDesde = hoy;
                                              _fechaHasta = hoy;
                                              setState(() {
                                                initState();
                                              });
                                            }
                                            print(_currentSelectedDate);
                                            Navigator.pop(context);
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
                        trailing: Icon(Icons.arrow_drop_down_sharp),
                      ),
                    ),
                 ):Container(child: null),
                  Expanded(
                    child: ListView.builder(
                        itemCount: _listaDeReservasAPI.length,
                        itemBuilder: (context,index){
                          return ListTile(
                            onLongPress: (){
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
                                      content: getInfoReserva(_listaDeReservasAPI[index].fecha,_listaDeReservasAPI[index].horaInicioCadena,_listaDeReservasAPI[index].horaFinCadena,_listaDeReservasAPI[index].empleado,_listaDeReservasAPI[index].cliente,_listaDeReservasAPI[index].flagAsistio,_listaDeReservasAPI[index].observacion)/*Text("Fecha: "+ _listaDeReservasAPI[index].fecha.substring(0,10) +"\nHora Inicio: "+ _listaDeReservasAPI[index].horaInicio
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
                                                                  if(porFisio == true){
                                                                    fisio = userFisio;
                                                                  }

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
                                      content: getInfoReserva(_listaDeReservasAPI[index].fecha,_listaDeReservasAPI[index].horaInicioCadena,_listaDeReservasAPI[index].horaFinCadena,_listaDeReservasAPI[index].empleado,_listaDeReservasAPI[index].cliente,_listaDeReservasAPI[index].flagAsistio,_listaDeReservasAPI[index].observacion)/*Text("Fecha: "+ _listaDeReservasAPI[index].fecha.substring(0,10) +"\nHora Inicio: "+ _listaDeReservasAPI[index].horaInicio
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
                                                      title: Text("Completar Reserva"),
                                                      content: Text("Agregar datos de asistencia y observacion"),
                                                      actions: [

                                                        Row(
                                                          children: [
                                                            Text("Asistio: "),
                                                            Text(""),
                                                          ],
                                                        ),
                                                        TextField(
                                                          controller: myControllerOk,
                                                          decoration: InputDecoration(
                                                            border: OutlineInputBorder(),
                                                            hintText: "Ingrese Si o No",
                                                          ),
                                                        ),
                                                        SizedBox(height: 15,),
                                                        Row(
                                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                          children: [
                                                            Text("Observacion: "),
                                                            Text("(Opcional)")
                                                          ],
                                                        ),
                                                        TextField(
                                                          controller: myControllerObs,
                                                          decoration: InputDecoration(
                                                            border: OutlineInputBorder(),
                                                            hintText: "Agregar Observacion",
                                                          ),
                                                        ),
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
                                                              onPressed: (){
                                                                //deleteReserva(_listaDeReservasAPI[index].idReserva);

                                                                var opcion = myControllerOk.text;
                                                                opcion = opcion.toUpperCase();
                                                                if(opcion == 'SI' || opcion == 'NO'){
                                                                  putReserva(_listaDeReservasAPI[index].idReserva);
                                                                  Navigator.pop(context);
                                                                  setState(() {
                                                                    initState();
                                                                  });
                                                                }else{
                                                                  showDialog(
                                                                    context: context,
                                                                    builder: (context){
                                                                      return AlertDialog(
                                                                        title: Text("Campos no valido"),
                                                                        content: Text("Los Datos Ingresados en el campo 'Asistio' no son correctos.\nIngrese 'si' o 'no'"),
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

                                                                //Navigator.pop(context);
                                                              },
                                                              child: Text("Confirmar"),
                                                            )
                                                          ],
                                                        ),
                                                      ],
                                                    ));
                                                //Navigator.pop(context);
                                              },
                                              child: Text('Completar'),
                                            ),
                                          ],
                                        )
                                      ],
                                    ));
                              }
                            },
                            title: getTituloReserva(_listaDeReservasAPI[index].cliente,_listaDeReservasAPI[index].flagAsistio)/*Text(_listaDeReservasAPI[index].horaInicio)*/,
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

  String dateTimeToCadena(dateTime){
    String fechaCadena;
    if(dateTime.day < 10 && dateTime.month < 10){
      fechaCadena = dateTime.year.toString()+"0"+dateTime.month.toString()+"0"+dateTime.day.toString();
    }else if(dateTime.day < 10){
      fechaCadena = dateTime.year.toString()+dateTime.month.toString()+"0"+dateTime.day.toString();
    }else if(dateTime.month < 10){
      fechaCadena = dateTime.year.toString()+"0"+dateTime.month.toString()+dateTime.day.toString();
    }else{
      fechaCadena = dateTime.year.toString()+dateTime.month.toString()+dateTime.day.toString();
    }
    print(fechaCadena);
    print(fechaCadena.length);

    return fechaCadena;
  }

  @override
  void initState() {

    print(_listadoReservas);
    DateTime dateToday =DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);
    print(dateToday);
    var fecha;

    if(allReservas == true){
      var url = "https://equipoyosh.com/stock-nutrinatalia/reserva";
      print(url);
      _listadoReservas = _getReservas(url);
    }else if(_fechaDesde == hoy && _fechaHasta == hoy && porFisio == false && porCliente == false){
      fecha = dateTimeToCadena(dateToday);
      print(fecha);
      var id = widget.userLogueado.idPersona;
      var url = "https://equipoyosh.com/stock-nutrinatalia/persona/$id/agenda?fecha=$fecha";
      print(url);
      _listadoReservas = _getReservas(url);
    }else if(_fechaDesde != hoy || _fechaHasta != hoy && porFisio == false && porCliente == false){
      var id = widget.userLogueado.idPersona;
      var desde = dateTimeToCadena(_fechaDesde);
      var hasta = dateTimeToCadena(_fechaHasta);
      var url = "https://equipoyosh.com/stock-nutrinatalia/reserva?ejemplo=%7B%22idEmpleado%22%3A%7B%22idPersona%22%3A$id%7D%2C%22fechaDesdeCadena%22%3A%22$desde%22%2C%22fechaHastaCadena%22%3A%22$hasta%22%7D";
      print(url);
      _listadoReservas = _getReservas(url);
      //%7B%22idEmpleado%22%3A%7B%22idPersona%22%3A3%7D%2C%22fechaDesdeCadena%22%3A%2220190903%22%2C%22fechaHastaCadena%22%3A%220190903%22%7D
    }else if(_fechaDesde == hoy && _fechaHasta == hoy && porFisio == true && porCliente == false){
      print("Entro en ordenamiento por fisio");
      fecha = dateTimeToCadena(dateToday);
      print(fecha);
      var id = widget.userLogueado.idPersona;
      var url = "https://equipoyosh.com/stock-nutrinatalia/persona/$id/agenda?fecha=$fecha";
      print(url);
      _listadoReservas = _getReservas(url);
    }else if(_fechaDesde != hoy || _fechaHasta != hoy && porFisio == true && porCliente == false){
      print("Entro en ordenamiento por fisio");
      var id = idFisio;
      var desde = dateTimeToCadena(_fechaDesde);
      var hasta = dateTimeToCadena(_fechaHasta);
      var url = "https://equipoyosh.com/stock-nutrinatalia/reserva?ejemplo=%7B%22idEmpleado%22%3A%7B%22idPersona%22%3A$id%7D%2C%22fechaDesdeCadena%22%3A%22$desde%22%2C%22fechaHastaCadena%22%3A%22$hasta%22%7D";
      print(url);
      _listadoReservas = _getReservas(url);
      //%7B%22idEmpleado%22%3A%7B%22idPersona%22%3A3%7D%2C%22fechaDesdeCadena%22%3A%2220190903%22%2C%22fechaHastaCadena%22%3A%220190903%22%7D
    }else if(porCliente == true){
      print("Entra al ordenamiento por Cliente");
      var id = idCliente;
      var url = "https://equipoyosh.com/stock-nutrinatalia/reserva?ejemplo=%7B%22idCliente%22%3A%7B%22idPersona%22%3A$id%7D%7D";
      print(url);
      _listadoReservas = _getReservas(url);
    }
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
      showDialog(
          context: context,
          builder: (context){
            return AlertDialog(
              title: Text("Reserva cancelada"),
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
      print("La Reserva se actualizo correctamente");
    }else{
      showDialog(
          context: context,
          builder: (context){
            return AlertDialog(
              title: Text("La reserva no puede ser cancelada"),
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
      print("La reserva no puede ser cancelada");
    }
  }

  void putReserva(idReserva) async{
    print(idReserva.runtimeType);
    var SoN = myControllerOk.text.substring(0,1);
    SoN = SoN.toUpperCase();
    final headers = {"Content-Type":"application/json"};
    print(headers);
    final url = Uri.parse("https://equipoyosh.com/stock-nutrinatalia/reserva");


    final _actualizarReserva = {
      "idReserva": idReserva,
      "observacion": myControllerObs.text,
      "flagAsistio": SoN,
    };

    print(_actualizarReserva.runtimeType);
    print(url);
    print(_actualizarReserva);
    var body = jsonEncode(_actualizarReserva);
    final response = await http.put(url,body: body,headers: headers);
    print(response.statusCode);
    print(response.body);
    if(response.statusCode == 200){
      showDialog(
          context: context,
          builder: (context){
            return AlertDialog(
              title: Text("La informacion de la Reserva se actualizo correctamente"),
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
      print("La Reserva se actualizo correctamente");
    }else{
      showDialog(
          context: context,
          builder: (context){
            return AlertDialog(
              title: Text("La reserva no puede ser modificada"),
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
      print("Error al actualizar los datos de la reserva");
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
      showDialog(
          context: context,
          builder: (context){
            return AlertDialog(
              title: Text("Reserva Agregada"),
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
      print("Reserva Agregada");
    }else{
      showDialog(
          context: context,
          builder: (context){
            return AlertDialog(
              title: Text("No se pudo cargar la Reserva"),
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
      print("No se pudo cargar la Reserva");
    }
  }
}

Widget getTituloReserva(idPersona,flagAsistio){
  late String _title;
  if(idPersona == ""){
    _title = "Disponible";
  }else if(idPersona != "" && (flagAsistio == 'N' || flagAsistio == 'n')){
    _title = "No Asistio";
  }else if(idPersona != "" && (flagAsistio == 'S' || flagAsistio == 's') ){
    _title = "Completado";
  }else{
    _title = "Reservado";
  };
  return Text(_title);
}

Widget getSubtituloReserva(horaIni,horaFin){
  late String _subtitle;

  horaIni = horaIni.substring(0,2) +":"+ horaIni.substring(2,4) + " hs.";
  horaFin = horaFin.substring(0,2) +":"+ horaFin.substring(2,4) + " hs.";

  _subtitle = horaIni + " a "+ horaFin;

  return Text(_subtitle);
}



Widget getInfoReserva(fecha,horaIni,horaFin,fisio,cliente,flagAsistio,observacion){

  var estado;

  fecha = fecha.substring(0, 10);
  horaIni = horaIni.substring(0,2) +":"+ horaIni.substring(2,4) + " hs.";
  horaFin = horaFin.substring(0,2) +":"+ horaFin.substring(2,4) + " hs.";

  if(cliente == ""){
    estado = "Sin Reservar";
  }else if(cliente != "" && flagAsistio == 'N'){
    estado = "No Asistio";
  }else if(cliente != "" && flagAsistio == 'S'){
    estado = "Completado";
  }else{
    estado = "Reservado";
  };

  return Text("Estado: "+ estado +"\nFecha: "+ fecha +"\nHora Inicio: "+ horaIni
      +"\nHora Fin: "+ horaFin+"\nFisioterapeuta: "+ fisio+"\nPaciente: "+ cliente+"\nObservacion: "+ observacion);
}

Widget getTitleAppBar(allReservas,porFisio,porCliente){
  var title;
  if(allReservas == true){
    title = "Todas las Reservas";
  }else if(porFisio == true || porCliente == true){
    title = "Reservas";
  }else{
    title = "Reservas";
  }
  return Text(title);
}

Widget getNameAgenda(nameFisioLogueado,nameFisio, porCliente,nameCliente){
  var title;
  if(nameFisioLogueado == nameFisio && porCliente == false){
    title = "\n   ■   Mi Agenda\n";
  }else if(nameFisioLogueado != nameFisio && porCliente == false){
    title = "\n   ■   Agenda de: $nameFisio\n";
  }else if(porCliente == true){
    title = "\n   ■   Paciente: $nameCliente\n";
  }
  //Text("\n   Agenda de: $nameFisio\n",style: TextStyle(fontSize: 17),),
  return Text(title,style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold),);
}

