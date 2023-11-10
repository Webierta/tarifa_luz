enum Source { api, file }

enum Status {
  none,
  ok,
  error,
  noPublicado,
  noAcceso,
  tiempoExcedido,
  errorToken,
  accessDenied,
  noInternet
}

enum StatusGeneracion { ok, error }

enum ProcessGetData { stopped, started, completed, aborted }

enum Periodo { llano, valle, punta }

extension PeriodoEx on Periodo {
  String get nombre {
    return switch (this) {
      Periodo.llano => 'LLANO',
      Periodo.valle => 'VALLE',
      Periodo.punta => 'PUNTA',
    };
  }
}

enum Generacion { renovable, noRenovable }

extension GeneracionExt on Generacion {
  String get texto {
    return switch (this) {
      Generacion.renovable => 'Generación renovable',
      Generacion.noRenovable => 'Generación no renovable',
    };
  }

  String get tipo {
    return switch (this) {
      Generacion.renovable => 'Renovables',
      Generacion.noRenovable => 'No renovables',
    };
  }
}
