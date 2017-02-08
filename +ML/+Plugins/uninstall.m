function out = uninstall(varargin)
%ML.Plugins.uninstall Uninstall MLab plugins
%
%   See also ML.plugins, ML.Plugins.install

% --- Input variables

in = ML.Input;
in.ptags = @(x) ischar(x) || iscellstr(x);
in = +in;

% =========================================================================

% --- Cellification
if ischar(in.ptags)
    in.ptags = {in.ptags};
end

% --- Get configuration structure
config = ML.config;

% --- Get user input
while true
    
    clc
    if numel(in.ptags)>1, s = 's'; else s= ''; end
    fprintf('You are about to uninstall the following plugin%s\nand all the associated configuration files:\n\n',s);
    for i = 1:numel(in.ptags)
        fprintf('\t- %s\n', in.ptags{i});
    end
    fprintf('\nDo you really want to proceed? [y/N]\n');
    a = input('?> ', 's');
    
    switch lower(a)
        case {'', 'n'}
            fprintf('\nUninstallation aborted.\n');
            if nargout, out = false; end
            return
            
        case {'y'}
            break;
            
        otherwise
            clc
    end
end

for i = 1:numel(in.ptags)

    fprintf('Uninstalling "%s" ...', in.ptags{i}); tic;
    
    ppath = [config.path 'Plugins' filesep in.ptags{i}];
    
    % Remove path
    rmpath(ppath);
    
    % Remove directory
    rmdir(ppath, 's');
                    
    % Remove configuration file
    cname = [prefdir 'MLab.' in.ptags{i} '.mat'];
    if exist(cname, 'file'), delete(cname); end
          
    fprintf(' %.2f sec\n', toc);
end

% --- Output
if nargout
    out = true;
end
fprintf('\nUninstallation has been successfull.\n');