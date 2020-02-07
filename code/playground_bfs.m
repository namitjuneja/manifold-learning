function playground_bfs()

    % read BFS traveral vectors generated from the python code
    D = table2array(readtable('bfs_D_small_data.csv'));
    %imagesc(D);
    
    %% Run Entropy Isomap with this data
    
    % Meta variable should have a different number for each trajectory
    meta = zeros(1, 60);
    for i=0:59
       meta(1, i+1) = floor(i/30) + 1;
    end
    
    [Y, R, E, NG, RV_allDim, n_comps, k_values, trajNgbr, entropyReached]  = ...
        IsomapE_debug(D, meta, 'k', 8, struct('display', 1, 'dims', 1:10, 'entropythresh', 0.35));
    
    save("bfs");
    
     %% Plotting the results
     
%     plot_graph(Y, E);

      % Replicating figure 9 of the entropy isomap paper
%     plot_graph(Y, E, [0 1 2 3])
%     plot_graph(Y, E, [4 5 6 7])
%     plot_graph(Y, E, [8 9 10 11])
%     plot_graph(Y, E, [12 13 14 15])
%     plot_graph(Y, E, [0 4 8 12])
%     plot_graph(Y, E, [1 5 9 13])
%     plot_graph(Y, E, [2 6 10 14])
%     plot_graph(Y, E, [3 7 11 15])
    
end

