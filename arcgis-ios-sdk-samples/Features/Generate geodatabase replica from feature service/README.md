# Generate geodatabase replica from feature service

Generate a local geodatabase replica from an online feature service.

![Generate geodatabase sample](generate-geodatabase-replica-from-feature-service.png)

## Use case

Generating geodatabase replica is the first step toward taking a feature service offline. It allows you to save features locally for offline display.

## How to use the sample

Zoom to any extent. Then tap the generate button to generate a geodatabase of features from a feature service filtered to the current extent. A red outline will show the extent used. When complete, the map will reload with only the layers in the geodatabase, clipped to the extent.

## How it works

1. Create an `AGSGeodatabaseSyncTask` with the URL of the feature service and load it.
2. Use `AGSGeodatabaseSyncTask.defaultGenerateGeodatabaseParameters(withExtent:completion:)` to generate default parameters and specify the extent.
3. Request a job to generate the geodatabase using `AGSGeodatabaseSyncTask.generateJob(with:downloadFileURL:)`.
4. Start the job with `AGSGenerateGeodatabaseJob.start(statusHandler:completion:)`.
5. When the job is done, add all the `AGSFeatureLayer`s from the geodatabase's `geodatabaseFeatureTables` to the map's `operationalLayers`.
6. Lastly, unregister the geodatabase with `AGSGeodatabaseSyncTask.unregisterGeodatabase(_:completion:)`.

## Relevant API

* AGSGenerateGeodatabaseJob
* AGSGenerateGeodatabaseParameters
* AGSGeodatabase
* AGSGeodatabaseSyncTask

## Offline data

This sample uses a [San Francisco offline basemap tile package](https://www.arcgis.com/home/item.html?id=e4a398afe9a945f3b0f4dca1e4faccb5).

## Tags

disconnected, local geodatabase, offline, replica, sync
