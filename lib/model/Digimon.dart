class Digimon {
  String? _name;
  String? _level;
  String? _img;

  Digimon(this._name, this._img, this._level);
  get name => this._name;

  set name(value) => this._name = value;

  get level => this._level;

  set level(value) => this._level = value;

  get img => this._img;

  set img(value) => this._img = value;
}
