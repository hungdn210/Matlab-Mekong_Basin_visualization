function drawFlowNetwork(flowMap, stationLocs, showDistance)
    % Set up geoaxes
    figure('Color', 'w', 'Position', [100, 100, 800, 800]);

    ax = geoaxes;
    geobasemap(ax, 'satellite');
    hold(ax, 'on');
    load('mekong_basin_mat.mat');  % Load lat/lon outline from .mat
    geoplot(ax, lat, lon, '-', ...
        'Color', [0.4 0.7 1], 'LineWidth', 1.5);
    set(ax, 'FontSize', 12);
    title(ax, 'Hydrological Flow Network (with Mekong Basin)', ...
        'FontSize', 14, 'FontWeight', 'bold');
    % Colors
    arrowColor = 'yellow';
    stationColor = [1, 0.5, 0];
    % Plot stations and flow lines (unchanged)
    keys = flowMap.keys;
    for i = 1:length(keys)
        upstream = keys{i};
        if ~isKey(stationLocs, upstream), continue; end
        upLoc = stationLocs(upstream);
        for downstream = flowMap(upstream)
            if ~isKey(stationLocs, downstream{1}), continue; end
            downLoc = stationLocs(downstream{1});
            geoplot(ax, [upLoc(1), downLoc(1)], [upLoc(2), downLoc(2)], ...
                '-', 'Color', arrowColor, 'LineWidth', 2);

            arrowSize = 0.12;  % smaller arrow
            dirVec = [downLoc(2) - upLoc(2), downLoc(1) - upLoc(1)];
            normDir = dirVec / norm(dirVec);
            perp = [-normDir(2), normDir(1)] * arrowSize / 2;
            
            tip = [downLoc(2), downLoc(1)];
            base1 = tip - normDir * arrowSize + perp;
            base2 = tip - normDir * arrowSize - perp;
            
            % Extract lat/lon
            tipLat = tip(2); tipLon = tip(1);
            b1Lat = base1(2); b1Lon = base1(1);
            b2Lat = base2(2); b2Lon = base2(1);
            
            % Draw open arrowhead
            geoplot(ax, [tipLat, b1Lat], [tipLon, b1Lon], '-', 'Color', arrowColor, 'LineWidth', 2);
            geoplot(ax, [tipLat, b2Lat], [tipLon, b2Lon], '-', 'Color', arrowColor, 'LineWidth', 2);

        end
    end
    for i = 1:length(keys)
        upstream = keys{i};
        if ~isKey(stationLocs, upstream), continue; end
        upLoc = stationLocs(upstream);
        geoscatter(ax, upLoc(1), upLoc(2), 60, 'Marker', 'o', ...
            'MarkerFaceColor', stationColor, 'MarkerEdgeColor', 'k', 'LineWidth', 0.8);
        text(ax, upLoc(1), upLoc(2), upstream, 'Color', 'White', 'FontSize', 14); %'FontWeight','bold');
    end
    geolimits(ax, [8 22], [98 110]);
    exportgraphics(gcf, 'hydro_flow_geo.pdf', 'ContentType', 'vector');
end