# PLV8-Geo

Geographic/geometric functions to augment PLV8.

## Goals

The goal of this project is to produce a well-tested and complete Geo toolkit running inside of PLV8.

This module is meant to work either on its own, or as a companion module to PostGIS, bringing in functionality that means to be lightweight toolkit, not a full-featured ecosystem.  Testing is extremely important, and is step one of this library.

## Usage

PLV8-Geo requires PLV8 to be available in your database.

### Installing

PLV8-Geo uses Node.js for installation and testing.

```
$ npm install
$ bin/install_plv8_geo -d database -h host -u user -p password
```

### Functions

#### simplify_polyline(json, epsilon)

Simplifies a Polyline.

_Parameters:_

json - Array of coordinates in a [ x, y ] pairs
epsilon - minimum distance for reduction

_Usage:_

```
pg=$ SELECT simplify_polyline('[ [0, 1], [1, 1.5], [2, 1.7] ]'::JSON, 1);
simplify_polyline
-------------------
[[0,1],[2,1.7]]
(1 row)
```
