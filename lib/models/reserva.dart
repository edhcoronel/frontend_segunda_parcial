
class Reserva {
  late int? idReserva;
  late String fecha;
  late String horaInicio;
  late String horaFin;
  late String idEmpleado;
  late String idCliente;
  late String empleado;
  late String cliente;


  Reserva(id, fecha, ini, fin, empleado, cliente,emple, clien) {
    this.idReserva = id;
    this.fecha = fecha;
    this.horaInicio = ini;
    this.horaFin = fin;
    this.idEmpleado = empleado;
    this.idCliente = cliente;
    this.empleado = emple;
    this.cliente = clien;
  }
}