# ArcREST
[![Build status](https://secure.travis-ci.org/MatzFan/ArcREST.svg)](http://travis-ci.org/MatzFan/ArcREST)
[![Gem Version](https://badge.fury.io/rb/arcrest.svg)](http://badge.fury.io/rb/arcrest)

Ruby Gem wrapper around the [ArcGIS REST API](http://services.arcgisonline.com/arcgis/sdk/rest/)

## Requirements

bundler


## Limitations

API FeatureServer query capabilities only at present. Unauthenticated calls only (please raise an issue if you wish this to be supported)


## Installation

Add this line to your application's Gemfile:

    $ gem 'arcrest'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install arcrest


## Usage

The API defines a [resource heirarchy](http://services.arcgisonline.com/arcgis/sdk/rest/#/Resource_hierarchy) which includes a Catalog of Services (MapServer or FeatureServer). Services have one or more Layers and Layers have Features, which may be queried in various ways, including by spatial coordinates.

```ruby
require 'arcrest'

catalog = ArcREST::Catalog.new('http://rmgsc.cr.usgs.gov/arcgis/rest/services')
puts catalog.services
#=> {"name"=>"cwqdr_main", "type"=>"MapServer"}
#=> {"name"=>"ecosys_Africa", "type"=>"MapServer"}
#=> {"name"=>"ecosys_SA", "type"=>"MapServer"}
#=> ...

service = ArcREST::Service.new('http://rmgsc.cr.usgs.gov/arcgis/rest/services/geomac_fires/FeatureServer')
puts service.layers
#=> {"id"=>1, "name"=>"Large Fire Points"}
#=> {"id"=>2, "name"=>"Fire Perimeters"}
#=> {"id"=>3, "name"=>"MODIS Thermal Satellite"}
#=> {"id"=>4, "name"=>"Inactive Fire Perimeters"}

layer = ArcREST::Layer.new("#{service.url}/2")
puts layer.name
#=> Fire Perimeters
puts layer.type
#=> Feature Layer
puts layer.count
#=> 14 # count of the layer's features
puts layer.object_ids.inspect
#=> [681, 682, 688, 690, 614, 618, 619, 653, 683, 684, 685, 686, 687, 689]
puts layer.fields
#=> {"name"=>"objectid", "type"=>"esriFieldTypeOID", "alias"=>"OBJECTID", "domain"=>nil, "editable"=>false, "nullable"=>false}
#=> {"name"=>"agency", "type"=>"esriFieldTypeString", "alias"=>"agency", "domain"=>nil, "editable"=>true, "nullable"=>true, "length"=>15}
#=> ...

features = layer.features(where: "agency='BLM'", options: { returnGeometry: false })
puts features.count
#=> 2
puts features.first
#=> {"objectid"=>690, "agency"=>"BLM", "comments"=>" ", "active"=>"Y"...
```

Layer #features method take 2 keyword args; ```where:``` and ```options:```
```where:``` is used with any valid SQL to query the layer fields. An InvalidQuery error is raised if the server gives a 400 error of this form:
```json
{
  "error": {
    "code": 400,
    "message": "Unable to complete operation.",
    "details": [
      "Unable to perform query operation.",
      "Invalid query"
    ]
  }
}
```

```options:``` is used to specify the additional query parameter settings. Valid param settings for the server can be listed as follows. Invalid key values raise an error.
```ruby
puts layer.params
#=> ["dbVersion", "distance", "geometry", "geometryPrecision"...
```


## Specification & Tests

For the full specification clone this repo and run:

    $ rake spec


## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/MatzFan/arcrest


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

