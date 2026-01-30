class OhsFilters {
  final String? unidade;
  final String? area;
  final String? supervisor;
  final String? idFunc;

  final String? genero; // "M"|"F"|"O"
  final String? cid; // CID completo (ex.: M54.5)

  final int? ano;
  final int? mes; // 1-12

  const OhsFilters({
    this.unidade,
    this.area,
    this.supervisor,
    this.idFunc,
    this.genero,
    this.cid,
    this.ano,
    this.mes,
  });

  OhsFilters copyWith({
    String? unidade,
    String? area,
    String? supervisor,
    String? idFunc,
    String? genero,
    String? cid,
    int? ano,
    int? mes,
    bool clearUnidade = false,
    bool clearArea = false,
    bool clearSupervisor = false,
    bool clearIdFunc = false,
    bool clearGenero = false,
    bool clearCid = false,
    bool clearAno = false,
    bool clearMes = false,
  }) {
    return OhsFilters(
      unidade: clearUnidade ? null : (unidade ?? this.unidade),
      area: clearArea ? null : (area ?? this.area),
      supervisor: clearSupervisor ? null : (supervisor ?? this.supervisor),
      idFunc: clearIdFunc ? null : (idFunc ?? this.idFunc),
      genero: clearGenero ? null : (genero ?? this.genero),
      cid: clearCid ? null : (cid ?? this.cid),
      ano: clearAno ? null : (ano ?? this.ano),
      mes: clearMes ? null : (mes ?? this.mes),
    );
  }

  static const empty = OhsFilters();
}
