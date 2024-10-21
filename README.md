# Garmin handheld GPS device Tips

**Note**:  
This document is for users of Garmin handheld GPS device and macOS.

## Mount

When connecting the device via a USB cable (mini-B on the GPS side), the internal memory of the device will be mounted to `/Volumes/GARMIN`.

- `/Volumes/GARMIN/Garmin/GPX/Archive`: Archived track logs
- `/Volumes/GARMIN/Garmin/GPX/Current`: Current track logs
- `/Volumes/GARMIN/Garmin/GPX/Waypoints.gpx`: Waypoints

**Note**:  

- The transfer speed is slow via a USB cable.
- Be aware that the visible storage is not the MicroSD card, but the device's internal memory.

## Backup

To copy the GPS data from the device to the `garmin` directory in the current directory, run the following command:

```bash
make backup
```

## Import the GPS data to database

To import the GPS data into PostGIS, use the following command:

```bash
make import-to-database
```

**Note**:

- Make sure that PostgreSQL and the PostGIS extension are set up and ready to use beforehand.  
- Also, ensure that GDAL tools are available and ready to use.
- Track log segments will be imported into the `tracks` table, and track log points will be imported into the `track_points` table.  
- The device model name will be added as the 'Model' property.

## Convert to GeoJSON form database

To convert the GPS data on PostGIS to GeoJSON format, run:

```bash
make convert-to-geojson
```

## Show GPS data on QGIS

1. Backup the GPS data.
2. Import the GPS data to database.
3. Open QGIS and add PostgresSQL layer for the tracks or track_points table.

**Note**:

- Showing with a PostgreSQL layer is faster than showing with a GeoJSON layer.
