import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:frontend_segunda_parcial/models/ficha.dart';
import 'package:frontend_segunda_parcial/pages/agg_fichas.dart';
import 'package:http/http.dart' as http;

import '../models/persona.dart';

class Fichas extends StatefulWidget {
  final List<Persona> profesionales;
  final List<Persona> pacientes;
  final Persona userLogueado;
  const Fichas(this.userLogueado,{Key? key, required this.profesionales, required this.pacientes}) : super(key: key);

  @override
  State<Fichas> createState() => _FichasState();
}

class _FichasState extends State<Fichas> {

  DateTime hoy = DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);
  late bool allFichas = true;
  late bool misFichas = false;
  late bool porCliente = false;
  late bool porFecha = false;
  late bool porFisio = false;
  late int idFisio;
  var idCliente;
  var nameCliente;
  late String nameFisio = widget.userLogueado.nombreCompleto;
  late bool onDateButton = false;

  Future<List<Ficha>>? _listadoFichas;
  final myControllerMotivo = TextEditingController();
  final myControllerDiagnostico = TextEditingController();
  final myControllerObservacion = TextEditingController();

  Future<List<Ficha>> _getFichas(url) async {
    var id = widget.userLogueado.idPersona;
    print(id);
    DateTime dateToday =DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);
    print(dateToday);
    final response = await http.get(Uri.parse(url));
    List<Ficha> fichas = [];
    print(response.statusCode);

    if (response.statusCode == 200) {
      String body = utf8.decode(response.bodyBytes);
      final jsonData = jsonDecode(body);
      for (var item in jsonData["lista"]) {
          //print(contador++);

          Ficha _f = Ficha(0, "", "", "", "", "", "", "", "", "", "", "", "","");

          //print(item["idFichaClinica"].runtimeType);
          _f.idFicha = item["idFichaClinica"];
          //print(_f.idFicha);
          //print(_f.idFicha.runtimeType);

          //print("\n");

          //print(item["fechaHora"].runtimeType);
          _f.fechaHora = item["fechaHora"];
          //print(_f.fechaHora);
          //print(_f.fechaHora.runtimeType);

          //print("\n");

          //print(item["motivoConsulta"].runtimeType);
          _f.motivoConsulta = item["motivoConsulta"];
          //print(_f.motivoConsulta);
          //print(_f.motivoConsulta.runtimeType);

          //print("\n");

          //print(item["diagnostico"].runtimeType);
          _f.diagnostico = item["diagnostico"];
          //print(_f.diagnostico);
          //print(_f.diagnostico.runtimeType);

          //print("\n");

          //print(item["observacion"].runtimeType);
          if(item["observacion"] != null){
            _f.observacion = item["observacion"];
          }else{
            _f.observacion = "";
          }
          //print(_f.observacion);
          //print(_f.observacion.runtimeType);

          //print("\n");

          /*if(item["idEmpleado"] != null){
            _f.idEmpleado = item["idEmpleado"]["idPersona"];
          }else{
            _f.idEmpleado = "";
          }*/
          //print(item["idEmpleado"].runtimeType);
          if(item["idEmpleado"] != null){
            //print(item["idEmpleado"]["nombreCompleto"]);
            if(item["idEmpleado"]["nombreCompleto"] != null){
              _f.nameEmpleado = item["idEmpleado"]["nombreCompleto"];
            }else{
              _f.nameEmpleado = "";
            }
          }else{
            _f.nameEmpleado = "";
          }
          //print(_f.nameEmpleado);
          //print(_f.nameEmpleado.runtimeType);
          /*if(item["idCliente"] != null){
            _f.idCliente = item["idCliente"]["idPersona"];
          }else{
            _f.idCliente = "";
          }*/
          //print("\n");
          //print(item["idCliente"].runtimeType);
          if(item["idCliente"] != null){
            //print(item["idCliente"]["nombreCompleto"]);
            _f.nameCliente = item["idCliente"]["nombreCompleto"];
          }else{
            _f.nameCliente = "";
          }
          //print(_f.nameCliente);
          //print(_f.nameCliente.runtimeType);

          /*if(item["idTipoProducto"] != null){
            _f.idTipoProducto = item["idTipoProducto"]["idTipoProducto"];
          }else{
            _f.idTipoProducto = "";
          }*/
          //print("\n");
          //print(item["idTipoProducto"].runtimeType);
          if(item["idTipoProducto"] != null){
            _f.subCategoria = item["idTipoProducto"]["descripcion"];
          }else{
            _f.subCategoria = "";
          }
          //print(_f.subCategoria);
          //print(_f.subCategoria.runtimeType);

          //print("\n");
          //print(item["idTipoProducto"]["idCategoria"].runtimeType);
          if(item["idTipoProducto"]["idCategoria"] != null){
            //print(item["idTipoProducto"]["idCategoria"]["descripcion"]);
            _f.categoria = item["idTipoProducto"]["idCategoria"]["descripcion"];
          }else{
            _f.categoria = "";
          }
          //print(_f.categoria);
          //print(_f.categoria.runtimeType);

          //print("\n");
          //print(item["fechaDesdeCadena"].runtimeType);
          if(item["fechaDesdeCadena"] != null){
            _f.fechaDesdeCadena = item["fechaDesdeCadena"];
          }else{
            _f.fechaDesdeCadena = "";
          }
          //print(_f.fechaDesdeCadena);
          //print(_f.fechaDesdeCadena.runtimeType);


          //print("\n");
          //print(item["fechaHastaCadena"].runtimeType);
          if(item["fechaHastaCadena"] != null){
            _f.fechaHastaCadena = item["fechaHastaCadena"];
          }else{
            _f.fechaHastaCadena = "";
          }
          //print(_f.fechaHastaCadena);
          //print(_f.fechaHastaCadena.runtimeType);
          fichas.add(_f);
          //print(_f);

        }
      /*}else{
        for (var item in jsonData) {
          Ficha _f = Ficha(0, "", "", "", "", "", "", "", "", "", "", "", "","");

          _f.idFicha = item["idFicha"];
          _f.fechaHora = item["fechaHora"];
          _f.motivoConsulta = item["motivoConsulta"];
          _f.diagnostico = item["diagnostico"];
          if(item["observacion"] != null){
            _f.observacion = item["observacion"];
          }else{
            _f.observacion = "";
          }
          if(item["idEmpleado"] != null){
            _f.idEmpleado = item["idEmpleado"]["idPersona"];
          }else{
            _f.idEmpleado = "";
          }
          if(item["idEmpleado"] != null){
            if(item["idEmpleado"]["nombreCompleto"].toString() != "null"){
              _f.nameEmpleado = item["idEmpleado"]["nombreCompleto"];
            }else{
              _f.nameEmpleado = "";
            }
          }else{
            _f.nameEmpleado = "";
          }
          if(item["idCliente"] != null){
            _f.idCliente = item["idCliente"]["idPersona"];
          }else{
            _f.idCliente = "";
          }
          if(item["idCliente"] != null){
            _f.nameCliente = item["idCliente"]["nombreCompleto"];
          }else{
            _f.nameCliente = "";
          }
          if(item["idTipoProducto"] != null){
            _f.idTipoProducto = item["idTipoProducto"]["idTipoProducto"];
          }else{
            _f.idTipoProducto = "";
          }
          if(item["idTipoProducto"] != null){
            _f.subCategoria = item["idTipoProducto"]["descripcion"];
          }else{
            _f.subCategoria = "";
          }
          if(item["idTipoProducto"]["idCategoria"] != null){
            _f.categoria = item["idTipoProducto"]["idCategoria"]["descripcion"];
          }else{
            _f.categoria = "";
          }
          _f.fechaDesdeCadena = item["fechaDesdeCadena"];
          _f.fechaHastaCadena = item["fechaHastaCadena"];
          fichas.add(_f);
        }
      }*/

      //print(reservas);
      return fichas;
    } else {
      throw Exception("Fallo la conexion");
    }

  }

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
        setState(() {
          initState();
        });
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
        porFecha = true;
        setState(() {
          initState();
        });
      }
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

  @override
  Widget build(BuildContext context) {
    var lisAuxEmpleados = widget.profesionales;
    var lisAuxClientes = widget.pacientes;
    return Scaffold(
      appBar: AppBar(
        title: getTitleAppBar(allFichas,porFisio,porCliente),
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
                child: Text("Todas las Fichas"),
                onTap: (){
                  allFichas = true;
                  misFichas = false;
                  porCliente = false;
                  porFecha = false;
                  porFisio = false;
                  onDateButton = false;
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
                child: Text("Mis Fichas"),
                onTap: (){
                  allFichas = false;
                  misFichas = true;
                  porCliente = false;
                  porFecha = false;
                  porFisio = false;
                  onDateButton = false;
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
                  allFichas = false;
                  misFichas = false;
                  porCliente = true;
                  porFecha = false;
                  porFisio = false;
                  onDateButton = false;
                },
              ),
              PopupMenuItem(
                value: 4,
                child: Text("Por Fecha"),
                onTap: (){
                  //var idCliente;
                  print("Entra en el onTap de la opcion por fecha");
                  allFichas = false;
                  misFichas = false;
                  porCliente = false;
                  porFecha = true;
                  porFisio = false;
                  onDateButton = true;
                  setState(() {
                    initState();
                  });
                },
              ),
            ],)
        ],
      ),
      body: FutureBuilder(
        future: _listadoFichas,
        builder: (context, snapshot){
          if(snapshot.hasData){
            final _listaDeFichasAPI = snapshot.data!;
            List<Ficha> ListaFichasCompletas = [];
            var desde = _fechaDesde.toString().substring(0,10);
            var hasta = _fechaHasta.toString().substring(0,10);
            ListaFichasCompletas.addAll(_listaDeFichasAPI);
            //print(_listaDeFichasAPI);
            //print(snapshot.data);
            //print(lisAuxEmpleados);
            //print(lisAuxClientes);

            return Column(
              children: [
                Container(
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
                                          allFichas = false;
                                          misFichas = false;
                                          porCliente = false;
                                          porFecha = false;
                                          porFisio = true;
                                          onDateButton = false;
                                          if(lisAuxEmpleados[index].idPersona == widget.userLogueado.idPersona){
                                            allFichas = false;
                                            misFichas = true;
                                            porCliente = false;
                                            porFecha = false;
                                            porFisio = false;
                                            onDateButton = false;
                                            _fechaDesde = hoy;
                                            _fechaHasta = hoy;
                                            nameFisio = lisAuxEmpleados[index].nombreCompleto;
                                            setState(() {
                                              initState();
                                            });
                                          }else{
                                            idFisio = lisAuxEmpleados[index].idPersona;
                                            nameFisio = lisAuxEmpleados[index].nombreCompleto;
                                            _fechaDesde = hoy;
                                            _fechaHasta = hoy;
                                            setState(() {
                                              initState();
                                            });
                                          }
                                          //print(_currentSelectedDate);
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
                ),
                (allFichas == false && porFecha == false)
                  ? Container(
                  child: Row(
                    children: [
                      getNameAgenda(widget.userLogueado.nombreCompleto, nameFisio, porCliente,nameCliente),
                    ],
                  ),
                ):Container(child: null),
                (onDateButton == true)
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
                      ],
                    ),
                ):Container(child: null),
                Expanded(
                    child: ListView.builder(
                        itemCount: _listaDeFichasAPI.length,
                        itemBuilder: (context,index){
                          return ListTile(
                            onTap: (){
                              var Fisio = widget.userLogueado.usuarioLogin;
                              showDialog(
                                  context: context,
                                  builder: (context) => AlertDialog(
                                    title: Text("Info de Ficha"),
                                    content: getInfoFichaClinica(_listaDeFichasAPI[index].categoria,_listaDeFichasAPI[index].subCategoria,_listaDeFichasAPI[index].fechaHora,_listaDeFichasAPI[index].fechaDesdeCadena,_listaDeFichasAPI[index].fechaHastaCadena,_listaDeFichasAPI[index].nameEmpleado,_listaDeFichasAPI[index].nameCliente,_listaDeFichasAPI[index].motivoConsulta,_listaDeFichasAPI[index].diagnostico,_listaDeFichasAPI[index].observacion)/*Text("Fecha: "+ _listaDeReservasAPI[index].fecha.substring(0,10) +"\nHora Inicio: "+ _listaDeReservasAPI[index].horaInicio
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
                                                    title: Text("Modificar Ficha Clinica"),
                                                    content: Text("Agregar observacion"),
                                                    actions: [
                                                      SizedBox(height: 15,),
                                                      Row(
                                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                        children: [
                                                          Text("Observacion: "),
                                                          Text("")
                                                        ],
                                                      ),
                                                      TextField(
                                                        controller: myControllerObservacion,
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

                                                              var opcion = myControllerObservacion.text;
                                                              if(opcion != null){
                                                                putReserva(Fisio,_listaDeFichasAPI[index].idFicha);
                                                                setState(() {
                                                                  initState();
                                                                });
                                                                Navigator.pop(context);
                                                              }else{
                                                                showDialog(
                                                                    context: context,
                                                                    builder: (context){
                                                                      return AlertDialog(
                                                                        title: Text("Campos vacio"),
                                                                        content: Text("Por favor complete el cuadro de texto"),
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
                                                            child: Text("Guardar"),
                                                          )
                                                        ],
                                                      ),
                                                    ],
                                                  ));
                                              //Navigator.pop(context);
                                            },
                                            child: Text("Agg Observacion"),
                                          ),
                                        ],
                                      )
                                    ],
                                  ));

                            },
                            title: getTituloFicha(_listaDeFichasAPI[index].nameCliente)/*Text(_listaDeReservasAPI[index].horaInicio)*/,
                            subtitle: getSubtituloFicha(_listaDeFichasAPI[index].nameEmpleado,_listaDeFichasAPI[index].fechaHora)/*Text("Fecha. "+ _listaDeReservasAPI[index].fecha.substring(0,10))*/,
                            leading: Icon(Icons.assignment_outlined),
                            trailing: Icon(Icons.arrow_forward_ios),
                          );
                        })
                )

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
      floatingActionButton: botonAggPacientes(),
    );
  }


  Widget botonAggPacientes(){
    return FloatingActionButton(
      onPressed: () {
        Navigator.push(
            context,
            MaterialPageRoute(builder: (context)=> Agg_fichas())
        );
        print('Button pressed');
      },
      child: Icon(Icons.add),
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
    print(_listadoFichas);
    DateTime dateToday =DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);
    print(dateToday);

    if(allFichas){  //estado inicial
      print("Primer if (Todas las fichas clinicas)");
      var url = "https://equipoyosh.com/stock-nutrinatalia/fichaClinica";
      print(url);
      _listadoFichas = _getFichas(url);
    } else if(misFichas){
      print("Segundo if (Mis fichas Clinicas)");
      /*fecha = dateTimeToCadena(dateToday);
      print(fecha);*/
      var id = widget.userLogueado.idPersona;
      var url = "https://equipoyosh.com/stock-nutrinatalia/fichaClinica?ejemplo=%7B%22idEmpleado%22%3A%7B%22idPersona%22%3A$id%7D%7D";
      print(url);
      _listadoFichas = _getFichas(url);
    }else if(porCliente){
      print("Quintp if Ordenar por cliente, todas sus fichas clinicas");
      var id = idCliente;
      var url = "https://equipoyosh.com/stock-nutrinatalia/fichaClinica?ejemplo=%7B%22idCliente%22%3A%7B%22idPersona%22%3A$id%7D%7D";
      print(url);
      _listadoFichas = _getFichas(url);
    }else if(misFichas){
      print("Segundo if (Mis fichas Clinicas)");
      /*fecha = dateTimeToCadena(dateToday);
      print(fecha);*/
      var id = widget.userLogueado.idPersona;
      var url = "https://equipoyosh.com/stock-nutrinatalia/fichaClinica?ejemplo=%7B%22idEmpleado%22%3A%7B%22idPersona%22%3A$id%7D%7D";
      print(url);
      _listadoFichas = _getFichas(url);
    }else if(porFecha){
      //var id = widget.userLogueado.idPersona;
      var desde = dateTimeToCadena(_fechaDesde);
      var hasta = dateTimeToCadena(_fechaHasta);
      print("Tercer if (Las fichas clinicas en un rango de fecha)  Desde "+desde+"  ----> Hasta "+hasta);
      var url = "https://equipoyosh.com/stock-nutrinatalia/fichaClinica?ejemplo=%7B%22fechaDesdeCadena%22%3A%22$desde%22%2C%22fechaHastaCadena%22%3A%22$hasta%22%7D";
      print(url);
      _listadoFichas = _getFichas(url);
      //%7B%22idEmpleado%22%3A%7B%22idPersona%22%3A3%7D%2C%22fechaDesdeCadena%22%3A%2220190903%22%2C%22fechaHastaCadena%22%3A%220190903%22%7D
    } else if(porFisio){
      print("Segundo if (Mis fichas Clinicas)");
      /*fecha = dateTimeToCadena(dateToday);
      print(fecha);*/
      var id = idFisio;
      var url = "https://equipoyosh.com/stock-nutrinatalia/fichaClinica?ejemplo=%7B%22idEmpleado%22%3A%7B%22idPersona%22%3A$id%7D%7D";
      print(url);
      _listadoFichas = _getFichas(url);
    }
  }

  void putReserva(fisio,idFicha) async{
    print(idFicha.runtimeType);
    final headers = {
      "Content-Type":"application/json",
      "usuario":fisio.toString()};

    print(headers);
    var mensaje = myControllerObservacion.text;
    final url = Uri.parse("https://equipoyosh.com/stock-nutrinatalia/fichaClinica");

    final _actualizarFicha = {
      "idFichaClinica":idFicha,
      "observacion":mensaje
    };

    print(_actualizarFicha.runtimeType);
    print(url);
    print(_actualizarFicha);
    var body = jsonEncode(_actualizarFicha);
    final response = await http.put(url,body: body,headers: headers);
    print(response.statusCode);
    print(response.body);
    if(response.statusCode == 200){
      showDialog(
          context: context,
          builder: (context){
            return AlertDialog(
              title: Text("La observacion de la Ficha Clinica se actualizo correctamente"),
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
      print("La Ficha se actualizo correctamente");
    }else{
      showDialog(
          context: context,
          builder: (context){
            return AlertDialog(
              title: Text("La Ficha Clinica no puede ser modificada"),
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
      print("Error al actualizar los datos de la ficha clinica");
    }

  }
}


Widget getTitleAppBar(allFichas,porFisio,porCliente){
  var title;
  if(allFichas == true){
    title = "Todas las Fichas";
  }else{
    title = "Fichas Clinicas";
  }
  return Text(title);
}

Widget getNameAgenda(nameFisioLogueado,nameFisio, porCliente,nameCliente){
  var title;
  if(nameFisioLogueado == nameFisio && porCliente == false){
    title = "\n   ■   Mis Fichas Clinicas\n";
  }else if(nameFisioLogueado != nameFisio && porCliente == false){
    title = "\n   ■   Profesional: $nameFisio\n";
  }else if(porCliente == true){
    title = "\n   ■   Paciente: $nameCliente\n";
  }
  //Text("\n   Agenda de: $nameFisio\n",style: TextStyle(fontSize: 17),),
  return Text(title,style: TextStyle(fontSize: 16.5,fontWeight: FontWeight.bold),);
}

Widget getInfoFichaClinica(categoria,subcategoria,fecha,desde,hasta,fisio,cliente,motivo,diagnostico,observacion){
  fecha = fecha.substring(0, 10);
  return Text("Categoria: "+ categoria +"\nSub Categoria: "+ subcategoria +"\nFecha: "+ fecha +"\nMotivo de Consulta: "+ motivo
      +"\nDiagnostico: "+ diagnostico+"\nFisioterapeuta: "+ fisio+"\nPaciente: "+ cliente+"\nObservacion: "+ observacion);
}

Widget getTituloFicha(categoria){
  return Text(categoria);
}

Widget getSubtituloFicha(subcategoria,horaFin){  //puede que le ponga la hora
  late String _subtitle;
  horaFin = horaFin.toString().substring(0,10);
  _subtitle = " Doc.: "+ subcategoria+"   Fecha: "+horaFin;
  return Text(_subtitle);
}

