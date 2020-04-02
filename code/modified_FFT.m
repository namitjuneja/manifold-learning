function [fftAll, fftRwise] = modified_FFT(data)

% data = load(Path);
% data = data.'
rows = 100; columns = 400; %TODO: rows and columns of dataset. edit if needed.

[N, D] = size(data);
fftAll = zeros(columns, rows, N);
fftRwise = zeros(columns, rows, N);

for idx = 1:N
    pt = reshape(data(idx,:), columns, rows)';
    fpt = fft2(pt);
    fpt = abs(fpt) ./ D;
    fftAll(:, :, idx) = fpt(:,:)';
	
	for jRow=1:rows
			ptRow = pt(jRow,:);
			fptR=fft(ptRow);
			fptR=abs(fptR)/columns;
			fftRwise(:,jRow, idx)=fptR';
	end

end

% dlmwrite('data_fft.csv',fftAll, '	'); 
% dlmwrite('data_fftRwise.csv',fftRwise, '	'); 

end
