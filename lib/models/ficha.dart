

class Ficha {
  late int? idFicha;
  late String fechaHora;
  late String motivoConsulta;
  late String diagnostico;
  late String observacion;
  late String idEmpleado;
  late String nameEmpleado;
  late String idCliente;
  late String nameCliente;
  late String idTipoProducto;
  late String subCategoria;
  late String categoria;
  late String fechaDesdeCadena;
  late String fechaHastaCadena;



  Ficha(idReserva, fechaHora, motivoConsulta, diagnostico, observacion, idEmpleado,nameEmpleado, idCliente,nameCliente,idTipoProducto,fechaDesdeCadena,fechaHastaCadena,subCategoria,categoria) {
    this.idFicha = idReserva;
    this.fechaHora = fechaHora;
    this.motivoConsulta = motivoConsulta;
    this.diagnostico = diagnostico;
    this.observacion = observacion;
    this.idEmpleado = idEmpleado;
    this.nameEmpleado = nameEmpleado;
    this.idCliente = idCliente;
    this.nameCliente = nameCliente;
    this.idTipoProducto = idTipoProducto;
    this.fechaDesdeCadena = fechaDesdeCadena;
    this.fechaHastaCadena = fechaHastaCadena;
    this.subCategoria = subCategoria;
    this.categoria = categoria;
  }
}