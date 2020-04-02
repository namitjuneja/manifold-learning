function [fftAll, fftRwise] = performFFTandStoreCoeff(data)

% data = load(Path);
data = data.';
rows = 100; columns = 400; %TODO: rows and columns of dataset. edit if needed.

[N, D] = size(data);
fftAll = zeros(N, rows, columns);
fftRwise = zeros(N, rows, columns);

for idx = 1:N
    pt = reshape(data(idx,:), columns, rows)';
    fpt = fft2(pt);
    fpt = abs(fpt) ./ D;
    fftAll(idx, :, :) = fpt(:,:);
	
	for jRow=1:rows
			ptRow = pt(jRow,:);
			fptR=fft(ptRow);
			fptR=abs(fptR)/columns;
			fftRwise(idx,jRow,:)=fptR;
	end

end

% dlmwrite('data_fft.csv',fftAll, '	'); 
% dlmwrite('data_fftRwise.csv',fftRwise, '	'); 

end
