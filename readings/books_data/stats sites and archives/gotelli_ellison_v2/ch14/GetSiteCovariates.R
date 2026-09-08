GetSiteCovariates = function(fspec='SiteCovariates.csv') {
    d = read.csv(fspec)
    lat = unlist(d[1,-1])
    lon = unlist(d[2,-1])
    elev = unlist(d[3,-1])
    area = unlist(d[4,-1])
    GSF = unlist(d[5,-1])
    LAI = unlist(d[6,-1])
    data.frame(lat, lon, elev, area, GSF, LAI)
}

