function out = path(varargin)
%ML.Plugins.path Plugin path
%
%   See also: ML.plugin

% --- Inputs
in = ML.Input;
in.plugin = @ischar;
in.items({'start', 'default', 'config', 'shortcuts'}) = @iscellstr;
in = +in;

% --- Output

config = ML.config;
out = struct('path', [config.path 'Plugins' filesep in.plugin filesep]); 

for i = 1:numel(in.items)

    item = in.items{i};
    fname = [out.path '+ML' filesep '+Plugins' filesep '+' in.plugin filesep item '.m'];
    if exist(fname, 'file')
        out.(item) = struct('exist', true, ...
            'path', fname, ...
            'run', @() eval(['ML.Plugins.' in.plugin '.' item]));
    else
        out.(item) = struct('exist', false, 'path', false, 'run', @() []);
    end
    
end