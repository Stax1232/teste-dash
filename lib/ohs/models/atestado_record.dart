class AtestadoRecord {
  final String id;

  final String unidade;
  final String idFunc;
  final String genero; // "M" | "F" | "O"
  final String area;
  final String supervisor;

  final String cid;
  final String cidTema;

  final String? medicoNome;
  final String? medicoCrm;

  final DateTime dataSaida;
  final DateTime dataRetorno;

  const AtestadoRecord({
    required this.id,
    required this.unidade,
    required this.idFunc,
    required this.genero,
    required this.area,
    required this.supervisor,
    required this.cid,
    required this.cidTema,
    required this.medicoNome,
    required this.medicoCrm,
    required this.dataSaida,
    required this.dataRetorno,
  });

  int get diasAtestado => dataRetorno.difference(dataSaida).inDays;

  String get cidCategoria =>
      cid.trim().isEmpty ? '-' : cid.trim().substring(0, 1).toUpperCase();

  AtestadoRecord copyWith({
    String? id,
    String? unidade,
    String? idFunc,
    String? genero,
    String? area,
    String? supervisor,
    String? cid,
    String? cidTema,
    String? medicoNome,
    String? medicoCrm,
    DateTime? dataSaida,
    DateTime? dataRetorno,
  }) {
    return AtestadoRecord(
      id: id ?? this.id,
      unidade: unidade ?? this.unidade,
      idFunc: idFunc ?? this.idFunc,
      genero: genero ?? this.genero,
      area: area ?? this.area,
      supervisor: supervisor ?? this.supervisor,
      cid: cid ?? this.cid,
      cidTema: cidTema ?? this.cidTema,
      medicoNome: medicoNome ?? this.medicoNome,
      medicoCrm: medicoCrm ?? this.medicoCrm,
      dataSaida: dataSaida ?? this.dataSaida,
      dataRetorno: dataRetorno ?? this.dataRetorno,
    );
  }

  static AtestadoRecord fromJson(Map<String, dynamic> json) {
    DateTime parseDate(dynamic v) {
      if (v == null) return DateTime(1970, 1, 1);
      final s = v.toString().trim();
      // Esperado: yyyy-MM-dd
      return DateTime.parse(s);
    }

    return AtestadoRecord(
      id: (json['id'] ?? '').toString(),
      unidade: (json['unidade'] ?? '').toString(),
      idFunc: (json['idFunc'] ?? '').toString(),
      genero: (json['genero'] ?? '').toString(),
      area: (json['area'] ?? '').toString(),
      supervisor: (json['supervisor'] ?? '').toString(),
      cid: (json['cid'] ?? '').toString(),
      cidTema: (json['cidTema'] ?? '').toString(),
      medicoNome: json['medicoNome']?.toString(),
      medicoCrm: json['medicoCrm']?.toString(),
      dataSaida: parseDate(json['dataSaida']),
      dataRetorno: parseDate(json['dataRetorno']),
    );
  }

  Map<String, dynamic> toJson() {
    String iso(DateTime d) =>
        '${d.year.toString().padLeft(4, '0')}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';

    return {
      'id': id,
      'unidade': unidade,
      'idFunc': idFunc,
      'genero': genero,
      'area': area,
      'supervisor': supervisor,
      'cid': cid,
      'cidTema': cidTema,
      'medicoNome': medicoNome,
      'medicoCrm': medicoCrm,
      'dataSaida': iso(dataSaida),
      'dataRetorno': iso(dataRetorno),
    };
  }
}
