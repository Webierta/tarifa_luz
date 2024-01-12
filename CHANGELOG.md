# Changelog

Este archivo registra y documenta los cambios más notables a lo largo del desarrollo del proyecto.

## [4.0.0] - 2023-12-11

### Fixed

- Bugfix: Eje Y graficos

### Added

- Nueva herramienta Etiqueta Energética.

## [3.2.5] - 2023-11-26

### Fixed

- Firma app: firma de apk para que actualice sin desinstalar.
- Gráficos: Máximo valor en Eje Y (duplicado).

### Changed

- Archivo apk renombrado a app-release.apk (eliminado applicationVariants en build.gradle).
- Update changelog: enlaces a comparación de versiones.

## [3.2.3] - 2023-11-25

### Added

- Nuevo archivo Changelog para registro e información de cambios entre versiones.
- Nueva página sobre el Bono Social.

### Changed

- Mejoras en gráficos: Eje Y desde 0, tooltip muestra hora y precio. 

## [3.2.2] - 2023-11-23

### Added

- Nueva función para comparar datos archivados.
- Firma App.

### Changed

- Eliminado de las fechas distintas a hoy el punto rojo que indica hora actual (#3).

### Fixed

- Corregidos errores menores.

### Changed

- Archivo apk renombrado a enlace permanente [TarifaLuz.apk](https://github.com/Webierta/tarifa_luz/releases/latest/download/TarifaLuz.apk).

## [3.2.1] - 2023-11-21

### Changed

- Gráficos mejorados.
- Precio en Eje Y de gráficos (#1).
- Archivo apk renombrado a TarifaLuz + número de versión (#2).
- Cambios en créditos (página About).
- Cambios en imágenes de capturas de pantalla.

### Fixed
 
- Corregidos errores menores.
- Corregida información sobre token.
- Corregidos errores de diseño.

### Deprecated

- Migración de clases y métodos obsoletos (WillPopScope y describeEnum).

## [3.2.0] - 2023-11-19

### Added

- Tipografía disponible offline.
- Añadido fastlane.

### Changed

- Profunda renovación estructural del código para mejorar la estabilidad y facilitar el mantenimiento.
- Mejoras de diseño.
- Mejoras en gráficos.

### Fixed

- Corregidos errores menores.
- Corregidos errores en gráficos.

### Removed

- Eliminada función de guardado automático en Ajustes.
- Eliminada dependencia de Google Fonts.

## [3.0.1] - 2023-11-12

### Added

- Nueva función de autosincronización en Ajustes.
- Nueva función de guardado automático en Ajustes.
- Nueva página de Ajustes.

### Fixed

- Horario de verano.
- Corregidos errores en gráficos (Eje X).
- Corregidos pequeños errores.

### Changed

- Diseño renovado.
- Renovada herramienta para entrada de tiempo en página para calcular franjas de tiempo más baratas.
- Página de inicio con últimos datos disponibles.

## [3.0.0] - 2023-11-08

### Changed

- Dependencias actualizadas.

### Added

- Fork del Proyecto del mismo autor [Precio Luz](https://github.com/Webierta/precio-luz): código renovado.

[3.2.5]: https://github.com/Webierta/tarifa_luz/compare/v3.2.3...v3.2.5
[3.2.3]: https://github.com/Webierta/tarifa_luz/compare/v3.2.2...v3.2.3
[3.2.2]: https://github.com/Webierta/tarifa_luz/compare/v3.2.1...v3.2.2
[3.2.1]: https://github.com/Webierta/tarifa_luz/compare/v3.2.0...v3.2.1
[3.2.0]: https://github.com/Webierta/tarifa_luz/compare/v3.0.1...v3.2.0
[3.0.1]: https://github.com/Webierta/tarifa_luz/compare/v3.0.0...v3.0.1
[3.0.0]: https://github.com/Webierta/tarifa_luz/releases/tag/v3.0.0
