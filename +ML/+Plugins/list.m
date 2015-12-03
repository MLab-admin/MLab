function out = list(varargin)
%ML.Plugins.list List MLab plugins
%
%   See also ML.plugins.

% === Input variables =====================================================

in = ML.Input;
in.location{'local'} = @(x) any(strcmpi(x, {'local', 'remote'}));
in = +in;

% =========================================================================

% --- Get configuration structure
config = ML.config;

% --- Get plugins list

switch lower(in.location)
    
    case 'local'

        d = dir([config.path 'Plugins']);
        list = {};
        for i = 1:numel(d)
            if d(i).isdir && ~ismember(d(i).name, {'.', '..', 'private'})
                list{end+1} = d(i).name;
            end
        end
        ttl = 'Installed plugins';
        
    case 'remote'
        
        tmp = webread('https://api.github.com/users/MLab-admin/repos', 'Charset','UTF-8');
        
        if numel(tmp)>2
            
            I = find(cellfun(@(x) numel(regexp(x, '^Plugin-')), {tmp(:).name}));
            list = cellfun(@(x) x(8:end), {tmp(I).name}, 'UniformOutput', false);
            
        else
            warning('ML:Plugins:list:fetch', 'The remote plugin list could not be obtained.');
        end
        
        ttl = 'List of remote plugins';

    otherwise
        
        out = NaN;
        return
        
end

% Manage output
if nargout
    out = list;
else
    ML.CW.print('\n~b{%s}\n\n', ttl);
    for i = 1:numel(list)
        fprintf('\t%s\n', list{i});
    end
    fprintf('\n');
end
