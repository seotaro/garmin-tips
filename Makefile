SRC := /Volumes/GARMIN/Garmin/GPX
DEST := garmin
MODEL := eTrex30x

snippet:
	# show info for current.gpx
	ogrinfo $(DEST)/GPX/Current/Current.gpx

backup:
	mkdir -p $(DEST)
	cp -r $(SRC) $(DEST)

import-to-database:
	- psql -U postgres -d geomdb -c "DROP TABLE tracks; DROP TABLE track_points;"

	# tracklogs - current
	find $(DEST)/GPX/Current -name "*.gpx" -print0 | xargs -0 -I {} \
		ogr2ogr -f "PostgreSQL" PG:"host=localhost dbname=geomdb user=postgres" -append {} \
		-nlt MULTILINESTRING -nln tracks -sql "SELECT *, '$(MODEL)' AS model FROM tracks"
	find $(DEST)/GPX/Current -name "*.gpx" -print0 | xargs -0 -I {} \
		ogr2ogr -f "PostgreSQL" PG:"host=localhost dbname=geomdb user=postgres" -append {} \
			-nlt POINTS -nln track_points -sql "SELECT *, '$(MODEL)' AS model FROM track_points"

	# tracklogs - archive
	find $(DEST)/GPX/Archive -name "*.gpx" -print0 | xargs -0 -I {} \
		ogr2ogr -f "PostgreSQL" PG:"host=localhost dbname=geomdb user=postgres" -append {} \
		-nlt MULTILINESTRING -nln tracks -sql "SELECT *, '$(MODEL)' AS model FROM tracks"
	find $(DEST)/GPX/Archive -name "*.gpx" -print0 | xargs -0 -I {} \
		ogr2ogr -f "PostgreSQL" PG:"host=localhost dbname=geomdb user=postgres" -append {} \
			-nlt POINTS -nln track_points -sql "SELECT *, '$(MODEL)' AS model FROM track_points"

convert-to-geojson:
	ogr2ogr -f GeoJSON tracks.geojson PG:"host=localhost user=postgres dbname=geomdb" tracks -select "name"
	ogr2ogr -f GeoJSON track_points.geojson PG:"host=localhost user=postgres dbname=geomdb" track_points -select "ele,time"
