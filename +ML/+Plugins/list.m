function out = list(varargin)
%ML.Plugins.list List installed MLab plugins
%
%   See also ML.plugins.

% === Input variables =====================================================

in = inputParser;
in.addOptional('location', 'local', @ischar);

in.parse(varargin{:});
in = in.Results;

% =========================================================================

% --- Get configuration structure
config = ML.Config.get;

% --- Get plugins list
list = {};

switch in.location
    
    case 'local'

        d = dir([config.path 'Plugins']);
        for i = 1:numel(d)
            if d(i).isdir && ~ismember(d(i).name, {'.', '..', 'private'})
                list{end+1} = d(i).name;
            end
        end
        ttl = 'Installed plugins';
        
    case 'remote'
        
        list = ML.Internal.fetch([config.updates.mirror_url 'MLab.php?list=Plugins']);
        ttl = 'List of all available plugins';

    otherwise
        out = NaN;
        return
        
end

% Manage output
if nargout
    out = list;
else
    fprintf('\n<strong>%s</strong>\n\n', ttl);
    for i = 1:numel(list)
        fprintf('\t%s\n', list{i});
    end
    fprintf('\n');
end
