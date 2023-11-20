enum Alert { archived, notyet }

enum Response { ok, cancel, go }

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

enum HttpStatus { stopped, started, api, file, generacion, completed }

extension HttpStatusEx on HttpStatus {
  String get textProgress {
    return switch (this) {
      HttpStatus.stopped => '',
      HttpStatus.started => 'Iniciando consulta...',
      HttpStatus.api => 'Consultando API REE...',
      HttpStatus.file => 'Consultando archivo...',
      HttpStatus.generacion => 'Consultando balance generación...',
      HttpStatus.completed => '',
    };
  }
}

enum Periodo { llano, valle, punta }

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
