import 'dart:math';
import 'package:bit_array/bit_array.dart';

class Lattice {
  static const int _defaultSize = 250;
  static const double _tau = pi + pi;
  final BitArray _grid;
  final Random _rng;
  final int _centerX;
  final int _centerY;
  final int _escapeRadiusSquared;
  final int _size;
  int _mass = 0;
  bool _boundaryReached = false;

  int get mass => _mass;

  bool get boundaryReached => _boundaryReached;

  int get size => _size;

  Lattice()
      : _grid = BitArray(_defaultSize * _defaultSize),
        _rng = Random(),
        _centerX = (_defaultSize / 2) as int,
        _centerY = (_defaultSize / 2) as int,
        _escapeRadiusSquared = 2 * _defaultSize * _defaultSize,
        _size = _defaultSize;

  bool get(int x, int y) => _grid[y * _size + x];

  void set(int x, int y, [bool value = true]) {
    bool alreadySet = get(x, y);
    if (value && !alreadySet) {
      _mass++;
    } else if (!value && alreadySet) {
      _mass--;
    }
    _grid[y * _size + x] = value;
  }

  bool isEscaped(int x, int y) {
    int deltaX = x - _centerX;
    int deltaY = y - _centerY;
    return (deltaX * deltaX + deltaY * deltaY > _escapeRadiusSquared);
  }

  bool isOnLattice(int x, int y) {
    return (x >= 0 && x < _size && y >= 0 && y < _size);
  }

  bool isOnBoundary(int x, int y) {
    return (x == 0 || x == _size - 1 || y == 0 || y == _size - 1);
  }

  bool isAdjacentToAggregate(int x, int y) {
    bool adjacent = false;
    for (Direction dir in Direction.values) {
      int neighborX = x + dir.offsetX;
      int neighborY = x + dir.offsetY;
      if (isOnLattice(neighborX, neighborY)
          && _grid[neighborY * _size + neighborX]) {
        adjacent = true;
        break;
      }
    }
    return adjacent;
  }

  Point? accumulate() {
    Point? point;
    if (_mass > 0 && !_boundaryReached) {
      bool accumulated = false;
      do {
        double theta = _rng.nextDouble() * _tau;
        int x = (_centerX + _size * cos(theta)).round();
        int y = (_centerY + _size * sin(theta)). round();
        while (!isEscaped(x, y)) {
          if (isAdjacentToAggregate(x, y)) {
            accumulated = true;
            _grid[y * _size + x] = true;
            _mass++;
            _boundaryReached = isOnBoundary(x, y);
            point = Point(x, y);
            break;
          }
          List<Direction> values = Direction.values;
          Direction dir = values[_rng.nextInt(values.length)];
          x += dir.offsetX;
          y += dir.offsetY;
        }
      } while (!accumulated);
    } else {
      point = null;
    }
    return point;
  }

  void clear() {
    _grid.clearAll();
    _mass = 0;
    _boundaryReached = false;
  }

}

enum Direction { north, east, south, west }

extension _DirectionExtension on Direction {
  int get offsetX {
    int offset;
    switch (this) {
      case Direction.east:
        offset = 1;
        break;
      case Direction.west:
        offset = -1;
        break;
      default:
        offset = 0;
        break;
    }
    return offset;
  }

  int get offsetY {
    int offset;
    switch (this) {
      case Direction.south:
        offset = 1;
        break;
      case Direction.north:
        offset = -1;
        break;
      default:
        offset = 0;
        break;
    }
    return offset;
  }

  static Direction random(Random rng) {
    List<Direction> values = Direction.values;
    return values[rng.nextInt(values.length)];
  }
}

class Point {
  final int x;
  final int y;

  Point(this.x, this.y);
}
