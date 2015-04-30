%allmean(data)
% Sorts data and outputs the means and stds.
% The 4 output columns are: Parameter value; Mean result; Standard deviation; n.

function av_data = allmean(data);

if nargin < 1
   help allmean
   return
end   

n_datapoints = size(data,1);

data = sortrows(data);

temp_data = data(1,:);
av_data = [];

for i = 2:n_datapoints
   if data(i,1) == data(i-1,1)
      temp_data = [temp_data;data(i,:)];
   else
      n_points = size(temp_data,1);
      av_data = [av_data; data(i-1,1) mean(temp_data(:,2)) std(temp_data(:,2)) n_points];
      temp_data = data(i,:);
   end
end
n_points = size(temp_data,1);
av_data = [av_data; data(n_datapoints,1) mean(temp_data(:,2)) std(temp_data(:,2)) n_points];
