function ts=read_digitized_table(dummyf)
%% read csv table produced by digitize
  %dummyf='../DIGITIZE/Sicily_ISS_may16.csv';
  opts = detectImportOptions(dummyf);
  opts.VariableTypes(1) ={'datetime'};
  opts = setvaropts(opts, 'date', 'InputFormat', 'yyy-MM-dd');
  fid = fopen(dummyf);
   ts=readtable(dummyf, opts);
end