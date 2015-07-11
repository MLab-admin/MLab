function out = install(varargin)
%ML.Plugins.install Install MLab plugins
%
%   See also ML.plugins.

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
    fprintf('You are about to install the following plugin%s:\n\n',s);
    for i = 1:numel(in.ptags)
        fprintf('\t- %s\n', in.ptags{i});
    end
    fprintf('\nDo you want to start the installation? [Y/n]\n');
    a = input('?> ', 's');
    
    switch lower(a)
        case 'n'
            fprintf('\nInstallation aborted.\n');
            if nargout, out = false; end
            return
            
        case {'', 'y'}
            break;
            
        otherwise
            clc
    end
end

% --- Prepare directories
pdir = cell(numel(in.ptags),1);
I = ones(numel(in.ptags),1);
for i = 1:numel(in.ptags)
    
    pdir{i} = [config.path 'Plugins' filesep in.ptags{i} filesep];
    if exist(pdir{i}, 'dir')
        
        while true
            
            clc
            ML.CW.print('~bc[orange]{WARNING} The following plugin already exists:\n\n');
            ML.CW.print('\t~b{%s}\n\n', pdir{i});
            ML.CW.print('Are you sure you want to erase it, as well as the configuration file ? [Y/n]\n');
            
            switch lower(input('?> ', 's'))
                case {'y', ''}
                    
                    % Remove directory
                    rmdir(pdir{i}, 's');
                    
                    % Remove configuration file
                    cname = [prefdir 'MLab.' in.ptags{i} '.mat'];
                    if exist(cname, 'file')
                        delete(cname);
                    end
                    
                    break;
                    
                case 'n'
                    I(i) = 0;
                otherwise
                    clc
            end
        end
        
    end
end

in.ptags = in.ptags(I);
pdir = pdir(I);

% --- Installation
for i = 1:numel(in.ptags)
    
    % Display
    fprintf('Installing "%s" ...', in.ptags{i}); tic;
    
    % Create plugin directory
    mkdir(pdir{i});
    
    % Clone repo
    cloneCMD = org.eclipse.jgit.api.Git.cloneRepository;
    cloneCMD.setDirectory(java.io.File(pdir));
    cloneCMD.setURI([config.updates.plugin_base in.ptags{i} '.git']);
    cloneCMD.call;

    % Get plugin structure
    P = ML.Plugins.path(in.ptags{i});
    
    % Default configuration
    if P.default.exist
        
        % Add to path
        addpath(P.path, '-end');
        
        % Set default configuration file
        P.default.run();
    end
    
    % Display
    fprintf(' %.2f sec\n', toc);
    
end

% --- Output
if nargout
    out = true;
end
fprintf('\nInstallation has been successfull.\n');

% Start the plugins
ML.start('plugin', in.ptags);