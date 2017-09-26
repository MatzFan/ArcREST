# ArcREST
[![Build status](https://secure.travis-ci.org/MatzFan/ArcREST.svg)](http://travis-ci.org/MatzFan/ArcREST)
[![Gem Version](https://badge.fury.io/rb/arcrest.svg)](http://badge.fury.io/rb/arcrest)

Ruby Gem wrapper around the [ArcGIS REST API](http://services.arcgisonline.com/arcgis/sdk/rest/)

## Requirements

bundler


## Current Limitations

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

catalog = ArcREST::Catalog.new('https://www.geomac.gov/arcgis/rest/services')
puts catalog.services
#=> {"name"=>"BIADigit", "type"=>"FeatureServer"}
#=> {"name"=>"BIADigit", "type"=>"MapServer"}
#=> {"name"=>"contAF", "type"=>"MapServer"}
#=> ...

service = ArcREST::Service.new('https://www.geomac.gov/arcgis/rest/services/geomac_fires/FeatureServer')
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
```

Catalog, Service and Layer have a ```json``` method which returns information from the relevant server as a Hash (derived from JSON). In addition to the example methods above this can be parsed in the usual way - e.g:
```ruby
puts layer.json.keys.inspect
#=> ["currentVersion", "id", "name", "type", "description", "copyrightText"...
```

Once you have a Layer object, you can perform queries on it. The [documention](http://services.arcgisonline.com/arcgis/sdk/rest/index.html#/Query_Feature_Service_Layer/) shows the possibilities. Here is a very simple example:

The ```query``` method returns the whole server response as a Hash:
```ruby
puts layer.query(where: '1=0').inspect
#=> {"objectIdFieldName"=>"objectid", "globalIdFieldName"=>"", "features"=>[]}
```

If you just want the features, use the ```features``` method:
```ruby
features = layer.features(where: "agency='BLM'", returnGeometry: false)
puts features.count
#=> 2
puts features.first
#=> {"objectid"=>690, "agency"=>"BLM", "comments"=>" ", "active"=>"Y"...
```

```query``` and ```features``` take an options hash of API call params. Invalid key values raise an error. Valid params for the server can be listed like this:
```ruby
puts layer.valid_opts.inspect
#=> ["dbVersion", "distance", "geometry", "geometryPrecision"...
```
or by consulting the [docs](http://services.arcgisonline.com/arcgis/sdk/rest/index.html#/Query_Feature_Service_Layer/). One default is set: ```outFields: '*'``` - which requests data for all fields.


The ```:where``` key is used with any valid SQL to query the layer fields. The default is '1=1' which returns all records (up to the ```@max_record_count``` value, usually 1,000). An error is raised if the server gives a 400 error of this form:
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


## Specification & Tests

Full specification documentation is available for each build at [Travis](https://travis-ci.org/MatzFan/ArcREST). To run the tests yourself clone this repo and run:

    $ rake spec


## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/MatzFan/arcrest


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

