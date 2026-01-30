class AreaAggregate {
  final String area;
  final int atestados;
  final int dias;
  final int ativos; // aqui: distintos (idFunc) dentro do filtro
  final double mediaDias;

  const AreaAggregate({
    required this.area,
    required this.atestados,
    required this.dias,
    required this.ativos,
    required this.mediaDias,
  });
}

class CidAggregate {
  final String cid;
  final String cidTema;
  final int atestados;
  final int dias;
  final double mediaDias;

  const CidAggregate({
    required this.cid,
    required this.cidTema,
    required this.atestados,
    required this.dias,
    required this.mediaDias,
  });
}

class MedicoAggregate {
  final String medicoNome; // "—" se vazio
  final String? crm;
  final int atestados;
  final int dias;
  final double mediaDias;

  const MedicoAggregate({
    required this.medicoNome,
    required this.crm,
    required this.atestados,
    required this.dias,
    required this.mediaDias,
  });
}
