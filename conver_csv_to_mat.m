% Load the CSV file exported from QGIS
T = readtable('mekong_basin.csv');  % Replace with your actual file name

% Extract longitude and latitude
lon = T.X;
lat = T.Y;

% Save as a .mat file
save('mekong_basin_mat.mat', 'lat', 'lon');