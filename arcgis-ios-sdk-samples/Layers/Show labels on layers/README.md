# Show labels on layers

Display custom labels on a feature layer.

![Show labels on layers sample](show-labels.png)

## Use case

Labeling features is useful to visually display a key piece of information or attribute of a feature on a map. For example, you may want to label rivers or street with their names.

## How to use the sample

Pan and zoom around the United States. Labels for congressional districts will be shown in red for Republican districts and blue for Democrat districts. Notice how labels pop into view as you zoom in.

## How it works

1. Create an `AGSServiceFeatureTable` using a feature service URL.
2. Create an `AGSFeatureLayer` from the service feature table.
3. Create and stylize an `AGSTextSymbol` to use for displaying the label text.
4. Create an `AGSLabelDefinition` with an `AGSArcadeLabelExpression` and the text symbol.
    * You can use fields of the feature by using `$feature.NAME` in the expression.
5. Add the definition to the feature layer's `labelDefinitions` array.
6. Lastly, enable labels on the layer by setting its `labelsEnabled` property to `true`.

## Relevant API

* AGSArcadeLabelExpression
* AGSFeatureLayer
* AGSLabelDefinition
* AGSTextSymbol

## About the data

This sample uses the [USA 116th Congressional Districts](https://www.arcgis.com/home/item.html?id=cc6a869374434bee9fefad45e291b779) feature layer hosted on ArcGIS Online.

## Additional information

Help regarding the Arcade label expression script for defining a label definition can be found on the [ArcGIS Developers](https://developers.arcgis.com/arcade/) site.

## Tags

arcade, attribute, deconfliction, label, labeling, string, symbol, text, visualization
