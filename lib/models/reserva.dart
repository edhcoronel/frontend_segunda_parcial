

class Reserva {
  late int? idReserva;
  late String fecha;
  late String horaInicio;
  late String horaFin;
  late String idEmpleado;
  late String idCliente;
  late String empleado;
  late String cliente;
  late String fechaCadena;
  late String horaInicioCadena;
  late String horaFinCadena;
  late String flagAsistio;
  late String observacion;


  Reserva(id, fecha, ini, fin, empleado, cliente,emple, clien,fechaCadena,iniCadena,finCadena,flagAsistio,observacion) {
    this.idReserva = id;
    this.fecha = fecha;
    this.horaInicio = ini;
    this.horaFin = fin;
    this.idEmpleado = empleado;
    this.idCliente = cliente;
    this.empleado = emple;
    this.cliente = clien;
    this.fechaCadena = fechaCadena;
    this.horaInicioCadena = iniCadena;
    this.horaFinCadena = finCadena;
    this.flagAsistio = flagAsistio;
    this.observacion = observacion;
  }
}