GetDetectionMatrix = function(habitat='Forest', fspec='AntDetections1999.csv') {
    d = read.csv(fspec)

    ind = d[,'Habitat']==habitat & d[,'Sample']=='EarlySeason'
    y.early = d[ind,-(1:3)]
    species = d[ind,'Species']
    dimnames(y.early)[1] = list(species)
    y.early = as.matrix(y.early)
    ind = is.na(y.early)
    y.early[ind] = 0

    ind = d[,'Habitat']==habitat & d[,'Sample']=='LateSeason'
    y.late = d[ind,-(1:3)]
    dimnames(y.late)[1] = list(species)
    y.late = as.matrix(y.late)
    ind = is.na(y.late)
    y.late[ind] = 0

    y = y.early + y.late
    y
}

