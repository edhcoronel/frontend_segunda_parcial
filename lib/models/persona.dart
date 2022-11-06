
class Persona{
  late int idPersona;
  late String nombre;
  late String? apellido;
  late String? email;
  late String? telefono;
  late String? ruc;
  late String? cedula;
  late String tipoPersona;
  late String usuarioLogin;
  late String nombreCompleto;
  late String? fechaNacimiento;

  Persona(id, nombre, apellido, email, telefono, ruc, cedula, tipo,userLogin, nombreCompleto,nacim){
    this.idPersona = id;
    this.nombre = nombre;
    this.apellido = apellido;
    this.email = email;
    this.telefono = telefono;
    this.ruc = ruc;
    this.cedula = cedula;
    this.tipoPersona = tipo;
    this.usuarioLogin = userLogin;
    this.nombreCompleto = nombreCompleto;
    this.fechaNacimiento = nacim;

  }
}