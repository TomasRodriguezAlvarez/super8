class FichaResumen {
  final int id;
  final String nombreCompleto;
  final String numeroIdentificacion;
  final int? edad;
  final String? genero;
  final String? tipoSangre;
  final String? numeroFicha;
  final String? ultimaConsultaFecha;

  FichaResumen({
    required this.id,
    required this.nombreCompleto,
    required this.numeroIdentificacion,
    this.edad,
    this.genero,
    this.tipoSangre,
    this.numeroFicha,
    this.ultimaConsultaFecha,
  });

  factory FichaResumen.fromJson(Map<String, dynamic> j) => FichaResumen(
        id: j['id'] as int,
        nombreCompleto: (j['nombre_completo'] ?? '') as String,
        numeroIdentificacion: (j['numero_identificacion'] ?? '') as String,
        edad: j['edad'] as int?,
        genero: j['genero'] as String?,
        tipoSangre: j['tipo_sangre'] as String?,
        numeroFicha: j['numero_ficha'] as String?,
        ultimaConsultaFecha: j['ultima_consulta_fecha']?.toString(),
      );
}

class FichaDetalle {
  final int fichaId;
  final String numeroFicha;
  final String nombres;
  final String apellidos;
  final String numeroIdentificacion;
  final String genero;
  final String tipoSangre;
  final String? email;
  final String? telefono;
  final String? alergiasJson;
  final String? condicionesJson;
  final List<dynamic> consultas;

  FichaDetalle({
    required this.fichaId,
    required this.numeroFicha,
    required this.nombres,
    required this.apellidos,
    required this.numeroIdentificacion,
    required this.genero,
    required this.tipoSangre,
    this.email,
    this.telefono,
    this.alergiasJson,
    this.condicionesJson,
    required this.consultas,
  });

  factory FichaDetalle.fromJson(Map<String, dynamic> j) => FichaDetalle(
        fichaId: j['ficha_id'] as int,
        numeroFicha: j['numero_ficha'] ?? '',
        nombres: j['nombres'] ?? '',
        apellidos: j['apellidos'] ?? '',
        numeroIdentificacion: j['numero_identificacion'] ?? '',
        genero: j['genero'] ?? '',
        tipoSangre: j['tipo_sangre'] ?? '',
        email: j['email']?.toString(),
        telefono: j['telefono']?.toString(),
        alergiasJson: j['alergias']?.toString(),
        condicionesJson: j['condiciones_cronicas']?.toString(),
        consultas: (j['consultas'] as List?) ?? const [],
      );

  String get nombreCompleto => '$nombres $apellidos';
}
