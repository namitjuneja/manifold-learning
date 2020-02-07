 function playground()
    
    %     This code computes the distance metric to be fed into Entropy-Isomap 
    %     in 3 different ways
    %     1. pixel by pixel L2 distance
    %     2. L2 distance of 1D and 2D FFT tranforms


    %% Generate data from the trajectory files
    
    data = double.empty; % create an empty matrix that will hold the trajectory points
    no_of_traj = 16;      % no of trajectories to be included in the collection
    
    % get all directories containing individual trajectories
    base_dir = "/home/namit/codes/Entropy-Isomap/selected_data/";
    traj_dirs = dir(base_dir);
    
    traj_dirs = clean_traj_dirs(traj_dirs);
    
    % iterate over "no_of_traj" trajectory directories and load its points in memory
    for i=1:no_of_traj
        disp("===============================");
        disp("Adding trajectory number: "+i);
        traj_dir = strcat(base_dir, traj_dirs(i).name);
        
        
        traj_pts = dir(traj_dir);       % get all the file names containing each point in the trajectory
        
        disp("Trajectory name: "+traj_dirs(i).name);
        
        % iterate through all the points and load them into memory
        % for j=1:length(traj_pts)  
        disp("Number of points found: "+length(traj_pts))
        disp(strcat("Data Dimensions: ",mat2str(size(data))))
        j = 1;
        count = 1;
        while count <= 80
            pt_file_name = traj_pts(j).name;
            %disp(pt_file_name)
            if length(pt_file_name) > 6 && pt_file_name(1:4) == "data"   % check if it is a data file
                pt = load(strcat(traj_dir, '/', pt_file_name));
                data = [data pt];
                count = count+1;
            end
            j = j + 1;
        end
    end
    data_t = data';
    
    % Genrate Images from the data
    % for i=1:size(data,2)
    %     image = reshape(data(:, i), 400, 100)';
    %     imwrite(image, strcat("images/", int2str(i), ".jpg"));
    % end
    
    disp("Final data dimensions: "+mat2str(size(data)))

    %% Perform Distance calculation function
    
    % FFT (normal and RowWise)    
    % [fftAll, fftRwise] = performFFTandStoreCoeff(data);
    [fftAll, fftRwise] = modified_FFT(data_t);
    
    
    fftAll = reshape(fftAll, 40000, size(fftAll,3));
    
    % verifying that the fft has been applied properly
    % imshow(reshape(data(:, 29), 400, 100)')
    % figure, imshow(ifft2(times(reshape(fftAll(:, 29), 400, 100), 40000))')
    
    %% Running Entropy Isomap Function
    N = size(data, 2);
    D = L2_distance(fftAll, fftAll);
    
    meta = zeros(1, N);
    for i=0:N
        meta(1, i+1) = floor(i/30) + 1;
    end
        
    [Y, R, E, NG, RV_allDim, n_comps, k_values, trajNgbr, entropyReached]  = ...
        IsomapE_debug(D, meta, 'k', 8, struct('display', 1, 'dims', 1:10, 'entropythresh', 0.35));
    
    %save("16_80");
    
    %% Plotting the results
    
    % Replicating figure 9 of the entropy isomap paper
    plot_graph(Y, E, [0 1 2 3])
    plot_graph(Y, E, [4 5 6 7])
    plot_graph(Y, E, [8 9 10 11])
    plot_graph(Y, E, [12 13 14 15])
    plot_graph(Y, E, [0 4 8 12])
    plot_graph(Y, E, [1 5 9 13])
    plot_graph(Y, E, [2 6 10 14])
    plot_graph(Y, E, [3 7 11 15])
 end
