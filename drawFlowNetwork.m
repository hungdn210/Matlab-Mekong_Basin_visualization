function drawFlowNetwork(flowMap, stationLocs, showDistance)
    figure('Color', 'w', 'Position', [100, 100, 1000, 800]);
    ax = axes;
    axis equal;
    hold(ax, 'on');
    set(ax, 'FontSize', 12);
    title(ax, 'Hydrological Flow Network (Mekong Basin Only)', ...
        'FontSize', 14, 'FontWeight', 'bold');

    % Load outline
    load('mekong_basin_mat.mat');  % contains lat, lon
    plot(ax, lon, lat, '-', 'Color', [0.4 0.7 1], 'LineWidth', 1.5);

    % Colors
    arrowColor = 'cyan';
    stationColor = [1, 0.5, 0];

    % Draw connections
    keys = flowMap.keys;
    for i = 1:length(keys)
        upstream = keys{i};
        if ~isKey(stationLocs, upstream), continue; end
        upLoc = stationLocs(upstream);

        for downstream = flowMap(upstream)
            if ~isKey(stationLocs, downstream{1}), continue; end
            downLoc = stationLocs(downstream{1});
            plot(ax, [upLoc(2), downLoc(2)], [upLoc(1), downLoc(1)], ...
                '-', 'Color', arrowColor, 'LineWidth', 1.2);
            scatter(ax, downLoc(2), downLoc(1), 30, '^', ...
                'MarkerFaceColor', arrowColor, 'MarkerEdgeColor', 'none');
        end
    end

    % Plot stations
    for i = 1:length(keys)
        upstream = keys{i};
        if ~isKey(stationLocs, upstream), continue; end
        upLoc = stationLocs(upstream);
        offsetLat = 0;
        offsetLon = 0.1;

        if ismember(upstream, {'Ban Tha Ton'}), offsetLat = 0.15; offsetLon = -0.4;
        elseif ismember(upstream, {'Ban Tha Mai Liam'}), offsetLat = -0.1; offsetLon = -0.2;
        elseif ismember(upstream, {'Vientiane KM4'}), offsetLat = 0.15; offsetLon = -0.3;
        elseif ismember(upstream, {'Ban Nong Kiang'}), offsetLat = 0.1; offsetLon = -0.3;
        elseif ismember(upstream, {'Chiang Khan'}), offsetLat = -0.05; offsetLon = -0.05;
        elseif ismember(upstream, {'Ban Huai Khayuong'}), offsetLat = -0.1; offsetLon = -1;
        end

        scatter(ax, upLoc(2), upLoc(1), 60, 'o', ...
            'MarkerFaceColor', stationColor, 'MarkerEdgeColor', 'k', 'LineWidth', 0.8);
        text(upLoc(2) + offsetLon, upLoc(1) + offsetLat, upstream, ...
            'Color', 'black', 'FontSize', 12);  % black text on white background
    end

    xlabel('Longitude'); ylabel('Latitude');
    box on;
    exportgraphics(gcf, 'hydro_flow_clean.pdf', 'ContentType', 'vector');
end
