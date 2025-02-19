# Create mobile geodatabase

Create and share a mobile geodatabase.

![Create and share mobile geodatabase](create-mobile-geodatabase-1.png)
![Geodatabase feature table](create-mobile-geodatabase-2.png)

## Use case

A mobile geodatabase is a collection of various types of GIS datasets contained in a single file (`.geodatabase`) on disk that can store, query, and manage spatial and nonspatial data. Mobile geodatabases are stored in a SQLite database and can contain up to 2 TB of portable data. Users can create, edit and share mobile geodatabases across ArcGIS Pro, ArcGIS Runtime, or any SQL software. These mobile geodatabases support both viewing and editing and enable new offline editing workflows that don't require a feature service.

For example, a user would like to track the location of their device at various intervals to generate a heat map of the most visited locations. The user can add each location as a feature to a table and generate a mobile geodatabase. The user can then instantly share the mobile geodatabase to ArcGIS Pro to generate a heat map using the recorded locations stored as a geodatabase feature table.

## How to use the sample

Tap on the map to add a feature symbolizing the user's location. Tap "View table" to view the contents of the geodatabase feature table. Once you have added the location points to the map, tap on "Create and share" to retrieve the `.geodatabase` file which can then be imported into ArcGIS Pro or opened in an ArcGIS Runtime application.

## How it works

1. Create the `AGSGeodatabase` from the mobile geodatabase location on file.
2. Create a new `AGSTableDescription` and add the list of `AGSFieldDescription`s to the table description.
3. Create an `AGSGeodatabaseFeatureTable` in the geodatabase from the `AGSTableDescription` using `AGSGeodatabase.createTable(with:completion:)`.
4. Create a feature on the selected map point using `AGSGeodatabaseFeatureTable.createFeature(attributes:geometry:)`.
5. Add the feature to the table using `AGSGeodatabaseFeatureTable.add(_:completion:)`.
6. Each feature added to the `AGSGeodatabaseFeatureTable` is committed to the mobile geodatabase file.
7. Close the mobile geodatabase to safely share the `.geodatabase` file using `AGSGeodatabase.close()`

## Relevant API

* AGSArcGISFeature
* AGSFeatureLayer
* AGSFeatureTable
* AGSFieldDescription
* AGSGeodatabase
* AGSGeodatabaseFeatureTable
* AGSTableDescription

## Additional information

Learn more about mobile geodatabases and how to utilize them on the [ArcGIS Pro documentation](https://pro.arcgis.com/en/pro-app/latest/help/data/geodatabases/manage-mobile-gdb/mobile-geodatabases.htm) page. The following mobile geodatabase behaviors are supported in ArcGIS Runtime: annotation, attachments, attribute rules, contingent values, dimensions, domains, feature-linked annotation, subtypes, utility network and relationship classes.

Learn more about the types of fields supported with mobile geodatabases on the [ArcGIS Pro documentation](https://pro.arcgis.com/en/pro-app/latest/help/data/geodatabases/overview/arcgis-field-data-types.htm) page.

## Tags

arcgis pro, database, feature, feature table, geodatabase, mobile geodatabase, sqlite
