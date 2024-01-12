enum ProductGroups {
  electronicdisplays,
  washingmachines2019,
  washerdriers2019,
  lightsources,
  refrigeratingappliances2019,
  dishwashers2019,
  airconditioners,
  ovens,
  rangehoods,
  tumbledriers,
  localspaceheaters,
  waterheaters,
}

extension ProductGroupsExt on ProductGroups {
  String get nombre {
    return switch (this) {
      ProductGroups.electronicdisplays => 'Pantallas',
      ProductGroups.washingmachines2019 => 'Lavadoras',
      ProductGroups.washerdriers2019 => 'Lavadoras secadoras',
      ProductGroups.lightsources => 'Luces',
      ProductGroups.refrigeratingappliances2019 => 'Refrigeradores',
      ProductGroups.dishwashers2019 => 'Lavaplatos',
      ProductGroups.airconditioners => 'Aires acondicionados',
      ProductGroups.ovens => 'Hornos',
      ProductGroups.rangehoods => 'Campanas extractoras',
      ProductGroups.tumbledriers => 'Secadoras',
      ProductGroups.localspaceheaters => 'Calefactores',
      ProductGroups.waterheaters => 'Calentadores de agua',
    };
  }

  String get imagen {
    return switch (this) {
      ProductGroups.electronicdisplays =>
        'assets/images/eprel/categorias/electronic_display.png',
      ProductGroups.washingmachines2019 =>
        'assets/images/eprel/categorias/household_washing_machine_2019.png',
      ProductGroups.washerdriers2019 =>
        'assets/images/eprel/categorias/household_washer_dryer_2019.png',
      ProductGroups.lightsources =>
        'assets/images/eprel/categorias/light_source.png',
      ProductGroups.refrigeratingappliances2019 =>
        'assets/images/eprel/categorias/household_refrigerating_appliance_2019.png',
      ProductGroups.dishwashers2019 =>
        'assets/images/eprel/categorias/household_dishwasher_2019.png',
      ProductGroups.airconditioners =>
        'assets/images/eprel/categorias/air_conditioner.png',
      ProductGroups.ovens => 'assets/images/eprel/categorias/domestic_oven.png',
      ProductGroups.rangehoods =>
        'assets/images/eprel/categorias/range_hood.png',
      ProductGroups.tumbledriers =>
        'assets/images/eprel/categorias/household_tumble_drier.png',
      ProductGroups.localspaceheaters =>
        'assets/images/eprel/categorias/local_space_heater.png',
      ProductGroups.waterheaters =>
        'assets/images/eprel/categorias/water_heaters.png',
    };
  }
}
