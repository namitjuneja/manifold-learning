function [Hr, Tc, eV] = findEntropy(M, x, ind, k, et, max_incr_k)
% Entropy function 
% 
% x -- row vector of trajectory labels 

% create prob vector p with length k
% with probabilities for each trajectory 
% and use H = sum(-(p(p>0).*(log2(p(p>0)))))


M=M(1:end); % Metadata -- passed from Meta in IsomapE
C=unique(M);
x=reshape(x, size(ind));
num_traj = size(C, 1);

loopcount=0;
max_loops=max_incr_k;
num_points = size(ind, 1);
while 1
    dynind = ind(1:(k+1), 1);
    metaSub = M(dynind); 

    if loopcount > max_loops
        % this neighborhood is too large
        % take this value and end   
        
        dynind = ind(1:(k+1), 1);
        metaSub = M(dynind);
        counts = hist(metaSub, C);
        break;
    end

    loopcount = loopcount + 1;
    k = k + 1;

    % freq/count for each label
    counts = hist(metaSub, C);
    
    % sum indiv counts for total neighbors
    totalN = sum(counts);


    % select non-zero idx (find(counts)) and get those vals (counts(idx))
    % to select the non-zero fractions when div by totalN
    fracN = counts(find(counts)) / totalN;

    % compute entropy value with the
    % prod distribution calculated above
    logFracN = log2(fracN);
    preSum = fracN .* logFracN;
    entropyValue = -1.0 * sum(preSum);

    %normalize entropyValue
    unifent = zeros(size(counts));
    tr = mod(k, num_traj);
    tq = floor(k./num_traj);
    
    % add quotient to each entry for uniform distribution
    % add remainder tr to first tr positions
    unifent = unifent + tq;
    unifent(1, 1:tr) = unifent(1, 1:tr) + 1;
 
    % compute prob distr and entropy value for max case
    unifent = unifent / sum(unifent);
    preMaxEnt = unifent .* log2(unifent);
    maxEntropy = -1.0 * sum(preMaxEnt);

    % normalize entropy for this ngbrhood size
    entropyValue = entropyValue / maxEntropy;

    if (entropyValue >= et) & (et ~= -1)
        break;
    end
end

eV = entropyValue;
Hr = k;
Tc = counts';
C;

end

%    findEntropy function for finding 'Neighborhood Entropy'
%    for IsomapE code -- (c) 2018 SCoRe Group http://www.score-group.org/
%    Author: Frank Schoeneman
%    
%    This code is provided as-is. Published reports of research 
%    using this code (or a modified version) should cite:
%
%       F. Schoeneman, V. Chandola, N. Napp, O. Wodo, and J. Zola. 2018. 
%       Entropy-Isomap: Manifold Learning for High-dimensional Dynamic Processes.

